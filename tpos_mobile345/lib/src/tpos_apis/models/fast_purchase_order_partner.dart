class PartnerFPO {
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Name'] = this.name;
    data['DisplayName'] = this.displayName;
    data['Street'] = this.street;
    data['Website'] = this.website;
    data['Phone'] = this.phone;
    data['Mobile'] = this.mobile;
    data['Fax'] = this.fax;
    data['Email'] = this.email;
    data['Supplier'] = this.supplier;
    data['Customer'] = this.customer;
    data['IsContact'] = this.isContact;
    data['IsCompany'] = this.isCompany;
    data['CompanyId'] = this.companyId;
    data['Ref'] = this.ref;
    data['Comment'] = this.comment;
    data['UserId'] = this.userId;
    data['Active'] = this.active;
    data['Employee'] = this.employee;
    data['TaxCode'] = this.taxCode;
    data['ParentId'] = this.parentId;
    data['PurchaseCurrencyId'] = this.purchaseCurrencyId;
    data['Credit'] = this.credit;
    data['Debit'] = this.debit;
    data['TitleId'] = this.titleId;
    data['Function'] = this.function;
    data['Type'] = this.type;
    data['CompanyType'] = this.companyType;
    data['AccountReceivableId'] = this.accountReceivableId;
    data['AccountPayableId'] = this.accountPayableId;
    data['StockCustomerId'] = this.stockCustomerId;
    data['StockSupplierId'] = this.stockSupplierId;
    data['Barcode'] = this.barcode;
    data['OverCredit'] = this.overCredit;
    data['CreditLimit'] = this.creditLimit;
    data['PropertyProductPricelistId'] = this.propertyProductPricelistId;
    data['Zalo'] = this.zalo;
    data['Facebook'] = this.facebook;
    data['FacebookId'] = this.facebookId;
    data['FacebookASIds'] = this.facebookASIds;
    data['Image'] = this.image;
    data['ImageUrl'] = this.imageUrl;
    data['LastUpdated'] = this.lastUpdated;
    data['LoyaltyPoints'] = this.loyaltyPoints;
    data['Discount'] = this.discount;
    data['PartnerCategoryId'] = this.partnerCategoryId;
    data['NameNoSign'] = this.nameNoSign;
    data['PropertyPaymentTermId'] = this.propertyPaymentTermId;
    data['PropertySupplierPaymentTermId'] = this.propertySupplierPaymentTermId;
    data['CategoryId'] = this.categoryId;
    data['DateCreated'] = this.dateCreated;
    data['BirthDay'] = this.birthDay;
    data['DepositAmount'] = this.depositAmount;
    data['Status'] = this.status;
    data['StatusText'] = this.statusText;
    data['StatusStyle'] = this.statusStyle;
    data['ZaloUserId'] = this.zaloUserId;
    data['ZaloUserName'] = this.zaloUserName;
    data['City'] = this.city;
    data['District'] = this.district;
    data['Ward'] = this.ward;
    return data;
  }
}
