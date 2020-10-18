import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/company.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/invoice.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/invoice_product.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/partners.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/payment.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/pos_config.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/pos_order.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/print_pos_data.dart';
import 'package:tpos_mobile/feature_group/pos_order/services/pos_tpos_api.dart';
import 'package:tpos_mobile/feature_group/pos_order/sqlite_database/database_function.dart';
import 'package:tpos_mobile/feature_group/pos_order/viewmodels/pos_cart_viewmodel.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/services/print_service.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class PosInvoiceListViewModel extends ViewModelBase {
  PosInvoiceListViewModel(
      {IPosTposApi tposApiService, DialogService dialogService}) {
    _tposApi = tposApiService ?? locator<IPosTposApi>();
    _dialog = dialogService ?? locator<DialogService>();
    _dbFunction = locator<IDatabaseFunction>();
    _printService = locator<PrintService>();
  }

  DialogService _dialog;
  IPosTposApi _tposApi;
  IDatabaseFunction _dbFunction;
  PrintService _printService;

  List<Lines> _lines = [];
  List<InvoiceProduct> _invoiceProducts = [];
  PosOrder _posOrder = PosOrder();

  PosOrder get posOrder => _posOrder;

  set posOrder(PosOrder value) {
    _posOrder = value;
    notifyListeners();
  }

  List<InvoiceProduct> get invoiceProducts => _invoiceProducts;
  set invoiceProducts(List<InvoiceProduct> value) {
    _invoiceProducts = value;
    notifyListeners();
  }

  List<Invoice> _invoices = [];

  List<Invoice> get invoices => _invoices;

  set invoices(List<Invoice> value) {
    _invoices = value;
    notifyListeners();
  }

  Future<void> getInvoices(int id) async {
    setState(true);
    try {
      final result = await _tposApi.getInvoicesPointSale(id);
      if (result != null) {
        invoices = result;
      }
    } catch (e, s) {
      logger.error("getInvoicesFail", e, s);
      _dialog.showError(error: e);
    }
    setState(false);
  }

  Future<void> getDetailInvoice(
      int id, String position, bool isPrint, isReturnInvoice) async {
    setState(true);
    try {
      final result = await _tposApi.getDetailInvoice(id);
      final List<PosConfig> _posConfigs = await _dbFunction.queryGetPosConfig();
      if (result != null) {
        invoiceProducts = await _tposApi.getProductInvoicePrint(id);
        _lines.clear();

        for (var i = 0; i < invoiceProducts.length; i++) {
          final Lines line = Lines();
          line.discount = double.parse(invoiceProducts[i].discount.toString());
          line.priceUnit =
              double.parse(invoiceProducts[i].priceUnit.toString());
          line.note = invoiceProducts[i].notice;
          line.id = invoiceProducts[i].id;
          line.productName = invoiceProducts[i].productNameGet;
          // isReturnInvoice == true: lưu lại sản phẩm giỏ hàng với sl là âm, isreturnInvoice == false: lưu lại sản phẩm giỏ hàng giá trị dương
          if (isReturnInvoice) {
            line.qty = -invoiceProducts[i].qty.floor();
          } else {
            line.qty = invoiceProducts[i].qty.floor();
          }
          line.uomId = invoiceProducts[i].uOMId;
          line.productId = invoiceProducts[i].productId;
          line.tb_cart_position = position;
          line.discountType = "percent";
          line.uomName = invoiceProducts[i].uOMName;
          line.image = invoiceProducts[i].product.imageUrl;
          _lines.add(line);
        }
        posOrder = result;
        final List<Companies> _companies = await _dbFunction.queryCompanys();

        final PrintPostData printPostData = PrintPostData();
        // Xử lý add thông tin để in hóa đơn
        printPostData.companyName = _companies[0].name;
        printPostData.companyId = _companies[0].id;
        printPostData.imageLogo = _companies[0].imageUrl;
        printPostData.companyPhone = _companies[0].phone;
        printPostData.companyAddress = _companies[0].street;
        if (result.partner != null) {
          printPostData.partnerName = result.partner.name;
          printPostData.partnerPhone = result.partner.phone;
          printPostData.partnerAddress = result.partner.street;
        }
        printPostData.dateSale = result.dateOrder.toIso8601String();
        printPostData.employee = result.userName;
        printPostData.amountTotal = result.amountTotal;
        printPostData.amountPaid = result.amountPaid;
        printPostData.amountReturn = result.amountReturn;
        printPostData.namePayment = result.pOSReference;
        printPostData.amountTax = result.amountTax;

        printPostData.discount = result.discount;
        printPostData.discountCash = result.discountFixed;
        printPostData.amountDiscount = result.amountDiscount;

        printPostData.tax = result.tax?.amount;
        printPostData.amountBeforeTax = result.amountUntaxed;

        // Xử lý add thông tin để in hóa đơn
        printPostData.lines = [];
        printPostData.lines = _lines;

        // Xét header và footer khi in
        if (_posConfigs[0].isHeaderOrFooter) {
          printPostData.header = _posConfigs[0].receiptHeader ?? "";
          printPostData.footer = _posConfigs[0].receiptFooter ?? "";
        }

        printPostData.isHeaderOrFooter = _posConfigs[0].isHeaderOrFooter;
        printPostData.isLogo = _posConfigs[0].ifaceLogo;

        if (isPrint) {
          try {
            await _printService.printPos80mm(printPostData);
          } catch (e) {
            _dialog.showError(title: S.current.printError, error: e.toString());
          }
        }
      }
    } catch (e, s) {
      logger.error("getInvoicesFail", e, s);
      _dialog.showError(error: e);
    }
    setState(false);
  }

  Future<void> insertProductForCart(
      String position, PosCartViewModel viewModel) async {
    setState(true);
    for (var i = 0; i < _lines.length; i++) {
      final List<Lines> lstProduct = await _dbFunction.queryGetProductWithID(
          position, _lines[i].productId);
      if (lstProduct.isEmpty) {
        final int result = await _dbFunction.insertProductCart(_lines[i]);

        // update cart
        double disCount = 0;
        if (posOrder.discountType == "percentage") {
          viewModel.showReduceMoney = false;
          viewModel.showReduceMoneyCk = true;
          disCount = posOrder.discount;
        } else if (posOrder.discountType == "amount_fixed") {
          viewModel.showReduceMoneyCk = false;
          viewModel.showReduceMoney = true;
          disCount = posOrder.discountFixed;
        }
        final Partners partners = Partners();
        partners.id = posOrder.partnerId;
        viewModel.partner = partners;
        viewModel.tax = posOrder.tax;

        viewModel.updateInfoMoneyCart(disCount.floor().toString(), true);

        if (result != 0) {
          showNotify(S.current.posOfSale_successful);
        } else {
          showNotify(S.current.posOfSale_failed);
        }
      } else {
        bool checkSameMoney = false;
        int positionUpdate = 0;
        for (var j = 0; j < lstProduct.length; j++) {
          if (lstProduct[j].priceUnit == _lines[i].priceUnit) {
            checkSameMoney = true;
            positionUpdate = j;
          }
        }
        if (checkSameMoney) {
          _lines[i].id = lstProduct[positionUpdate].id;
          _lines[i].qty = _lines[i].qty + lstProduct[positionUpdate].qty;
          await _dbFunction.updateProductCart(_lines[i]);
        } else {
          await _dbFunction.insertProductCart(_lines[i]);
        }
      }
    }
    setState(false);
  }

  Future<void> deleteProductPosition(String position) async {
    setState(true);
    try {
      final List<Lines> lines =
          await _dbFunction.queryGetProductsForCart(position);
      _lines = lines;
      for (var i = 0; i < _lines.length; i++) {
        await _dbFunction.deleteProductCart(_lines[i]);
      }
      _lines.clear();
    } catch (e, s) {
      logger.error("deleteProductPosition", e, s);
    }
    setState(false);
  }

  void showNotify(String message) {
    _dialog.showNotify(title: S.current.notification, message: message);
  }
}
