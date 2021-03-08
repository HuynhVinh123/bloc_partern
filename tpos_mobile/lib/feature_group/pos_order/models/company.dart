class Companies {
  Companies(
      {this.id,
      this.name,
      this.sender,
      this.moreInfo,
      this.partnerId,
      this.email,
      this.phone,
      this.currencyId,
      this.fax,
      this.street,
      this.currencyExchangeJournalId,
      this.incomeCurrencyExchangeAccountId,
      this.expenseCurrencyExchangeAccountId,
      this.securityLead,
      this.logo,
      this.lastUpdated,
      this.transferAccountId,
      this.saleNote,
      this.taxCode,
      this.warehouseId,
      this.sOFromPO,
      this.pOFromSO,
      this.autoValidation,
      this.customer,
      this.supplier,
      this.active,
      this.periodLockDate,
      this.quatityDecimal,
      this.extRegexPhone,
      this.imageUrl,
      this.city,
      this.district,
      this.ward});

  Companies.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    sender = json['Sender'];
    moreInfo = json['MoreInfo'];
    partnerId = json['PartnerId'];
    email = json['Email'];
    phone = json['Phone'];
    currencyId = json['CurrencyId'];
    fax = json['Fax'];
    street = json['Street'];
    currencyExchangeJournalId = json['CurrencyExchangeJournalId'];
    incomeCurrencyExchangeAccountId = json['IncomeCurrencyExchangeAccountId'];
    expenseCurrencyExchangeAccountId = json['ExpenseCurrencyExchangeAccountId'];
    securityLead = json['SecurityLead'];
    logo = json['Logo'];
    lastUpdated = json['LastUpdated'];
    transferAccountId = json['TransferAccountId'];
    saleNote = json['SaleNote'];
    taxCode = json['TaxCode'];
    warehouseId = json['WarehouseId'];
    sOFromPO = json['SOFromPO'];
    pOFromSO = json['POFromSO'];
    autoValidation = json['AutoValidation'];
    customer = json['Customer'];
    supplier = json['Supplier'];
    active = json['Active'];
    periodLockDate = json['PeriodLockDate'];
    quatityDecimal = json['QuatityDecimal']?.toDouble();
    extRegexPhone = json['ExtRegexPhone'];
    imageUrl = json['ImageUrl'];
    city = json['City'];
    district = json['District'];
    ward = json['Ward'];
  }

  int id;
  String name;
  String sender;
  String moreInfo;
  int partnerId;
  String email;
  String phone;
  int currencyId;
  dynamic fax;
  String street;
  String currencyExchangeJournalId;
  String incomeCurrencyExchangeAccountId;
  String expenseCurrencyExchangeAccountId;
  String securityLead;
  dynamic logo;
  String lastUpdated;
  int transferAccountId;
  String saleNote;
  String taxCode;
  int warehouseId;
  String sOFromPO;
  bool pOFromSO;
  String autoValidation;
  bool customer;
  bool supplier;
  bool active;
  String periodLockDate;
  double quatityDecimal;
  String extRegexPhone;
  String imageUrl;
  String city;
  String district;
  String ward;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Name'] = name;
    data['PartnerId'] = partnerId;
    data['Email'] = email;
    data['Phone'] = phone;
    data['CurrencyId'] = currencyId;

    data['Street'] = street;

    data['LastUpdated'] = lastUpdated;
    data['TransferAccountId'] = transferAccountId;

    data['WarehouseId'] = warehouseId;

    data['PeriodLockDate'] = periodLockDate;

    data['City'] = city;
    data['District'] = district;
    data['Ward'] = ward;
    return data;
  }
}
