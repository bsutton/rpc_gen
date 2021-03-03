// @dart = 2.10
part of '../rpc_generator.dart';

class RpcGenerator extends GeneratorForAnnotation<RpcService> {
  @override
  FutureOr<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! ClassElement) {
      throw StateError(
          'Unable to process annotation ${RpcService} applied to ${element}');
    }

    LibraryElement dartCoreLibarary;
    if (element is ClassElement) {
      for (final superType in element.allSupertypes) {
        if (superType.isDartCoreObject) {
          dartCoreLibarary = superType.element.library;
          break;
        }
      }
    } else {
      return '';
    }

    if (dartCoreLibarary == null) {
      throw StateError('Unable to determine Dart core library element');
    }

    final typeHelper = _TypeHelper(dartCoreLibrary: dartCoreLibarary);

    final clientPort = annotation.read('clientPort').isNull
        ? null
        : annotation.read('clientPort').intValue;
    final host = annotation.read('host').isNull
        ? null
        : annotation.read('host').stringValue;
    final serverPort = annotation.read('serverPort').isNull
        ? null
        : annotation.read('serverPort').intValue;

    final declaration = element.declaration;
    final name = declaration.name;
    final clientClass = '${name}Client';
    final configClass = '${name}Config';
    final handlerClass = '${name}Handler';
    final methodClass = '${name}Method';
    final transportClass = '${name}Transport';
    final utilsClass = '${name}Utils';

    final annotationLibrary = annotation.objectValue.type.element.library;
    final methods = _collectInfo(name, element, annotationLibrary, typeHelper);

    final classes = <Class>[];
    final clientGenerator = _ClientGenerator(
        baseClass: name,
        methods: methods,
        name: clientClass,
        transportClass: transportClass,
        typeHelper: typeHelper);
    var clazz = clientGenerator.generate();
    classes.add(clazz);

    final configGenerator = _ConfigGenerator(
        clientPort: clientPort,
        host: host,
        name: configClass,
        serverPort: serverPort);
    clazz = configGenerator.generate();
    classes.add(clazz);

    final handlerGenerator = _HandlerGenerator(
        baseClass: name,
        methods: methods,
        name: handlerClass,
        typeHelper: typeHelper);
    clazz = handlerGenerator.generate();
    classes.add(clazz);

    final methodGenerator = _MethodGenerator(name: methodClass);
    clazz = methodGenerator.generate();
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

  List<_MethodInfo> _collectInfo(String name, Element element,
      LibraryElement annotationLibrary, _TypeHelper typeHelper) {
    final result = <_MethodInfo>[];
    final visitor = _ClassVisitor(
        annotationLibrary: annotationLibrary,
        methods: result,
        name: name,
        typeHelper: typeHelper);
    element.visitChildren(visitor);
    return result;
  }
}
