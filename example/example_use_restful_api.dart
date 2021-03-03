import 'dart:convert';

import 'package:http/http.dart' as _http;
import 'package:json_annotation/json_annotation.dart';
import 'package:rpc_gen/rpc_http_transport.dart';
import 'package:rpc_gen/rpc_meta.dart';

part 'example_use_restful_api.g.dart';

Future<void> main(List<String> args) async {
  final client = _Client();
  final id = 1;
  print('Comments with post id $id:');
  final postComments = await client.postComments(id: id);
  for (final comment in postComments) {
    print('${comment.id}: ${comment.email}');
  }
}

@RpcService(host: 'https://jsonplaceholder.typicode.com')
abstract class JsonPlaceholder {
  @RpcMethod(path: '/posts/<id>/comments', httpMethod: 'GET')
  Future<List<_Comment>> postComments({required int id});
}

class _Client extends JsonPlaceholderClient {
  _Client() : super(_RestTransport(host: JsonPlaceholderConfig.host));
}

@JsonSerializable()
class _Comment {
  String? body;
  String? email;
  int? id;
  int? postId;

  _Comment();

  factory _Comment.fromJson(Map<String, dynamic> json) =>
      _$_CommentFromJson(json);

  Map<String, dynamic> toJson() => _$_CommentToJson(this);
}

class _Request {
  final Map<String, String> headers = {};
  final Uri url;

  _Request({required this.url});
}

class _RestTransport extends JsonPlaceholderTransport
    with RpcHttpTransport<_Request, _http.Response> {
  final String host;

  _RestTransport({required this.host});

  @override
  Future<_http.Response> get(_Request request, data) {
    return _http.get(request.url, headers: request.headers);
  }

  @override
  Future postprocess(_Request request, _http.Response response) async {
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw 'Bad response: ${response.statusCode}';
    }
  }

  @override
  Future<_Request> preprocess(String method, String path, data) async {
    final args = data as Map<String, dynamic>;
    for (final key in args.keys) {
      if (path.contains('<$key>')) {
        path = path.replaceAll('<$key>', '${args[key]}');
      } else {
        throw StateError(
            'Unable to apply the arguments to path \'$path\': $args');
      }
    }

    final uri = Uri.parse(host + path);
    final request = _Request(url: uri);
    return request;
  }
}
