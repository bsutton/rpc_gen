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
    final $1 = <String, dynamic>{};
    final $2 = <String, dynamic>{};
    $2['x'] = x;
    $2['y'] = y;
    final $0 =
        await _transport.send('add', 'POST', '/example_api/v1/add', $1, $2);
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
          path: '/example_api/v1/add',
          positionalParameters: [])
    ];
  }
}
