// Import RPC annotation metadata
import 'package:rpc_gen/rpc_meta.dart';

// Import used JSON models
import 'example_objects.dart';

// Export used JSON models
export 'example_objects.dart';

// Import generated RPC stub files
part 'example_rpc.g.dart';

// Path to our service
const _path = '/example_api/v1/';

// The "host" and "path" parameters must be specified, but this is only
// configuration (which can be ignored)
@RpcService(host: 'http://localhost', port: 8002)
abstract class ExampleApi {
  @RpcMethod(path: _path + 'add')
  Future<AddResponse> add(AddRequest request);

  @RpcMethod(path: _path + 'not')
  Future<NotResponse> not(NotRequest request);

  @RpcMethod(path: _path + 'void', authorize: true)
  Future<VoidResponse> void_(VoidRequest request);
}
