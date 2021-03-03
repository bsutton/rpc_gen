// @dart = 2.10
part of '../rpc_generator.dart';

class _MethodInfo {
  final bool authorize;

  final String httpMethod;

  final bool ignoreIfNull;

  final String name;

  final String path;

  final List<_ParameterInfo> parameters;

  final DartType returnType;

  _MethodInfo({
    @required this.authorize,
    @required this.httpMethod,
    @required this.ignoreIfNull,
    @required this.name,
    @required this.path,
    @required this.parameters,
    @required this.returnType,
  });
}
