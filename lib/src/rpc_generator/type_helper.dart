// @dart = 2.10
part of '../rpc_generator.dart';

class _TypeHelper {
  final LibraryElement dartCoreLibrary;

  _TypeHelper({@required this.dartCoreLibrary});

  List<DartType> getTypeArguments(DartType type) {
    if (type is ParameterizedType) {
      return type.typeArguments;
    }

    return const [];
  }

  bool hasComplexTypes(DartType type) {
    if (isObjectType(type) || isDateTimeType(type)) {
      return true;
    }

    final arguments = getTypeArguments(type);
    for (final argument in arguments) {
      if (hasComplexTypes(argument)) {
        return true;
      }
    }

    return false;
  }

  bool isArrayType(DartType type) {
    if (type.isDartCoreList) {
      return true;
    }

    return false;
  }

  bool isDateTimeType(DartType type) {
    if (!type.isVoid &&
        type.element.library == dartCoreLibrary &&
        type.getDisplayString(withNullability: false) == 'DateTime') {
      return true;
    }

    return false;
  }

  bool isGenericType(DartType type) {
    final arguments = getTypeArguments(type);
    if (arguments.isNotEmpty) {
      return true;
    }

    return false;
  }

  bool isNullableType(DartType type) {
    if (type.nullabilitySuffix == NullabilitySuffix.none) {
      return false;
    }

    return true;
  }

  bool isObjectType(DartType type) {
    if (!type.isDynamic &&
        !type.isVoid &&
        type.element.library != dartCoreLibrary) {
      return true;
    }

    return false;
  }

  bool isPrimitiveType(DartType type) {
    if (type.isDartCoreBool ||
        type.isDartCoreDouble ||
        type.isDartCoreInt ||
        type.isDartCoreNull ||
        type.isDartCoreNum ||
        type.isDartCoreString) {
      return true;
    }

    return false;
  }

  bool isValidType(DartType type) {
    if (isPrimitiveType(type)) {
      return true;
    }

    if (isDateTimeType(type)) {
      return true;
    }

    if (isArrayType(type)) {
      final arguments = getTypeArguments(type);
      return isValidType(arguments.first);
    }

    if (isObjectType(type)) {
      return !isGenericType(type);
    }

    if (type.isDartCoreMap) {
      final arguments = getTypeArguments(type);
      final keyType = arguments[0];
      final valueType = arguments[1];
      if (!keyType.isDartCoreString) {
        return false;
      }

      return isValidType(valueType);
    }

    if (type.isDynamic) {
      return true;
    }

    return false;
  }

  String typeToString(DartType type, [bool withNullability = true]) {
    return type.getDisplayString(withNullability: withNullability);
  }
}
