import 'dart:convert';

import 'package:http/http.dart' as _http;
import 'package:rpc_gen/rpc_http_transport.dart';

import 'simple_request.dart';

export 'simple_request.dart';

abstract class CustomHttpJsonTransport
    extends RpcHttpTransport<SimpleRequest, _http.Response> {
  String get host;

  int? get port;

  @override
  Future<_http.Response> delete(SimpleRequest request) async {
    return _http.delete(request.url,
        headers: request.headers, body: jsonEncode(request.body));
  }

  @override
  Future<_http.Response> get(SimpleRequest request) {
    return _http.get(request.url, headers: request.headers);
  }

  @override
  Future<_http.Response> head(SimpleRequest request) async {
    return _http.head(request.url, headers: request.headers);
  }

  @override
  Future<_http.Response> patch(SimpleRequest request) async {
    return _http.patch(request.url,
        headers: request.headers, body: jsonEncode(request.body));
  }

  @override
  Future<_http.Response> post(SimpleRequest request) async {
    return _http.post(request.url,
        headers: request.headers, body: jsonEncode(request.body));
  }

  @override
  Future postprocess(SimpleRequest request, _http.Response response) async {
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw 'Bad response: ${response.statusCode}\n${response.body}';
    }
  }

  @override
  Future<_http.Response> put(SimpleRequest request) async {
    return _http.put(request.url,
        headers: request.headers, body: jsonEncode(request.body));
  }
}
