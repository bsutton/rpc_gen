// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test.dart';

// **************************************************************************
// RpcGenerator
// **************************************************************************

class TesterClient implements Tester {
  TesterClient(this._transport);

  final TesterTransport _transport;

  @override
  Future<bool> testAlias({required bool v}) async {
    final $0 = <String, dynamic>{};
    $0['void'] = v;
    final $1 = await _transport.send('POST', '/testAlias', $0);
    return $1 as bool;
  }

  @override
  Future<bool> testBool(bool v) async {
    final $0 = v;
    final $1 = await _transport.send('POST', '/testBool', $0);
    return $1 as bool;
  }

  @override
  Future<bool?> testBool_(bool? v) async {
    final $0 = v;
    final $1 = await _transport.send('POST', '/testBool_', $0);
    return $1 as bool?;
  }

  @override
  Future<DateTime> testDateTime(DateTime v) async {
    final $0 = v.toIso8601String();
    final $1 = await _transport.send('POST', '/testDateTime', $0);
    return DateTime.parse($1 as String);
  }

  @override
  Future<DateTime?> testDateTime_(DateTime? v) async {
    final $0 = v?.toIso8601String();
    final $1 = await _transport.send('POST', '/testDateTime_', $0);
    return $1 == null ? null : DateTime.parse($1 as String);
  }

  @override
  Future<double> testDouble(double v) async {
    final $0 = v;
    final $1 = await _transport.send('POST', '/testDouble', $0);
    return ($1 as num).toDouble();
  }

  @override
  Future<double?> testDouble_(double? v) async {
    final $0 = v;
    final $1 = await _transport.send('POST', '/testDouble_', $0);
    return ($1 as num?)?.toDouble();
  }

  @override
  Future<dynamic> testDynamic(dynamic v) async {
    final $0 = v;
    final $1 = await _transport.send('POST', '/testDynamic', $0);
    return $1;
  }

  @override
  Future<dynamic> testDynamic_(dynamic v) async {
    final $0 = v;
    final $1 = await _transport.send('POST', '/testDynamic_', $0);
    return $1;
  }

  @override
  Future<String> testIgnoreIfNullForMethod({bool? v1, int? v2}) async {
    final $0 = <String, dynamic>{};
    if (v1 != null) {
      $0['v1'] = v1;
    }
    if (v2 != null) {
      $0['v2'] = v2;
    }
    final $1 = await _transport.send('POST', '/testIgnoreIfNullForMethod', $0);
    return $1 as String;
  }

  @override
  Future<int> testInt(int v) async {
    final $0 = v;
    final $1 = await _transport.send('POST', '/testInt', $0);
    return $1 as int;
  }

  @override
  Future<int?> testInt_(int? v) async {
    final $0 = v;
    final $1 = await _transport.send('POST', '/testInt_', $0);
    return $1 as int?;
  }

  @override
  Future<List<dynamic>> testList(List<dynamic> v) async {
    final $0 = v;
    final $1 = await _transport.send('POST', '/testList', $0);
    return ($1 as List).map((e) => e).toList();
  }

  @override
  Future<List<dynamic>?> testList_(List<dynamic>? v) async {
    final $0 = v;
    final $1 = await _transport.send('POST', '/testList_', $0);
    return $1 == null ? null : ($1 as List).map((e) => e).toList();
  }

  @override
  Future<List<int>?> testList_Int(List<int>? v) async {
    final $0 = v;
    final $1 = await _transport.send('POST', '/testList_Primitive', $0);
    return $1 == null ? null : ($1 as List).map((e) => e as int).toList();
  }

  @override
  Future<List<int?>?> testList_Int_(List<int?>? v) async {
    final $0 = v;
    final $1 = await _transport.send('POST', '/testList_Primitive_', $0);
    return $1 == null ? null : ($1 as List).map((e) => e as int?).toList();
  }

  @override
  Future<List<Model>?> testList_Model(List<Model>? v) async {
    final $0 = v?.map((e) => e.toJson()).toList();
    final $1 = await _transport.send('POST', '/testList_Model', $0);
    return $1 == null
        ? null
        : ($1 as List)
            .map((e) => Model.fromJson((e as Map).cast<String, dynamic>()))
            .toList();
  }

  @override
  Future<List<Model?>?> testList_Model_(List<Model?>? v) async {
    final $0 = v?.map((e) => e?.toJson()).toList();
    final $1 = await _transport.send('POST', '/testList_Model_', $0);
    return $1 == null
        ? null
        : ($1 as List)
            .map((e) => e == null
                ? null
                : Model?.fromJson((e as Map).cast<String, dynamic>()))
            .toList();
  }

  @override
  Future<List<List<int>>> testListListInt(List<List<int>> v) async {
    final $0 = v;
    final $1 = await _transport.send('POST', '/testListListPrimitive', $0);
    return ($1 as List)
        .map((e) => (e as List).map((e) => e as int).toList())
        .toList();
  }

  @override
  Future<List<List<Model>>> testListListModel(List<List<Model>> v) async {
    final $0 = v.map((e) => e.map((e) => e.toJson()).toList()).toList();
    final $1 = await _transport.send('POST', '/testListListModel', $0);
    return ($1 as List)
        .map((e) => (e as List)
            .map((e) => Model.fromJson((e as Map).cast<String, dynamic>()))
            .toList())
        .toList();
  }

  @override
  Future<List<Model>> testListModel(List<Model> v) async {
    final $0 = v.map((e) => e.toJson()).toList();
    final $1 = await _transport.send('POST', '/testListModel', $0);
    return ($1 as List)
        .map((e) => Model.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  @override
  Future<List<Model?>> testListModel_(List<Model?> v) async {
    final $0 = v.map((e) => e?.toJson()).toList();
    final $1 = await _transport.send('POST', '/testListModel_', $0);
    return ($1 as List)
        .map((e) => e == null
            ? null
            : Model?.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  @override
  Future<Map<String, List<Model>>?> testMap_ListModel(
      Map<String, List<Model>>? v) async {
    final $0 = v?.map((k, v) => MapEntry(k, v.map((e) => e.toJson()).toList()));
    final $1 = await _transport.send('POST', '/testMap_ListModel', $0);
    return $1 == null
        ? null
        : ($1 as Map).map((k, v) => MapEntry(
            k as String,
            (v as List)
                .map((e) => Model.fromJson((e as Map).cast<String, dynamic>()))
                .toList()));
  }

  @override
  Future<Map<String, List<Model>>> testMapListModel(
      Map<String, List<Model>> v) async {
    final $0 = v.map((k, v) => MapEntry(k, v.map((e) => e.toJson()).toList()));
    final $1 = await _transport.send('POST', '/testMapListModel', $0);
    return ($1 as Map).map((k, v) => MapEntry(
        k as String,
        (v as List)
            .map((e) => Model.fromJson((e as Map).cast<String, dynamic>()))
            .toList()));
  }

  @override
  Future<Model> testModel(Model v) async {
    final $0 = v.toJson();
    final $1 = await _transport.send('POST', '/testModel', $0);
    return Model.fromJson(($1 as Map).cast<String, dynamic>());
  }

  @override
  Future<Model?> testModel_(Model? v) async {
    final $0 = v?.toJson();
    final $1 = await _transport.send('POST', '/testModel_', $0);
    return $1 == null
        ? null
        : Model?.fromJson(($1 as Map).cast<String, dynamic>());
  }

  @override
  Future<num> testNum(num v) async {
    final $0 = v;
    final $1 = await _transport.send('POST', '/testNum', $0);
    return $1 as num;
  }

  @override
  Future<num?> testNum_(num? v) async {
    final $0 = v;
    final $1 = await _transport.send('POST', '/testNum_', $0);
    return $1 as num?;
  }

  @override
  Future<Map<String, dynamic>> testSendAll(
      {required bool bool_,
      required double double_,
      required dynamic dynamic_,
      required int int_,
      required num num_,
      required String string,
      required Model model}) async {
    final $0 = <String, dynamic>{};
    $0['bool_'] = bool_;
    $0['double_'] = double_;
    $0['dynamic_'] = dynamic_;
    $0['int_'] = int_;
    $0['num_'] = num_;
    $0['string'] = string;
    $0['model'] = model.toJson();
    final $1 = await _transport.send('POST', '', $0);
    return ($1 as Map).map((k, v) => MapEntry(k as String, v));
  }

  @override
  Future<String> testString(String v) async {
    final $0 = v;
    final $1 = await _transport.send('POST', '/testString', $0);
    return $1 as String;
  }

  @override
  Future<String?> testString_(String? v) async {
    final $0 = v;
    final $1 = await _transport.send('POST', '/testString_', $0);
    return $1 as String?;
  }

  @override
  Future<void> testVoid() async {
    final $0 = <String, dynamic>{};
    await _transport.send('POST', '/void', $0);
  }
}

class TesterConfig {
  static const int? clientPort = 0;

  static const String host = '';

  static const int? serverPort = 0;
}

class TesterHandler {
  TesterHandler(this._handler);

  final Tester _handler;

  Future handle(String name, data) async {
    switch (name) {
      case 'testAlias':
        final $0 = data as Map;
        final $1 = $0['void'] as bool;
        final $2 = await _handler.testAlias(v: $1);
        return $2;
      case 'testBool':
        final $0 = data as bool;
        final $1 = await _handler.testBool($0);
        return $1;
      case 'testBool_':
        final $0 = data as bool?;
        final $1 = await _handler.testBool_($0);
        return $1;
      case 'testDateTime':
        final $0 = DateTime.parse(data as String);
        final $1 = await _handler.testDateTime($0);
        return $1.toIso8601String();
      case 'testDateTime_':
        final $0 = data == null ? null : DateTime.parse(data as String);
        final $1 = await _handler.testDateTime_($0);
        return $1?.toIso8601String();
      case 'testDouble':
        final $0 = (data as num).toDouble();
        final $1 = await _handler.testDouble($0);
        return $1;
      case 'testDouble_':
        final $0 = (data as num?)?.toDouble();
        final $1 = await _handler.testDouble_($0);
        return $1;
      case 'testDynamic':
        final $0 = data;
        final $1 = await _handler.testDynamic($0);
        return $1;
      case 'testDynamic_':
        final $0 = data;
        final $1 = await _handler.testDynamic_($0);
        return $1;
      case 'testIgnoreIfNullForMethod':
        final $0 = data as Map;
        final $1 = $0['v1'] as bool?;
        final $2 = $0['v2'] as int?;
        final $3 = await _handler.testIgnoreIfNullForMethod(v1: $1, v2: $2);
        return $3;
      case 'testInt':
        final $0 = data as int;
        final $1 = await _handler.testInt($0);
        return $1;
      case 'testInt_':
        final $0 = data as int?;
        final $1 = await _handler.testInt_($0);
        return $1;
      case 'testList':
        final $0 = (data as List).map((e) => e).toList();
        final $1 = await _handler.testList($0);
        return $1;
      case 'testList_':
        final $0 = data == null ? null : (data as List).map((e) => e).toList();
        final $1 = await _handler.testList_($0);
        return $1;
      case 'testList_Int':
        final $0 =
            data == null ? null : (data as List).map((e) => e as int).toList();
        final $1 = await _handler.testList_Int($0);
        return $1;
      case 'testList_Int_':
        final $0 =
            data == null ? null : (data as List).map((e) => e as int?).toList();
        final $1 = await _handler.testList_Int_($0);
        return $1;
      case 'testList_Model':
        final $0 = data == null
            ? null
            : (data as List)
                .map((e) => Model.fromJson((e as Map).cast<String, dynamic>()))
                .toList();
        final $1 = await _handler.testList_Model($0);
        return $1?.map((e) => e.toJson()).toList();
      case 'testList_Model_':
        final $0 = data == null
            ? null
            : (data as List)
                .map((e) => e == null
                    ? null
                    : Model?.fromJson((e as Map).cast<String, dynamic>()))
                .toList();
        final $1 = await _handler.testList_Model_($0);
        return $1?.map((e) => e?.toJson()).toList();
      case 'testListListInt':
        final $0 = (data as List)
            .map((e) => (e as List).map((e) => e as int).toList())
            .toList();
        final $1 = await _handler.testListListInt($0);
        return $1;
      case 'testListListModel':
        final $0 = (data as List)
            .map((e) => (e as List)
                .map((e) => Model.fromJson((e as Map).cast<String, dynamic>()))
                .toList())
            .toList();
        final $1 = await _handler.testListListModel($0);
        return $1.map((e) => e.map((e) => e.toJson()).toList()).toList();
      case 'testListModel':
        final $0 = (data as List)
            .map((e) => Model.fromJson((e as Map).cast<String, dynamic>()))
            .toList();
        final $1 = await _handler.testListModel($0);
        return $1.map((e) => e.toJson()).toList();
      case 'testListModel_':
        final $0 = (data as List)
            .map((e) => e == null
                ? null
                : Model?.fromJson((e as Map).cast<String, dynamic>()))
            .toList();
        final $1 = await _handler.testListModel_($0);
        return $1.map((e) => e?.toJson()).toList();
      case 'testMap_ListModel':
        final $0 = data == null
            ? null
            : (data as Map).map((k, v) => MapEntry(
                k as String,
                (v as List)
                    .map((e) =>
                        Model.fromJson((e as Map).cast<String, dynamic>()))
                    .toList()));
        final $1 = await _handler.testMap_ListModel($0);
        return $1
            ?.map((k, v) => MapEntry(k, v.map((e) => e.toJson()).toList()));
      case 'testMapListModel':
        final $0 = (data as Map).map((k, v) => MapEntry(
            k as String,
            (v as List)
                .map((e) => Model.fromJson((e as Map).cast<String, dynamic>()))
                .toList()));
        final $1 = await _handler.testMapListModel($0);
        return $1.map((k, v) => MapEntry(k, v.map((e) => e.toJson()).toList()));
      case 'testModel':
        final $0 = Model.fromJson((data as Map).cast<String, dynamic>());
        final $1 = await _handler.testModel($0);
        return $1.toJson();
      case 'testModel_':
        final $0 = data == null
            ? null
            : Model?.fromJson((data as Map).cast<String, dynamic>());
        final $1 = await _handler.testModel_($0);
        return $1?.toJson();
      case 'testNum':
        final $0 = data as num;
        final $1 = await _handler.testNum($0);
        return $1;
      case 'testNum_':
        final $0 = data as num?;
        final $1 = await _handler.testNum_($0);
        return $1;
      case 'testSendAll':
        final $0 = data as Map;
        final $1 = $0['bool_'] as bool;
        final $2 = ($0['double_'] as num).toDouble();
        final $3 = $0['dynamic_'];
        final $4 = $0['int_'] as int;
        final $5 = $0['num_'] as num;
        final $6 = $0['string'] as String;
        final $7 = Model.fromJson(($0['model'] as Map).cast<String, dynamic>());
        final $8 = await _handler.testSendAll(
            bool_: $1,
            double_: $2,
            dynamic_: $3,
            int_: $4,
            num_: $5,
            string: $6,
            model: $7);
        return $8;
      case 'testString':
        final $0 = data as String;
        final $1 = await _handler.testString($0);
        return $1;
      case 'testString_':
        final $0 = data as String?;
        final $1 = await _handler.testString_($0);
        return $1;
      case 'testVoid':
        await _handler.testVoid();
        return;
      default:
        throw StateError('Unknown remote procedure: \'$name\'');
    }
  }
}

class TesterMethod {
  const TesterMethod(
      {required this.authorize,
      required this.method,
      required this.name,
      required this.path});

  final bool authorize;

  final String method;

  final String name;

  final String path;
}

abstract class TesterTransport {
  Future send(String method, String path, request);
}

abstract class TesterUtils {
  static List<TesterMethod> getMethods() {
    return const [
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testAlias',
          path: '/testAlias'),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testBool',
          path: '/testBool'),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testBool_',
          path: '/testBool_'),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testDateTime',
          path: '/testDateTime'),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testDateTime_',
          path: '/testDateTime_'),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testDouble',
          path: '/testDouble'),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testDouble_',
          path: '/testDouble_'),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testDynamic',
          path: '/testDynamic'),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testDynamic_',
          path: '/testDynamic_'),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testIgnoreIfNullForMethod',
          path: '/testIgnoreIfNullForMethod'),
      TesterMethod(
          authorize: false, method: 'POST', name: 'testInt', path: '/testInt'),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testInt_',
          path: '/testInt_'),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testList',
          path: '/testList'),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testList_',
          path: '/testList_'),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testList_Int',
          path: '/testList_Primitive'),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testList_Int_',
          path: '/testList_Primitive_'),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testList_Model',
          path: '/testList_Model'),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testList_Model_',
          path: '/testList_Model_'),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testListListInt',
          path: '/testListListPrimitive'),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testListListModel',
          path: '/testListListModel'),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testListModel',
          path: '/testListModel'),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testListModel_',
          path: '/testListModel_'),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testMap_ListModel',
          path: '/testMap_ListModel'),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testMapListModel',
          path: '/testMapListModel'),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testModel',
          path: '/testModel'),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testModel_',
          path: '/testModel_'),
      TesterMethod(
          authorize: false, method: 'POST', name: 'testNum', path: '/testNum'),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testNum_',
          path: '/testNum_'),
      TesterMethod(
          authorize: false, method: 'POST', name: 'testSendAll', path: ''),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testString',
          path: '/testString'),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testString_',
          path: '/testString_'),
      TesterMethod(
          authorize: false, method: 'POST', name: 'testVoid', path: '/void')
    ];
  }
}
