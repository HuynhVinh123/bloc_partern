class SaleOnlineFacebookPostUpdateConfigRequest {
  SaleOnlineFacebookPostUpdateConfigRequest model;

  SaleOnlineFacebookPostUpdateConfigRequest({this.model});

  SaleOnlineFacebookPostUpdateConfigRequest.fromJson(
      Map<String, dynamic> json) {
    model = json['model'] != null
        ? SaleOnlineFacebookPostUpdateConfigRequest.fromJson(json['model'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    if (this.model != null) {
      data['model'] = this.model.toJson();
    }
    return data;
  }
}
