class BatchResult {
  String body;
  int code;

  BatchResult({this.body, this.code});

  BatchResult.fromJson(Map<String, dynamic> json) {
    body = json["body"];
    code = json["code"];
  }
}
