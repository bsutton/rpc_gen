# rpc_gen

The `rpc_gen` is a builder and generator of RPC (Remote Procedure Call) stub files.  

ATTENTION: Under development

Version 0.1.4

Why need another RPC?

Although this software makes it easy to implement a client and server to call remote procedures (RPC) from the client, it is not limited to this application only.  

This software also makes it easy to implement a client to access various external APIs in the form of external procedure calls (or simply, method calls).  

And, of course, it is possible to organize (limited) work with the RestFul API (via custom transport implementation).  
Not the best way, but many do it in the same way, but with their own hands.  

Of course, all of this can be done manually, but it may take a little longer.  

The main goals and purpose of this project:

- Easy adaptation for use with existing external APIs
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
  @RpcMethod(path: '/comments', httpMethod: 'GET', ignoreIfNull: true)
  Future<List<_Comment>> comments({String? email, int? id, int? postId});
}
```

Source code of example:

```dart
import 'dart:convert';

import 'package:http/http.dart' as _http;
import 'package:json_annotation/json_annotation.dart';
import 'package:rpc_gen/rpc_http_transport.dart';
import 'package:rpc_gen/rpc_meta.dart';

part 'example_jsonplaceholder.g.dart';

Future<void> main(List<String> args) async {
  final client = _Client();
  final id = 1;
  print('Comments with id $id:');
  final commentsById = await client.comments(id: id);
  for (final comment in await client.comments(id: 1)) {
    print('${comment.id}: ${comment.email}');
  }

  if (commentsById.isNotEmpty) {
    final comment = commentsById.first;
    print('Comments with email ${comment.email}:');
    final commentsByEmail = await client.comments(email: comment.email);
    for (final comment in commentsByEmail) {
      print('${comment.id}: ${comment.email}');
    }
  }
}

@RpcService(host: 'https://jsonplaceholder.typicode.com')
abstract class JsonPlaceholder {
  @RpcMethod(path: '/comments', httpMethod: 'GET', ignoreIfNull: true)
  Future<List<_Comment>> comments({String? email, int? id, int? postId});
}

class _Client extends JsonPlaceholderClient {
  _Client() : super(_Transport(host: JsonPlaceholderConfig.host));
}

@JsonSerializable()
class _Comment {
  String? body;
  String? email;
  int? id;
  int? postId;

  _Comment();

  factory _Comment.fromJson(Map<String, dynamic> json) =>
      _$_CommentFromJson(json);

  Map<String, dynamic> toJson() => _$_CommentToJson(this);
}

class _Request {
  final Map<String, String> headers = {};
  final Uri url;

  _Request({required this.url});
}

class _Transport extends JsonPlaceholderTransport
    with RpcHttpTransport<_Request, _http.Response> {
  final String host;

  _Transport({required this.host});

  @override
  Future<_http.Response> get(_Request request, data) {
    final queryString =
        Uri(queryParameters: (data as Map).map((k, v) => MapEntry('$k', '$v')))
            .query;
    final url = Uri.parse('${request.url}?$queryString');
    return _http.get(url, headers: request.headers);
  }

  @override
  Future postprocess(_Request request, _http.Response response) async {
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw 'Bad response: ${response.statusCode}';
    }
  }

  @override
  Future<_Request> preprocess(String method, String path, data) async {
    final uri = Uri.parse(host + path);
    final request = _Request(url: uri);
    return request;
  }
}

```

The example looks like a bit complicated source code, but most of the code is the source code for models and transport for sending and receiving data.  
If this code is taken out of the code of the example, then the example will look much simpler.  

```dart
import 'dart:convert';

import 'package:http/http.dart' as _http;
import 'package:json_annotation/json_annotation.dart';
import 'package:rpc_gen/rpc_http_transport.dart';
import 'package:rpc_gen/rpc_meta.dart';

part 'example_jsonplaceholder.g.dart';

Future<void> main(List<String> args) async {
  final client = _Client();
  final id = 1;
  print('Comments with id $id:');
  final commentsById = await client.comments(id: id);
  for (final comment in await client.comments(id: 1)) {
    print('${comment.id}: ${comment.email}');
  }

  if (commentsById.isNotEmpty) {
    final comment = commentsById.first;
    print('Comments with email ${comment.email}:');
    final commentsByEmail = await client.comments(email: comment.email);
    for (final comment in commentsByEmail) {
      print('${comment.id}: ${comment.email}');
    }
  }
}

@RpcService(host: 'https://jsonplaceholder.typicode.com')
abstract class JsonPlaceholder {
  @RpcMethod(path: '/comments', httpMethod: 'GET', ignoreIfNull: true)
  Future<List<_Comment>> comments({String? email, int? id, int? postId});
}

class _Client extends JsonPlaceholderClient {
  _Client() : super(_Transport(host: JsonPlaceholderConfig.host));
}

```

A very simple example of how to access the RestFul API via custom transport:  
The principle of operation is not new and lies in the fact that the method parameters are specified in the path (for example, so `/posts/<id>/comments`) and, before sending, they are replaced with the passed values in the transport.  

```dart
import 'dart:convert';

import 'package:http/http.dart' as _http;
import 'package:json_annotation/json_annotation.dart';
import 'package:rpc_gen/rpc_http_transport.dart';
import 'package:rpc_gen/rpc_meta.dart';

part 'example_use_restful_api.g.dart';

Future<void> main(List<String> args) async {
  final client = _Client();
  final id = 1;
  print('Comments with post id $id:');
  final postComments = await client.postComments(id: id);
  for (final comment in postComments) {
    print('${comment.id}: ${comment.email}');
  }
}

@RpcService(host: 'https://jsonplaceholder.typicode.com')
abstract class JsonPlaceholder {
  @RpcMethod(path: '/posts/<id>/comments', httpMethod: 'GET')
  Future<List<_Comment>> postComments({required int id});
}

class _Client extends JsonPlaceholderClient {
  _Client() : super(_RestTransport(host: JsonPlaceholderConfig.host));
}

@JsonSerializable()
class _Comment {
  String? body;
  String? email;
  int? id;
  int? postId;

  _Comment();

  factory _Comment.fromJson(Map<String, dynamic> json) =>
      _$_CommentFromJson(json);

  Map<String, dynamic> toJson() => _$_CommentToJson(this);
}

class _Request {
  final Map<String, String> headers = {};
  final Uri url;

  _Request({required this.url});
}

class _RestTransport extends JsonPlaceholderTransport
    with RpcHttpTransport<_Request, _http.Response> {
  final String host;

  _RestTransport({required this.host});

  @override
  Future<_http.Response> get(_Request request, data) {
    return _http.get(request.url, headers: request.headers);
  }

  @override
  Future postprocess(_Request request, _http.Response response) async {
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw 'Bad response: ${response.statusCode}';
    }
  }

  @override
  Future<_Request> preprocess(String method, String path, data) async {
    final args = data as Map<String, dynamic>;
    for (final key in args.keys) {
      if (path.contains('<$key>')) {
        path = path.replaceAll('<$key>', '${args[key]}');
      } else {
        throw StateError(
            'Unable to apply the arguments to path \'$path\': $args');
      }
    }

    final uri = Uri.parse(host + path);
    final request = _Request(url: uri);
    return request;
  }
}

```

Another example:

Let's say we need to organize and coordinate the call of the following remote procedures:

- `Future<int> add({required int x, required int y})`

How can we quickly organize client-server interactions?  
What if we need not 3 procedures, but much more?  

How to implement it quickly and conveniently and without errors?  

First you need to describe the interaction interfaces:

```dart
import 'package:rpc_gen/rpc_meta.dart';

part 'example_rpc.g.dart';

const _path = '/example_api/v1/';

@RpcService(host: 'http://exmaple.com', serverPort: 8002)
abstract class ExampleApi {
  @RpcMethod(path: _path + 'add', authorize: true)
  Future<int> add({required int x, required int y});
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

```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example_rpc.dart';

// **************************************************************************
// RpcGenerator
// **************************************************************************

class ExampleApiClient implements ExampleApi {
  ExampleApiClient(this._transport);

  final ExampleApiTransport _transport;

  @override
  Future<int> add({required int x, required int y}) async {
    final $0 = <String, dynamic>{};
    $0['x'] = x;
    $0['y'] = y;
    final $1 = await _transport.send('POST', '/example_api/v1/add', $0);
    return $1 as int;
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

  Future handle(String name, data) async {
    switch (name) {
      case 'add':
        final $0 = data as Map;
        final $1 = $0['x'] as int;
        final $2 = $0['y'] as int;
        final $3 = await _handler.add(x: $1, y: $2);
        return $3;
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
      required this.path});

  final bool authorize;

  final String method;

  final String name;

  final String path;
}

abstract class ExampleApiTransport {
  Future send(String method, String path, request);
}

abstract class ExampleApiUtils {
  static List<ExampleApiMethod> getMethods() {
    return const [
      ExampleApiMethod(
          authorize: true,
          method: 'POST',
          name: 'add',
          path: '/example_api/v1/add')
    ];
  }
}

```

Not much code, but you would have to write all this code (or similar) by hand whenever you make a change. But now there is no need to do this, the generator will do everything for you.  

Finally, an example of how these classes can be used with maximum efficiency.  

The source code of the example will contain a little more code than we would like (to organize the interaction), but this code is the code of the program, without which nothing will work at all (function "main", web server, calls from client, etc.). In real life, this code will be different, but it is included in the example as an illustrative part.  


```dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as _http;
import 'package:rpc_gen/rpc_http_transport.dart';
import 'package:rpc_gen/rpc_meta.dart';

import 'example_rpc.dart';

void main() async {
  // Schedule a delayed client launch
  Timer(Duration(seconds: 2), () async {
    await _runCleint();
    exit(0);
  });

  // Start web server
  await _serve();
}

bool development = true;

const secretHeaderKey = 'SECRET';

const secretToken = '123';

String? globalSecret;

/// Client runner, for demonstration only
Future<void> _runCleint() async {
  final client = Client();
  globalSecret = secretToken;
  final x = 2;
  final y = 3;
  final res1 = await client.add(x: x, y: y);
  print('add($x,$y) = ${res1}');
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
        final result = await handler.handle(method.name, data);
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

/// Transport, for demonstration only
abstract class Transport extends RpcHttpTransport<_Request, _http.Response> {
  final String host;

  final int? port;

  Transport({required this.host, this.port});

  @override
  Future<_http.Response> post(_Request request, data) {
    return _http.post(request.uri,
        body: jsonEncode(data), headers: request.headers);
  }

  @override
  Future postprocess(_Request request, _http.Response response) async {
    if (response.statusCode != 200) {
      throw StateError('RPC error: ${response.statusCode}');
    }

    return jsonDecode(response.body);
  }

  @override
  Future<_Request> preprocess(String method, String path, data) async {
    final headers = <String, String>{};
    if (globalSecret != null) {
      headers[secretHeaderKey] = globalSecret!;
    }

    headers['Content-Type'] = 'application/json';
    final host = development ? 'http://localhost' : this.host;
    late Uri uri;
    if (port != null) {
      uri = Uri.parse('$host:$port$path');
    } else {
      uri = Uri.parse('$host$path');
    }

    final request = _Request(uri: uri);
    request.headers.addAll(headers);
    return request;
  }
}

/// Request, for demonstration only
class _Request {
  final Map<String, String> headers = {};

  final Uri uri;

  _Request({required this.uri});
}

// **************************************************************************
// Our own client, handwritten
// **************************************************************************

class Client extends ExampleApiClient {
  Client() : super(ClientTransport());
}

/// Client transport implementation
class ClientTransport extends Transport with ExampleApiTransport {
  ClientTransport()
      : super(host: ExampleApiConfig.host, port: ExampleApiConfig.clientPort);
}

// **************************************************************************
// Our own server, handwritten
// **************************************************************************

/// ServerHandler
class ServerHandler extends ExampleApiHandler {
  ServerHandler() : super(ServerService());
}

/// ServerService
class ServerService extends ExampleApi {
  @override
  @RpcMethod(path: '/add', authorize: true)
  Future<int> add({required int x, required int y}) async {
    return x + y;
  }
}

```

That's all for now!
