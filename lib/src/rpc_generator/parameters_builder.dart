// @dart = 2.10
part of '../rpc_generator.dart';

class _ParametersBuilder {
  MethodBuilder methodBuilder;

  _MethodInfo method;

  _TypeHelper typeHelper;

  _ParametersBuilder(
      {@required this.method,
      @required this.methodBuilder,
      @required this.typeHelper});

  void build() {
    final parameters = method.parameters;
    for (final parameterInfo in parameters) {
      final parameter = parameterInfo.parameter;
      final parameterType = parameter.type;
      void build(ParameterBuilder b, bool named) {
        b.named = named;
        b.type = refer(typeHelper.typeToString(parameterType));
        b.required = parameter.isRequiredNamed;
        if (parameter.hasDefaultValue) {
          b.defaultTo = Code(parameter.defaultValueCode);
        }

        b.name = parameter.name;
      }

      if (parameter.isNamed) {
        methodBuilder.optionalParameters.add(Parameter((b) => build(b, true)));
      } else {
        methodBuilder.requiredParameters.add(Parameter((b) => build(b, false)));
      }
    }
  }
}
