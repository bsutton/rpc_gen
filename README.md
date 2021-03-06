# rpc_gen

The `rpc_gen` is a builder and generator of RPC (Remote Procedure Call) stub files.  

ATTENTION: Under development

Version 0.1.7

Why need another RPC?

Although this software makes it easy to implement a client and server to call remote procedures (RPC) from the client, it is not limited to this application only.  

This software also makes it easy to implement a client to access various external APIs in the form of external procedure calls (or simply, method calls).  

It would be more correct to call this software as RPC without transport (that is, without a specific data format and methods for sending and receiving data).  

Half of the work (or even most) will be done by this software.  
The rest of the work will be done by transport (sending and receiving data).  
The transport is not only concerned with the delivery of data, but it also determines how and in what format the data will be sent.  

This makes it possible (using transport) to follow many conventions and makes it possible to emulate the client calls in a different formats (e.g. RestFul).  

Of course, all of this can be done manually, but it may take a little longer.  

The main goals and purpose of this project:

- Easy adaptation for use with existing external APIs using your own transport
- Fast (in minutes) creation of API services simultaneously for server and client
- Fast (in seconds) creation of API procedures simultaneously on the server and client
- Maximum flexibility in the choice of how to send and handle procedure calls
- Easily maintenance of consistency of source code for procedures on both layers

Conventions (or limitations, if you like to call it that):

- The JSON models must contain a constructor like `fromJson(Map<String, dynamic> json)`
- The JSON models must contain an instance method like `Map<String, dynamic> toJson()`
- The RPC service metadata class (interface) should contain nothing but methods

Planned features:

- Applying automatic default values when deserializing non-nullable types (soon)  
- Implementing automatic  JSON serialization/deserialization of plain objects (not soon)  

Example of procedures:

```dart
@RpcMethod(path: '/ping')
Future<void> ping();

@RpcMethod(path: '/add')
Future<int> add({int x, int y});

@RpcMethod(path: '/comments', httpMethod: 'GET', ignoreIfNull: true)
Future<List<Comment>> comments({String? email, int? id, int? postId});

@RpcMethod(path: '/find_products')
Future<List<Product>> findProducts({List<String>? q, int? page, int? pageSize});

@RpcMethod(path: '/find_products')
Future<TResponse> findProducts(TRequest request);
```

A very simple example:

Using free fake API for testing and prototyping '{JSON} Placeholder' at https://jsonplaceholder.typicode.com.

Service declaration:

```dart
@RpcService(host: 'https://jsonplaceholder.typicode.com')
abstract class JsonPlaceholder {
  @RpcMethod(path: '/posts', httpMethod: 'POST')
  Future<Post> addPost(Post post);

  @RpcMethod(path: '/comments', httpMethod: 'GET', ignoreIfNull: true)
  Future<List<Comment>> comments({String? email, int? id, int? postId});

  @RpcMethod(path: '/posts/<id>/comments', httpMethod: 'GET')
  Future<List<Comment>> commentsByPostId(int id);

  @RpcMethod(path: '/posts/<id>', httpMethod: 'GET')
  Future<Post> postById(int id);

  @RpcMethod(path: '/posts/<id>', httpMethod: 'PUT')
  Future<Post> updatePost(Post post, {required int id});
}

```

Source code of example:

[example_use_jsonplaceholder.dart](https://github.com/mezoni/rpc_gen/blob/main/example/example_use_jsonplaceholder.dart)

```dart
import 'dart:convert';

import 'package:http/http.dart' as _http;
import 'package:json_annotation/json_annotation.dart';
import 'package:rpc_gen/rpc_meta.dart';

import '_rest_transport.dart';

part 'example_use_jsonplaceholder.g.dart';

Future<void> main(List<String> args) async {
  final client = Client();
  final commnetId = 1;
  print('Comments with id $commnetId:');
  final commentsById = await client.comments(id: commnetId);
  for (final comment in commentsById) {
    print('id: ${comment.id}, email: ${comment.email}');
  }

  print('====');
  if (commentsById.isNotEmpty) {
    final comment = commentsById.first;
    print('Comments with email ${comment.email}:');
    final commentsByEmail = await client.comments(email: comment.email);
    for (final comment in commentsByEmail) {
      print('id: ${comment.id}, email: ${comment.email}');
    }
  }

  print('====');
  final postId = 1;
  var post = await client.postById(postId);
  print('Post with id $postId:');
  print('id: ${post.id}, user id ${post.userId}');

  print('====');
  post = Post()
    ..title = 'foo'
    ..body = 'bar'
    ..userId = 1;

  try {
    post = await client.addPost(post);
    print('Added post with id ${post.id}');
  } catch (e) {
    print(e);
  }

  print('====');
  try {
    post.id = 1;
    post.title = 'it works!';
    post = await client.updatePost(post, id: 1);
    print('Update post with id ${post.id}, title: ${post.title}');
  } catch (e) {
    print(e);
  }
}

class Client extends JsonPlaceholderClient {
  Client() : super(Transport(host: JsonPlaceholderConfig.host));
}

@JsonSerializable()
class Comment {
  String? body;
  String? email;
  int? id;
  int? postId;

  Comment();

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}

@RpcService(host: 'https://jsonplaceholder.typicode.com')
abstract class JsonPlaceholder {
  @RpcMethod(path: '/posts', httpMethod: 'POST')
  Future<Post> addPost(Post post);

  @RpcMethod(path: '/comments', httpMethod: 'GET', ignoreIfNull: true)
  Future<List<Comment>> comments({String? email, int? id, int? postId});

  @RpcMethod(path: '/posts/<id>/comments', httpMethod: 'GET')
  Future<List<Comment>> commentsByPostId(int id);

  @RpcMethod(path: '/posts/<id>', httpMethod: 'GET')
  Future<Post> postById(int id);

  @RpcMethod(path: '/posts/<id>', httpMethod: 'PUT')
  Future<Post> updatePost(Post post, {required int id});
}

@JsonSerializable()
class Post {
  int? userId;
  int? id;
  String? title;
  String? body;

  Post();

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}

class Transport extends RestTransport with JsonPlaceholderTransport {
  @override
  final String host;

  @override
  final int? port;

  Transport({required this.host, this.port});

  @override
  Future postprocess(RpcRequest request, _http.Response response) async {
    switch (response.statusCode) {
      case 200:
      case 201:
        return jsonDecode(response.body);
      default:
        throw 'Bad response: ${response.statusCode}\n${response.body}';
    }
  }
}

```

Another example:

Let's say we need to organize and coordinate the call of the following remote procedures:

- `Future<int> add({required int x, required int y})`

How can we quickly organize client-server interactions?  
What if we need not 3 procedures, but much more?  

How to implement it quickly and conveniently and without errors?  

[example.dart](https://github.com/mezoni/rpc_gen/blob/main/example/example.dart)

```dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/src/response.dart';
import 'package:rpc_gen/rpc_meta.dart';

import '_http_transport.dart';

part 'example.g.dart';

void main() async {
  // Schedule a delayed client launch
  Timer(Duration(seconds: 2), () async {
    await _runCleint();
    exit(0);
  });

  // Start web server
  await _serve();
}

const secretHeaderKey = 'SECRET';

const secretToken = '123';

bool development = true;

String? globalSecret;

/// Client runner, for demonstration only
Future<void> _runCleint() async {
  final client = Client();
  globalSecret = secretToken;
  final x = 2;
  final y = 3;
  final res1 = await client.add(x: x, y: y);
  print('add($x,$y) = $res1');
}

/// Web server, for demonstration only
Future<void> _serve() async {
  final webServer = await HttpServer.bind(
      InternetAddress.anyIPv4, ExampleApiConfig.serverPort!);
  await for (final request in webServer) {
    final response = request.response;
    try {
      final path = request.uri.path;
      final methods = ExampleApiUtils.getMethods()
          .where((e) => e.path == path && e.method == request.method);
      if (methods.isNotEmpty) {
        final handler = ServerHandler();
        final method = methods.first;
        if (method.authorize) {
          if (request.headers.value(secretHeaderKey) != secretToken) {
            response.statusCode = 401;
            throw 'Unauthorized access';
          } else {
            print('Authorized access');
          }
        }

        final source = await utf8.decodeStream(request);
        final data = jsonDecode(source);
        Map<String, dynamic>? positionalArguments;
        Map<String, dynamic>? namedArguments;
        if (data is Map) {
          final p = data['p'];
          if (p is Map<String, dynamic>) {
            positionalArguments = p;
          }

          final n = data['n'];
          if (n is Map<String, dynamic>) {
            namedArguments = n;
          }
        }

        if (positionalArguments == null || namedArguments == null) {
          throw StateError('Invalid data format');
        }

        final result = await handler.handle(
            method.name, positionalArguments, namedArguments);
        response.headers.add('Content-Type', 'application/json');
        response.write(jsonEncode(result));
      } else {
        response.statusCode = 404;
      }
    } catch (e) {
      print(e);
    } finally {
      await response.close();
    }
  }
}

class Client extends ExampleApiClient {
  Client() : super(ClientTransport());
}

class ClientTransport extends Transport with ExampleApiTransport {
  ClientTransport()
      : super(host: ExampleApiConfig.host, port: ExampleApiConfig.clientPort);
}

@RpcService(host: 'http://exmaple.com', serverPort: 8002)
abstract class ExampleApi {
  @RpcMethod(path: '/api/v1/add', authorize: true)
  Future<int> add({required int x, required int y});
}

class ServerHandler extends ExampleApiHandler {
  ServerHandler() : super(ServerService());
}

class ServerService extends ExampleApi {
  @override
  Future<int> add({required int x, required int y}) async {
    return x + y;
  }
}

class Transport extends HttpTransport with ExampleApiTransport {
  @override
  final String host;

  @override
  final int? port;

  Transport({required String host, this.port})
      : host = development ? 'http://localhost' : host;

  @override
  Future postprocess(RpcRequest request, Response response) async {
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      default:
        throw StateError(
            'Bad response: ${response.statusCode}\n${response.body}');
    }
  }

  @override
  Future<RpcRequest> preprocess(
      String name,
      String httpMethod,
      String path,
      Map<String, dynamic> positionalArguments,
      Map<String, dynamic> namedArguments) async {
    final body = {'p': positionalArguments, 'n': namedArguments};
    final url =
        port == null ? Uri.parse('$host$path') : Uri.parse('$host:$port$path');
    final request = RpcRequest(url: url, body: body);
    request.headers['Content-Type'] = 'application/json';
    if (globalSecret != null) {
      request.headers[secretHeaderKey] = secretToken;
    }

    return request;
  }
}

```

Based on this code (in fact, interfaces), classes for work on the server and client will be generated.

List of generated classes:

- ExampleApiClient
- ExampleApiHandler
- ExampleApiMethod
- ExampleApiTransport
- ExampleApiUtils

All of these classes contain stubs for client and server procedures.  

An interface is also generated for organizing the sending of calls from the client to the server (the so-called transport). You write yourself the implementation you need and, in particular, you can create a universal base transport class if you need to work with different services (API).

And, of course, for the convenience of processing on the server, convenient metadata classes for the procedures used have been created. This gives maximum flexibility in the choice of processing methods. They are also available on the client and can be used in transport class (and not only there) if you need it.

A utility class is also generated. At the moment it only allows getting a list of procedure metadata.

So it's time to take a look at the generated classes (there is not so much source code).  

[example.g.dart](https://github.com/mezoni/rpc_gen/blob/main/example/example.g.dart)

```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// RpcGenerator
// **************************************************************************

class ExampleApiClient implements ExampleApi {
  ExampleApiClient(this._transport);

  final ExampleApiTransport _transport;

  @override
  Future<int> add({required int x, required int y}) async {
    final $1 = <String, dynamic>{};
    final $2 = <String, dynamic>{};
    $2['x'] = x;
    $2['y'] = y;
    final $0 = await _transport.send('add', 'POST', '/api/v1/add', $1, $2);
    return $0 as int;
  }
}

class ExampleApiConfig {
  static const int? clientPort = 8002;

  static const String host = 'http://exmaple.com';

  static const int? serverPort = 8002;
}

class ExampleApiHandler {
  ExampleApiHandler(this._handler);

  final ExampleApi _handler;

  Future handle(String name, Map<String, dynamic> positionalArguments,
      Map<String, dynamic> namedArguments) async {
    switch (name) {
      case 'add':
        final $0 = namedArguments['x'] as int;
        final $1 = namedArguments['y'] as int;
        final $2 = await _handler.add(x: $0, y: $1);
        return $2;
      default:
        throw StateError('Unknown remote procedure: \'$name\'');
    }
  }
}

class ExampleApiMethod {
  const ExampleApiMethod(
      {required this.authorize,
      required this.method,
      required this.name,
      required this.namedParameters,
      required this.positionalParameters,
      required this.path});

  final bool authorize;

  final String method;

  final String name;

  final List<String> namedParameters;

  final List<String> positionalParameters;

  final String path;
}

abstract class ExampleApiTransport {
  Future send(
      String name,
      String httpMethod,
      String path,
      Map<String, dynamic> positionalArguments,
      Map<String, dynamic> namedArguments);
}

abstract class ExampleApiUtils {
  static List<ExampleApiMethod> getMethods() {
    return const [
      ExampleApiMethod(
          authorize: true,
          method: 'POST',
          name: 'add',
          namedParameters: [],
          path: '/api/v1/add',
          positionalParameters: [])
    ];
  }
}

```

That's all for now!
