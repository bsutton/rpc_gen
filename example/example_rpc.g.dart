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
