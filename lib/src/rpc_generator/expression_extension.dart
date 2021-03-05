// @dart = 2.10
part of '../rpc_generator.dart';

const Code emtpyLineOfCode = Code('\n');

Code else_(List<Code> statements) => CodeExpression(Block.of([
      const Code('else {'),
      ...statements,
      const Code('}'),
    ])).code;

Code elseIf_(Expression expression, List<Code> statements) =>
    _statement('else if', expression, statements);

Code if_(Expression expression, List<Code> statements) =>
    _statement('if', expression, statements);

Code forIn(Reference identifier, Expression expression, List<Code> statements,
        {bool isFinal = true}) =>
    _statement(
        'for',
        CodeExpression(Block.of([
          isFinal ? const Code('final ') : const Code('var '),
          identifier.code,
          const Code(' in '),
          expression.code
        ])),
        statements);

Code switch_(Expression expression, Map<List<Expression>, List<Code>> cases,
    [List<Code> default_]) {
  final code = <Code>[];
  for (final entry in cases.entries) {
    for (final case_ in entry.key) {
      code.addAll([
        const Code('case '),
        case_.code,
        const Code(':'),
      ]);
    }

    code.addAll(entry.value);
  }

  if (default_ != null) {
    code.addAll([const Code('default:\n'), ...default_]);
  }

  return _statement('switch', expression, code);
}

Code while_(Expression expression, List<Code> statements) =>
    _statement('while', expression, statements);

Code _statement(String name, Expression expression, List<Code> statements) =>
    CodeExpression(Block.of([
      Code(name),
      const Code(' ('),
      expression.code,
      const Code(') {'),
      ...statements,
      const Code('}'),
    ])).code;

extension _ExpressionExtension on Expression {
  Expression asWithoutParenthesis(Expression type) => CodeExpression(Block.of([
        code,
        const Code(' as '),
        type.code,
      ]));
}

extension _ListExt<E> on List<E> {
  List<E> operator <<(E value) {
    add(value);
    return this;
  }
}
