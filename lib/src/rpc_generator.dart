// @dart = 2.10
import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:code_builder/code_builder.dart';
import 'package:meta/meta.dart';
import 'package:rpc_gen/rpc_meta.dart';
import 'package:source_gen/source_gen.dart';

part 'rpc_generator/rpc_service_class_visitor.dart';
part 'rpc_generator/client_generator.dart';
part 'rpc_generator/codec.dart';
part 'rpc_generator/config_generator.dart';
part 'rpc_generator/expression_extension.dart';
part 'rpc_generator/handler_generator.dart';
part 'rpc_generator/method_generator.dart';
part 'rpc_generator/method_info.dart';
part 'rpc_generator/parameter_info.dart';
part 'rpc_generator/parameters_builder.dart';
part 'rpc_generator/rpc_generator.dart';
part 'rpc_generator/transport_generator.dart';
part 'rpc_generator/type_helper.dart';
part 'rpc_generator/utils_generator.dart';
part 'rpc_generator/variable_allocator.dart';
