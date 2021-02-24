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
  //
  final z = true;
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
  final webServer =
      await HttpServer.bind(InternetAddress.anyIPv4, ExampleApiConfig.port);
  await for (final request in webServer) {
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
