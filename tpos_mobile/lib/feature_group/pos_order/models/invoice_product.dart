class InvoiceProduct {
  InvoiceProduct(
      {this.id,
      this.companyId,
      this.name,
      this.notice,
      this.productId,
      this.uOMId,
      this.uOMName,
      this.productNameGet,
      this.priceUnit,
      this.qty,
      this.discount,
      this.orderId,
      this.priceSubTotal,
      this.product,
      this.uOM});

  InvoiceProduct.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    companyId = json['CompanyId'];
    name = json['Name'];
    notice = json['Notice'];
    productId = json['ProductId'];
    uOMId = json['UOMId'];
    uOMName = json['UOMName'];
    productNameGet = json['ProductNameGet'];
    priceUnit = json['PriceUnit'];
    qty = json['Qty'];
    discount = json['Discount'];
    orderId = json['OrderId'];
    priceSubTotal = json['PriceSubTotal'];
    if (json['Product'] != null) {
      product = Product.fromJson(json['Product']);
    } else {
      product = null;
    }
    if (json['UOM'] != null) {
      uOM = UOM.fromJson(json['UOM']);
    } else {
      uOM = null;
    }
  }

  int id;
  int companyId;
  String name;
  String notice;
  int productId;
  int uOMId;
  String uOMName;
  String productNameGet;
  double priceUnit;
  double qty;
  double discount;
  int orderId;
  double priceSubTotal;
  Product product;
  UOM uOM;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['CompanyId'] = companyId;
    data['Name'] = name;
    data['Notice'] = notice;
    data['ProductId'] = productId;
    data['UOMId'] = uOMId;
    data['UOMName'] = uOMName;
    data['ProductNameGet'] = productNameGet;
    data['PriceUnit'] = priceUnit;
    data['Qty'] = qty;
    data['Discount'] = discount;
    data['OrderId'] = orderId;
    data['PriceSubTotal'] = priceSubTotal;
    if (product != null) {
      data['Product'] = product.toJson();
    }
    if (uOM != null) {
      data['UOM'] = uOM.toJson();
    }
    return data;
  }
}

//TODO(vinhht): Phải đổi tên object
class Product {
  Product(
      {this.id,
      this.eAN13,
      this.defaultCode,
      this.nameTemplate,
      this.nameNoSign,
      this.productTmplId,
      this.uOMId,
      this.uOMName,
      this.uOMPOId,
      this.qtyAvailable,
      this.virtualAvailable,
      this.outgoingQty,
      this.incomingQty,
      this.nameGet,
      this.pOSCategId,
      this.price,
      this.barcode,
      this.image,
      this.imageUrl,
      this.saleOK,
      this.purchaseOK,
      this.displayAttributeValues,
      this.lstPrice,
      this.active,
      this.listPrice,
      this.purchasePrice,
      this.discountSale,
      this.discountPurchase,
      this.standardPrice,
      this.weight,
      this.oldPrice,
      this.version,
      this.description,
      this.lastUpdated,
      this.type,
      this.categId,
      this.costMethod,
      this.invoicePolicy,
      this.name,
      this.propertyCostMethod,
      this.propertyValuation,
      this.purchaseMethod,
      this.saleDelay,
      this.tracking,
      this.valuation,
      this.availableInPOS,
      this.companyId,
      this.isCombo,
      this.nameTemplateNoSign,
      this.taxesIds,
      this.stockValue,
      this.saleValue,
      this.posSalesCount,
      this.factor,
      this.categName,
      this.amountTotal,
      this.nameCombos});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    eAN13 = json['EAN13'];
    defaultCode = json['DefaultCode'];
    nameTemplate = json['NameTemplate'];
    nameNoSign = json['NameNoSign'];
    productTmplId = json['ProductTmplId'];
    uOMId = json['UOMId'];
    uOMName = json['UOMName'];
    uOMPOId = json['UOMPOId'];
    qtyAvailable = json['QtyAvailable'];
    virtualAvailable = json['VirtualAvailable'];
    outgoingQty = json['OutgoingQty'];
    incomingQty = json['IncomingQty'];
    nameGet = json['NameGet'];
    pOSCategId = json['POSCategId'];
    price = json['Price'];
    barcode = json['Barcode'];
    image = json['Image'];
    imageUrl = json['ImageUrl'];
    saleOK = json['SaleOK'];
    purchaseOK = json['PurchaseOK'];
    displayAttributeValues = json['DisplayAttributeValues'];
    lstPrice = json['LstPrice'];
    active = json['Active'];
    listPrice = json['ListPrice'];
    purchasePrice = json['PurchasePrice'];
    discountSale = json['DiscountSale'];
    discountPurchase = json['DiscountPurchase'];
    standardPrice = json['StandardPrice'];
    weight = json['Weight'];
    oldPrice = json['OldPrice'];
    version = json['Version'];
    description = json['Description'];
    lastUpdated = json['LastUpdated'];
    type = json['Type'];
    categId = json['CategId'];
    costMethod = json['CostMethod'];
    invoicePolicy = json['InvoicePolicy'];
    name = json['Name'];
    propertyCostMethod = json['PropertyCostMethod'];
    propertyValuation = json['PropertyValuation'];
    purchaseMethod = json['PurchaseMethod'];
    saleDelay = json['SaleDelay'];
    tracking = json['Tracking'];
    valuation = json['Valuation'];
    availableInPOS = json['AvailableInPOS'];
    companyId = json['CompanyId'];
    isCombo = json['IsCombo'];
    nameTemplateNoSign = json['NameTemplateNoSign'];
//    if (json['TaxesIds'] != null) {
//      taxesIds = new List<Null>();
//      json['TaxesIds'].forEach((v) {
//        taxesIds.add(new Null.fromJson(v));
//      });
//    }
    stockValue = json['StockValue'];
    saleValue = json['SaleValue'];
    posSalesCount = json['PosSalesCount'];
    factor = json['Factor'];
    categName = json['CategName'];
    amountTotal = json['AmountTotal'];
//    if (json['NameCombos'] != null) {
//      nameCombos = new List<Null>();
//      json['NameCombos'].forEach((v) {
//        nameCombos.add(new Null.fromJson(v));
//      });
//    }
  }

  int id;
  dynamic eAN13;
  String defaultCode;
  String nameTemplate;
  dynamic nameNoSign;
  int productTmplId;
  int uOMId;
  String uOMName;
  int uOMPOId;
  int qtyAvailable;
  int virtualAvailable;
  int outgoingQty;
  int incomingQty;
  String nameGet;
  int pOSCategId;
  double price;
  String barcode;
  dynamic image;
  String imageUrl;
  bool saleOK;
  bool purchaseOK;
  dynamic displayAttributeValues;
  int lstPrice;
  bool active;
  int listPrice;
  dynamic purchasePrice;
  dynamic discountSale;
  dynamic discountPurchase;
  int standardPrice;
  int weight;
  dynamic oldPrice;
  int version;
  dynamic description;
  dynamic lastUpdated;
  String type;
  int categId;
  dynamic costMethod;
  String invoicePolicy;
  String name;
  dynamic propertyCostMethod;
  dynamic propertyValuation;
  String purchaseMethod;
  double saleDelay;
  dynamic tracking;
  dynamic valuation;
  bool availableInPOS;
  dynamic companyId;
  dynamic isCombo;
  String nameTemplateNoSign;
  List<dynamic> taxesIds;
  dynamic stockValue;
  dynamic saleValue;
  dynamic posSalesCount;
  dynamic factor;
  dynamic categName;
  dynamic amountTotal;
  List<dynamic> nameCombos;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['EAN13'] = eAN13;
    data['DefaultCode'] = defaultCode;
    data['NameTemplate'] = nameTemplate;
    data['NameNoSign'] = nameNoSign;
    data['ProductTmplId'] = productTmplId;
    data['UOMId'] = uOMId;
    data['UOMName'] = uOMName;
    data['UOMPOId'] = uOMPOId;
    data['QtyAvailable'] = qtyAvailable;
    data['VirtualAvailable'] = virtualAvailable;
    data['OutgoingQty'] = outgoingQty;
    data['IncomingQty'] = incomingQty;
    data['NameGet'] = nameGet;
    data['POSCategId'] = pOSCategId;
    data['Price'] = price;
    data['Barcode'] = barcode;
    data['Image'] = image;
    data['ImageUrl'] = imageUrl;
    data['SaleOK'] = saleOK;
    data['PurchaseOK'] = purchaseOK;
    data['DisplayAttributeValues'] = displayAttributeValues;
    data['LstPrice'] = lstPrice;
    data['Active'] = active;
    data['ListPrice'] = listPrice;
    data['PurchasePrice'] = purchasePrice;
    data['DiscountSale'] = discountSale;
    data['DiscountPurchase'] = discountPurchase;
    data['StandardPrice'] = standardPrice;
    data['Weight'] = weight;
    data['OldPrice'] = oldPrice;
    data['Version'] = version;
    data['Description'] = description;
    data['LastUpdated'] = lastUpdated;
    data['Type'] = type;
    data['CategId'] = categId;
    data['CostMethod'] = costMethod;
    data['InvoicePolicy'] = invoicePolicy;
    data['Name'] = name;
    data['PropertyCostMethod'] = propertyCostMethod;
    data['PropertyValuation'] = propertyValuation;
    data['PurchaseMethod'] = purchaseMethod;
    data['SaleDelay'] = saleDelay;
    data['Tracking'] = tracking;
    data['Valuation'] = valuation;
    data['AvailableInPOS'] = availableInPOS;
    data['CompanyId'] = companyId;
    data['IsCombo'] = isCombo;
    data['NameTemplateNoSign'] = nameTemplateNoSign;
//    if (this.taxesIds != null) {
//      data['TaxesIds'] = this.taxesIds.map((v) => v.toJson()).toList();
//    }
    data['StockValue'] = stockValue;
    data['SaleValue'] = saleValue;
    data['PosSalesCount'] = posSalesCount;
    data['Factor'] = factor;
    data['CategName'] = categName;
    data['AmountTotal'] = amountTotal;
//    if (this.nameCombos != null) {
//      data['NameCombos'] = this.nameCombos.map((v) => v.toJson()).toList();
//    }
    return data;
  }
}

class UOM {
  UOM(
      {this.id,
      this.name,
      this.nameNoSign,
      this.rounding,
      this.active,
      this.factor,
      this.factorInv,
      this.uOMType,
      this.categoryId,
      this.categoryName,
      this.description,
      this.showUOMType,
      this.nameGet,
      this.showFactor});

  UOM.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    nameNoSign = json['NameNoSign'];
    rounding = json['Rounding'];
    active = json['Active'];
    factor = json['Factor'];
    factorInv = json['FactorInv'];
    uOMType = json['UOMType'];
    categoryId = json['CategoryId'];
    categoryName = json['CategoryName'];
    description = json['Description'];
    showUOMType = json['ShowUOMType'];
    nameGet = json['NameGet'];
    showFactor = json['ShowFactor'];
  }

  int id;
  String name;
  String nameNoSign;
  double rounding;
  bool active;
  double factor;
  int factorInv;
  String uOMType;
  int categoryId;
  String categoryName;
  String description;
  String showUOMType;
  String nameGet;
  double showFactor;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Name'] = name;
    data['NameNoSign'] = nameNoSign;
    data['Rounding'] = rounding;
    data['Active'] = active;
    data['Factor'] = factor;
    data['FactorInv'] = factorInv;
    data['UOMType'] = uOMType;
    data['CategoryId'] = categoryId;
    data['CategoryName'] = categoryName;
    data['Description'] = description;
    data['ShowUOMType'] = showUOMType;
    data['NameGet'] = nameGet;
    data['ShowFactor'] = showFactor;
    return data;
  }
}
