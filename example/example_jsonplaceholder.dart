import 'dart:convert';

import 'package:http/http.dart' as _http;
import 'package:json_annotation/json_annotation.dart';
import 'package:rpc_gen/rpc_meta.dart';

import 'custom_http_json_transport.dart';

part 'example_jsonplaceholder.g.dart';

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

/// This class is an example of a transport
/// A similar transport class can be reused
class Transport extends CustomHttpJsonTransport with JsonPlaceholderTransport {
  @override
  final String host;

  @override
  final int? port;

  Transport({required this.host, this.port});

  @override
  Future postprocess(SimpleRequest request, _http.Response response) async {
    switch (response.statusCode) {
      case 200:
      case 201:
        return jsonDecode(response.body);
      default:
        throw 'Bad response: ${response.statusCode}\n${response.body}';
    }
  }

  @override
  Future<SimpleRequest> preprocess(
      String name,
      String httpMethod,
      String path,
      Map<String, dynamic> positionalArguments,
      Map<String, dynamic> namedArguments) async {
    final methodName = '$httpMethod.$name';
    var queryString = '';
    var body;
    final hasPathArguments = path.contains('<');
    switch (httpMethod) {
      case 'GET':
      case 'HEAD':
        if (hasPathArguments) {
          path =
              _buildPath(methodName, path, positionalArguments, 'positional');
        }

        queryString = _buildQueryString(methodName, namedArguments);
        break;
      default:
        if (hasPathArguments) {
          path = _buildPath(methodName, path, namedArguments, 'named');
        }

        if (positionalArguments.length > 1) {
          StateError(
              'The number of positional arguments must not exceed one argument when calling method \'$name\'');
        }

        if (positionalArguments.length == 1) {
          body = positionalArguments.values.first;
        }
    }

    final url = port == null
        ? Uri.parse('$host$path$queryString')
        : Uri.parse('$host:$port$path$queryString');
    final request = SimpleRequest(url: url, body: body);
    request.headers['Content-type'] = 'application/json; charset=UTF-8';
    return request;
  }

  String _buildPath(String methodName, String path,
      Map<String, dynamic> arguments, String kind) {
    final parts = path.split('/');
    final keys = <String>[];
    final processed = <String>{};
    for (var i = 0; i < parts.length; i++) {
      final part = parts[i];
      if (part.startsWith('<') && part.endsWith('>')) {
        final key = part.substring(1, part.length - 1);
        if (!arguments.containsKey(key)) {
          throw StateError(
              'Path argument \'$key\' was not be found in $kind arguments when calling method \'$methodName\'');
        }

        final argument = arguments[key];
        final type = argument.runtimeType;
        _checkArgumentType(type,
            'Invalid type \'$type\' of path argument \'$key\' in path \'$path\' when calling method \'$methodName\'');
        parts[i] = '$argument';
        keys.add(key);
        processed.add(part);
      }
    }

    for (final key in arguments.keys) {
      if (!processed.add(key)) {
        throw StateError(
            'Path argument \'$key\' from $kind arguments was not be found in path \'$path\' when calling method \'$methodName\'');
      }
    }

    return parts.join('/');
  }

  String _buildQueryString(String methodName, Map<String, dynamic> arguments) {
    for (final key in arguments.keys) {
      final argument = arguments[key];
      final type = argument.runtimeType;
      _checkArgumentType(type,
          'Invalid type \'$type\' of query argument \'$key\' when calling method \'$methodName\'');
    }

    return '?' +
        Uri(queryParameters: arguments.map((k, v) => MapEntry(k, '$v'))).query;
  }

  void _checkArgumentType(Type type, String error) {
    switch (type) {
      case bool:
      case double:
      case int:
      case num:
      case String:
        break;
      default:
        throw StateError(error);
    }
  }
}
