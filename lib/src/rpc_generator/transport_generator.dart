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

      b.requiredParameters.add(Parameter((b) {
        b.type = refer('String');
        b.name = 'name';
      }));

      b.requiredParameters.add(Parameter((b) {
        b.type = refer('String');
        b.name = 'httpMethod';
      }));

      b.requiredParameters.add(Parameter((b) {
        b.type = refer('String');
        b.name = 'path';
      }));

      b.requiredParameters.add(Parameter((b) {
        b.type = refer('Map<String, dynamic>');
        b.name = 'positionalArguments';
      }));

      b.requiredParameters.add(Parameter((b) {
        b.type = refer('Map<String, dynamic>');
        b.name = 'namedArguments';
      }));
    });

    methods.add(method);

    return Class((b) {
      b.abstract = true;
      b.name = name;
      b.methods.addAll(methods);
    });
  }
}
