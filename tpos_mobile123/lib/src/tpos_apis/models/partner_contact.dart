class PartnerContact {
  int id;
  String name;
  String displayName;
  String street;
  String website;
  String phone;
  String mobile;
  Null fax;
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
        ? new AccountPayable.fromJson(json['AccountPayable'])
        : null;
    accountReceivable = json['AccountReceivable'] != null
        ? new AccountPayable.fromJson(json['AccountReceivable'])
        : null;
    stockCustomer = json['StockCustomer'] != null
        ? new StockCustomer.fromJson(json['StockCustomer'])
        : null;
    stockSupplier = json['StockSupplier'] != null
        ? new StockCustomer.fromJson(json['StockSupplier'])
        : null;
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
    data['FacebookPSId'] = this.facebookPSId;
    data['Image'] = this.image;
    data['ImageUrl'] = this.imageUrl;
    data['LastUpdated'] = this.lastUpdated;
    data['LoyaltyPoints'] = this.loyaltyPoints;
    data['Discount'] = this.discount;
    data['AmountDiscount'] = this.amountDiscount;
    data['PartnerCategoryId'] = this.partnerCategoryId;
    data['PartnerCategoryName'] = this.partnerCategoryName;
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
    if (this.accountPayable != null) {
      data['AccountPayable'] = this.accountPayable.toJson();
    }
    if (this.accountReceivable != null) {
      data['AccountReceivable'] = this.accountReceivable.toJson();
    }
    if (this.stockCustomer != null) {
      data['StockCustomer'] = this.stockCustomer.toJson();
    }
    if (this.stockSupplier != null) {
      data['StockSupplier'] = this.stockSupplier.toJson();
    }
    return data;
  }
}

class AccountPayable {
  int id;
  String name;
  String code;
  int userTypeId;
  String userTypeName;
  bool active;
  Null note;
  int companyId;
  String companyName;
  Null currencyId;
  String internalType;
  String nameGet;
  bool reconcile;

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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Name'] = this.name;
    data['Code'] = this.code;
    data['UserTypeId'] = this.userTypeId;
    data['UserTypeName'] = this.userTypeName;
    data['Active'] = this.active;
    data['Note'] = this.note;
    data['CompanyId'] = this.companyId;
    data['CompanyName'] = this.companyName;
    data['CurrencyId'] = this.currencyId;
    data['InternalType'] = this.internalType;
    data['NameGet'] = this.nameGet;
    data['Reconcile'] = this.reconcile;
    return data;
  }
}

class StockCustomer {
  int id;
  String usage;
  bool scrapLocation;
  String name;
  String completeName;
  int parentLocationId;
  bool active;
  int parentLeft;
  Null companyId;
  String showUsage;
  String nameGet;

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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Usage'] = this.usage;
    data['ScrapLocation'] = this.scrapLocation;
    data['Name'] = this.name;
    data['CompleteName'] = this.completeName;
    data['ParentLocationId'] = this.parentLocationId;
    data['Active'] = this.active;
    data['ParentLeft'] = this.parentLeft;
    data['CompanyId'] = this.companyId;
    data['ShowUsage'] = this.showUsage;
    data['NameGet'] = this.nameGet;
    return data;
  }
}
