// @dart = 2.10
part of '../rpc_generator.dart';

class _Codec {
  final _TypeHelper typeHelper;

  _Codec({@required this.typeHelper});

  Expression decode(Expression expression, DartType type) {
    var result = _decode(expression, type);
    if (typeHelper.isArrayType(type)) {
      result = result.property('toList').call([]);
    }

    return result;
  }

  Expression encode(Expression expression, DartType type) {
    return _encode(expression, type);
  }

  Expression _decode(Expression expression, DartType type) {
    final typeName = typeHelper.typeToString(type);
    if (typeHelper.isPrimitiveType(type)) {
      if (type.isDartCoreDouble) {
        final numType = typeHelper.isNullableType(type) ? 'num?' : 'num';
        return _property(expression.asA(refer(numType)), 'toDouble', type)
            .call([]);
      }

      return expression.asWithoutParenthesis(refer(typeName));
    }

    if (typeHelper.isArrayType(type)) {
      final arguments = typeHelper.getTypeArguments(type);
      final elementType = arguments.first;
      final closure = Method((b) {
        b.lambda = true;
        final e = 'e';
        b.requiredParameters.add(Parameter((b) {
          b.name = e;
        }));

        b.body = decode(refer(e), elementType).code;
      }).closure;

      var result =
          expression.asA(refer('List')).property('map').call([closure]);
      if (typeHelper.isNullableType(type)) {
        result = _wrapNullable_(expression, result);
      }

      return result;
    }

    if (typeHelper.isObjectType(type)) {
      final argument = expression
          .asA(refer('Map'))
          .property('cast')
          .call([], const {}, [refer('String'), refer('dynamic')]);
      var result = refer(typeName).property('fromJson').call([argument]);
      if (typeHelper.isNullableType(type)) {
        result = _wrapNullable_(expression, result);
      }

      return result;
    }

    if (typeHelper.isDateTimeType(type)) {
      var result = refer('DateTime')
          .property('parse')
          .call([expression.asWithoutParenthesis(refer('String'))]);
      if (typeHelper.isNullableType(type)) {
        result = _wrapNullable_(expression, result);
      }

      return result;
    }

    if (type.isDartCoreMap) {
      final closure = Method((b) {
        b.lambda = true;
        final arguments = typeHelper.getTypeArguments(type);
        final keyType = arguments[0];
        final valueType = arguments[1];
        final k = 'k';
        final v = 'v';
        b.requiredParameters.add(Parameter((b) {
          b.name = k;
        }));

        b.requiredParameters.add(Parameter((b) {
          b.name = v;
        }));

        final decodeKey = decode(refer(k), keyType);
        final decodeValue = decode(refer(v), valueType);
        b.body = refer('MapEntry').call([decodeKey, decodeValue]).code;
      }).closure;

      var result = expression.asA(refer('Map')).property('map').call([closure]);
      if (typeHelper.isNullableType(type)) {
        result = _wrapNullable_(expression, result);
      }

      return result;
    }

    return expression;
  }

  Expression _encode(Expression expression, DartType type) {
    if (typeHelper.isPrimitiveType(type)) {
      return expression;
    }

    if (typeHelper.isArrayType(type)) {
      final closure = Method((b) {
        b.lambda = true;
        final arguments = typeHelper.getTypeArguments(type);
        final elementType = arguments.first;
        final e = 'e';
        final encoding = encode(refer(e), elementType);
        b.requiredParameters.add(Parameter((b) {
          b.name = e;
        }));

        b.body = encoding.code;
      }).closure;

      return _property(expression, 'map', type)
          .call([closure])
          .property('toList')
          .call([]);
    }

    if (typeHelper.isObjectType(type)) {
      return _property(expression, 'toJson', type).call([]);
    }

    if (typeHelper.isDateTimeType(type)) {
      return _property(expression, 'toIso8601String', type).call([]);
    }

    if (type.isDartCoreMap) {
      final closure = Method((b) {
        b.lambda = true;
        final arguments = typeHelper.getTypeArguments(type);
        final keyType = arguments[0];
        final valueType = arguments[1];
        final k = 'k';
        final v = 'v';
        final encodeKey = encode(refer(k), keyType);
        final encodeValue = encode(refer(v), valueType);
        b.requiredParameters.add(Parameter((b) {
          b.name = k;
        }));

        b.requiredParameters.add(Parameter((b) {
          b.name = v;
        }));

        b.body = refer('MapEntry').call([encodeKey, encodeValue]).code;
      }).closure;

      return _property(expression, 'map', type).call([closure]);
    }

    if (type.isDynamic) {
      return expression;
    }

    return expression;
  }

  Expression _property(Expression expression, String name, DartType type) {
    if (typeHelper.isNullableType(type)) {
      return expression.nullSafeProperty(name);
    }

    return expression.property(name);
  }

  Expression _wrapNullable_(Expression expression, Expression whenNotNull) {
    return expression
        .equalTo(literalNull)
        .conditional(literalNull, whenNotNull);
  }
}
