import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'custom_http_json_transport.dart';
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

/// Transport, for demonstration only
class Transport extends CustomHttpJsonTransport with ExampleApiTransport {
  @override
  final String host;

  @override
  final int? port;

  Transport({required String host, this.port})
      : host = development ? 'http://localhost' : host;

  @override
  Future<SimpleRequest> preprocess(
      String name,
      String httpMethod,
      String path,
      Map<String, dynamic> positionalArguments,
      Map<String, dynamic> namedArguments) async {
    final body = {'p': positionalArguments, 'n': namedArguments};
    final url =
        port == null ? Uri.parse('$host$path') : Uri.parse('$host:$port$path');
    final request = SimpleRequest(url: url, body: body);
    request.headers['Content-Type'] = 'application/json';
    if (globalSecret != null) {
      request.headers[secretHeaderKey] = secretToken;
    }

    return request;
  }
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
  Future<int> add({required int x, required int y}) async {
    return x + y;
  }
}
