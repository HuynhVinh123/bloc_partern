class SaleOnlineFacebookPostUpdateConfigRequest {
  SaleOnlineFacebookPostUpdateConfigRequest model;

  SaleOnlineFacebookPostUpdateConfigRequest({this.model});

  SaleOnlineFacebookPostUpdateConfigRequest.fromJson(
      Map<String, dynamic> json) {
    model = json['model'] != null
        ? new SaleOnlineFacebookPostUpdateConfigRequest.fromJson(json['model'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.model != null) {
      data['model'] = this.model.toJson();
    }
    return data;
  }
}
