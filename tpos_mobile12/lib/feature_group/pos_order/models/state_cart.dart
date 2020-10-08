class StateCart {
  StateCart({this.position, this.check, this.time, this.loginNumber});

  StateCart.fromJson(Map<String, dynamic> json) {
    position = json['tb_cart_position'];
    check = json['tb_cart_check'];
    time = json['Time'];
    loginNumber = json['LoginNumber'];
  }

  String position;
  int check;
  String time;
  int loginNumber;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tb_cart_position'] = position;
    data['tb_cart_check'] = check;
    data['Time'] = time;
    data['LoginNumber'] = loginNumber;
    return data;
  }
}
