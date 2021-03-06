import 'dart:convert';

import 'package:http/http.dart' as _http;
import 'package:rpc_gen/rpc_http_transport.dart';

import '_rpc_request.dart';

export '_rpc_request.dart';

abstract class HttpTransport
    extends RpcHttpTransport<RpcRequest, _http.Response> {
  String get host;

  int? get port;

  @override
  Future<_http.Response> delete(RpcRequest request) async {
    return _http.delete(request.url,
        headers: request.headers, body: jsonEncode(request.body));
  }

  @override
  Future<_http.Response> get(RpcRequest request) {
    return _http.get(request.url, headers: request.headers);
  }

  @override
  Future<_http.Response> head(RpcRequest request) async {
    return _http.head(request.url, headers: request.headers);
  }

  @override
  Future<_http.Response> patch(RpcRequest request) async {
    return _http.patch(request.url,
        headers: request.headers, body: jsonEncode(request.body));
  }

  @override
  Future<_http.Response> post(RpcRequest request) async {
    return _http.post(request.url,
        headers: request.headers, body: jsonEncode(request.body));
  }

  @override
  Future<_http.Response> put(RpcRequest request) async {
    return _http.put(request.url,
        headers: request.headers, body: jsonEncode(request.body));
  }
}
