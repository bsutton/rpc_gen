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
