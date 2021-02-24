// Import RPC annotation metadata
import 'package:rpc_gen/rpc.dart';

// Import used JSON models
import 'example_objects.dart';

// Export used JSON models
export 'example_objects.dart';

// Import generated RPC stub files
part 'example_rpc.g.dart';

// Path to our service
const _path = '/example_api/v1/';

@RpcService(host: 'http://localhost', port: 8002)
abstract class ExampleApi {
  @RpcMethod(path: _path + 'add')
  Future<AddResponse> add(AddRequest request);

  @RpcMethod(path: _path + 'not')
  Future<NotResponse> not(NotRequest request);

  @RpcMethod(path: _path + 'void', authorize: true)
  Future<VoidResponse> void_(VoidRequest request);
}
