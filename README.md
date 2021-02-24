# rpc_gen

The `rpc_gen` is a builder and generator of RPC (Remote Procedure Call) stub files.  

ATTENTION: Under development

Version 0.1.0

The main goals and purpose of this project:

- Fast (in minutes) creation of RPC services simultaneously for server and client
- Fast (in seconds) creation of RPC procedures simultaneously on the server and client
- Maximum flexibility in the choice of how to send and handle procedure calls
- Easily maintenance of consistency of source code for procedures on both layers

Conventions (or limitations, if you like to call it that):

- The `Request` and `Response` classes must be JSON models
- The JSON models must contain a constructor like `formJson(Map json)`
- The JSON models must contain an instance method like `Map<String, dynamic> toJson()`
- The RPC methods must be declared like `Future<Response> Function(Request)`
- The RPC service metadata class (interface) should contain nothing but methods

Example:

Let's say we need to organize and coordinate the call of the following remote procedures:

- `Future<AddResponse> add(AddRequest request)`
- `Future<NotResponse> not(NotRequest request)`
- `Future<VoidResponse> void_(VoidRequest request)`

How can we quickly organize client-server interactions?  
What if we need not 3 procedures, but much more?  

How to implement it quickly and conveniently and without errors?  

First you need to describe the interaction interfaces:

```dart
// Import RPC annotation metadata
import 'package:rpc_gen/rpc_meta.dart';

// Import used JSON models
import 'example_objects.dart';

// Export used JSON models
export 'example_objects.dart';

// Import generated RPC stub files
part 'example_rpc.g.dart';

// Path to our service
const _path = '/example_api/v1/';

// The "host" and "path" parameters must be specified, but this is only
// configuration (which can be ignored)
@RpcService(host: 'http://localhost', port: 8002)
abstract class ExampleApi {
  @RpcMethod(path: _path + 'add')
  Future<AddResponse> add(AddRequest request);

  @RpcMethod(path: _path + 'not')
  Future<NotResponse> not(NotRequest request);

  @RpcMethod(path: _path + 'void', authorize: true)
  Future<VoidResponse> void_(VoidRequest request);
}

```

Based on this code (in fact, interfaces), classes for work on the server and client will be generated.

List of generated classes:

- ExampleApiClient
- ExampleApiMethod
- ExampleApiServer
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
  Future<AddResponse> add(AddRequest request) async {
    final json = request.toJson();
    final response = await _transport.send('POST', '/example_api/v1/add', json);
    return AddResponse.fromJson(response);
  }

  @override
  Future<NotResponse> not(NotRequest request) async {
    final json = request.toJson();
    final response = await _transport.send('POST', '/example_api/v1/not', json);
    return NotResponse.fromJson(response);
  }

  @override
  Future<VoidResponse> void_(VoidRequest request) async {
    final json = request.toJson();
    final response =
        await _transport.send('POST', '/example_api/v1/void', json);
    return VoidResponse.fromJson(response);
  }
}

class ExampleApiConfig {
  static const String host = 'http://localhost';

  static const int port = 8002;
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

abstract class ExampleApiServer {
  ExampleApiServer(this._handler);

  final ExampleApi _handler;

  Future<Map> handle(String method, Map json) async {
    switch (method) {
      case 'add':
        final request = AddRequest.fromJson(json);
        final response = await _handler.add(request);
        return response.toJson();
      case 'not':
        final request = NotRequest.fromJson(json);
        final response = await _handler.not(request);
        return response.toJson();
      case 'void_':
        final request = VoidRequest.fromJson(json);
        final response = await _handler.void_(request);
        return response.toJson();
      default:
        throw StateError('Unknown remote procedure: \'$method\'');
    }
  }
}

abstract class ExampleApiTransport {
  Future<Map> send(String method, String path, Map request);
}

abstract class ExampleApiUtils {
  static List<ExampleApiMethod> getMethods() {
    return const [
      ExampleApiMethod(
          authorize: false,
          method: 'POST',
          name: 'add',
          path: '/example_api/v1/add'),
      ExampleApiMethod(
          authorize: false,
          method: 'POST',
          name: 'not',
          path: '/example_api/v1/not'),
      ExampleApiMethod(
          authorize: true,
          method: 'POST',
          name: 'void_',
          path: '/example_api/v1/void')
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

const secretHeaderKey = 'SECRET';

const secretToken = '123';

String? globalSecret;

// Client runner, for demonstration only
Future<void> _runCleint() async {
  final client = Client();
  final x = 2;
  final y = 3;
  final res1 = await client.add(AddRequest(arg1: x, arg2: y));
  print('add($x,$y) = ${res1.result}');
  final z = true;
  //
  final res2 = await client.not(NotRequest(arg: true));
  print('not($z) = ${res2.result}');
  //
  globalSecret = secretToken;
  final name = 'Jack';
  final res3 = await client.void_(VoidRequest(name: name));
  print('void($name) = ${res3.result}');
}

// Web server, for demonstration only
Future<void> _serve() async {
  final app = App();
  app.db = 'use db...';
  final wevServer =
      await HttpServer.bind(InternetAddress.anyIPv4, ExampleApiConfig.port);
  await for (final request in wevServer) {
    final response = request.response;
    try {
      final path = request.uri.path;
      final procs = ExampleApiUtils.getMethods()
          .where((e) => e.path == path && e.method == request.method);
      if (procs.isNotEmpty) {
        final proc = procs.first;
        if (proc.authorize) {
          if (request.headers.value(secretHeaderKey) != secretToken) {
            response.statusCode = 401;
            throw 'Unauthorized access';
          } else {
            print('Authorized access');
          }
        }

        final source = await utf8.decodeStream(request);
        final json = jsonDecode(source);
        if (json is Map) {
          final server = Server(app, request);
          final object = await server.handle(proc.name, json);
          response.write(jsonEncode(object));
        } else {
          throw StateError(
              'Wrong argument type for method \'${proc.name}\': ${json.runtimeType}');
        }
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

// Application, for demonstration only
class App {
  late Object db;
}

// **************************************************************************
// Our own client, handwritten
// **************************************************************************

// Client implementation
class Client extends ExampleApiClient {
  Client() : super(ClientTransport());
}

// Client transport implementation
class ClientTransport extends ExampleApiTransport {
  @override
  Future<Map> send(String method, String path, Map request) async {
    if (method != 'POST') {
      throw UnimplementedError('Oops!!! Method \'$method\' unimplemented');
    }

    final headers = <String, String>{};
    if (globalSecret != null) {
      headers[secretHeaderKey] = globalSecret!;
    }

    final host = ExampleApiConfig.host;
    // You can ignore port
    final port = ExampleApiConfig.port;
    final uri = Uri.parse('$host:$port$path');
    final req =
        await _http.post(uri, body: jsonEncode(request), headers: headers);
    if (req.statusCode != 200) {
      throw StateError('Rpc error: ${req.statusCode}');
    }

    final json = jsonDecode(req.body);
    if (json is Map) {
      return json;
    }

    throw StateError('Rpc error: Wrong response value');
  }
}

// **************************************************************************
// Our own server, handwritten
// **************************************************************************

// Server implementation
class Server extends ExampleApiServer {
  Server(App app, HttpRequest _request) : super(ServerHandler(app, _request));
}

// Server handler implementation
class ServerHandler extends ExampleApi {
  final App _app;

  // Can be used to access session data
  final HttpRequest _request;

  ServerHandler(this._app, this._request);

  @override
  Future<AddResponse> add(AddRequest request) async {
    print(_app.db);
    return AddResponse(result: request.arg1! + request.arg2!);
  }

  @override
  Future<NotResponse> not(NotRequest request) async {
    return NotResponse(result: !request.arg!);
  }

  @override
  Future<VoidResponse> void_(VoidRequest request) async {
    final name = request.name ?? 'Unknown';
    return VoidResponse(result: 'Hello you, $name!');
  }
}

```

That's all for now!
