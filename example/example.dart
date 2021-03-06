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
