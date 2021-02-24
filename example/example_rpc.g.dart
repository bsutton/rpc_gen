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
