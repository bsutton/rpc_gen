import 'package:json_annotation/json_annotation.dart';

import 'package:rpc_gen/rpc_meta.dart';

import 'custom_http_json_transport.dart';

part 'example_jsonplaceholder.g.dart';

Future<void> main(List<String> args) async {
  final client = _Client();
  final id = 1;
  print('Comments with id $id:');
  final commentsById = await client.comments(id: id);
  for (final comment in commentsById) {
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

class _Transport extends CustomHttpJsonTransport with JsonPlaceholderTransport {
  @override
  final String host;

  @override
  final int? port;

  _Transport({required this.host, this.port});
}
