class PartnerFPO {
  PartnerFPO(
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
      this.discount,
      this.partnerCategoryId,
      this.nameNoSign,
      this.propertyPaymentTermId,
      this.propertySupplierPaymentTermId,
      this.categoryId,
      this.dateCreated,
      this.birthDay,
      this.depositAmount,
      this.status,
      this.statusText,
      this.statusStyle,
      this.zaloUserId,
      this.zaloUserName,
      this.city,
      this.district,
      this.ward});

  PartnerFPO.fromJson(Map<String, dynamic> json) {
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
    creditLimit = json['CreditLimit'];
    propertyProductPricelistId = json['PropertyProductPricelistId'];
    zalo = json['Zalo'];
    facebook = json['Facebook'];
    facebookId = json['FacebookId'];
    facebookASIds = json['FacebookASIds'];
    image = json['Image'];
    imageUrl = json['ImageUrl'];
    lastUpdated = json['LastUpdated'];
    loyaltyPoints = json['LoyaltyPoints'];
    discount = json['Discount'];
    partnerCategoryId = json['PartnerCategoryId'];
    nameNoSign = json['NameNoSign'];
    propertyPaymentTermId = json['PropertyPaymentTermId'];
    propertySupplierPaymentTermId = json['PropertySupplierPaymentTermId'];
    categoryId = json['CategoryId'];
    dateCreated = json['DateCreated'];
    birthDay = json['BirthDay'];
    depositAmount = json['DepositAmount'];
    status = json['Status'];
    statusText = json['StatusText'];
    statusStyle = json['StatusStyle'];
    zaloUserId = json['ZaloUserId'];
    zaloUserName = json['ZaloUserName'];
    city = json['City'];
    district = json['District'];
    ward = json['Ward'];
  }
  int id;
  String name;
  String displayName;
  String street;
  dynamic website;
  String phone;
  dynamic mobile;
  dynamic fax;
  dynamic email;
  bool supplier;
  bool customer;
  dynamic isContact;
  bool isCompany;
  dynamic companyId;
  String ref;
  dynamic comment;
  dynamic userId;
  bool active;
  bool employee;
  dynamic taxCode;
  dynamic parentId;
  dynamic purchaseCurrencyId;
  int credit;
  int debit;
  dynamic titleId;
  dynamic function;
  String type;
  String companyType;
  dynamic accountReceivableId;
  dynamic accountPayableId;
  dynamic stockCustomerId;
  dynamic stockSupplierId;
  dynamic barcode;
  bool overCredit;
  int creditLimit;
  dynamic propertyProductPricelistId;
  String zalo;
  String facebook;
  String facebookId;
  String facebookASIds;
  dynamic image;
  dynamic imageUrl;
  dynamic lastUpdated;
  dynamic loyaltyPoints;
  int discount;
  dynamic partnerCategoryId;
  String nameNoSign;
  dynamic propertyPaymentTermId;
  dynamic propertySupplierPaymentTermId;
  int categoryId;
  String dateCreated;
  dynamic birthDay;
  dynamic depositAmount;
  String status;
  String statusText;
  String statusStyle;
  dynamic zaloUserId;
  dynamic zaloUserName;
  dynamic city;
  dynamic district;
  dynamic ward;

  Map<String, dynamic> toJson() {
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
    data['Discount'] = discount;
    data['PartnerCategoryId'] = partnerCategoryId;
    data['NameNoSign'] = nameNoSign;
    data['PropertyPaymentTermId'] = propertyPaymentTermId;
    data['PropertySupplierPaymentTermId'] = propertySupplierPaymentTermId;
    data['CategoryId'] = categoryId;
    data['DateCreated'] = dateCreated;
    data['BirthDay'] = birthDay;
    data['DepositAmount'] = depositAmount;
    data['Status'] = status;
    data['StatusText'] = statusText;
    data['StatusStyle'] = statusStyle;
    data['ZaloUserId'] = zaloUserId;
    data['ZaloUserName'] = zaloUserName;
    data['City'] = city;
    data['District'] = district;
    data['Ward'] = ward;
    return data;
  }
}
