import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_mobile/locator.dart';

import 'package:tpos_mobile/services/log_services/log_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/ProductTemplate.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_purchase_order.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_purchase_order_account_tax.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_purchase_order_application_user.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_purchase_order_partner.dart';
import 'package:tpos_mobile/src/tpos_apis/models/product.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/product_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';

import 'fast_purchase_order_viewmodel.dart';

class FastPurchaseOrderAddEditViewModel extends Model {
  double qtyLines = 0;
  FastPurchaseOrder defaultFPO;
  bool isRefund = false;
  double oldQty = 1;
  final TposApiService _tposApi = locator<ITposApiService>();
  final _productApi = locator<ProductApi>();
  List<PartnerFPO> partners = new List<PartnerFPO>();
  List<ApplicationUserFPO> applicationUsers = new List<ApplicationUserFPO>();
  bool isLoadingDefaultForm = true;
  List<Product> products = new List<Product>();
  FastPurchaseOrderViewModel fastPurchaseOrderViewModel =
      locator<FastPurchaseOrderViewModel>();

  final _log = locator<LogService>();

  Future getDefaultForm() async {
    isLoadingDefaultForm = true;
    notifyListeners();
    _tposApi.getDefaultFastPurchaseOrder(isRefund: isRefund).then((value) {
      defaultFPO = value;
      isLoadingDefaultForm = false;
      notifyListeners();
    }).catchError((e, s) {
      _log.error("", e, s);
    });
  }

  void setDefaultFPO(FastPurchaseOrder fpo) {
    defaultFPO = fpo;
    print("${defaultFPO.id}");
    isLoadingDefaultForm = false;
    notifyListeners();
  }

  bool isLoadingListPartner = true;
  Future getPartner() async {
    isLoadingListPartner = true;
    notifyListeners();
    _tposApi.getListPartnerFPO().then((values) {
      partners = values;
      isLoadingListPartner = false;
      notifyListeners();
    });
  }

  Future getPartnerByKeyWord(String text) async {
    isLoadingListPartner = true;
    notifyListeners();
    _tposApi.getListPartnerByKeyWord(text).then((values) {
      partners = values;
      isLoadingListPartner = false;
      notifyListeners();
    }).catchError((e, s) {
      _log.error("", e, s);
    });
  }

  Future getProductByKeyWord(String text) async {
    isLoadingListPartner = true;
    notifyListeners();
    _productApi.actionSearchProduct(text).then((values) {
      print(values.length);
      products = values;
      isLoadingListPartner = false;
      notifyListeners();
    }).catchError((e, s) {
      _log.error("get product", e, s);
    });
  }

  Future onPickPartner(PartnerFPO item) async {
    defaultFPO.partner = item;
    defaultFPO.account = null;

    notifyListeners();
    _tposApi.onChangePartnerFPO(defaultFPO).then((value) {
      defaultFPO.account = value;

      notifyListeners();
    });
  }

  void setInvoiceDate(DateTime date) {
    var temp = defaultFPO.dateInvoice;
    defaultFPO.dateInvoice = new DateTime(
        date.year,
        date.month,
        date.day,
        temp.hour,
        temp.minute,
        temp.second,
        temp.millisecond,
        temp.microsecond);
    notifyListeners();
  }

  void setInvoiceTime(TimeOfDay time) {
    var temp = defaultFPO.dateInvoice;
    defaultFPO.dateInvoice = new DateTime(
        temp.year,
        temp.month,
        temp.day,
        time.hour,
        time.minute,
        temp.second,
        temp.millisecond,
        temp.microsecond);
    notifyListeners();
  }

  Future getApplicationUser() async {
    _tposApi.getApplicationUserFPO().then((value) {
      applicationUsers = value;
      if (applicationUsers.isNotEmpty && defaultFPO != null) {
        defaultFPO.user = applicationUsers[0];
      }

      notifyListeners();
    });
  }

  void setUser(ApplicationUserFPO user) {
    defaultFPO.user = user;
    notifyListeners();
  }

  Future getProductList() async {
    _productApi.getProductsFPO().then((values) {
      products = values;
      notifyListeners();
    });
  }

  Future addOrderLineCommand(Product product) async {
    if (defaultFPO.orderLines == null) {
      defaultFPO.orderLines = new List<OrderLine>();
    }
    /* print("kết quả đây nè");
      debugPrint(JsonEncoder.withIndent('  ').convert(convertProduct.toJson()));*/
    OrderLine orderLine = OrderLine(
      product: product,
      name: product.nameGet,
      productId: product.id,
      productUOMId: product.uOMId,
      productUom: product.uOM,
      productQty: 1,
      priceUnit: product.purchasePrice?.toDouble() ?? 0,
    );

    await _tposApi.onChangeProductFPO(defaultFPO, orderLine).then(
      (value) {
        var existLine = defaultFPO.orderLines.firstWhere(
            (f) => f.productId == value.productId,
            orElse: () => null);

        if (existLine != null)
          existLine.productQty += 1;
        else {
          //value.id = Random().nextInt(999999);
          defaultFPO.orderLines.add(value);
        }

        notifyListeners();
      },
    );
  }

  void setApplicationUser(ApplicationUserFPO item) {
    defaultFPO.user = item;
    notifyListeners();
  }

  void setValueQty(OrderLine item, double value) {
    defaultFPO.orderLines[defaultFPO.orderLines.indexOf(item)].productQty =
        value;
    notifyListeners();
  }

  void increaseQty(OrderLine item) {
    defaultFPO.orderLines[defaultFPO.orderLines.indexOf(item)].productQty++;

    notifyListeners();
  }

  void decreaseQty(OrderLine item) {
    if (defaultFPO.orderLines[defaultFPO.orderLines.indexOf(item)].productQty <
        2) {
      defaultFPO.orderLines[defaultFPO.orderLines.indexOf(item)].productQty = 1;
    } else {
      defaultFPO.orderLines[defaultFPO.orderLines.indexOf(item)].productQty--;
    }

    notifyListeners();
  }

  @override
  void notifyListeners() {
    updateAmountTotal();
    super.notifyListeners();
  }

  void updateAmountTotal() {
    if (defaultFPO == null || defaultFPO.orderLines == null) return;
    double amount = 0;
    defaultFPO.orderLines.forEach((item) {
      /*print(
          "${item.priceUnit} ${item.discount} ${item.priceSubTotal} ${defaultFPO.discount} ${defaultFPO.decreaseAmount}");
*/
      item.priceUnit = item.priceUnit == null ? 0 : item.priceUnit;
      item.discount = item.discount == null ? 0 : item.discount;
      item.priceSubTotal = item.priceSubTotal == null ? 0 : item.priceSubTotal;

      item.priceSubTotal =
          (item.priceUnit - (item.priceUnit * item.discount / 100)) *
              item.productQty;

      amount = amount + item.priceSubTotal;
    });
    defaultFPO.amount = amount;
    defaultFPO.discountAmount = (amount * defaultFPO.discount / 100);
    defaultFPO.amountUntaxed =
        amount - defaultFPO.discountAmount - defaultFPO.decreaseAmount; //

    defaultFPO.amountTax = defaultFPO.amountUntaxed *
        (defaultFPO.tax != null ? defaultFPO.tax.amount : 0) /
        100; //132500
    defaultFPO.amountTotal = defaultFPO.amountUntaxed - defaultFPO.amountTax;
  }

  List<AccountTaxFPO> taxs = new List<AccountTaxFPO>();

  Future getTax() async {
    _tposApi.getTextFPO().then((values) {
      taxs = values;
      taxs.add(AccountTaxFPO(name: "Không thuế", amount: 0));
      notifyListeners();
    });
  }

  void updateOrderLinesInfo(Map<String, dynamic> value, OrderLine item) {
    //print(value);
    if (value != null) {
      defaultFPO.orderLines.firstWhere((f) => f == item).productQty =
          value["productQty"];
      defaultFPO.orderLines.firstWhere((f) => f == item).priceUnit =
          value["priceUnit"];
      defaultFPO.orderLines.firstWhere((f) => f == item).discount =
          value["discount"];

      notifyListeners();
    }
  }

  double getSubTotal(OrderLine item) =>
      defaultFPO.orderLines.firstWhere((f) => f == item).priceSubTotal;

  void duplicateOrderLine(OrderLine item) {
    defaultFPO.orderLines.add(item);

    notifyListeners();
  }

  void removeOrderLine(OrderLine item) {
    defaultFPO.orderLines.remove(item);
    notifyListeners();
  }

  // void InvoiceOpen() {}

  Future<FastPurchaseOrder> actionDraftInvoice() async {
    var result = await _tposApi.actionInvoiceDraftFPO(defaultFPO);
    if (result != null) {
      var details = await _tposApi.getDetailsPurchaseOrderById(result.id);
      refreshList();
      return details;
    } else {
      throw Exception("Thất bại");
    }
  }

  Future<FastPurchaseOrder> actionOpenInvoice() async {
    print("defaultFPO.id ${defaultFPO.id}");
    var fastPurchaseOrder;

    ///nếu là tạo mới.
    ///Tạo hóa đơn thành nháp sau đó xác nhận hóa đơn nháp đó
    if (defaultFPO.id == 0) {
      fastPurchaseOrder = await _tposApi.actionInvoiceDraftFPO(defaultFPO);
    }

    ///nếu là sửa, bỏ qua bước tạo nháp.
    else {
      fastPurchaseOrder = defaultFPO;
      fastPurchaseOrder = await _tposApi.actionEditInvoice(fastPurchaseOrder);
    }

    var isSuccess = await _tposApi.actionInvoiceOpenFPO(fastPurchaseOrder);
    if (isSuccess) {
      var details =
          await _tposApi.getDetailsPurchaseOrderById(fastPurchaseOrder.id);
      refreshList();
      return details;
    } else {
      throw Exception("Thất bại rùi");
    }
  }

  Future<FastPurchaseOrder> editActionDraftInvoice() async {
    var result = await _tposApi.actionEditInvoice(defaultFPO);
    if (result != null) {
      var details = await _tposApi.getDetailsPurchaseOrderById(result.id);
      refreshList();
      return details;
    } else {
      throw Exception("Thất bại");
    }
  }

  void refreshList() {
    fastPurchaseOrderViewModel.loadData();
  }

  void setNote(String note) {
    defaultFPO.note = note;
  }

  Product castProductTemplateToProduct(ProductTemplate productTemplate) {
    Product product = new Product();
    product.id = productTemplate.id;
    product.uOMId = productTemplate.uOMId;
    product.version = productTemplate.version;
    product.productTmplId = productTemplate.productTmplId;
    product.price = productTemplate.price;
    product.oldPrice = productTemplate.oldPrice;
    product.discountPurchase = productTemplate.discountPurchase;
    product.discountSale = productTemplate.discountSale;
    product.name = productTemplate.name;
    product.uOMName = productTemplate.uOMName;
    product.nameGet = productTemplate.nameGet;
    product.nameNoSign = productTemplate.nameNoSign;
    product.image = productTemplate.image;
    product.imageUrl = productTemplate.imageUrl;
    product.defaultCode = productTemplate.defaultCode;
    product.weight = productTemplate.weight;
    product.type = productTemplate.type;
    product.showType = productTemplate.showType;
    product.listPrice = productTemplate.listPrice;
    product.purchasePrice = productTemplate.purchasePrice;
    product.standardPrice = productTemplate.standardPrice;
    product.saleOK = productTemplate.saleOK;
    product.purchaseOK = productTemplate.purchaseOK;
    product.active = productTemplate.active;
    product.uOMPOId = productTemplate.uOMPOId;
    product.isProductVariant = productTemplate.isProductVariant;
    product.qtyAvailable = productTemplate.qtyAvailable;
    product.virtualAvailable = productTemplate.virtualAvailable;
    product.outgoingQty = productTemplate.outgoingQty;
    product.incomingQty = productTemplate.incomingQty;
    product.categId = productTemplate.categId;
    product.tracking = productTemplate.tracking;
    product.saleDelay = productTemplate.saleDelay;
    product.companyId = productTemplate.companyId;
    product.invoicePolicy = productTemplate.invoicePolicy;
    product.purchaseMethod = productTemplate.purchaseMethod;
    product.availableInPOS = productTemplate.availableInPOS;
    product.productVariantCount = productTemplate.productVariantCount;
    product.bOMCount = productTemplate.bOMCount;
    product.isCombo = productTemplate.isCombo;
    product.enableAll = productTemplate.enableAll;
    product.variantFistId = productTemplate.variantFistId;
    product.uOM = productTemplate.uOM;
    product.categ = productTemplate.categ;
    product.uOMPO = productTemplate.uOMPO;
    product.uomLines = productTemplate.uomLines;
    product.productAttributeLines = productTemplate.productAttributeLines;
    product.barcode = productTemplate.barcode;
    return product;
  }

  // HANDLE EDIT PRODUCT
  double priceDiscountProduct(String strPriceUnit, String strDiscount) {
    double priceUnit = double.parse(strPriceUnit.replaceAll(".", ""));
    double discount = double.parse(strDiscount.replaceAll(".", ""));
    return priceUnit * (1 - (discount / 100));
  }
}
