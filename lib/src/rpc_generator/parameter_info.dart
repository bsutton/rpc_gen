// @dart = 2.10
part of '../rpc_generator.dart';

class _ParameterInfo {
  final bool ignoreIfNull;

  final String keyName;

  final ParameterElement parameter;

  _ParameterInfo(
      {@required this.ignoreIfNull,
      @required this.keyName,
      @required this.parameter});
}
