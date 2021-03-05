// @dart = 2.10
part of '../rpc_generator.dart';

class _ClassVisitor extends SimpleElementVisitor<void> {
  LibraryElement annotationLibrary;

  List<_MethodInfo> methods;

  final String name;

  _TypeHelper typeHelper;

  _ClassVisitor(
      {@required this.annotationLibrary,
      @required this.methods,
      @required this.name,
      @required this.typeHelper});

  @override
  void visitClassElement(ClassElement element) {
    if (!element.isAbstract) {
      _error('Class \'$name\' must be declared as abstract');
    }
  }

  @override
  void visitConstructorElement(ConstructorElement element) {
    final elementName = element.name.isEmpty ? name : element.name;
    if (element.parameters.isNotEmpty || elementName != name) {
      _error(
          'Class \'$name\' must not declare a constructor \'${element.name}\'');
    }
  }

  @override
  void visitFieldElement(FieldElement element) {
    _error('Class \'$name\' must not declare a field \'${element.name}\'');
  }

  @override
  void visitMethodElement(MethodElement element) {
    final methodName = element.name;
    final fullMethodName = '$name.$methodName';
    RpcMethod rpcMethod;
    for (final annotation in element.metadata) {
      final constant = annotation.computeConstantValue();
      final constantType = constant.type.element;
      if (constantType.library == constant.type.element.library) {
        if (constantType.displayName == '$RpcMethod') {
          if (rpcMethod != null) {
            _error(
                'Method \'$fullMethodName\' must be declared with only one annotation \'@$RpcMethod\'');
          }

          rpcMethod = RpcMethod(
            authorize: constant.getField('authorize').toBoolValue(),
            ignoreIfNull: constant.getField('ignoreIfNull').toBoolValue(),
            httpMethod: constant.getField('httpMethod').toStringValue(),
            path: constant.getField('path').toStringValue(),
          );
        }
      }
    }

    if (rpcMethod == null) {
      _error(
          'Method \'$fullMethodName\' must be declared with annotation \'@$RpcMethod\'');
    }

    void checkParameter(value, String name) {
      if (value == null) {
        _error(
            'Method \'$fullMethodName\' must specify \'@$RpcMethod.$name\' parameter');
      }
    }

    checkParameter(rpcMethod.authorize, 'authorize');
    final authorize = rpcMethod.authorize;
    checkParameter(rpcMethod.httpMethod, 'httpMethod');
    final httpMethod = rpcMethod.httpMethod;
    var methodIgnoreIfNull = rpcMethod.ignoreIfNull;
    methodIgnoreIfNull ??= false;
    checkParameter(rpcMethod.path, 'path');
    final path = rpcMethod.path;

    final parameterInfos = <_ParameterInfo>[];
    final keyNames = <String>{};
    final parameters = element.parameters;
    for (final parameter in parameters) {
      final parameterType = parameter.type;
      if (parameter.name == null) {
        _error(
            'Method \'$fullMethodName\' must not be declared with unnamed parameters');
      }

      if (parameter.defaultValueCode != null) {
        _error(
            'Method \'$fullMethodName\' must not be declared with parameters with default values');
      }

      final parameterName = parameter.name;
      if (!typeHelper.isValidType(parameterType)) {
        final typeName = typeHelper.typeToString(parameterType);
        _error(
            'Method \'$fullMethodName\' is declared with parameter \'$parameterName\' with unsupported type \'$typeName\'');
      }

      if (parameterName.startsWith('_') || parameterName.startsWith('\$')) {
        _error(
            'Method \'$fullMethodName\' invalid parameter name \'$parameterName\'');
      }

      RpcKey rpcKey;
      var keyName = parameter.name;
      bool ignoreIfNull;
      for (final annotation in parameter.metadata) {
        final constant = annotation.computeConstantValue();
        final constantType = constant.type.element;
        if (constantType.library == constant.type.element.library) {
          if (constantType.displayName == '$RpcKey') {
            if (rpcKey != null) {
              _error(
                  'Method \'$fullMethodName\' parameter \'$parameterName\' can be declared with only one annotation \'@$RpcKey\'');
            }

            keyName = constant.getField('name').toStringValue();
            keyName ??= parameter.name;
            ignoreIfNull = constant.getField('ignoreIfNull').toBoolValue();
            if (keyName.contains(' ')) {
              _error(
                  'Method \'$fullMethodName\' parameter \'$parameterName\' declared with an invalid key name \'$name\'');
            }
          }
        }
      }

      if (!keyNames.add(keyName)) {
        _error(
            'Method \'$fullMethodName\' parameter \'$parameterName\' declared with a non-unique key name \'$keyName\'');
      }

      ignoreIfNull ??= methodIgnoreIfNull;

      final parameterInfo = _ParameterInfo(
          ignoreIfNull: ignoreIfNull, keyName: keyName, parameter: parameter);
      parameterInfos.add(parameterInfo);
    }

    if (element.isPrivate) {
      _error('Method \'$fullMethodName\' must not be declared as private');
    }

    final returnType = element.returnType;
    if (returnType.isDartAsyncFuture) {
      final arguments = typeHelper.getTypeArguments(returnType);
      final typeArgumentType = arguments.first;
      if (!typeArgumentType.isVoid &&
          !typeHelper.isValidType(typeArgumentType)) {
        final typeName = typeHelper.typeToString(returnType);
        _error(
            'Method \'$fullMethodName\' must not be declared with return type \'$typeName\'');
      }

      if (typeHelper.isNullableType(returnType)) {
        _error(
            'Method \'$fullMethodName\' must not be declared with return type \'Future?\'');
      }
    } else {
      _error(
          'Method \'$fullMethodName\' must be declared with return type \'Future\'');
    }

    final method = _MethodInfo(
        authorize: authorize,
        httpMethod: httpMethod,
        ignoreIfNull: methodIgnoreIfNull,
        name: methodName,
        parameters: parameterInfos,
        path: path,
        returnType: returnType);
    methods.add(method);
  }

  void _error(String message) {
    message = 'RPC class $name error: ' + message;
    throw StateError(message);
  }
}
