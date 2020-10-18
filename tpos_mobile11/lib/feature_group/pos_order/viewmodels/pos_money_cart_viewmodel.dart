import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/money_cart.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/partners.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/point_sale.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/pos_config.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/print_pos_data.dart';
import 'package:tpos_mobile/feature_group/pos_order/sqlite_database/database_function.dart';
import 'package:tpos_mobile/locator.dart';

import 'package:tpos_mobile/services/dialog_service.dart';

class PosMoneyCartViewModel extends ViewModelBase {
  PosMoneyCartViewModel({DialogService dialogService}) {
    _dialog = dialogService ?? locator<DialogService>();
    _dbFunction = locator<IDatabaseFunction>();
  }
  DialogService _dialog;
  IDatabaseFunction _dbFunction;

  bool checkChietKhau = false;
  bool checkGiamTien = false;
  PrintPostData printPostData = PrintPostData();
  Partners _partner = Partners();
  double tongTien = 0;
  int chietKhau = 0;
  double tienGiam = 0;
  int cachThucGiam = -1;
  double tongTienChietKhau = 0;
  double tongTienGiamTien = 0;
  double tienTruocThue = 0;
  double tienThue = 0;
  PosConfig _posConfig = PosConfig();
  MoneyCart moneyCart = MoneyCart();
  Tax _tax;

  Tax get tax => _tax;
  set tax(Tax value) {
    _tax = value;
    notifyListeners();
  }

  Partners get partner => _partner;
  set partner(Partners value) {
    _partner = value;
    notifyListeners();
  }

  PosConfig get posConfig => _posConfig;
  set posConfig(PosConfig value) {
    _posConfig = value;
    notifyListeners();
  }

  void changeDiscountPriceChietKhau(bool value) {
//    cachThucGiam = value;
//    notifyListeners();
    if (value) {
      cachThucGiam = 0;
    } else {
      cachThucGiam = -1;
    }
  }

  void changeDiscountPriceGiamTien(bool value) {
//    cachThucGiam = value;
//    notifyListeners();
    if (value) {
      cachThucGiam = 1;
    } else {
      cachThucGiam = -1;
    }
  }

  void handleGiamChietKhau(String value) {
    chietKhau = value == "" ? 0 : int.parse(value.replaceAll(".", ""));
    if (chietKhau < 0) {
      chietKhau = 0;
    } else if (chietKhau > 100) {
      chietKhau = 100;
    }
    tongTienChietKhau = tongTien * (1 - chietKhau / 100);
    tongTienChietKhau = tongTienChietKhau.roundToDouble();
    if (tax != null) {
      tienTruocThue = tongTienChietKhau;
      tienThue = tienTruocThue * (tax.amount / 100);
    }
    tienTruocThue = tongTienChietKhau;
    tongTienChietKhau += tienThue;
    notifyListeners();
  }

  void handleGiamTien(String value) {
    tienGiam = value == "" ? 0 : double.parse(value.replaceAll(".", ""));
    if (tienGiam > tongTien) {
      tongTienGiamTien = 0;
    } else {
      tongTienGiamTien = tongTien - tienGiam;
    }
    if (tax != null) {
      tienTruocThue = tongTienGiamTien;
      tienThue = tienThue = tienTruocThue * (tax.amount / 100);
    }
    tienTruocThue = tongTienGiamTien;
    tongTienGiamTien += tienThue;
    notifyListeners();
  }

  Future<void> updateTongTien(double tong) async {
    tongTien = tong;
    tienTruocThue = tong;
    tongTienChietKhau = tong;
    tongTienGiamTien = tong;
    if (posConfig.taxId != null) {
      if (posConfig.ifaceTax) {
        await getTaxById();
        tienTruocThue = tong;
        tienThue = tienTruocThue * (tax.amount / 100);
        tongTienChietKhau += tienThue;
        tongTienGiamTien += tienThue;
      }
    }

    notifyListeners();
  }

  void notifyErrorPayment() {
    _dialog.showNotify(title: "Thông báo", message: "Bạn chưa chọn khách hàng");
  }

  Future<void> getTaxById() async {
    try {
      final List<Tax> _taxs =
          await _dbFunction.queryGetTaxById(posConfig.taxId);
      if (_taxs.isNotEmpty) {
        tax = _taxs[0];
      }
    } catch (e, s) {
      logger.error("getTaxById", e, s);
    }
  }

  Future<void> getPosConfig() async {
    setState(true);
    try {
      final result = await _dbFunction.queryGetPosConfig();
      posConfig = result[0];
      print(posConfig.discountPc);
      if (!posConfig.ifaceDiscount) {
        cachThucGiam = 1;
      }
    } catch (e, s) {
      logger.error("getPosConfig", e, s);
    }
    setState(false);
  }

  void amountTax(Tax aTax) {
    if (cachThucGiam == 0) {
      tongTienChietKhau = tongTien * (1 - chietKhau / 100);
      tongTienChietKhau = tongTienChietKhau.roundToDouble();
      if (tax != null) {
        tienTruocThue = tongTienChietKhau;
        tienThue = tienTruocThue * (tax.amount / 100);
      } else {
        tienThue = 0;
      }
      tongTienChietKhau += tienThue;
    } else {
      if (tienGiam > tongTien) {
        tongTienGiamTien = 0;
      } else {
        tongTienGiamTien = tongTien - tienGiam;
      }
      if (tax != null) {
        tienTruocThue = tongTienGiamTien;
        tienThue = tienThue = tienTruocThue * (tax.amount / 100);
      } else {
        tienThue = 0;
      }
      tongTienGiamTien += tienThue;
    }
    notifyListeners();
  }

  Future<void> getMoneyCart(String position, bool isSave) async {
    try {
      List<MoneyCart> moneyCarts = [];
      moneyCarts = await _dbFunction.queryGetMoneyCartPosition(position);
      if (moneyCarts.isNotEmpty) {
        if (isSave) {
          await _dbFunction.updateMoneyCart(moneyCart);
        } else {
          cachThucGiam = moneyCarts[0].discountMethod;

          if (cachThucGiam == 0) {
            checkChietKhau = true;
            chietKhau = moneyCarts[0].discount.floor();
            handleGiamChietKhau(chietKhau.toString());
          } else if (cachThucGiam == 1) {
            checkGiamTien = true;
            tienGiam = moneyCarts[0].discount;
            handleGiamTien(tienGiam.floor().toString());
          } else {
            checkChietKhau = false;
            checkGiamTien = false;
          }
          final partners = await _dbFunction
              .queryGetPartnersById(moneyCarts[0].partnerId ?? 0);
          if (partners.isNotEmpty) {
            partner = partners[0];
          } else {
            partner = Partners();
          }
          final taxs =
              await _dbFunction.queryGetTaxById(moneyCarts[0].taxId ?? -1);
          if (taxs.isNotEmpty) {
            tax = taxs[0];
            amountTax(tax);
          } else {
            tax = null;
            amountTax(tax);
          }
        }
      } else {
        if (isSave) {
          await _dbFunction.insertCartMoney(moneyCart);
        }
      }
      notifyListeners();
    } catch (e) {
      _dialog.showError(title: "Thông báo", content: e.toString());
    }
  }
}
