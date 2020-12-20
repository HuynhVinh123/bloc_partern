import 'package:tpos_api_client/tpos_api_client.dart';

class PartnerInvoice {
  PartnerInvoice(
      {this.id,
      this.name,
      this.displayName,
      this.street,
      this.website,
      this.phone,
      this.mobile,
      this.fax,
      this.email,
      this.supplier,
      this.customer,
      this.isContact,
      this.isCompany,
      this.companyId,
      this.ref,
      this.comment,
      this.userId,
      this.active,
      this.employee,
      this.taxCode,
      this.parentId,
      this.purchaseCurrencyId,
      this.credit,
      this.debit,
      this.titleId,
      this.function,
      this.type,
      this.companyType,
      this.accountReceivableId,
      this.accountPayableId,
      this.stockCustomerId,
      this.stockSupplierId,
      this.barcode,
      this.overCredit,
      this.creditLimit,
      this.propertyProductPricelistId,
      this.zalo,
      this.facebook,
      this.facebookId,
      this.facebookASIds,
      this.image,
      this.imageUrl,
      this.lastUpdated,
      this.loyaltyPoints,
      this.partnerCategoryId,
      this.nameNoSign,
      this.propertyPaymentTermId,
      this.propertySupplierPaymentTermId,
      this.categoryId,
      this.dateCreated,
      this.depositAmount,
      this.status,
      this.statusText,
      this.zaloUserId,
      this.zaloUserName,
      this.city,
      this.district,
      this.ward});

  PartnerInvoice.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    displayName = json['DisplayName'];
    street = json['Street'];
    website = json['Website'];
    phone = json['Phone'];
    mobile = json['Mobile'];
    fax = json['Fax'];
    email = json['Email'];
    supplier = json['Supplier'];
    customer = json['Customer'];
    isContact = json['IsContact'];
    isCompany = json['IsCompany'];
    companyId = json['CompanyId'];
    ref = json['Ref'];
    comment = json['Comment'];
    userId = json['UserId'];
    active = json['Active'];
    employee = json['Employee'];
    taxCode = json['TaxCode'];
    parentId = json['ParentId'];
    purchaseCurrencyId = json['PurchaseCurrencyId'];
    credit = json['Credit'];
    debit = json['Debit'];
    titleId = json['TitleId'];
    function = json['Function'];
    type = json['Type'];
    companyType = json['CompanyType'];
    accountReceivableId = json['AccountReceivableId'];
    accountPayableId = json['AccountPayableId'];
    stockCustomerId = json['StockCustomerId'];
    stockSupplierId = json['StockSupplierId'];
    barcode = json['Barcode'];
    overCredit = json['OverCredit'];
    creditLimit = json['CreditLimit']?.toDouble();
    propertyProductPricelistId = json['PropertyProductPricelistId'];
    zalo = json['Zalo'];
    facebook = json['Facebook'];
    facebookId = json['FacebookId'];
    facebookASIds = json['FacebookASIds'];
    image = json['Image'];
    imageUrl = json['ImageUrl'];
    lastUpdated = json['LastUpdated'];
    loyaltyPoints = json['LoyaltyPoints'];
    partnerCategoryId = json['PartnerCategoryId'];
    nameNoSign = json['NameNoSign'];
    propertyPaymentTermId = json['PropertyPaymentTermId'];
    propertySupplierPaymentTermId = json['PropertySupplierPaymentTermId'];
    categoryId = json['CategoryId'];
    dateCreated = json['DateCreated'];
    depositAmount = json['DepositAmount'];
    status = json['Status'];
    statusText = json['StatusText'];
    zaloUserId = json['ZaloUserId'];
    zaloUserName = json['ZaloUserName'];
    city = json['City'] != null ? CityAddress.fromMap(json['City']) : null;
    district = json['District'] != null
        ? DistrictAddress.fromMap(json['District'])
        : null;
    ward = json['Ward'] != null ? WardAddress.fromMap(json['Ward']) : null;
  }

  int id;
  String name;
  String displayName;
  String street;
  String website;
  String phone;
  String mobile;
  String fax;
  String email;
  bool supplier;
  bool customer;
  bool isContact;
  bool isCompany;
  int companyId;
  String ref;
  String comment;
  int userId;
  bool active;
  bool employee;
  String taxCode;
  int parentId;
  int purchaseCurrencyId;
  int credit;
  int debit;
  int titleId;
  dynamic function;
  String type;
  String companyType;
  int accountReceivableId;
  int accountPayableId;
  int stockCustomerId;
  int stockSupplierId;
  String barcode;
  bool overCredit;
  double creditLimit;
  int propertyProductPricelistId;
  String zalo;
  String facebook;
  String facebookId;
  String facebookASIds;
  String image;
  String imageUrl;
  String lastUpdated;
  dynamic loyaltyPoints;
  int partnerCategoryId;
  String nameNoSign;
  int propertyPaymentTermId;
  int propertySupplierPaymentTermId;
  int categoryId;
  String dateCreated;
  double depositAmount;
  String status;
  String statusText;
  int zaloUserId;
  String zaloUserName;
  CityAddress city;
  DistrictAddress district;
  WardAddress ward;

  Map<String, dynamic> toJson({bool removeIfNull = true}) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Name'] = name;
    data['DisplayName'] = displayName;
    data['Street'] = street;
    data['Website'] = website;
    data['Phone'] = phone;
    data['Mobile'] = mobile;
    data['Fax'] = fax;
    data['Email'] = email;
    data['Supplier'] = supplier;
    data['Customer'] = customer;
    data['IsContact'] = isContact;
    data['IsCompany'] = isCompany;
    data['CompanyId'] = companyId;
    data['Ref'] = ref;
    data['Comment'] = comment;
    data['UserId'] = userId;
    data['Active'] = active;
    data['Employee'] = employee;
    data['TaxCode'] = taxCode;
    data['ParentId'] = parentId;
    data['PurchaseCurrencyId'] = purchaseCurrencyId;
    data['Credit'] = credit;
    data['Debit'] = debit;
    data['TitleId'] = titleId;
    data['Function'] = function;
    data['Type'] = type;
    data['CompanyType'] = companyType;
    data['AccountReceivableId'] = accountReceivableId;
    data['AccountPayableId'] = accountPayableId;
    data['StockCustomerId'] = stockCustomerId;
    data['StockSupplierId'] = stockSupplierId;
    data['Barcode'] = barcode;
    data['OverCredit'] = overCredit;
    data['CreditLimit'] = creditLimit;
    data['PropertyProductPricelistId'] = propertyProductPricelistId;
    data['Zalo'] = zalo;
    data['Facebook'] = facebook;
    data['FacebookId'] = facebookId;
    data['FacebookASIds'] = facebookASIds;
    data['Image'] = image;
    data['ImageUrl'] = imageUrl;
    data['LastUpdated'] = lastUpdated;
    data['LoyaltyPoints'] = loyaltyPoints;
    data['PartnerCategoryId'] = partnerCategoryId;
    data['NameNoSign'] = nameNoSign;
    data['PropertyPaymentTermId'] = propertyPaymentTermId;
    data['PropertySupplierPaymentTermId'] = propertySupplierPaymentTermId;
    data['CategoryId'] = categoryId;
    data['DateCreated'] = dateCreated;
    data['DepositAmount'] = depositAmount;
    data['Status'] = status;
    data['StatusText'] = statusText;
    data['ZaloUserId'] = zaloUserId;
    data['ZaloUserName'] = zaloUserName;
    if (city != null) {
      data['City'] = city.toJson();
    }
    if (district != null) {
      data['District'] = district.toJson();
    }
    if (ward != null) {
      data['Ward'] = ward.toJson();
    }
    if (removeIfNull == true) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
