class SimpleRequest {
  final Uri url;

  final dynamic body;

  SimpleRequest({this.body, required this.url});

  final Map<String, String> headers = {};
}
