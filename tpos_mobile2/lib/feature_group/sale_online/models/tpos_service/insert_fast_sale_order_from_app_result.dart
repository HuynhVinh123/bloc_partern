/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

class InsertFastSaleOrderFromAppResult {
  InsertFastSaleOrderFromAppResult(
      {this.success, this.warning, this.error, this.orderId});

  InsertFastSaleOrderFromAppResult.fromJson(Map jsonmap) {
    success = jsonmap["Success"];
    warning = jsonmap["Warning"];
    error = jsonmap["Error"];
    orderId = jsonmap["OrderId"];
  }
  String success;
  String warning;
  String error;
  int orderId;
}
