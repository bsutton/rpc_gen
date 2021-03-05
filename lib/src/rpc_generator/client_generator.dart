// @dart = 2.10
part of '../rpc_generator.dart';

class _ClientGenerator {
  final String baseClass;

  final String name;

  final List<_MethodInfo> methods;

  final String transportClass;

  final _TypeHelper typeHelper;

  final _Codec _codec;

  _ClientGenerator(
      {@required this.baseClass,
      @required this.methods,
      @required this.name,
      @required this.transportClass,
      @required this.typeHelper})
      : _codec = _Codec(typeHelper: typeHelper);

  Class generate() {
    return Class((b) {
      b.name = name;
      b.implements.add(refer(baseClass));
      b.fields.add(Field((b) {
        b.modifier = FieldModifier.final$;
        b.type = refer(transportClass);
        b.name = '_transport';
      }));

      b.constructors.add(Constructor((b) {
        b.requiredParameters.add(Parameter((b) => b..name = 'this._transport'));
      }));

      b.methods.addAll(_generateMethods());
    });
  }

  Expression _decode(Expression expression, DartType type) {
    return _codec.decode(expression, type);
  }

  Expression _encode(Expression expression, DartType type) {
    if (typeHelper.hasComplexTypes(type)) {
      return _codec.encode(expression, type);
    }

    return expression;
  }

  List<Method> _generateMethods() {
    final result = <Method>[];
    for (final method in methods) {
      final m = Method((b) {
        final returnType = method.returnType;
        final returnTypeName = typeHelper.typeToString(returnType);
        b.annotations.add(refer('override'));
        b.returns = refer(returnTypeName);
        b.name = method.name;
        b.modifier = MethodModifier.async;

        final parametersBuilder = _ParametersBuilder(
            method: method, methodBuilder: b, typeHelper: typeHelper);
        parametersBuilder.build();

        final variableAllocator = VariableAllocator();
        final response = variableAllocator.alloc();
        final parameters = method.parameters;
        final positional = variableAllocator.alloc();
        final named = variableAllocator.alloc();
        final code = <Code>[];
        code <<
            literalMap({}, refer('String'), refer('dynamic'))
                .assignFinal(positional)
                .statement;
        code <<
            literalMap({}, refer('String'), refer('dynamic'))
                .assignFinal(named)
                .statement;
        for (final parameterInfo in parameters) {
          final parameter = parameterInfo.parameter;
          final parameterType = parameter.type;
          final encoding = _encode(refer(parameter.name), parameterType);
          final map = parameter.isNamed ? named : positional;
          final assigning = refer(map)
              .index(literalString(parameterInfo.keyName))
              .assign(encoding)
              .statement;
          if (typeHelper.isNullableType(parameterType) &&
              parameterInfo.ignoreIfNull) {
            code <<
                if_(refer(parameter.name).notEqualTo(literalNull), [assigning]);
          } else {
            code << assigning;
          }
        }

        final returnTypeArguments = typeHelper.getTypeArguments(returnType);
        final returnTypeArgument = returnTypeArguments.first;
        final send = refer('_transport').property('send').call([
          literalString(method.name),
          literalString(method.httpMethod),
          literalString(method.path),
          refer(positional),
          refer(named),
        ]).awaited;

        if (returnTypeArgument.isVoid) {
          code << send.statement;
        } else {
          code << send.assignFinal(response).statement;
        }

        if (!returnTypeArgument.isVoid) {
          code <<
              _decode(refer(response), returnTypeArgument).returned.statement;
        }

        b.body = Block.of(code);
      });

      result.add(m);
    }

    return result;
  }
}
