// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example_jsonplaceholder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) {
  return Comment()
    ..body = json['body'] as String?
    ..email = json['email'] as String?
    ..id = json['id'] as int?
    ..postId = json['postId'] as int?;
}

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'body': instance.body,
      'email': instance.email,
      'id': instance.id,
      'postId': instance.postId,
    };

Post _$PostFromJson(Map<String, dynamic> json) {
  return Post()
    ..userId = json['userId'] as int?
    ..id = json['id'] as int?
    ..title = json['title'] as String?
    ..body = json['body'] as String?;
}

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'userId': instance.userId,
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
    };

// **************************************************************************
// RpcGenerator
// **************************************************************************

class JsonPlaceholderClient implements JsonPlaceholder {
  JsonPlaceholderClient(this._transport);

  final JsonPlaceholderTransport _transport;

  @override
  Future<Post> addPost(Post post) async {
    final $1 = <String, dynamic>{};
    final $2 = <String, dynamic>{};
    $1['post'] = post.toJson();
    final $0 = await _transport.send('addPost', 'POST', '/posts', $1, $2);
    return Post.fromJson(($0 as Map).cast<String, dynamic>());
  }

  @override
  Future<List<Comment>> comments({String? email, int? id, int? postId}) async {
    final $1 = <String, dynamic>{};
    final $2 = <String, dynamic>{};
    if (email != null) {
      $2['email'] = email;
    }
    if (id != null) {
      $2['id'] = id;
    }
    if (postId != null) {
      $2['postId'] = postId;
    }
    final $0 = await _transport.send('comments', 'GET', '/comments', $1, $2);
    return ($0 as List)
        .map((e) => Comment.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  @override
  Future<List<Comment>> commentsByPostId(int id) async {
    final $1 = <String, dynamic>{};
    final $2 = <String, dynamic>{};
    $1['id'] = id;
    final $0 = await _transport.send(
        'commentsByPostId', 'GET', '/posts/<id>/comments', $1, $2);
    return ($0 as List)
        .map((e) => Comment.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  @override
  Future<Post> postById(int id) async {
    final $1 = <String, dynamic>{};
    final $2 = <String, dynamic>{};
    $1['id'] = id;
    final $0 = await _transport.send('postById', 'GET', '/posts/<id>', $1, $2);
    return Post.fromJson(($0 as Map).cast<String, dynamic>());
  }

  @override
  Future<Post> updatePost(Post post, {required int id}) async {
    final $1 = <String, dynamic>{};
    final $2 = <String, dynamic>{};
    $1['post'] = post.toJson();
    $2['id'] = id;
    final $0 =
        await _transport.send('updatePost', 'PUT', '/posts/<id>', $1, $2);
    return Post.fromJson(($0 as Map).cast<String, dynamic>());
  }
}

class JsonPlaceholderConfig {
  static const int? clientPort = null;

  static const String host = 'https://jsonplaceholder.typicode.com';

  static const int? serverPort = null;
}

class JsonPlaceholderHandler {
  JsonPlaceholderHandler(this._handler);

  final JsonPlaceholder _handler;

  Future handle(String name, Map<String, dynamic> positionalArguments,
      Map<String, dynamic> namedArguments) async {
    switch (name) {
      case 'addPost':
        final $0 = Post.fromJson(
            (positionalArguments['post'] as Map).cast<String, dynamic>());
        final $1 = await _handler.addPost($0);
        return $1.toJson();
      case 'comments':
        final $0 = namedArguments['email'] as String?;
        final $1 = namedArguments['id'] as int?;
        final $2 = namedArguments['postId'] as int?;
        final $3 = await _handler.comments(email: $0, id: $1, postId: $2);
        return $3.map((e) => e.toJson()).toList();
      case 'commentsByPostId':
        final $0 = positionalArguments['id'] as int;
        final $1 = await _handler.commentsByPostId($0);
        return $1.map((e) => e.toJson()).toList();
      case 'postById':
        final $0 = positionalArguments['id'] as int;
        final $1 = await _handler.postById($0);
        return $1.toJson();
      case 'updatePost':
        final $0 = Post.fromJson(
            (positionalArguments['post'] as Map).cast<String, dynamic>());
        final $1 = namedArguments['id'] as int;
        final $2 = await _handler.updatePost($0, id: $1);
        return $2.toJson();
      default:
        throw StateError('Unknown remote procedure: \'$name\'');
    }
  }
}

class JsonPlaceholderMethod {
  const JsonPlaceholderMethod(
      {required this.authorize,
      required this.method,
      required this.name,
      required this.namedParameters,
      required this.positionalParameters,
      required this.path});

  final bool authorize;

  final String method;

  final String name;

  final List<String> namedParameters;

  final List<String> positionalParameters;

  final String path;
}

abstract class JsonPlaceholderTransport {
  Future send(
      String name,
      String httpMethod,
      String path,
      Map<String, dynamic> positionalArguments,
      Map<String, dynamic> namedArguments);
}

abstract class JsonPlaceholderUtils {
  static List<JsonPlaceholderMethod> getMethods() {
    return const [
      JsonPlaceholderMethod(
          authorize: false,
          method: 'POST',
          name: 'addPost',
          namedParameters: [],
          path: '/posts',
          positionalParameters: []),
      JsonPlaceholderMethod(
          authorize: false,
          method: 'GET',
          name: 'comments',
          namedParameters: [],
          path: '/comments',
          positionalParameters: []),
      JsonPlaceholderMethod(
          authorize: false,
          method: 'GET',
          name: 'commentsByPostId',
          namedParameters: [],
          path: '/posts/<id>/comments',
          positionalParameters: []),
      JsonPlaceholderMethod(
          authorize: false,
          method: 'GET',
          name: 'postById',
          namedParameters: [],
          path: '/posts/<id>',
          positionalParameters: []),
      JsonPlaceholderMethod(
          authorize: false,
          method: 'PUT',
          name: 'updatePost',
          namedParameters: [],
          path: '/posts/<id>',
          positionalParameters: [])
    ];
  }
}
