class RpcMethod {
  final bool authorize;

  final String method;

  final String path;

  const RpcMethod(
      {this.authorize = false, this.method = 'POST', required this.path});
}

class RpcService {
  final String host;

  final int port;

  const RpcService({required this.host, required this.port});
}
