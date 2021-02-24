// @dart = 2.10

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'src/rpc_generator.dart';

Builder rpcBuilder(BuilderOptions options) =>
    SharedPartBuilder([RpcGenerator()], 'rpc_builder');
