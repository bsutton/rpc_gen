class RpcRequest {
  final Uri url;

  final dynamic body;

  RpcRequest({this.body, required this.url});

  final Map<String, String> headers = {};
}
