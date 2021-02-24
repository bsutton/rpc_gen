class AddRequest {
  final int? arg1;

  final int? arg2;

  AddRequest({required this.arg1, required this.arg2});

  factory AddRequest.fromJson(Map json) {
    return AddRequest(arg1: json['arg1'] as int, arg2: json['arg2'] as int);
  }

  Map<String, dynamic> toJson() {
    return {'arg1': arg1, 'arg2': arg2};
  }
}

class AddResponse {
  final int? result;

  AddResponse({required this.result});

  factory AddResponse.fromJson(Map json) {
    return AddResponse(result: json['result'] as int);
  }

  Map<String, dynamic> toJson() {
    return {'result': result};
  }
}

class NotRequest {
  final bool? arg;

  NotRequest({required this.arg});

  factory NotRequest.fromJson(Map json) {
    return NotRequest(arg: json['arg'] as bool);
  }

  Map<String, dynamic> toJson() {
    return {'arg': arg};
  }
}

class NotResponse {
  final bool? result;

  NotResponse({required this.result});

  factory NotResponse.fromJson(Map json) {
    return NotResponse(result: json['result'] as bool);
  }

  Map<String, dynamic> toJson() {
    return {'result': result};
  }
}

class VoidRequest {
  final String? name;

  VoidRequest({required this.name});

  factory VoidRequest.fromJson(Map json) {
    return VoidRequest(name: json['name'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'name': name};
  }
}

class VoidResponse {
  final String? result;

  VoidResponse({required this.result});

  factory VoidResponse.fromJson(Map json) {
    return VoidResponse(result: json['result'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'result': result};
  }
}
