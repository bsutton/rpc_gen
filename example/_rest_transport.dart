import '_http_transport.dart';

export '_rpc_request.dart';

abstract class RestTransport extends HttpTransport {
  @override
  Future<RpcRequest> preprocess(
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
    final request = RpcRequest(url: url, body: body);
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
