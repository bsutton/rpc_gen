import 'dart:convert';

import 'package:http/http.dart' as _http;
import 'package:json_annotation/json_annotation.dart';
import 'package:rpc_gen/rpc_http_transport.dart';
import 'package:rpc_gen/rpc_meta.dart';

part 'example_jsonplaceholder.g.dart';

Future<void> main(List<String> args) async {
  final client = _Client();
  final id = 1;
  print('Comments with id $id:');
  final commentsById = await client.comments(id: id);
  for (final comment in await client.comments(id: 1)) {
    print('${comment.id}: ${comment.email}');
  }

  if (commentsById.isNotEmpty) {
    final comment = commentsById.first;
    print('Comments with email ${comment.email}:');
    final commentsByEmail = await client.comments(email: comment.email);
    for (final comment in commentsByEmail) {
      print('${comment.id}: ${comment.email}');
    }
  }
}

@RpcService(host: 'https://jsonplaceholder.typicode.com')
abstract class JsonPlaceholder {
  @RpcMethod(path: '/comments', httpMethod: 'GET', ignoreIfNull: true)
  Future<List<_Comment>> comments({String? email, int? id, int? postId});
}

class _Client extends JsonPlaceholderClient {
  _Client() : super(_Transport(host: JsonPlaceholderConfig.host));
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

class _Transport extends JsonPlaceholderTransport
    with RpcHttpTransport<_Request, _http.Response> {
  final String host;

  _Transport({required this.host});

  @override
  Future<_http.Response> get(_Request request, data) {
    final queryString =
        Uri(queryParameters: (data as Map).map((k, v) => MapEntry('$k', '$v')))
            .query;
    final url = Uri.parse('${request.url}?$queryString');
    return _http.get(url, headers: request.headers);
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
    final uri = Uri.parse(host + path);
    final request = _Request(url: uri);
    return request;
  }
}
