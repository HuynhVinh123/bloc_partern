class PartnerContact {
  PartnerContact(
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
      this.facebookPSId,
      this.image,
      this.imageUrl,
      this.lastUpdated,
      this.loyaltyPoints,
      this.discount,
      this.amountDiscount,
      this.partnerCategoryId,
      this.partnerCategoryName,
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
      this.ward,
      this.accountPayable,
      this.accountReceivable,
      this.stockCustomer,
      this.stockSupplier});

  PartnerContact.fromJson(Map<String, dynamic> json) {
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
    facebookPSId = json['FacebookPSId'];
    image = json['Image'];
    imageUrl = json['ImageUrl'];
    lastUpdated = json['LastUpdated'];
    loyaltyPoints = json['LoyaltyPoints'];
    discount = json['Discount'];
    amountDiscount = json['AmountDiscount'];
    partnerCategoryId = json['PartnerCategoryId'];
    partnerCategoryName = json['PartnerCategoryName'];
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
    accountPayable = json['AccountPayable'] != null
        ? AccountPayable.fromJson(json['AccountPayable'])
        : null;
    accountReceivable = json['AccountReceivable'] != null
        ? AccountPayable.fromJson(json['AccountReceivable'])
        : null;
    stockCustomer = json['StockCustomer'] != null
        ? StockCustomer.fromJson(json['StockCustomer'])
        : null;
    stockSupplier = json['StockSupplier'] != null
        ? StockCustomer.fromJson(json['StockSupplier'])
        : null;
  }

  int id;
  String name;
  String displayName;
  String street;
  String website;
  String phone;
  String mobile;
  dynamic fax;
  String email;
  bool supplier;
  bool customer;
  bool isContact;
  bool isCompany;
  int companyId;
  String ref;
  String comment;
  String userId;
  bool active;
  bool employee;
  String taxCode;
  String parentId;
  String purchaseCurrencyId;
  int credit;
  int debit;
  String titleId;
  String function;
  String type;
  String companyType;
  String accountReceivableId;
  String accountPayableId;
  String stockCustomerId;
  String stockSupplierId;
  String barcode;
  bool overCredit;
  int creditLimit;
  String propertyProductPricelistId;
  String zalo;
  String facebook;
  String facebookId;
  String facebookASIds;
  String facebookPSId;
  String image;
  String imageUrl;
  String lastUpdated;
  String loyaltyPoints;
  int discount;
  int amountDiscount;
  String partnerCategoryId;
  String partnerCategoryName;
  String nameNoSign;
  String propertyPaymentTermId;
  String propertySupplierPaymentTermId;
  int categoryId;
  String dateCreated;
  String birthDay;
  String depositAmount;
  String status;
  String statusText;
  String statusStyle;
  String zaloUserId;
  String zaloUserName;
  String city;
  String district;
  String ward;
  AccountPayable accountPayable;
  AccountPayable accountReceivable;
  StockCustomer stockCustomer;
  StockCustomer stockSupplier;

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
    data['FacebookPSId'] = facebookPSId;
    data['Image'] = image;
    data['ImageUrl'] = imageUrl;
    data['LastUpdated'] = lastUpdated;
    data['LoyaltyPoints'] = loyaltyPoints;
    data['Discount'] = discount;
    data['AmountDiscount'] = amountDiscount;
    data['PartnerCategoryId'] = partnerCategoryId;
    data['PartnerCategoryName'] = partnerCategoryName;
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
    if (accountPayable != null) {
      data['AccountPayable'] = accountPayable.toJson();
    }
    if (accountReceivable != null) {
      data['AccountReceivable'] = accountReceivable.toJson();
    }
    if (stockCustomer != null) {
      data['StockCustomer'] = stockCustomer.toJson();
    }
    if (stockSupplier != null) {
      data['StockSupplier'] = stockSupplier.toJson();
    }
    return data;
  }
}

class AccountPayable {
  AccountPayable(
      {this.id,
      this.name,
      this.code,
      this.userTypeId,
      this.userTypeName,
      this.active,
      this.note,
      this.companyId,
      this.companyName,
      this.currencyId,
      this.internalType,
      this.nameGet,
      this.reconcile});

  AccountPayable.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    code = json['Code'];
    userTypeId = json['UserTypeId'];
    userTypeName = json['UserTypeName'];
    active = json['Active'];
    note = json['Note'];
    companyId = json['CompanyId'];
    companyName = json['CompanyName'];
    currencyId = json['CurrencyId'];
    internalType = json['InternalType'];
    nameGet = json['NameGet'];
    reconcile = json['Reconcile'];
  }

  int id;
  String name;
  String code;
  int userTypeId;
  String userTypeName;
  bool active;
  dynamic note;
  int companyId;
  String companyName;
  dynamic currencyId;
  String internalType;
  String nameGet;
  bool reconcile;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Name'] = name;
    data['Code'] = code;
    data['UserTypeId'] = userTypeId;
    data['UserTypeName'] = userTypeName;
    data['Active'] = active;
    data['Note'] = note;
    data['CompanyId'] = companyId;
    data['CompanyName'] = companyName;
    data['CurrencyId'] = currencyId;
    data['InternalType'] = internalType;
    data['NameGet'] = nameGet;
    data['Reconcile'] = reconcile;
    return data;
  }
}

class StockCustomer {
  StockCustomer(
      {this.id,
      this.usage,
      this.scrapLocation,
      this.name,
      this.completeName,
      this.parentLocationId,
      this.active,
      this.parentLeft,
      this.companyId,
      this.showUsage,
      this.nameGet});

  StockCustomer.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    usage = json['Usage'];
    scrapLocation = json['ScrapLocation'];
    name = json['Name'];
    completeName = json['CompleteName'];
    parentLocationId = json['ParentLocationId'];
    active = json['Active'];
    parentLeft = json['ParentLeft'];
    companyId = json['CompanyId'];
    showUsage = json['ShowUsage'];
    nameGet = json['NameGet'];
  }
  int id;
  String usage;
  bool scrapLocation;
  String name;
  String completeName;
  int parentLocationId;
  bool active;
  int parentLeft;
  dynamic companyId;
  String showUsage;
  String nameGet;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Usage'] = usage;
    data['ScrapLocation'] = scrapLocation;
    data['Name'] = name;
    data['CompleteName'] = completeName;
    data['ParentLocationId'] = parentLocationId;
    data['Active'] = active;
    data['ParentLeft'] = parentLeft;
    data['CompanyId'] = companyId;
    data['ShowUsage'] = showUsage;
    data['NameGet'] = nameGet;
    return data;
  }
}
