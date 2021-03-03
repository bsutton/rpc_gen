class RpcKey {
  final bool? ignoreIfNull;

  final String? name;

  const RpcKey({this.ignoreIfNull, this.name});
}

class RpcMethod {
  final bool authorize;

  final bool? ignoreIfNull;

  final String httpMethod;

  final String path;

  const RpcMethod(
      {this.authorize = false,
      this.ignoreIfNull,
      this.httpMethod = 'POST',
      required this.path});
}

class RpcService {
  final int? clientPort;

  final String host;

  final int? serverPort;

  const RpcService({this.clientPort, required this.host, this.serverPort});
}
