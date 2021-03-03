import 'package:rpc_gen/rpc_meta.dart';

part 'example_rpc.g.dart';

const _path = '/example_api/v1/';

@RpcService(host: 'http://exmaple.com', serverPort: 8002)
abstract class ExampleApi {
  @RpcMethod(path: _path + 'add', authorize: true)
  Future<int> add({required int x, required int y});
}
