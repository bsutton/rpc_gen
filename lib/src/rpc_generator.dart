// @dart = 2.10

import 'dart:async';

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:code_builder/code_builder.dart';
import 'package:rpc_gen/rpc_meta.dart';
import 'package:source_gen/source_gen.dart';

class RpcGenerator extends GeneratorForAnnotation<RpcService> {
  @override
  FutureOr<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! ClassElement) {
      throw StateError(
          'Unable to process annotation ${RpcService} applied to ${element}');
    }

    final host = annotation.read('host').isNull
        ? null
        : annotation.read('host').stringValue;
    final port = annotation.read('port').isNull
        ? null
        : annotation.read('port').intValue;

    final declaration = element.declaration;
    final name = declaration.name;
    final clientClass = '${name}Client';
    final configClass = '${name}Config';
    final methodClass = '${name}Method';
    final serverClass = '${name}Server';
    final transportClass = '${name}Transport';
    final utilsClass = '${name}Utils';

    final annotationLibrary = annotation.objectValue.type.element.library;
    final methods = _collectInfo(name, element, annotationLibrary);

    final classes = <Class>[];

    final clientGenerator = _ClientGenerator(
        baseClass: name,
        methods: methods,
        name: clientClass,
        transportClass: transportClass);
    var clazz = clientGenerator.generate();
    classes.add(clazz);

    final configGenerator =
        _ConfigGenerator(host: host, name: configClass, port: port);
    clazz = configGenerator.generate();
    classes.add(clazz);

    final methodGenerator = _MethodGenerator(name: methodClass);
    clazz = methodGenerator.generate();
    classes.add(clazz);

    final serverGenerator =
        _ServerGenerator(baseClass: name, methods: methods, name: serverClass);
    clazz = serverGenerator.generate();
    classes.add(clazz);

    final transportGenerator = _TransportGenerator(name: transportClass);
    clazz = transportGenerator.generate();
    classes.add(clazz);

    final utilsGenerator = _UtilsGenerator(
        methods: methods, methodClass: methodClass, name: utilsClass);
    clazz = utilsGenerator.generate();

    classes.add(clazz);

    final library = Library((b) => b..body.addAll(classes));
    final emitter = DartEmitter(Allocator.simplePrefixing());
    final result = '${library.accept(emitter)}';
    return result;
  }

  List<_MethodInfo> _collectInfo(
      String name, Element element, LibraryElement annotationLibrary) {
    final result = <_MethodInfo>[];
    final visitor = _ClassVisitor(
        annotationLibrary: annotationLibrary, methods: result, name: name);
    element.visitChildren(visitor);
    return result;
  }
}

class _ClassVisitor extends SimpleElementVisitor<void> {
  LibraryElement annotationLibrary;

  List<_MethodInfo> methods;

  final String name;

  _ClassVisitor({this.annotationLibrary, this.methods, this.name});

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
    final fullMethodName = '$name.${element.name}';
    final parameters = element.parameters;
    if (parameters.length != 1) {
      _error('Method \'$fullMethodName\' must declare one parameter');
    }

    if (element.isPrivate) {
      _error('Method \'$fullMethodName\' must not be declared as private');
    }

    final parameter = element.parameters.first;
    final parameterType = parameter.type;
    final returnType = element.returnType;
    if (!returnType.isDartAsyncFuture) {
      _error(
          'Method \'$fullMethodName\' must be declared with return type \'Future\'');
    }

    if (_TypeInfo.getTypeArguments(returnType).length != 1) {
      _error(
          'Method \'$fullMethodName\' must not be declared with return type \'$returnType\'');
    }

    final metadata = <DartObject>[];
    for (final annotation in element.metadata) {
      final constant = annotation.computeConstantValue();
      final constantType = constant.type.element;
      if (constantType.library == constant.type.element.library) {
        if (constantType.displayName == '$RpcMethod') {
          metadata.add(constant);
        }
      }
    }

    if (metadata.isEmpty) {
      _error(
          'Method \'$fullMethodName\' must be declared with annotation \'@$RpcMethod\'');
    }

    if (metadata.length > 1) {
      _error(
          'Method \'$fullMethodName\' must be declared with only one annotation \'@$RpcMethod\'');
    }

    final value = metadata.first;
    void checkParameter(DartObject field, String name) {
      if (field.isNull) {
        _error(
            'Method \'$fullMethodName\' must specify \'@$RpcMethod.$name\' parameter');
      }
    }

    var fieldName = 'authorize';
    var field = value.getField(fieldName);
    checkParameter(field, name);
    final authorize = field.toBoolValue();

    fieldName = 'method';
    field = value.getField(fieldName);
    checkParameter(field, name);
    final method_ = field.toStringValue();

    fieldName = 'path';
    field = value.getField(fieldName);
    checkParameter(field, name);
    final path = field.toStringValue();

    final method = _MethodInfo(
        authorize: authorize,
        method: method_,
        name: element.name,
        path: path,
        parameterType: parameterType,
        returnType: returnType);
    methods.add(method);
  }

  void _error(String message) {
    message = 'RPC class $name error: ' + message;
    throw StateError(message);
  }
}

class _ClientGenerator {
  final String baseClass;

  final String name;

  final List<_MethodInfo> methods;

  final String transportClass;

  _ClientGenerator(
      {this.baseClass, this.methods, this.name, this.transportClass});

  Class generate() {
    return Class((b) => b
      ..name = name
      ..implements.add(refer(baseClass))
      ..fields.add(Field((b) => b
        ..modifier = FieldModifier.final$
        ..type = refer(transportClass)
        ..name = '_transport'))
      ..constructors.add(Constructor((b) => b
        ..requiredParameters
            .add(Parameter((b) => b..name = 'this._transport'))))
      ..methods.addAll(_generateMethods()));
  }

  List<Method> _generateMethods() {
    final result = <Method>[];
    for (final method in methods) {
      final parameterType =
          method.parameterType.getDisplayString(withNullability: true);
      final returnType =
          method.returnType.getDisplayString(withNullability: true);
      final typeArguments = _TypeInfo.getTypeArguments(method.returnType);
      final responseType =
          typeArguments.first.getDisplayString(withNullability: true);
      final m = Method((b) => b
        ..annotations.add(refer('override'))
        ..returns = refer(returnType)
        ..name = method.name
        ..requiredParameters.add(Parameter((b) => b
          ..type = refer(parameterType)
          ..name = 'request'))
        ..modifier = MethodModifier.async
        ..body = Block.of([
          Code('final json = request.toJson();'),
          Code('final response = await '),
          refer('_transport.send').call([
            literalString(method.method),
            literalString(method.path),
            refer('json'),
          ]).code,
          Code(';'),
          Code('return '),
          refer(responseType).code,
          Code('.fromJson(response);'),
        ]));

      result.add(m);
    }

    return result;
  }
}

class _ConfigGenerator {
  final String host;

  final String name;

  final int port;

  _ConfigGenerator({this.host, this.name, this.port});

  Class generate() {
    return Class((b) => b
      ..name = name
      ..fields.add(Field((b) => b
        ..static = true
        ..modifier = FieldModifier.constant
        ..type = refer('String')
        ..name = 'host'
        ..assignment = host == null ? Code('null') : literalString(host).code))
      ..fields.add(Field((b) => b
        ..static = true
        ..modifier = FieldModifier.constant
        ..type = refer('int')
        ..name = 'port'
        ..assignment = port == null ? Code('null') : Code('$port'))));
  }
}

class _MethodGenerator {
  final String name;

  _MethodGenerator({this.name});

  Class generate() {
    return Class((b) => b
      ..fields.add(Field((b) => b
        ..modifier = FieldModifier.final$
        ..type = refer('bool')
        ..name = 'authorize'))
      ..name = name
      ..fields.add(Field((b) => b
        ..modifier = FieldModifier.final$
        ..type = refer('String')
        ..name = 'method'))
      ..fields.add(Field((b) => b
        ..modifier = FieldModifier.final$
        ..type = refer('String')
        ..name = 'name'))
      ..fields.add(Field((b) => b
        ..modifier = FieldModifier.final$
        ..type = refer('String')
        ..name = 'path'))
      ..constructors.add(Constructor((b) => b
        ..constant = true
        ..optionalParameters.add(Parameter((b) => b
          ..named = true
          ..name = 'required this.authorize'))
        ..optionalParameters.add(Parameter((b) => b
          ..named = true
          ..name = 'required this.method'))
        ..optionalParameters.add(Parameter((b) => b
          ..named = true
          ..name = 'required this.name'))
        ..optionalParameters.add(Parameter((b) => b
          ..named = true
          ..name = 'required this.path')))));
  }
}

class _MethodInfo {
  final bool authorize;

  final String method;

  final String name;

  final String path;

  final DartType parameterType;

  final DartType returnType;

  _MethodInfo(
      {this.authorize,
      this.method,
      this.name,
      this.path,
      this.parameterType,
      this.returnType});
}

class _ServerGenerator {
  final String baseClass;

  final List<_MethodInfo> methods;

  final String name;

  _ServerGenerator({this.baseClass, this.methods, this.name});

  Class generate() {
    return Class((b) => b
      ..abstract = true
      ..name = name
      ..fields.add(Field((b) => b
        ..modifier = FieldModifier.final$
        ..type = refer(baseClass)
        ..name = '_handler'))
      ..constructors.add(Constructor((b) => b
        ..requiredParameters.add(Parameter((b) => b..name = 'this._handler'))))
      ..methods.add(_generateMethodHandle()));
  }

  Method _generateMethodHandle() {
    final code = <Code>[];
    code.add(Code('switch (method) {'));
    for (final method in methods) {
      final parameterType =
          method.parameterType.getDisplayString(withNullability: true);
      code.add(Block.of(
          [Code('case '), literalString(method.name).code, Code(':')]));
      code.add(Code('final request = '));
      code.add(refer(parameterType).code);
      code.add(Code('.fromJson(json);'));
      code.add(
          Code('final response = await _handler.${method.name}(request);'));
      code.add(Code('return response.toJson();'));
    }

    code.add(Code('default:'));
    code.add(Code(
        'throw StateError(\'Unknown remote procedure: \\\'\$method\\\'\');'));
    code.add(Code('}'));
    return Method((b) => b
      ..modifier = MethodModifier.async
      ..returns = refer('Future<Map<String, dynamic>>')
      ..name = 'handle'
      ..requiredParameters.add(Parameter((b) => b
        ..type = refer('String')
        ..name = 'method'))
      ..requiredParameters.add(Parameter((b) => b
        ..type = refer('Map<String, dynamic>')
        ..name = 'json'))
      ..body = Block.of(code));
  }
}

class _TransportGenerator {
  final String name;

  _TransportGenerator({this.name});

  Class generate() {
    final methods = <Method>[];
    final method = Method((b) => b
      ..returns = refer('Future<Map<String, dynamic>>')
      ..name = 'send'
      ..requiredParameters.add(Parameter((b) => b
        ..type = refer('String')
        ..name = 'method'))
      ..requiredParameters.add(Parameter((b) => b
        ..type = refer('String')
        ..name = 'path'))
      ..requiredParameters.add(Parameter((b) => b
        ..type = refer('Map<String, dynamic>')
        ..name = 'request')));
    methods.add(method);
    return Class((b) => b
      ..abstract = true
      ..name = name
      ..methods.addAll(methods));
  }
}

class _TypeInfo {
  static List<DartType> getTypeArguments(DartType type) {
    if (type is ParameterizedType) {
      return type.typeArguments;
    }

    return const [];
  }
}

class _UtilsGenerator {
  final List<_MethodInfo> methods;

  final String methodClass;

  final String name;

  _UtilsGenerator({this.methods, this.methodClass, this.name});

  Class generate() {
    return Class((b) => b
      ..abstract = true
      ..name = name
      ..methods.add(_generateMethodGetProcedures()));
  }

  Method _generateMethodGetProcedures() {
    final values = [];
    for (final method in methods) {
      final value = refer(methodClass).call([], {
        'authorize': literalBool(method.authorize),
        'method': literalString(method.method),
        'name': literalString(method.name),
        'path': literalString(method.path),
      });

      values.add(value);
    }

    final list = literalConstList(values);
    return Method((b) => b
      ..static = true
      ..returns = refer('List<$methodClass>')
      ..name = 'getMethods'
      ..body = Block.of([
        Code('return '),
        list.code,
        Code(';'),
      ]));
  }
}
