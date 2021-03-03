// @dart = 2.10
part of '../rpc_generator.dart';

class _TransportGenerator {
  final String name;

  _TransportGenerator({@required this.name});

  Class generate() {
    final methods = <Method>[];
    final method = Method((b) {
      b.returns = refer('Future');
      b.name = 'send';
      b.requiredParameters.add(Parameter((b) => b
        ..type = refer('String')
        ..name = 'method'));
      b.requiredParameters.add(Parameter((b) => b
        ..type = refer('String')
        ..name = 'path'));
      b.requiredParameters.add(Parameter((b) => b..name = 'request'));
    });

    methods.add(method);

    return Class((b) {
      b.abstract = true;
      b.name = name;
      b.methods.addAll(methods);
    });
  }
}
