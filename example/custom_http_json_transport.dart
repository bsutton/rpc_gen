import 'dart:convert';

import 'package:http/http.dart' as _http;
import 'package:rpc_gen/rpc_http_transport.dart';

import 'custom_request.dart';

export 'custom_request.dart';

abstract class CustomHttpJsonTransport
    extends RpcHttpTransport<CustomRequest, _http.Response> {
  String get host;

  int? get port;

  @override
  Future<_http.Response> get(CustomRequest request, data) {
    final queryString =
        Uri(queryParameters: (data as Map).map((k, v) => MapEntry('$k', '$v')))
            .query;
    final url = Uri.parse('${request.url}?$queryString');
    return _http.get(url, headers: request.headers);
  }

  @override
  Future<_http.Response> post(CustomRequest request, data) async {
    return _http.post(request.url,
        headers: request.headers, body: jsonEncode(data));
  }

  @override
  Future postprocess(CustomRequest request, _http.Response response) async {
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw 'Bad response: ${response.statusCode}\n${response.body}';
    }
  }

  @override
  Future<CustomRequest> preprocess(String method, String path, data) async {
    final url =
        port == null ? Uri.parse('$host$path') : Uri.parse('$host:$port$path');
    final request = CustomRequest(url: url);
    request.headers['Content-Type'] = 'application/json';
    return request;
  }
}
