// @dart = 2.10
part of '../rpc_generator.dart';

class _MethodGenerator {
  final String name;

  _MethodGenerator({@required this.name});

  Class generate() {
    return Class((b) {
      b.name = name;

      b.fields.add(Field((b) {
        b.modifier = FieldModifier.final$;
        b..type = refer('bool');
        b..name = 'authorize';
      }));

      b.fields.add(Field((b) {
        b.modifier = FieldModifier.final$;
        b.type = refer('String');
        b.name = 'method';
      }));

      b.fields.add(Field((b) {
        b.modifier = FieldModifier.final$;
        b.type = refer('String');
        b.name = 'name';
      }));

      b.fields.add(Field((b) {
        b.modifier = FieldModifier.final$;
        b.type = refer('String');
        b.name = 'path';
      }));

      b.constructors.add(Constructor((b) {
        b.constant = true;
        b.optionalParameters.add(Parameter((b) {
          b.named = true;
          b.required = true;
          b.toThis = true;
          b.name = 'authorize';
        }));

        b.optionalParameters.add(Parameter((b) {
          b.named = true;
          b.required = true;
          b.toThis = true;
          b.name = 'method';
        }));

        b.optionalParameters.add(Parameter((b) {
          b.named = true;
          b.required = true;
          b.toThis = true;
          b.name = 'name';
        }));

        b.optionalParameters.add(Parameter((b) {
          b.named = true;
          b.required = true;
          b.toThis = true;
          b.name = 'path';
        }));
      }));
    });
  }
}
