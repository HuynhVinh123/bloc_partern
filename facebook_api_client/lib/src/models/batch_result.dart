/// Kết quả trả về khi dùng hàm getLiveVideoBatch
class BatchResult {
  BatchResult({this.body, this.code});
  BatchResult.fromJson(Map<String, dynamic> json) {
    body = json["body"];
    code = json["code"];
  }
  String body;
  int code;
}
