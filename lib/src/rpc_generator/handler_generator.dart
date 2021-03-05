// @dart = 2.10
part of '../rpc_generator.dart';

class _HandlerGenerator {
  final String baseClass;

  final List<_MethodInfo> methods;

  final String name;

  final _TypeHelper typeHelper;

  final _Codec _codec;

  _HandlerGenerator(
      {@required this.baseClass,
      @required this.methods,
      @required this.name,
      @required this.typeHelper})
      : _codec = _Codec(typeHelper: typeHelper);

  Class generate() {
    return Class((b) {
      b.name = name;
      b.fields.add(Field((b) {
        b.modifier = FieldModifier.final$;
        b.type = refer(baseClass);
        b.name = '_handler';
      }));

      b.constructors.add(Constructor((b) {
        b.requiredParameters.add(Parameter((b) {
          b.toThis = true;
          b.name = '_handler';
        }));
      }));

      b.methods.add(_generateMethodHandle());
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

  Method _generateMethodHandle() {
    return Method((b) {
      b.modifier = MethodModifier.async;
      b.returns = refer('Future');
      b.name = 'handle';
      b.requiredParameters.add(Parameter((b) {
        b.type = refer('String');
        b.name = 'name';
      }));

      b.requiredParameters.add(Parameter((b) {
        b.type = refer('Map<String, dynamic>');
        b.name = 'positionalArguments';
      }));

      b.requiredParameters.add(Parameter((b) {
        b.type = refer('Map<String, dynamic>');
        b.name = 'namedArguments';
      }));

      final cases = <List<Expression>, List<Code>>{};
      for (final method in methods) {
        final variableAllocator = VariableAllocator();
        final code = <Code>[];
        final parameters = method.parameters;
        final positionalArguments = <Expression>[];
        final namedArguments = <String, Expression>{};
        for (final parameterInfo in parameters) {
          final parameter = parameterInfo.parameter;
          final variable = variableAllocator.alloc();
          if (parameter.isPositional) {
            final decoding = _decode(
                refer('positionalArguments')
                    .index(literalString(parameterInfo.keyName)),
                parameter.type);
            code << decoding.assignFinal(variable).statement;
            positionalArguments.add(refer(variable));
          } else {
            final decoding = _decode(
                refer('namedArguments')
                    .index(literalString(parameterInfo.keyName)),
                parameter.type);
            code << decoding.assignFinal(variable).statement;
            namedArguments[parameter.name] = refer(variable);
          }
        }

        final invoke = refer('_handler')
            .property(method.name)
            .call(positionalArguments, namedArguments)
            .awaited;
        final returnType = method.returnType;
        final returnTypeArguments = typeHelper.getTypeArguments(returnType);
        final returnTypeArgument = returnTypeArguments.first;
        if (!returnTypeArgument.isVoid) {
          final response = variableAllocator.alloc();
          code << invoke.assignFinal(response).statement;
          final encoding = _encode(refer(response), returnTypeArgument);
          code << encoding.returned.statement;
        } else {
          code << invoke.statement;
          code << const Code('return;');
        }

        cases[[literalString(method.name)]] = code;
      }

      final default_ = [
        refer('StateError')
            .call([literalString('Unknown remote procedure: \'\$name\'')])
            .thrown
            .statement
      ];

      final code = <Code>[];
      code << switch_(refer('name'), cases, default_);
      b.body = Block.of(code);
    });
  }
}
