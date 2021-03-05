import 'dart:convert';

import 'package:rpc_gen/rpc_http_transport.dart';
import 'package:rpc_gen/rpc_meta.dart';
import 'package:test/test.dart';

part 'test.g.dart';

Future<void> main(List<String> args) async {
  final client = Client();

  {
    final closure = client.testBool;
    test('Test ${closure.runtimeType}', () async {
      final values = [true, false];
      for (final value in values) {
        final result = await closure(value);
        expect(result, value);
      }
    });
  }

  {
    final closure = client.testBool_;
    test('Test ${closure.runtimeType}', () async {
      final values = [null, true, false];
      for (final value in values) {
        final result = await closure(value);
        expect(result, value);
      }
    });
  }

  {
    final closure = client.testDateTime;
    test('Test ${closure.runtimeType}', () async {
      final values = [DateTime.now()];
      for (final value in values) {
        final result = await closure(value);
        expect(result, value);
      }
    });
  }

  {
    final closure = client.testDateTime_;
    test('Test ${closure.runtimeType}', () async {
      final values = [null, DateTime.now()];
      for (final value in values) {
        final result = await closure(value);
        expect(result, value);
      }
    });
  }

  {
    final closure = client.testDouble;
    test('Test ${closure.runtimeType}', () async {
      final values = [-1.0, 0.0, 1.0];
      for (final value in values) {
        final result = await closure(value);
        expect(result, value);
      }
    });
  }

  {
    final closure = client.testDouble_;
    test('Test ${closure.runtimeType}', () async {
      final values = [null, -1.0, 0.0, 1.0];
      for (final value in values) {
        final result = await closure(value);
        expect(result, value);
      }
    });
  }

  {
    final closure = client.testDynamic;
    test('Test ${closure.runtimeType}', () async {
      final values = [null, false, 0, 0.0, 'test'];
      for (final value in values) {
        final result = await closure(value);
        expect(result, value);
      }
    });
  }

  {
    final closure = client.testDynamic_;
    test('Test ${closure.runtimeType}', () async {
      final values = [null, false, 0, 0.0, 'test'];
      for (final value in values) {
        final result = await closure(value);
        expect(result, value);
      }
    });
  }

  {
    final closure = client.testInt;
    test('Test ${closure.runtimeType}', () async {
      final values = [-1, 0, 1];
      for (final value in values) {
        final result = await closure(value);
        expect(result, value);
      }
    });
  }

  {
    final closure = client.testInt_;
    test('Test ${closure.runtimeType}', () async {
      final values = [null, -1, 0, 1];
      for (final value in values) {
        final result = await closure(value);
        expect(result, value);
      }
    });
  }

  {
    final closure = client.testNum;
    test('Test ${closure.runtimeType}', () async {
      final values = [-1, 0, 1, -1.0, 0.0, 1.0];
      for (final value in values) {
        final result = await closure(value);
        expect(result, value);
      }
    });
  }

  {
    final closure = client.testNum_;
    test('Test ${closure.runtimeType}', () async {
      final values = [null, -1, 0, 1, -1.0, 0.0, 1.0];
      for (final value in values) {
        final result = await closure(value);
        expect(result, value);
      }
    });
  }

  {
    final closure = client.testString;
    test('Test ${closure.runtimeType}', () async {
      final values = ['test'];
      for (final value in values) {
        final result = await closure(value);
        expect(result, value);
      }
    });
  }

  {
    final closure = client.testString_;
    test('Test ${closure.runtimeType}', () async {
      final values = [null, 'test'];
      for (final value in values) {
        final result = await closure(value);
        expect(result, value);
      }
    });
  }

  {
    final closure = client.testList;
    test('Test ${closure.runtimeType}', () async {
      final values = [
        [null, false, 0, 0.0, 'test']
      ];
      for (final value in values) {
        final result = await closure(value);
        expect(result, value);
      }
    });
  }

  {
    final closure = client.testListListInt;
    test('Test ${closure.runtimeType}', () async {
      final values = [
        [
          [-1, 0, 1]
        ]
      ];
      for (final value in values) {
        final result = await closure(value);
        expect(result, value);
      }
    });
  }

  {
    final closure = client.testListListModel;
    test('Test ${closure.runtimeType}', () async {
      final values = [
        [
          [Model(s: 'test1'), Model(s: 'test2')]
        ]
      ];
      for (final value in values) {
        final result = await closure(value);
        expect(result, value);
      }
    });
  }

  {
    final closure = client.testListModel;
    test('Test ${closure.runtimeType}', () async {
      final values = [
        [Model(s: 'test1'), Model(s: 'test2')]
      ];
      for (final value in values) {
        final result = await closure(value);
        expect(result, value);
      }
    });
  }

  {
    final closure = client.testListModel_;
    test('Test ${closure.runtimeType}', () async {
      final values = [
        [null, Model(s: 'test1'), Model(s: 'test2')]
      ];
      for (final value in values) {
        final result = await closure(value);
        expect(result, value);
      }
    });
  }

  {
    final closure = client.testList_;
    test('Test ${closure.runtimeType}', () async {
      final values = [
        null,
        [null, false, 0, 0.0, 'test']
      ];
      for (final value in values) {
        final result = await closure(value);
        expect(result, value);
      }
    });
  }

  {
    final closure = client.testList_Int;
    test('Test ${closure.runtimeType}', () async {
      final values = [
        null,
        [0, -1, 1],
      ];
      for (final value in values) {
        final result = await closure(value);
        expect(result, value);
      }
    });
  }

  {
    final closure = client.testList_Model;
    test('Test ${closure.runtimeType}', () async {
      final values = [
        null,
        [Model(s: 'test1'), Model(s: 'test2')]
      ];
      for (final value in values) {
        final result = await closure(value);
        expect(result, value);
      }
    });
  }

  {
    final closure = client.testVoid;
    test('Test ${closure.runtimeType}', () async {
      await closure();
    });
  }

  {
    final closure = client.testSendAll;

    test('Test ${closure.runtimeType}', () async {
      final bool_ = false;
      final double_ = 0.0;
      final dynamic_ = 123;
      final int_ = 0;
      final num_ = 0.0;
      final string = 'test';
      final model = Model(s: 'test');
      final result = await closure(
          bool_: bool_,
          double_: double_,
          dynamic_: dynamic_,
          int_: int_,
          num_: num_,
          string: string,
          model: model);

      expect(result['bool_'], bool_);
      expect(result['double_'], double_);
      expect(result['dynamic_'], dynamic_);
      expect(result['int_'], int_);
      expect(result['num_'], num_);
      expect(result['string'], string);
      expect(result['model'], model.toJson());
    });
  }

  {
    final closure = client.testMapListModel;
    test('Test ${closure.runtimeType}', () async {
      final values = [
        {
          'test1': [Model(s: '10'), Model(s: '11')],
          'test2': [Model(s: '20'), Model(s: '21')],
        },
        {
          'test3': [Model(s: '30'), Model(s: '31')],
        },
      ];
      for (final value in values) {
        final result = await closure(value);
        expect(result, value);
      }
    });
  }

  {
    final closure = client.testMap_ListModel;
    test('Test ${closure.runtimeType}', () async {
      final values = [
        null,
        {
          'test1': [Model(s: '10'), Model(s: '11')],
          'test2': [Model(s: '20'), Model(s: '21')],
        },
        {
          'test3': [Model(s: '30'), Model(s: '31')],
        },
      ];
      for (final value in values) {
        final result = await closure(value);
        expect(result, value);
      }
    });
  }

  {
    final closure = client.testIgnoreIfNullForMethod();
    test('Test ${closure.runtimeType}', () async {
      // TODO: Test testIgnoreIfNullForMethod
    });
  }
}

class Client extends TesterClient {
  Client() : super(ClientTransport());
}

class ClientTransport extends TesterTransport
    with RpcHttpTransport<_Request, dynamic> {
  final TesterHandler _handler = TesterHandler(TesterServer());

  @override
  Future post(_Request request) async {
    final methods =
        TesterUtils.getMethods().where((e) => e.path == request.path);
    if (methods.isNotEmpty) {
      final method = methods.first;
      final body = jsonDecode(request.body as String) as Map;
      return await _handler.handle(method.name,
          body['p'] as Map<String, dynamic>, body['n'] as Map<String, dynamic>);
    } else {
      throw StateError('Path not found: ${request.path}');
    }
  }

  @override
  Future postprocess(request, response) async {
    return response;
  }

  @override
  Future<_Request> preprocess(
      String name,
      String method,
      String path,
      Map<String, dynamic> positionalArguments,
      Map<String, dynamic> namedArguments) async {
    final body = {'p': positionalArguments, 'n': namedArguments};
    return _Request(path: path, body: jsonEncode(body));
  }
}

class Model {
  final String s;

  Model({required this.s});

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(s: json['s'] as String);
  }

  @override
  bool operator ==(other) {
    if (other is Model) {
      return s == other.s;
    }

    return false;
  }

  Map<String, dynamic> toJson() {
    return {'s': s};
  }
}

@RpcService(host: '', serverPort: 0)
abstract class Tester {
  @RpcMethod(path: '/testAlias')
  Future<bool> testAlias({@RpcKey(name: 'void') required bool v});

  @RpcMethod(path: '/testBool')
  Future<bool> testBool(bool v);

  @RpcMethod(path: '/testBool_')
  Future<bool?> testBool_(bool? v);

  @RpcMethod(path: '/testDateTime')
  Future<DateTime> testDateTime(DateTime v);

  @RpcMethod(path: '/testDateTime_')
  Future<DateTime?> testDateTime_(DateTime? v);

  @RpcMethod(path: '/testDouble')
  Future<double> testDouble(double v);

  @RpcMethod(path: '/testDouble_')
  Future<double?> testDouble_(double? v);

  @RpcMethod(path: '/testDynamic')
  Future<dynamic> testDynamic(dynamic v);

  @RpcMethod(path: '/testDynamic_')
  Future<dynamic?> testDynamic_(dynamic? v);

  @RpcMethod(path: '/testIgnoreIfNullForMethod', ignoreIfNull: true)
  Future<String> testIgnoreIfNullForMethod({bool? v1, int? v2});

  @RpcMethod(path: '/testInt')
  Future<int> testInt(int v);

  @RpcMethod(path: '/testInt_')
  Future<int?> testInt_(int? v);

  @RpcMethod(path: '/testList')
  Future<List> testList(List v);

  @RpcMethod(path: '/testList_')
  Future<List?> testList_(List? v);

  @RpcMethod(path: '/testList_Primitive')
  Future<List<int>?> testList_Int(List<int>? v);

  @RpcMethod(path: '/testList_Primitive_')
  Future<List<int?>?> testList_Int_(List<int?>? v);

  @RpcMethod(path: '/testList_Model')
  Future<List<Model>?> testList_Model(List<Model>? v);

  @RpcMethod(path: '/testList_Model_')
  Future<List<Model?>?> testList_Model_(List<Model?>? v);

  @RpcMethod(path: '/testListListPrimitive')
  Future<List<List<int>>> testListListInt(List<List<int>> v);

  @RpcMethod(path: '/testListListModel')
  Future<List<List<Model>>> testListListModel(List<List<Model>> v);

  @RpcMethod(path: '/testListModel')
  Future<List<Model>> testListModel(List<Model> v);

  @RpcMethod(path: '/testListModel_')
  Future<List<Model?>> testListModel_(List<Model?> v);

  @RpcMethod(path: '/testMap_ListModel')
  Future<Map<String, List<Model>>?> testMap_ListModel(
      Map<String, List<Model>>? v);

  @RpcMethod(path: '/testMapListModel')
  Future<Map<String, List<Model>>> testMapListModel(Map<String, List<Model>> v);

  @RpcMethod(path: '/testModel')
  Future<Model> testModel(Model v);

  @RpcMethod(path: '/testModel_')
  Future<Model?> testModel_(Model? v);

  @RpcMethod(path: '/testNum')
  Future<num> testNum(num v);

  @RpcMethod(path: '/testNum_')
  Future<num?> testNum_(num? v);

  @RpcMethod(path: '')
  Future<Map<String, dynamic>> testSendAll(
      {required bool bool_,
      required double double_,
      required dynamic dynamic_,
      required int int_,
      required num num_,
      required String string,
      required Model model});

  @RpcMethod(path: '/testString')
  Future<String> testString(String v);

  @RpcMethod(path: '/testString_')
  Future<String?> testString_(String? v);

  @RpcMethod(path: '/void')
  Future<void> testVoid();
}

class TesterServer implements Tester {
  @override
  Future<bool> testAlias({required bool v}) async {
    return v;
  }

  @override
  Future<bool> testBool(bool v) async {
    return v;
  }

  @override
  Future<bool?> testBool_(bool? v) async {
    return v;
  }

  @override
  Future<DateTime> testDateTime(DateTime v) async {
    return v;
  }

  @override
  Future<DateTime?> testDateTime_(DateTime? v) async {
    return v;
  }

  @override
  Future<double> testDouble(double v) async {
    return v;
  }

  @override
  Future<double?> testDouble_(double? v) async {
    return v;
  }

  @override
  Future testDynamic(v) async {
    return v;
  }

  @override
  Future testDynamic_(v) async {
    return v;
  }

  @override
  Future<String> testIgnoreIfNullForMethod({bool? v1, int? v2}) async {
    return '';
  }

  @override
  Future<int> testInt(int v) async {
    return v;
  }

  @override
  Future<int?> testInt_(int? v) async {
    return v;
  }

  @override
  Future<List> testList(List v) async {
    return v;
  }

  @override
  Future<List?> testList_(List? v) async {
    return v;
  }

  @override
  Future<List<int>?> testList_Int(List<int>? v) async {
    return v;
  }

  @override
  Future<List<int?>?> testList_Int_(List<int?>? v) async {
    return v;
  }

  @override
  Future<List<Model>?> testList_Model(List<Model>? v) async {
    return v;
  }

  @override
  Future<List<Model?>?> testList_Model_(List<Model?>? v) async {
    return v;
  }

  @override
  Future<List<List<int>>> testListListInt(List<List<int>> v) async {
    return v;
  }

  @override
  Future<List<List<Model>>> testListListModel(List<List<Model>> v) async {
    return v;
  }

  @override
  Future<List<Model>> testListModel(List<Model> v) async {
    return v;
  }

  @override
  Future<List<Model?>> testListModel_(List<Model?> v) async {
    return v;
  }

  @override
  Future<Map<String, List<Model>>?> testMap_ListModel(
      Map<String, List<Model>>? v) async {
    return v;
  }

  @override
  Future<Map<String, List<Model>>> testMapListModel(
      Map<String, List<Model>> v) async {
    return v;
  }

  @override
  Future<Model> testModel(Model v) async {
    return v;
  }

  @override
  Future<Model?> testModel_(Model? v) async {
    return v;
  }

  @override
  Future<num> testNum(num v) async {
    return v;
  }

  @override
  Future<num?> testNum_(num? v) async {
    return v;
  }

  @override
  Future<Map<String, dynamic>> testSendAll(
      {required bool bool_,
      required double double_,
      required dynamic_,
      required int int_,
      required num num_,
      required String string,
      required Model model}) async {
    return {
      'bool_': bool_,
      'double_': double_,
      'dynamic_': dynamic_,
      'int_': int_,
      'num_': num_,
      'string': string,
      'model': model.toJson()
    };
  }

  @override
  Future<String> testString(String v) async {
    return v;
  }

  @override
  Future<String?> testString_(String? v) async {
    return v;
  }

  @override
  Future<void> testVoid() async {
    return;
  }
}

class _Request {
  final String path;

  final dynamic body;

  _Request({this.body, required this.path});
}
