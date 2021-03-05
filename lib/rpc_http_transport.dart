abstract class RpcHttpTransport<TRequest, TResponse> {
  Future<TResponse> delete(TRequest request) async {
    unimplementedHttpMethod('DELETE');
  }

  Future<TResponse> get(TRequest request) async {
    unimplementedHttpMethod('GET');
  }

  Future<TResponse> head(TRequest request) async {
    unimplementedHttpMethod('HEAD');
  }

  Future<TResponse> options(TRequest request) async {
    unimplementedHttpMethod('OPTIONS');
  }

  Future<TResponse> patch(TRequest request) async {
    unimplementedHttpMethod('PATCH');
  }

  Future<TResponse> post(TRequest request) async {
    unimplementedHttpMethod('POST');
  }

  Future postprocess(TRequest request, TResponse response);

  Future<TRequest> preprocess(
      String name,
      String httpMethod,
      String path,
      Map<String, dynamic> positionalArguments,
      Map<String, dynamic> namedArguments);

  Future<TResponse> put(TRequest request) async {
    unimplementedHttpMethod('PUT');
  }

  Future send(
      String name,
      String httpMethod,
      String path,
      Map<String, dynamic> positionalArguments,
      Map<String, dynamic> namedArguments) async {
    final request = await preprocess(
        name, httpMethod, path, positionalArguments, namedArguments);
    late TResponse response;
    switch (httpMethod) {
      case 'GET':
        response = await get(request);
        break;
      case 'HEAD':
        response = await head(request);
        break;
      case 'POST':
        response = await post(request);
        break;
      case 'PUT':
        response = await put(request);
        break;
      case 'DELETE':
        response = await delete(request);
        break;
      case 'OPTIONS':
        response = await options(request);
        break;
      case 'TRACE':
        response = await trace(request);
        break;
      case 'PATCH':
        response = await patch(request);
        break;
      default:
        throw UnsupportedError(
            'Sending data using the http method \'$httpMethod\' is not supported');
    }

    return postprocess(request, response);
  }

  Future<TResponse> trace(TRequest request) async {
    unimplementedHttpMethod('TRACE');
  }

  Never unimplementedHttpMethod(String httpMethod) {
    throw UnimplementedError(
        'Sending data using the http method \'$httpMethod\' is not supported');
  }
}
