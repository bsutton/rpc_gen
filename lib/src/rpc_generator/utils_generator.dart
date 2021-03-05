// @dart = 2.10
part of '../rpc_generator.dart';

class _UtilsGenerator {
  final List<_MethodInfo> methods;

  final String methodClass;

  final String name;

  _UtilsGenerator(
      {@required this.methods,
      @required this.methodClass,
      @required this.name});

  Class generate() {
    return Class((b) {
      b.abstract = true;
      b.name = name;
      b.methods.add(_generateMethodGetProcedures());
    });
  }

  Method _generateMethodGetProcedures() {
    final values = [];
    for (final method in methods) {
      final value = refer(methodClass).call([], {
        'authorize': literalBool(method.authorize),
        'method': literalString(method.httpMethod),
        'name': literalString(method.name),
        'namedParameters': literalList([]),
        'path': literalString(method.path),
        'positionalParameters': literalList([]),
      });

      values.add(value);
    }

    final list = literalConstList(values);
    return Method((b) {
      b.static = true;
      b.returns = TypeReference((b) {
        b.symbol = 'List';
        b.types.add(TypeReference((b) {
          b.symbol = methodClass;
        }));
      });

      b.name = 'getMethods';
      b.body = list.returned.statement;
    });
  }
}
