abstract class RpcHttpTransport<TRequest, TResponse> {
  Future<TResponse> delete(TRequest request, data) async {
    unsupportedMethod('DELETE');
  }

  Future<TResponse> get(TRequest request, datan) async {
    unsupportedMethod('GET');
  }

  Future<TResponse> head(TRequest request, data) async {
    unsupportedMethod('HEAD');
  }

  Future<TResponse> options(TRequest request, data) async {
    unsupportedMethod('OPTIONS');
  }

  Future<TResponse> patch(TRequest request, data) async {
    unsupportedMethod('PATCH');
  }

  Future<TResponse> post(TRequest request, data) async {
    unsupportedMethod('POST');
  }

  Future postprocess(TRequest request, TResponse response);

  Future<TRequest> preprocess(String method, String path, data);

  Future<TResponse> put(TRequest request, data) async {
    unsupportedMethod('PUT');
  }

  Future send(String method, String path, data) async {
    final request = await preprocess(method, path, data);
    late TResponse response;
    switch (method) {
      case 'GET':
        response = await get(request, data);
        break;
      case 'HEAD':
        response = await head(request, data);
        break;
      case 'POST':
        response = await post(request, data);
        break;
      case 'PUT':
        response = await put(request, data);
        break;
      case 'DELETE':
        response = await delete(request, data);
        break;
      case 'OPTIONS':
        response = await options(request, data);
        break;
      case 'TRACE':
        response = await trace(request, data);
        break;
      case 'PATCH':
        response = await patch(request, data);
        break;
      default:
        unsupportedMethod(method);
    }

    return postprocess(request, response);
  }

  Future<TResponse> trace(TRequest request, data) async {
    unsupportedMethod('TRACE');
  }

  Never unsupportedMethod(String method) {
    throw UnsupportedError(
        'Sending data using the \'$method\' method is not supported');
  }
}
