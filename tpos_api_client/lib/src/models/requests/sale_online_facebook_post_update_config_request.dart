class SaleOnlineFacebookPostUpdateConfigRequest {
  SaleOnlineFacebookPostUpdateConfigRequest({this.model});
  SaleOnlineFacebookPostUpdateConfigRequest.fromJson(
      Map<String, dynamic> json) {
    model = json['model'] != null
        ? SaleOnlineFacebookPostUpdateConfigRequest.fromJson(json['model'])
        : null;
  }
  SaleOnlineFacebookPostUpdateConfigRequest model;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (model != null) {
      data['model'] = model.toJson();
    }
    return data;
  }
}
