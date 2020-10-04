///*
// * *
// *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
// *  * Copyright (c) 2019 . All rights reserved.
// *  * Last modified 4/9/19 9:53 AM
// *
// */
//
//import 'dart:convert';
//
//import 'package:intl/intl.dart';
//import "package:test/test.dart";
//import 'package:tpos_mobile/sale_online/models/tpos/ProductTemplate.dart';
//import 'package:tpos_mobile/sale_online/models/tpos/tpos_models.dart';
//import 'package:tpos_mobile/sale_online/services/tpos_api_service.dart';
//
//import 'package:tpos_mobile/sale_online/models/tpos/productUOM.dart';
//import 'package:tpos_mobile/sale_online/models/tpos/product_category.dart';
//
//main() {
//  TposApiService tposApi = new TposApiService(
//      shopUrl: "https://tmtsofts.tpos.vn",
//      accessToken:
//          "QcjoU0jNbibVyAEYG1eNXe_to4oqxuouQ7qSo0x7HSJLwvv6TcakQ57YAiLrhW5Wk0M6OhvMjmnFLd2zPh9zFLejCFfofS4kyDGWMhCU7VlCukkJwiUWQB3CDsW4EBFi3M8jUBi-UBwLfxRIXyu-mLcGfi9dzVer3AyrtUKJD8mYX4VuzPaG2lIl8aQUW8UKatb2HoeyMXcL-tXpWBRgUJsKOp3rZ_zOR46vmv-mRFEeoZzEUravEbZGJfREICDAM1wffe5mIkVPRy-R3ASzKrQoXGgzcOVXSZ_ZUe9IPLhfbobycmY1uqjv5XuL6LKC16TvVsRL_njDgxk4TRjjP0GKpWSYoh5tdygx0Wqx1dJGzV9yNcL1NGh1tqXX0Lsurn1qYqmOFrPDb-yEJ7mBINEYWm2J_V5GvXt3CMMUMQNCdOdNLyZNl31eKHuZHxq2");
//
//  test("Test login", () async {
//    TposApiService sv = new TposApiService(
//        shopUrl: "https://tmtsofts.tpos.vn", accessToken: "");
//
//    var loginInfo = await sv.login(
//      username: "admin",
//      password: "123123",
//    );
//    expect(
//      loginInfo,
//      isNotNull,
//    );
//
//    expect(
//      loginInfo.accessToken,
//      isNotNull,
//    );
//
//    print(loginInfo.accessToken);
//  });
//
//  test("Test DateTimeForamt", () {
//    // DateTime d = DateTime.now();
//    // DateTime tmt = TmtDateTime.parse ("2019-04-19T16:53:40.037+07:00");
//    DateTime tmt2 = DateFormat("yyyy-MM-ddTHH:mm:ss.SSS")
//        .parse("2019-04-19T16:53:40.037+07:00");
//    // print("tmtTime: ${tmt.toString()}");
//    // print("tmtTimeUtc: ${tmt.toUtc()}");
//    // print("tmtTimeLocal: ${tmt.toLocal()}");
//
//    print("tmt2Time: ${tmt2.toString()}");
//    print("tmt2TimeUtc: ${tmt2.toUtc()}");
//    print("tmt2TimeLocal: ${tmt2.toLocal()}");
//    print(
//        "tmt2String: ${DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSS'").add_j().format(tmt2)}");
//
//    // print("tmtTimeJson: ${DateFormat("yyy-MM-ddTHH:mm:ss.SSS", "vi_VN").format(tmt)}");
//
//    // print (a);
//  });
//
//  test("Test setLoginAuthentiacation", () async {
//    TposApiService sv = new TposApiService(
//        shopUrl: "https://tmtsofts.tpos.vn", accessToken: "");
//
//    var loginInfo = await sv.setAuthentiacation(
//      shopUrl: "https://tmt20.tpos.vn",
//      username: "admin",
//      password: "123123",
//    );
//
//    expect(
//      loginInfo,
//      isNotNull,
//    );
//
//    print(loginInfo.accessToken);
//  });
//
//  test(
//      "Test getSavedFacebookAccount (Tài khoản facebook được lưu trữ trên máy chủ)",
//      () async {
//    TposApiService sv = new TposApiService(
//        shopUrl: "https://tmtsofts.tpos.vn",
//        accessToken:
//            "47jvlb8f4SgQGTBWCn7GlqGqcRR6t-pVeem6Nr2n3Z5zUgnt5WVYOXud9CE58x6Nyzca_DNxid4emEToYFPrqUBG4ebehIuD7-xSuNAIAkTxc_Oot4wInmRBz4DFGZQ0WIVRaxwHVPe2AtJro5LTF8XR2EjubLs9q-7R8frUmc3JppxiK0oMcXM7de-AnV-eup-L3K-ff_aJhhDmNiBfXB44zSZ63sZzEG4rfMP5LV3SS3YbMI6o8GcvBg1sPyU7ZtxeQxR7zyPTgrwEGkALcb5EEM5deWdVdEhyWdCAhUVWzq3-p8zt92IZNZRl79o33TrjwQeWDqbJVZ7wsoK9fTqXqyORKO1DUYVNBrziduaB83BIYqk9xDld5Uy1pSxeSD2_oJi7B3XIIXhEZc5YJMJLroKNd8y-0wAvTxbs8oHhNVvA0HIU0aq7FC9G7MWP");
//    var savedFacebookUsers = await sv.getLogginedFacebookAccount();
//    expect(
//      savedFacebookUsers,
//      isNotNull,
//    );
//  });
//
//  test("Test getFacebookPartnersdfdfdf", () async {
//    TposApiService sv = new TposApiService(
//        shopUrl: "https://tmtsofts.tpos.vn",
//        accessToken:
//            "ULFQBbmsi7TOAscFJO4T8Q5wW1cIm5M6inzeDowPzuqKZBY9tW8rwkRdHVnSvsoqMv9Wo6TvW5xzgPoTSr90eaw9g9W4S6N2AOWE4KJ8XvQFGKn_tXf7u-801sl4VTaX20F-uX-Zna9b_ZFteTcPsfNf-Ir1bKMWe_FdmJaQKHcnIt98Nq7CDZbqz6vIbBxRKWZSDdUy2Vy1eH4-X_kmVhkkKpHlsk1CgkBvNtUTTK5xeTqrqXZWPNmlXJlXVw7GQ-YJyt8y_fe91ynjTcI0CjXhbvVasBNG7gTaNKdDwja7Cxd8dGEWyC-2bG-LxjrX0tZ-Y5oxTwIFTAK_94MGa6rzDYKa00tqI7TISLqqFDhGNQE00QGGIYyBpLVVo5zq0KidDtX3kl4rKdgrlQ-0VimMb9iTJOMUQnjc2FV198DX9U_YwWS7QVn5ui4L3vwY");
//
//    var result = await sv.getFacebookPartners();
//    expect(
//      result,
//      isNotNull,
//    );
//  });
//
//  test("Test checkFacebookId", () async {
//    TposApiService sv = new TposApiService(
//        shopUrl: "https://tmtsofts.tpos.vn",
//        accessToken:
//            "47jvlb8f4SgQGTBWCn7GlqGqcRR6t-pVeem6Nr2n3Z5zUgnt5WVYOXud9CE58x6Nyzca_DNxid4emEToYFPrqUBG4ebehIuD7-xSuNAIAkTxc_Oot4wInmRBz4DFGZQ0WIVRaxwHVPe2AtJro5LTF8XR2EjubLs9q-7R8frUmc3JppxiK0oMcXM7de-AnV-eup-L3K-ff_aJhhDmNiBfXB44zSZ63sZzEG4rfMP5LV3SS3YbMI6o8GcvBg1sPyU7ZtxeQxR7zyPTgrwEGkALcb5EEM5deWdVdEhyWdCAhUVWzq3-p8zt92IZNZRl79o33TrjwQeWDqbJVZ7wsoK9fTqXqyORKO1DUYVNBrziduaB83BIYqk9xDld5Uy1pSxeSD2_oJi7B3XIIXhEZc5YJMJLroKNd8y-0wAvTxbs8oHhNVvA0HIU0aq7FC9G7MWP");
//    var result = await sv.checkFacebookId(
//        "1026330714235418", "2102043623392489_2160063214257196");
//
//    expect(
//      result,
//      isNotNull,
//    );
//  });
//
//  test("Test insertSaleOnlineOrderFromApp", () async {
//    SaleOnlineOrder order = new SaleOnlineOrder();
//    order.facebookPostId = "1766726416685248_1768342966523593";
//    order.facebookUserId = "100004024095705";
//    order.facebookAsuid = "1257485461062245";
//    order.facebookUserName = "Quỳnh chi";
//    order.facebookCommentId = "1768342966523593_1770009666356923";
//    order.name = "Quỳnh chi";
//    order.note = "Test note";
//    order.totalAmount = 15000;
//    order.partnerId = 30039;
//    order.partnerName = "Hồ kính";
//
//    var result = await tposApi.insertSaleOnlineOrderFromApp(order);
//    expect(
//      result,
//      isNotNull,
//    );
//  });
//
//  test("Test ConvertObjectToJson", () {
//    List<String> ids = <String>["string 1", "string 2"];
//    Map<String, dynamic> jsonMap = {
//      "model": {
//        "fromId": "123123123",
//        "PostIds": ids,
//      }
//    };
//
//    print(jsonEncode(jsonMap));
//  });
//
//  test("Test Convert DateTime", () {
//    var d = DateTime.now();
//    print(d.toIso8601String() + "+07:00");
//    print(d.toUtc());
//    print(d.toString());
//    print(d.toLocal());
//  });
//
//  test("Test Get Product Category", () async {
//    var ids = ["318b292f-f0dc-e811-8c01-14dda9ee59dd"];
//    TposApiService sv = new TposApiService(
//        shopUrl: "https://tmtsofts.tpos.vn",
//        accessToken:
//            "k3fWLsMcp_2vLEGfXzYzOsmdw_JxsrH66CRhcjRuBmLkCVWgrK-h1wvYD5l4ybPi5TQANDxlZSOpjjZyKFP52FxBBaQmYrPANoeL1y2RkOgPF9JUn7K9hwnamfe8h2OQCu35FfqBEj5F7nfjwept27p3D_zuS2ixBZhnW4MKcZB_VPDvommdbH0UMxHitQxArJYfn86J8UmE15Rcczrs0fMvQCLdW9KQ9q_otIFgsJjycseKZPQfLVI8DJKgcZhSu9DFe60kArM_V1L1UrebVqjDUqCY0pbKYht50oqD7uz730C-PGO8nZdSh5nqefQCy_6kL2yo52kzCuvSoeiIMnuP_aUgK0FTWsS8otpDOacCkcAMcZ0KJcNGe_pgYvpzDxPKT8NaL-I_5FMc8kfv7dDl7BJMYFqdG4lQvgDxEZ882MwCxOw2Mz7u2hUMGJm6");
//    var result = await sv.prepareFastSaleOrder(ids);
//    print(result.toString());
//    expect(1, equals(1));
//  });
//
//  test("Test product", () async {
//    TposApiService tPos = new TposApiService(
//        shopUrl: "https://tmtsofts.tpos.vn",
//        accessToken:
//            "c_gjUPTOAPfv0y4D3mdzSdeIJPB1PPe4x-Y2qrbv3HgY12L_ETAYKGgA-INqVVxduiZpQYLK3XYt6g3zE6BZ3ezi8ADeCYXqkexC-tvIiY9UbTID50iRB-5e5vqy4tZSOTkssvPycUKVM7TOikfhDRHqrZKJpUlh07cMqp2auYcp0sTTIq5oHnkOdVAR3zozZ8vesBTSiU8eEkIlZ1kFGn_FvCNKgC1naJQEH4jXmonwH9hNDFJa81dMCBrHYWObFeudU5421MzKetXfzjI4CTTD39EswA-FqclARTJiOXH14wDprdPFzRhLk-g5f2JjjEFhSu4rZKZsXAmoJk_6SvCLpnM0Ug6girgdNy4d3WlqGM8L8aBlK2GGovqZJRmkT3YH0nmiQsouLncSFrKl45YAhC7lPLnH75tpKlcFgF2z4_oJB2x2xavZa-idBCAa");
//    ProductTemplate product = new ProductTemplate();
//    product.name = "Test sản phẩm tt3";
//    product.weight = 1;
//    product.type = "Type";
//    product.showType = "Có thể lưu trữ";
//    product.listPrice = 1;
//    product.discountSale = 1;
//    product.discountPurchase = 1;
//    product.purchasePrice = 0;
//    product.standardPrice = 0;
//    product.saleOK = true;
//    product.purchaseOK = true;
//    product.active = true;
//    product.uOMId = 1;
//    product.uOMPOId = 1;
//    product.isProductVariant = false;
//    product.qtyAvailable = 0;
//    product.virtualAvailable = 0;
//    product.outgoingQty = 0;
//    product.incomingQty = 0;
//    product.categId = 1;
//    product.companyId = 1;
//    product.saleDelay = 0;
//    product.invoicePolicy = "order";
//    product.purchaseMethod = "receive";
//    product.availableInPOS = true;
//    product.productVariantCount = 0;
//    product.bOMCount = 0;
//    product.isCombo = false;
//    product.enableAll = true;
//    product.version = 513;
//    product.variantFistId = 0;
//    product.uOM = new ProductUOM(
//      id: 1,
//      name: "Cái",
//      nameNoSign: "Cai",
//      rounding: 0.01,
//      active: true,
//      factor: 1,
//      factorInv: 1,
//      uOMType: "reference",
//      categoryId: 1,
//      categoryName: "Đơn vị",
//      showUOMType: "Đơn vị gốc của nhóm này",
//      nameGet: "Cái",
//      showFactor: 1,
//    );
//    product.uOMPO = new ProductUOM(
//      id: 1,
//      name: "Cái",
//      nameNoSign: "Cai",
//      rounding: 0.01,
//      active: true,
//      factor: 1,
//      factorInv: 1,
//      uOMType: "reference",
//      categoryId: 1,
//      categoryName: "Đơn vị",
//      showUOMType: "Đơn vị gốc của nhóm này",
//      nameGet: "Cái",
//      showFactor: 1,
//    );
//
//    product.categ = new ProductCategory(
//      id: 10072,
//      name: "Điện Thoại",
//      completeName: "Điện Thoại",
//      parentLeft: 360,
//      parentRight: 361,
//      sequence: 1,
//      type: "normal",
//      propertyCostMethod: "average",
//      nameNoSign: "Dien Thoai",
//      isPos: true,
//    );
//
//    var result = await tPos.quickInsertProductTemplate(product);
//    expect(
//      result,
//      isNotNull,
//    );
//  });
//
//  test("QuickInsertProductTempalte", () async {
//    var map = {
//      "Name": "Sản phẩm mới 02",
//      "NameNoSign": null,
//      "Description": null,
//      "Type": "product",
//      "ShowType": "Có thể lưu trữ",
//      "ListPrice": 1999999,
//      "DiscountSale": 0,
//      "DiscountPurchase": 0,
//      "PurchasePrice": 0,
//      "StandardPrice": 0,
//      "SaleOK": true,
//      "PurchaseOK": true,
//      "Active": true,
//      "UOMId": 1,
//      "UOMName": null,
//      "UOMPOId": 1,
//      "UOMPOName": null,
//      "UOSId": null,
//      "IsProductVariant": false,
//      "EAN13": null,
//      "DefaultCode": "SPM02",
//      "QtyAvailable": 0,
//      "VirtualAvailable": 0,
//      "OutgoingQty": 0,
//      "IncomingQty": 0,
//      "PropertyCostMethod": null,
//      "CategId": 1,
//      "CategCompleteName": null,
//      "CategName": null,
//      "Weight": 1,
//      "Tracking": "none",
//      "DescriptionPurchase": null,
//      "DescriptionSale": null,
//      "CompanyId": 1,
//      "NameGet": null,
//      "PropertyStockProductionId": null,
//      "SaleDelay": 0,
//      "InvoicePolicy": "order",
//      "PurchaseMethod": "receive",
//      "PropertyValuation": null,
//      "Valuation": null,
//      "AvailableInPOS": true,
//      "POSCategId": null,
//      "CostMethod": null,
//      "Barcode": "SPM01",
//      "Image": null,
//      "ImageUrl": null,
//      "ProductVariantCount": 0,
//      "LastUpdated": null,
//      "UOMCategId": null,
//      "BOMCount": 0,
//      "Volume": null,
//      "CategNameNoSign": null,
//      "UOMNameNoSign": null,
//      "UOMPONameNoSign": null,
//      "IsCombo": false,
//      "EnableAll": true,
//      "ComboPurchased": null,
//      "Version": 525,
//      "VariantFistId": 0,
//      "ZaloProductId": null,
//      "CompanyName": null,
//      "CompanyNameNoSign": null,
//      "UOM": {
//        "Id": 1,
//        "Name": "Cái",
//        "NameNoSign": "Cai",
//        "Rounding": 0.01,
//        "Active": true,
//        "Factor": 1,
//        "FactorInv": 1,
//        "UOMType": "reference",
//        "CategoryId": 1,
//        "CategoryName": "Đơn vị",
//        "Description": null,
//        "ShowUOMType": "Đơn vị gốc của nhóm này",
//        "NameGet": "Cái",
//        "ShowFactor": 1
//      },
//      "Categ": {
//        "Id": 1,
//        "Name": "Tất cả",
//        "CompleteName": "Tất cả",
//        "ParentId": null,
//        "ParentCompleteName": null,
//        "ParentLeft": 302,
//        "ParentRight": 303,
//        "Sequence": null,
//        "Type": "normal",
//        "AccountIncomeCategId": null,
//        "AccountExpenseCategId": null,
//        "StockJournalId": null,
//        "StockAccountInputCategId": null,
//        "StockAccountOutputCategId": null,
//        "StockValuationAccountId": null,
//        "PropertyValuation": null,
//        "PropertyCostMethod": "average",
//        "NameNoSign": null,
//        "IsPos": true,
//        "Version": null
//      },
//      "UOMPO": {
//        "Id": 1,
//        "Name": "Cái",
//        "NameNoSign": "Cai",
//        "Rounding": 0.01,
//        "Active": true,
//        "Factor": 1,
//        "FactorInv": 1,
//        "UOMType": "reference",
//        "CategoryId": 1,
//        "CategoryName": "Đơn vị",
//        "Description": null,
//        "ShowUOMType": "Đơn vị gốc của nhóm này",
//        "NameGet": "Cái",
//        "ShowFactor": 1
//      },
//      "AttributeLines": [],
//      "Items": [],
//      "UOMLines": [],
//      "ComboProducts": [],
//      "ProductSupplierInfos": []
//    };
//
//    try {
//      ProductTemplate insertProduct = ProductTemplate.fromJson(map);
//      TposApiService tPos = new TposApiService(
//          shopUrl: "https://tmtsofts.tpos.vn",
//          accessToken:
//              "c_gjUPTOAPfv0y4D3mdzSdeIJPB1PPe4x-Y2qrbv3HgY12L_ETAYKGgA-INqVVxduiZpQYLK3XYt6g3zE6BZ3ezi8ADeCYXqkexC-tvIiY9UbTID50iRB-5e5vqy4tZSOTkssvPycUKVM7TOikfhDRHqrZKJpUlh07cMqp2auYcp0sTTIq5oHnkOdVAR3zozZ8vesBTSiU8eEkIlZ1kFGn_FvCNKgC1naJQEH4jXmonwH9hNDFJa81dMCBrHYWObFeudU5421MzKetXfzjI4CTTD39EswA-FqclARTJiOXH14wDprdPFzRhLk-g5f2JjjEFhSu4rZKZsXAmoJk_6SvCLpnM0Ug6girgdNy4d3WlqGM8L8aBlK2GGovqZJRmkT3YH0nmiQsouLncSFrKl45YAhC7lPLnH75tpKlcFgF2z4_oJB2x2xavZa-idBCAa");
//      var result = await tPos.quickInsertProductTemplate(insertProduct);
//      expect(result, isNotNull);
//    } catch (e, s) {
//      print(s);
//    }
//  });
//
//  test("prepareFastSaleOrderInfoFromOrder", () async {
//    var result = await tposApi
//        .prepareFastSaleOrder(["9c3cf84c-4558-e911-b802-00155dd69a40"]);
//
//    expect(result, isNotNull);
//  });
//}
