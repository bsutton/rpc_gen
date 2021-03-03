// @dart = 2.10
part of '../rpc_generator.dart';

class _ConfigGenerator {
  final int clientPort;

  final String host;

  final String name;

  final int serverPort;

  _ConfigGenerator(
      {@required this.clientPort,
      @required this.host,
      @required this.name,
      @required this.serverPort});

  Class generate() {
    return Class((b) {
      b.fields.add(Field((b) {
        b.static = true;
        b.modifier = FieldModifier.constant;
        b.type = refer('int?');
        b.name = 'clientPort';
        b.assignment =
            serverPort == null ? const Code('null') : Code('$serverPort');
      }));

      b.name = name;
      b.fields.add(Field((b) {
        b.static = true;
        b.modifier = FieldModifier.constant;
        b.type = refer('String');
        b.name = 'host';
        b.assignment =
            host == null ? const Code('null') : literalString(host).code;
      }));

      b.fields.add(Field((b) {
        b.static = true;
        b.modifier = FieldModifier.constant;
        b.type = refer('int?');
        b.name = 'serverPort';
        b.assignment =
            serverPort == null ? const Code('null') : Code('$serverPort');
      }));
    });
  }
}
