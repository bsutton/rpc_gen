import 'dart:convert';

import 'package:http/http.dart' as _http;
import 'package:json_annotation/json_annotation.dart';
import 'package:rpc_gen/rpc_meta.dart';

import '_rest_transport.dart';

part 'example_use_jsonplaceholder.g.dart';

Future<void> main(List<String> args) async {
  final client = Client();
  final commnetId = 1;
  print('Comments with id $commnetId:');
  final commentsById = await client.comments(id: commnetId);
  for (final comment in commentsById) {
    print('id: ${comment.id}, email: ${comment.email}');
  }

  print('====');
  if (commentsById.isNotEmpty) {
    final comment = commentsById.first;
    print('Comments with email ${comment.email}:');
    final commentsByEmail = await client.comments(email: comment.email);
    for (final comment in commentsByEmail) {
      print('id: ${comment.id}, email: ${comment.email}');
    }
  }

  print('====');
  final postId = 1;
  var post = await client.postById(postId);
  print('Post with id $postId:');
  print('id: ${post.id}, user id ${post.userId}');

  print('====');
  post = Post()
    ..title = 'foo'
    ..body = 'bar'
    ..userId = 1;

  try {
    post = await client.addPost(post);
    print('Added post with id ${post.id}');
  } catch (e) {
    print(e);
  }

  print('====');
  try {
    post.id = 1;
    post.title = 'it works!';
    post = await client.updatePost(post, id: 1);
    print('Update post with id ${post.id}, title: ${post.title}');
  } catch (e) {
    print(e);
  }
}

class Client extends JsonPlaceholderClient {
  Client() : super(Transport(host: JsonPlaceholderConfig.host));
}

@JsonSerializable()
class Comment {
  String? body;
  String? email;
  int? id;
  int? postId;

  Comment();

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}

@RpcService(host: 'https://jsonplaceholder.typicode.com')
abstract class JsonPlaceholder {
  @RpcMethod(path: '/posts', httpMethod: 'POST')
  Future<Post> addPost(Post post);

  @RpcMethod(path: '/comments', httpMethod: 'GET', ignoreIfNull: true)
  Future<List<Comment>> comments({String? email, int? id, int? postId});

  @RpcMethod(path: '/posts/<id>/comments', httpMethod: 'GET')
  Future<List<Comment>> commentsByPostId(int id);

  @RpcMethod(path: '/posts/<id>', httpMethod: 'GET')
  Future<Post> postById(int id);

  @RpcMethod(path: '/posts/<id>', httpMethod: 'PUT')
  Future<Post> updatePost(Post post, {required int id});
}

@JsonSerializable()
class Post {
  int? userId;
  int? id;
  String? title;
  String? body;

  Post();

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}

class Transport extends RestTransport with JsonPlaceholderTransport {
  @override
  final String host;

  @override
  final int? port;

  Transport({required this.host, this.port});

  @override
  Future postprocess(RpcRequest request, _http.Response response) async {
    switch (response.statusCode) {
      case 200:
      case 201:
        return jsonDecode(response.body);
      default:
        throw 'Bad response: ${response.statusCode}\n${response.body}';
    }
  }
}
