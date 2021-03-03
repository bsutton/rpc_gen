// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example_jsonplaceholder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Comment _$_CommentFromJson(Map<String, dynamic> json) {
  return _Comment()
    ..body = json['body'] as String?
    ..email = json['email'] as String?
    ..id = json['id'] as int?
    ..postId = json['postId'] as int?;
}

Map<String, dynamic> _$_CommentToJson(_Comment instance) => <String, dynamic>{
      'body': instance.body,
      'email': instance.email,
      'id': instance.id,
      'postId': instance.postId,
    };

// **************************************************************************
// RpcGenerator
// **************************************************************************

class JsonPlaceholderClient implements JsonPlaceholder {
  JsonPlaceholderClient(this._transport);

  final JsonPlaceholderTransport _transport;

  @override
  Future<List<_Comment>> comments({String? email, int? id, int? postId}) async {
    final $0 = <String, dynamic>{};
    if (email != null) {
      $0['email'] = email;
    }
    if (id != null) {
      $0['id'] = id;
    }
    if (postId != null) {
      $0['postId'] = postId;
    }
    final $1 = await _transport.send('GET', '/comments', $0);
    return ($1 as List)
        .map((e) => _Comment.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
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

  Future handle(String name, data) async {
    switch (name) {
      case 'comments':
        final $0 = data as Map;
        final $1 = $0['email'] as String?;
        final $2 = $0['id'] as int?;
        final $3 = $0['postId'] as int?;
        final $4 = await _handler.comments(email: $1, id: $2, postId: $3);
        return $4.map((e) => e.toJson()).toList();
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
      required this.path});

  final bool authorize;

  final String method;

  final String name;

  final String path;
}

abstract class JsonPlaceholderTransport {
  Future send(String method, String path, request);
}

abstract class JsonPlaceholderUtils {
  static List<JsonPlaceholderMethod> getMethods() {
    return const [
      JsonPlaceholderMethod(
          authorize: false, method: 'GET', name: 'comments', path: '/comments')
    ];
  }
}
