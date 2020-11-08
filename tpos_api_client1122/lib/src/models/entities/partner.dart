/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

import 'product/product_price_list.dart';

class Partner {
  Partner(
      {this.ref,
      this.image,
      this.imageUrl,
      this.taxCode,
      this.propertySupplierPaymentTermId,
      this.propertyPaymentTermId,
      this.barcode,
      this.id,
      this.name,
      this.displayName,
      this.street,
      this.website,
      this.phone,
      this.email,
      this.supplier,
      this.customer = false,
      this.isCompany = false,
      this.companyId,
      this.active,
      this.employee,
      this.credit,
      this.debit,
      this.type,
      this.companyType,
      this.overCredit,
      this.creditLimit,
      this.zalo,
      this.facebook,
      this.categoryNames,
      this.categoryId,
      this.dateCreated,
      this.status,
      this.statusText,
      this.city,
      this.district,
      this.ward,
      this.partnerCategories,
      this.fax,
      this.comment,
      this.facebookId,
      this.facebookASids,
      this.statusInt,
      this.propertyPaymentTerm,
      this.birthDay,
      this.statusStyle,
      this.tags});
  int id;
  String name;
  String displayName;
  String street;
  String website;
  String phone;
  String email;
  bool supplier;
  bool customer;
  bool isCompany;
  int companyId;
  bool active;
  bool employee;
  double credit;
  int debit;
  String type;
  String companyType;
  bool overCredit;
  int creditLimit;
  String zalo;
  String facebook;
  String categoryNames;
  int categoryId;
  DateTime dateCreated;
  DateTime birthDay;
  String status;
  String statusText;
  int propertyPaymentTermId;
  int propertySupplierPaymentTermId;
  String taxCode;
  String imageUrl;
  String image;
  String statusStyle;

  CityAddress city;
  DistrictAddress district;
  WardAddress ward;
  List<PartnerCategory> partnerCategories;
  List<Tag> tags;
  AccountPaymentTerm propertyPaymentTerm;
  AccountPaymentTerm propertySupplierPaymentTerm;
  ProductPrice propertyProductPricelist;

  String fax;
  String comment;
  String facebookId;
  String facebookASids;
  int statusInt;
  String barcode;
  String ref;

  /// Chiết khấu mặc định
  double discount;
  double amountDiscount;
  String get addressFull {
    String temp = "";
    temp = street ?? "";
    if (this.ward != null && this.ward.name != null) {
      if (temp.isNotEmpty)
        temp += ", ${ward.name}";
      else
        temp += ward.name;
    }

    if (this.district != null && this.district.name != null) {
      if (temp.isNotEmpty)
        temp += ", ${this.district.name}";
      else
        temp += district.name;
    }

    if (city != null && city.name != null) {
      if (temp.isNotEmpty)
        temp += ", ${city.name}";
      else
        temp += city.name;
    }

    return temp;
  }

  ///Địa chỉ có hợp lệ để giao hàng hay không?
  ///name, phone, street, city ,distric phải không được  trống
  bool get isAddressValidateToShip {
    if (name == null || name == "") return false;
    if (phone == null || phone == "") return false;
    if (street == null || street == "") return false;
    if (city == null || city.code == null) return false;
    if (district == null || district.code == null) return false;
    return true;
  }

  Partner.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap["Id"];
    name = jsonMap["Name"];
    displayName = jsonMap["DisplayName"];
    street = jsonMap["Street"];
    phone = jsonMap["Phone"];
    comment = jsonMap["Comment"];
    facebook = jsonMap["Facebook"];
    facebookId = jsonMap["FacebookId"];
    facebookASids = jsonMap["FacebookASIds"];
    email = jsonMap["Email"];
    fax = jsonMap["Fax"];
    zalo = jsonMap["Zalo"];
    website = jsonMap["Website"];
    //categoryNames = jsonMap["CategoryNames"];
    categoryId = jsonMap["CategoryId"];
    barcode = jsonMap["Barcode"];
    supplier = jsonMap["Supplier"];
    active = jsonMap["Active"];
    ref = jsonMap["Ref"];
    taxCode = jsonMap["TaxCode"];
    customer = jsonMap["Customer"];
    propertyPaymentTermId = jsonMap["PropertyPaymentTermId"];
    propertySupplierPaymentTermId = jsonMap["PropertySupplierPaymentTermId"];
    imageUrl = jsonMap["ImageUrl"];
    image = jsonMap["Image"];
    credit = (jsonMap["Credit"] ?? 0).toDouble();

    if (jsonMap["BirthDay"] != null) {
      birthDay = DateTime.parse(jsonMap['BirthDay']);
    }

    statusStyle = jsonMap["StatusStyle"];
    if (jsonMap["PropertyPaymentTerm"] != null) {
      propertyPaymentTerm =
          AccountPaymentTerm.fromJson(jsonMap["PropertyPaymentTerm"]);
    }

    if (jsonMap["PropertySupplierPaymentTerm"] != null) {
      propertySupplierPaymentTerm =
          AccountPaymentTerm.fromJson(jsonMap["PropertySupplierPaymentTerm"]);
    }

    status = jsonMap["Status"].toString();
    statusText = jsonMap["StatusText"];
    companyType = jsonMap["CompanyType"];

    if (jsonMap["City"] != null) {
      city = CityAddress.fromMap(jsonMap["City"]);
    }
    if (jsonMap["District"] != null) {
      district = DistrictAddress.fromMap(jsonMap["District"]);
    }
    if (jsonMap["Ward"] != null) {
      ward = WardAddress.fromMap(jsonMap["Ward"]);
    }
    if (jsonMap["Categories"] != null) {
      partnerCategories = (jsonMap["Categories"] as List).map((map) {
        return PartnerCategory.fromJson(map);
      }).toList();
    }
    if (jsonMap["Tags"] != null) {
      tags = (json.decode(jsonMap["Tags"]) as List)
          .map((value) => Tag.fromJson(value))
          .toList();
    }

    if (jsonMap['PropertyProductPricelist'] != null) {
      propertyProductPricelist = ProductPrice.fromJson(
        jsonMap['PropertyProductPricelist'],
      );
    }

    discount = jsonMap['Discount']?.toDouble();
    amountDiscount = jsonMap['AmountDiscount']?.toDouble();
  }

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final data = {
      "Id": id,
      "Name": name,
      "DisplayName": displayName,
      "Street": street,
      "Phone": phone,
      "Comment": comment,
      "Facebook": facebook,
      "FacebookId": facebookId,
      "FacebookASIds": facebookASids,
      "Email": email,
      "Fax": fax,
      "StatusText": statusText,
      "Status": status,
      "Zalo": zalo,
      "Website": website,
      "Barcode": barcode,
      "Supplier": supplier,
      "Customer": customer,
      "Active": active,
      "TaxCode": taxCode,
      "CompanyType": companyType,
      "Ref": ref,
      "PropertyPaymentTermId": propertyPaymentTermId,
      "PropertySupplierPaymentTermId": propertySupplierPaymentTermId,
      "ImageUrl": imageUrl,
      "Image": image,
      "Credit": credit,
      "PropertyPaymentTerm":
          propertyPaymentTerm != null ? propertyPaymentTerm.toJson() : null,
      "PropertySupplierPaymentTerm": this.propertySupplierPaymentTerm != null
          ? propertySupplierPaymentTerm.toJson()
          : null,
      "City": city != null ? city.toJson() : null,
      "District": district != null ? district.toJson() : null,
      "Ward": ward != null ? ward.toJson() : null,
      "CategoryId": categoryId,
      "StatusStyle": statusStyle,
      // "CategoryNames": this.categoryNames,
      "Categories": partnerCategories != null
          ? partnerCategories.map((map) {
              return map.toJson();
            }).toList()
          : null,
      "Tags":
          tags != null ? tags.map((value) => value.toJson()).toList() : null,

      "Discount": discount,
      "AmountDiscount": amountDiscount,
      "BirthDay": birthDay?.toIso8601String(),
    };

    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }

    return data;
  }
}
