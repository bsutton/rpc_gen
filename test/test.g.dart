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
    final $1 = <String, dynamic>{};
    final $2 = <String, dynamic>{};
    $2['void'] = v;
    final $0 = await _transport.send('testAlias', 'POST', '/testAlias', $1, $2);
    return $0 as bool;
  }

  @override
  Future<bool> testBool(bool v) async {
    final $1 = <String, dynamic>{};
    final $2 = <String, dynamic>{};
    $1['v'] = v;
    final $0 = await _transport.send('testBool', 'POST', '/testBool', $1, $2);
    return $0 as bool;
  }

  @override
  Future<bool?> testBool_(bool? v) async {
    final $1 = <String, dynamic>{};
    final $2 = <String, dynamic>{};
    $1['v'] = v;
    final $0 = await _transport.send('testBool_', 'POST', '/testBool_', $1, $2);
    return $0 as bool?;
  }

  @override
  Future<DateTime> testDateTime(DateTime v) async {
    final $1 = <String, dynamic>{};
    final $2 = <String, dynamic>{};
    $1['v'] = v.toIso8601String();
    final $0 =
        await _transport.send('testDateTime', 'POST', '/testDateTime', $1, $2);
    return DateTime.parse($0 as String);
  }

  @override
  Future<DateTime?> testDateTime_(DateTime? v) async {
    final $1 = <String, dynamic>{};
    final $2 = <String, dynamic>{};
    $1['v'] = v?.toIso8601String();
    final $0 = await _transport.send(
        'testDateTime_', 'POST', '/testDateTime_', $1, $2);
    return $0 == null ? null : DateTime.parse($0 as String);
  }

  @override
  Future<double> testDouble(double v) async {
    final $1 = <String, dynamic>{};
    final $2 = <String, dynamic>{};
    $1['v'] = v;
    final $0 =
        await _transport.send('testDouble', 'POST', '/testDouble', $1, $2);
    return ($0 as num).toDouble();
  }

  @override
  Future<double?> testDouble_(double? v) async {
    final $1 = <String, dynamic>{};
    final $2 = <String, dynamic>{};
    $1['v'] = v;
    final $0 =
        await _transport.send('testDouble_', 'POST', '/testDouble_', $1, $2);
    return ($0 as num?)?.toDouble();
  }

  @override
  Future<dynamic> testDynamic(dynamic v) async {
    final $1 = <String, dynamic>{};
    final $2 = <String, dynamic>{};
    $1['v'] = v;
    final $0 =
        await _transport.send('testDynamic', 'POST', '/testDynamic', $1, $2);
    return $0;
  }

  @override
  Future<dynamic> testDynamic_(dynamic v) async {
    final $1 = <String, dynamic>{};
    final $2 = <String, dynamic>{};
    $1['v'] = v;
    final $0 =
        await _transport.send('testDynamic_', 'POST', '/testDynamic_', $1, $2);
    return $0;
  }

  @override
  Future<String> testIgnoreIfNullForMethod({bool? v1, int? v2}) async {
    final $1 = <String, dynamic>{};
    final $2 = <String, dynamic>{};
    if (v1 != null) {
      $2['v1'] = v1;
    }
    if (v2 != null) {
      $2['v2'] = v2;
    }
    final $0 = await _transport.send('testIgnoreIfNullForMethod', 'POST',
        '/testIgnoreIfNullForMethod', $1, $2);
    return $0 as String;
  }

  @override
  Future<int> testInt(int v) async {
    final $1 = <String, dynamic>{};
    final $2 = <String, dynamic>{};
    $1['v'] = v;
    final $0 = await _transport.send('testInt', 'POST', '/testInt', $1, $2);
    return $0 as int;
  }

  @override
  Future<int?> testInt_(int? v) async {
    final $1 = <String, dynamic>{};
    final $2 = <String, dynamic>{};
    $1['v'] = v;
    final $0 = await _transport.send('testInt_', 'POST', '/testInt_', $1, $2);
    return $0 as int?;
  }

  @override
  Future<List<dynamic>> testList(List<dynamic> v) async {
    final $1 = <String, dynamic>{};
    final $2 = <String, dynamic>{};
    $1['v'] = v;
    final $0 = await _transport.send('testList', 'POST', '/testList', $1, $2);
    return ($0 as List).map((e) => e).toList();
  }

  @override
  Future<List<dynamic>?> testList_(List<dynamic>? v) async {
    final $1 = <String, dynamic>{};
    final $2 = <String, dynamic>{};
    $1['v'] = v;
    final $0 = await _transport.send('testList_', 'POST', '/testList_', $1, $2);
    return $0 == null ? null : ($0 as List).map((e) => e).toList();
  }

  @override
  Future<List<int>?> testList_Int(List<int>? v) async {
    final $1 = <String, dynamic>{};
    final $2 = <String, dynamic>{};
    $1['v'] = v;
    final $0 = await _transport.send(
        'testList_Int', 'POST', '/testList_Primitive', $1, $2);
    return $0 == null ? null : ($0 as List).map((e) => e as int).toList();
  }

  @override
  Future<List<int?>?> testList_Int_(List<int?>? v) async {
    final $1 = <String, dynamic>{};
    final $2 = <String, dynamic>{};
    $1['v'] = v;
    final $0 = await _transport.send(
        'testList_Int_', 'POST', '/testList_Primitive_', $1, $2);
    return $0 == null ? null : ($0 as List).map((e) => e as int?).toList();
  }

  @override
  Future<List<Model>?> testList_Model(List<Model>? v) async {
    final $1 = <String, dynamic>{};
    final $2 = <String, dynamic>{};
    $1['v'] = v?.map((e) => e.toJson()).toList();
    final $0 = await _transport.send(
        'testList_Model', 'POST', '/testList_Model', $1, $2);
    return $0 == null
        ? null
        : ($0 as List)
            .map((e) => Model.fromJson((e as Map).cast<String, dynamic>()))
            .toList();
  }

  @override
  Future<List<Model?>?> testList_Model_(List<Model?>? v) async {
    final $1 = <String, dynamic>{};
    final $2 = <String, dynamic>{};
    $1['v'] = v?.map((e) => e?.toJson()).toList();
    final $0 = await _transport.send(
        'testList_Model_', 'POST', '/testList_Model_', $1, $2);
    return $0 == null
        ? null
        : ($0 as List)
            .map((e) => e == null
                ? null
                : Model?.fromJson((e as Map).cast<String, dynamic>()))
            .toList();
  }

  @override
  Future<List<List<int>>> testListListInt(List<List<int>> v) async {
    final $1 = <String, dynamic>{};
    final $2 = <String, dynamic>{};
    $1['v'] = v;
    final $0 = await _transport.send(
        'testListListInt', 'POST', '/testListListPrimitive', $1, $2);
    return ($0 as List)
        .map((e) => (e as List).map((e) => e as int).toList())
        .toList();
  }

  @override
  Future<List<List<Model>>> testListListModel(List<List<Model>> v) async {
    final $1 = <String, dynamic>{};
    final $2 = <String, dynamic>{};
    $1['v'] = v.map((e) => e.map((e) => e.toJson()).toList()).toList();
    final $0 = await _transport.send(
        'testListListModel', 'POST', '/testListListModel', $1, $2);
    return ($0 as List)
        .map((e) => (e as List)
            .map((e) => Model.fromJson((e as Map).cast<String, dynamic>()))
            .toList())
        .toList();
  }

  @override
  Future<List<Model>> testListModel(List<Model> v) async {
    final $1 = <String, dynamic>{};
    final $2 = <String, dynamic>{};
    $1['v'] = v.map((e) => e.toJson()).toList();
    final $0 = await _transport.send(
        'testListModel', 'POST', '/testListModel', $1, $2);
    return ($0 as List)
        .map((e) => Model.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  @override
  Future<List<Model?>> testListModel_(List<Model?> v) async {
    final $1 = <String, dynamic>{};
    final $2 = <String, dynamic>{};
    $1['v'] = v.map((e) => e?.toJson()).toList();
    final $0 = await _transport.send(
        'testListModel_', 'POST', '/testListModel_', $1, $2);
    return ($0 as List)
        .map((e) => e == null
            ? null
            : Model?.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  @override
  Future<Map<String, List<Model>>?> testMap_ListModel(
      Map<String, List<Model>>? v) async {
    final $1 = <String, dynamic>{};
    final $2 = <String, dynamic>{};
    $1['v'] = v?.map((k, v) => MapEntry(k, v.map((e) => e.toJson()).toList()));
    final $0 = await _transport.send(
        'testMap_ListModel', 'POST', '/testMap_ListModel', $1, $2);
    return $0 == null
        ? null
        : ($0 as Map).map((k, v) => MapEntry(
            k as String,
            (v as List)
                .map((e) => Model.fromJson((e as Map).cast<String, dynamic>()))
                .toList()));
  }

  @override
  Future<Map<String, List<Model>>> testMapListModel(
      Map<String, List<Model>> v) async {
    final $1 = <String, dynamic>{};
    final $2 = <String, dynamic>{};
    $1['v'] = v.map((k, v) => MapEntry(k, v.map((e) => e.toJson()).toList()));
    final $0 = await _transport.send(
        'testMapListModel', 'POST', '/testMapListModel', $1, $2);
    return ($0 as Map).map((k, v) => MapEntry(
        k as String,
        (v as List)
            .map((e) => Model.fromJson((e as Map).cast<String, dynamic>()))
            .toList()));
  }

  @override
  Future<Model> testModel(Model v) async {
    final $1 = <String, dynamic>{};
    final $2 = <String, dynamic>{};
    $1['v'] = v.toJson();
    final $0 = await _transport.send('testModel', 'POST', '/testModel', $1, $2);
    return Model.fromJson(($0 as Map).cast<String, dynamic>());
  }

  @override
  Future<Model?> testModel_(Model? v) async {
    final $1 = <String, dynamic>{};
    final $2 = <String, dynamic>{};
    $1['v'] = v?.toJson();
    final $0 =
        await _transport.send('testModel_', 'POST', '/testModel_', $1, $2);
    return $0 == null
        ? null
        : Model?.fromJson(($0 as Map).cast<String, dynamic>());
  }

  @override
  Future<num> testNum(num v) async {
    final $1 = <String, dynamic>{};
    final $2 = <String, dynamic>{};
    $1['v'] = v;
    final $0 = await _transport.send('testNum', 'POST', '/testNum', $1, $2);
    return $0 as num;
  }

  @override
  Future<num?> testNum_(num? v) async {
    final $1 = <String, dynamic>{};
    final $2 = <String, dynamic>{};
    $1['v'] = v;
    final $0 = await _transport.send('testNum_', 'POST', '/testNum_', $1, $2);
    return $0 as num?;
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
    final $1 = <String, dynamic>{};
    final $2 = <String, dynamic>{};
    $2['bool_'] = bool_;
    $2['double_'] = double_;
    $2['dynamic_'] = dynamic_;
    $2['int_'] = int_;
    $2['num_'] = num_;
    $2['string'] = string;
    $2['model'] = model.toJson();
    final $0 = await _transport.send('testSendAll', 'POST', '', $1, $2);
    return ($0 as Map).map((k, v) => MapEntry(k as String, v));
  }

  @override
  Future<String> testString(String v) async {
    final $1 = <String, dynamic>{};
    final $2 = <String, dynamic>{};
    $1['v'] = v;
    final $0 =
        await _transport.send('testString', 'POST', '/testString', $1, $2);
    return $0 as String;
  }

  @override
  Future<String?> testString_(String? v) async {
    final $1 = <String, dynamic>{};
    final $2 = <String, dynamic>{};
    $1['v'] = v;
    final $0 =
        await _transport.send('testString_', 'POST', '/testString_', $1, $2);
    return $0 as String?;
  }

  @override
  Future<void> testVoid() async {
    final $1 = <String, dynamic>{};
    final $2 = <String, dynamic>{};
    await _transport.send('testVoid', 'POST', '/void', $1, $2);
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

  Future handle(String name, Map<String, dynamic> positionalArguments,
      Map<String, dynamic> namedArguments) async {
    switch (name) {
      case 'testAlias':
        final $0 = namedArguments['void'] as bool;
        final $1 = await _handler.testAlias(v: $0);
        return $1;
      case 'testBool':
        final $0 = positionalArguments['v'] as bool;
        final $1 = await _handler.testBool($0);
        return $1;
      case 'testBool_':
        final $0 = positionalArguments['v'] as bool?;
        final $1 = await _handler.testBool_($0);
        return $1;
      case 'testDateTime':
        final $0 = DateTime.parse(positionalArguments['v'] as String);
        final $1 = await _handler.testDateTime($0);
        return $1.toIso8601String();
      case 'testDateTime_':
        final $0 = positionalArguments['v'] == null
            ? null
            : DateTime.parse(positionalArguments['v'] as String);
        final $1 = await _handler.testDateTime_($0);
        return $1?.toIso8601String();
      case 'testDouble':
        final $0 = (positionalArguments['v'] as num).toDouble();
        final $1 = await _handler.testDouble($0);
        return $1;
      case 'testDouble_':
        final $0 = (positionalArguments['v'] as num?)?.toDouble();
        final $1 = await _handler.testDouble_($0);
        return $1;
      case 'testDynamic':
        final $0 = positionalArguments['v'];
        final $1 = await _handler.testDynamic($0);
        return $1;
      case 'testDynamic_':
        final $0 = positionalArguments['v'];
        final $1 = await _handler.testDynamic_($0);
        return $1;
      case 'testIgnoreIfNullForMethod':
        final $0 = namedArguments['v1'] as bool?;
        final $1 = namedArguments['v2'] as int?;
        final $2 = await _handler.testIgnoreIfNullForMethod(v1: $0, v2: $1);
        return $2;
      case 'testInt':
        final $0 = positionalArguments['v'] as int;
        final $1 = await _handler.testInt($0);
        return $1;
      case 'testInt_':
        final $0 = positionalArguments['v'] as int?;
        final $1 = await _handler.testInt_($0);
        return $1;
      case 'testList':
        final $0 = (positionalArguments['v'] as List).map((e) => e).toList();
        final $1 = await _handler.testList($0);
        return $1;
      case 'testList_':
        final $0 = positionalArguments['v'] == null
            ? null
            : (positionalArguments['v'] as List).map((e) => e).toList();
        final $1 = await _handler.testList_($0);
        return $1;
      case 'testList_Int':
        final $0 = positionalArguments['v'] == null
            ? null
            : (positionalArguments['v'] as List).map((e) => e as int).toList();
        final $1 = await _handler.testList_Int($0);
        return $1;
      case 'testList_Int_':
        final $0 = positionalArguments['v'] == null
            ? null
            : (positionalArguments['v'] as List).map((e) => e as int?).toList();
        final $1 = await _handler.testList_Int_($0);
        return $1;
      case 'testList_Model':
        final $0 = positionalArguments['v'] == null
            ? null
            : (positionalArguments['v'] as List)
                .map((e) => Model.fromJson((e as Map).cast<String, dynamic>()))
                .toList();
        final $1 = await _handler.testList_Model($0);
        return $1?.map((e) => e.toJson()).toList();
      case 'testList_Model_':
        final $0 = positionalArguments['v'] == null
            ? null
            : (positionalArguments['v'] as List)
                .map((e) => e == null
                    ? null
                    : Model?.fromJson((e as Map).cast<String, dynamic>()))
                .toList();
        final $1 = await _handler.testList_Model_($0);
        return $1?.map((e) => e?.toJson()).toList();
      case 'testListListInt':
        final $0 = (positionalArguments['v'] as List)
            .map((e) => (e as List).map((e) => e as int).toList())
            .toList();
        final $1 = await _handler.testListListInt($0);
        return $1;
      case 'testListListModel':
        final $0 = (positionalArguments['v'] as List)
            .map((e) => (e as List)
                .map((e) => Model.fromJson((e as Map).cast<String, dynamic>()))
                .toList())
            .toList();
        final $1 = await _handler.testListListModel($0);
        return $1.map((e) => e.map((e) => e.toJson()).toList()).toList();
      case 'testListModel':
        final $0 = (positionalArguments['v'] as List)
            .map((e) => Model.fromJson((e as Map).cast<String, dynamic>()))
            .toList();
        final $1 = await _handler.testListModel($0);
        return $1.map((e) => e.toJson()).toList();
      case 'testListModel_':
        final $0 = (positionalArguments['v'] as List)
            .map((e) => e == null
                ? null
                : Model?.fromJson((e as Map).cast<String, dynamic>()))
            .toList();
        final $1 = await _handler.testListModel_($0);
        return $1.map((e) => e?.toJson()).toList();
      case 'testMap_ListModel':
        final $0 = positionalArguments['v'] == null
            ? null
            : (positionalArguments['v'] as Map).map((k, v) => MapEntry(
                k as String,
                (v as List)
                    .map((e) =>
                        Model.fromJson((e as Map).cast<String, dynamic>()))
                    .toList()));
        final $1 = await _handler.testMap_ListModel($0);
        return $1
            ?.map((k, v) => MapEntry(k, v.map((e) => e.toJson()).toList()));
      case 'testMapListModel':
        final $0 = (positionalArguments['v'] as Map).map((k, v) => MapEntry(
            k as String,
            (v as List)
                .map((e) => Model.fromJson((e as Map).cast<String, dynamic>()))
                .toList()));
        final $1 = await _handler.testMapListModel($0);
        return $1.map((k, v) => MapEntry(k, v.map((e) => e.toJson()).toList()));
      case 'testModel':
        final $0 = Model.fromJson(
            (positionalArguments['v'] as Map).cast<String, dynamic>());
        final $1 = await _handler.testModel($0);
        return $1.toJson();
      case 'testModel_':
        final $0 = positionalArguments['v'] == null
            ? null
            : Model?.fromJson(
                (positionalArguments['v'] as Map).cast<String, dynamic>());
        final $1 = await _handler.testModel_($0);
        return $1?.toJson();
      case 'testNum':
        final $0 = positionalArguments['v'] as num;
        final $1 = await _handler.testNum($0);
        return $1;
      case 'testNum_':
        final $0 = positionalArguments['v'] as num?;
        final $1 = await _handler.testNum_($0);
        return $1;
      case 'testSendAll':
        final $0 = namedArguments['bool_'] as bool;
        final $1 = (namedArguments['double_'] as num).toDouble();
        final $2 = namedArguments['dynamic_'];
        final $3 = namedArguments['int_'] as int;
        final $4 = namedArguments['num_'] as num;
        final $5 = namedArguments['string'] as String;
        final $6 = Model.fromJson(
            (namedArguments['model'] as Map).cast<String, dynamic>());
        final $7 = await _handler.testSendAll(
            bool_: $0,
            double_: $1,
            dynamic_: $2,
            int_: $3,
            num_: $4,
            string: $5,
            model: $6);
        return $7;
      case 'testString':
        final $0 = positionalArguments['v'] as String;
        final $1 = await _handler.testString($0);
        return $1;
      case 'testString_':
        final $0 = positionalArguments['v'] as String?;
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
      required this.namedParameters,
      required this.positionalParameters,
      required this.path});

  final bool authorize;

  final String method;

  final String name;

  final List<String> namedParameters;

  final List<String> positionalParameters;

  final String path;
}

abstract class TesterTransport {
  Future send(
      String name,
      String httpMethod,
      String path,
      Map<String, dynamic> positionalArguments,
      Map<String, dynamic> namedArguments);
}

abstract class TesterUtils {
  static List<TesterMethod> getMethods() {
    return const [
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testAlias',
          namedParameters: [],
          path: '/testAlias',
          positionalParameters: []),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testBool',
          namedParameters: [],
          path: '/testBool',
          positionalParameters: []),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testBool_',
          namedParameters: [],
          path: '/testBool_',
          positionalParameters: []),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testDateTime',
          namedParameters: [],
          path: '/testDateTime',
          positionalParameters: []),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testDateTime_',
          namedParameters: [],
          path: '/testDateTime_',
          positionalParameters: []),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testDouble',
          namedParameters: [],
          path: '/testDouble',
          positionalParameters: []),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testDouble_',
          namedParameters: [],
          path: '/testDouble_',
          positionalParameters: []),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testDynamic',
          namedParameters: [],
          path: '/testDynamic',
          positionalParameters: []),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testDynamic_',
          namedParameters: [],
          path: '/testDynamic_',
          positionalParameters: []),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testIgnoreIfNullForMethod',
          namedParameters: [],
          path: '/testIgnoreIfNullForMethod',
          positionalParameters: []),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testInt',
          namedParameters: [],
          path: '/testInt',
          positionalParameters: []),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testInt_',
          namedParameters: [],
          path: '/testInt_',
          positionalParameters: []),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testList',
          namedParameters: [],
          path: '/testList',
          positionalParameters: []),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testList_',
          namedParameters: [],
          path: '/testList_',
          positionalParameters: []),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testList_Int',
          namedParameters: [],
          path: '/testList_Primitive',
          positionalParameters: []),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testList_Int_',
          namedParameters: [],
          path: '/testList_Primitive_',
          positionalParameters: []),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testList_Model',
          namedParameters: [],
          path: '/testList_Model',
          positionalParameters: []),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testList_Model_',
          namedParameters: [],
          path: '/testList_Model_',
          positionalParameters: []),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testListListInt',
          namedParameters: [],
          path: '/testListListPrimitive',
          positionalParameters: []),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testListListModel',
          namedParameters: [],
          path: '/testListListModel',
          positionalParameters: []),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testListModel',
          namedParameters: [],
          path: '/testListModel',
          positionalParameters: []),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testListModel_',
          namedParameters: [],
          path: '/testListModel_',
          positionalParameters: []),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testMap_ListModel',
          namedParameters: [],
          path: '/testMap_ListModel',
          positionalParameters: []),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testMapListModel',
          namedParameters: [],
          path: '/testMapListModel',
          positionalParameters: []),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testModel',
          namedParameters: [],
          path: '/testModel',
          positionalParameters: []),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testModel_',
          namedParameters: [],
          path: '/testModel_',
          positionalParameters: []),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testNum',
          namedParameters: [],
          path: '/testNum',
          positionalParameters: []),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testNum_',
          namedParameters: [],
          path: '/testNum_',
          positionalParameters: []),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testSendAll',
          namedParameters: [],
          path: '',
          positionalParameters: []),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testString',
          namedParameters: [],
          path: '/testString',
          positionalParameters: []),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testString_',
          namedParameters: [],
          path: '/testString_',
          positionalParameters: []),
      TesterMethod(
          authorize: false,
          method: 'POST',
          name: 'testVoid',
          namedParameters: [],
          path: '/void',
          positionalParameters: [])
    ];
  }
}
