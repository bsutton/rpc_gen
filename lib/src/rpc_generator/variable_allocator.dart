// @dart = 2.10
part of '../rpc_generator.dart';

class VariableAllocator {
  int _index = 0;

  String alloc() {
    return '\$${_index++}';
  }
}
