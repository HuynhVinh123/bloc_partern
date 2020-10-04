import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/application_user.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/company.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/money_cart.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/multi_payment.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/partners.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/payment.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/point_sale.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/pos_config.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/pos_order.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/print_pos_data.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/state_cart.dart';
import 'package:tpos_mobile/feature_group/pos_order/services/pos_tpos_api.dart';
import 'package:tpos_mobile/feature_group/pos_order/sqlite_database/database_function.dart';
import 'package:tpos_mobile/locator.dart';

import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/services/print_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/account_journal.dart';

class PosPaymentPrintViewModel extends ViewModelBase {
  PosPaymentPrintViewModel(
      {IPosTposApi tposApiService, DialogService dialogService}) {
    _dialog = dialogService ?? locator<DialogService>();
    _dbFunction = dialogService ?? locator<IDatabaseFunction>();
    _tposApi = tposApiService ?? locator<IPosTposApi>();
    _printService = locator<PrintService>();
  }

  DialogService _dialog;
  DatabaseFunction _dbFunction;
  IPosTposApi _tposApi;
  PrintService _printService;

  bool checkInvoice = false;
  int discountMethod = 0;
  double discount = 0;
  double amountDiscountCK = 0;
  double amountTax = 0;
  String position = "1";
  String inputAmountPaid = "";

  PrintPostData printPostData = PrintPostData();
  Payment payment = Payment();
  MoneyCart moneyCart = MoneyCart();
  PosConfig _posConfig = PosConfig();
  Partners _partner = Partners();
  List<AccountJournal> _accountJournals = [];
  List<MultiPayment> _multiPayments = [];
  final List<Payment> _payments = [];
  List<double> lstMoney = [];

  List<AccountJournal> get accountJournals => _accountJournals;
  set accountJournals(List<AccountJournal> value) {
    _accountJournals = value;
    notifyListeners();
  }

  List<MultiPayment> get multiPayments => _multiPayments;
  set multiPayments(List<MultiPayment> value) {
    _multiPayments = value;
    notifyListeners();
  }

  PosConfig get posConfig => _posConfig;
  set posConfig(PosConfig value) {
    _posConfig = value;
    notifyListeners();
  }

  Partners get partner => _partner;
  set partner(Partners value) {
    _partner = value;
    notifyListeners();
  }

  void changeCheckMoney(int index) {
    accountJournals[index].isCheckSelect =
        !accountJournals[index].isCheckSelect;
    notifyListeners();
  }

  void changeCheckInvoice(bool value) {
    checkInvoice = value;
    notifyListeners();
  }

  Future<void> getAccountJournals() async {
    accountJournals = await _dbFunction.queryGetAccountJournals();
    print(accountJournals.length);

//    AccountJournal accountJournal = AccountJournal();
//    accountJournal.id = 2;
//    accountJournal.name = "Card";
//    accountJournal.isCheckSelect = false;
//    accountJournals.add(accountJournal);

    if (accountJournals.isNotEmpty) {
      accountJournals[0].isCheckSelect = true;
    }
  }

  Future<void> updateDataConfig(double amountTotal, String position) async {
    await getAccountJournals();
    this.position = position;
    final List<PosConfig> _posConfigs = await _dbFunction.queryGetPosConfig();
    posConfig = _posConfigs[0];

    notifyListeners();
  }

  String getAccountNameJournal(int id) {
    String name = "";
    for (var i = 0; i < _accountJournals.length; i++) {
      if (id == _accountJournals[i].id) {
        name = _accountJournals[i].name;
      }
    }
    return name;
  }

  void updateInfoMultiPayment(
      double amountTotal, int positionAccountJournalId) {
    final MultiPayment multiPayment = MultiPayment();
    if (posConfig.ifacePaymentAuto) {
      multiPayment.amountTotal = discountMethod == 0
          ? amountTotal - amountDiscountCK + amountTax
          : amountTotal - discount + amountTax;
      multiPayment.amountDebt = 0;
      if (amountTotal < 0) {
        multiPayment.amountReturn = -(discountMethod == 0
            ? amountTotal - amountDiscountCK + amountTax
            : amountTotal - discount + amountTax);
        multiPayment.amountPaid = 0;
      } else {
        multiPayment.amountPaid = discountMethod == 0
            ? amountTotal - amountDiscountCK + amountTax
            : amountTotal - discount + amountTax;
        multiPayment.amountReturn = 0;
      }
      multiPayment.accountJournalId =
          accountJournals[positionAccountJournalId].id;
    } else {
      multiPayment.amountTotal = discountMethod == 0
          ? amountTotal - amountDiscountCK + amountTax
          : amountTotal - discount + amountTax;
      multiPayment.amountPaid = 0;
      if (amountTotal > 0) {
        multiPayment.amountReturn = 0;
        multiPayment.amountDebt = discountMethod == 0
            ? amountTotal - amountDiscountCK + amountTax
            : amountTotal - discount + amountTax;
      } else {
        multiPayment.amountReturn = -(discountMethod == 0
            ? amountTotal - amountDiscountCK + amountTax
            : amountTotal - discount + amountTax);
        multiPayment.amountDebt = 0;
      }

      multiPayment.accountJournalId =
          accountJournals[positionAccountJournalId].id;
    }

    multiPayments.add(multiPayment);
    notifyListeners();
  }

  void updatePayment(int index, String value) {
    if (value == "") {
      value = "0";
    }
    if (multiPayments[index].amountDebt <= 0) {
      if (index == 0) {
        multiPayments[index].amountPaid =
            double.parse(value.replaceAll(".", ""));
        multiPayments[index].amountDebt = multiPayments[index].amountTotal -
            double.parse(value.replaceAll(".", ""));
        multiPayments[index].amountReturn =
            double.parse(value.replaceAll(".", "")) -
                multiPayments[index].amountTotal;
        if (multiPayments[index].amountDebt < 0) {
          multiPayments[index].amountDebt = 0;
        }
        if (multiPayments[index].amountReturn < 0) {
          multiPayments[index].amountReturn = 0;
        }
      } else {
        multiPayments[index].amountPaid =
            double.parse(value.replaceAll(".", ""));
        multiPayments[index].amountDebt = multiPayments[index].amountTotal -
            double.parse(value.replaceAll(".", ""));
        multiPayments[index].amountReturn =
            double.parse(value.replaceAll(".", "")) +
                multiPayments[index - 1].amountReturn -
                multiPayments[index].amountTotal;
        if (multiPayments[index].amountDebt < 0) {
          multiPayments[index].amountDebt = 0;
        }
        if (multiPayments[index].amountReturn < 0) {
          multiPayments[index].amountReturn = 0;
        }
      }

      for (var i = index; i < multiPayments.length - 1; i++) {
        multiPayments[i + 1].amountTotal = multiPayments[i].amountDebt;
        multiPayments[i + 1].amountDebt =
            (multiPayments[i].amountDebt) - multiPayments[i + 1].amountPaid;
        if (multiPayments[i + 1].amountDebt <= 0) {
          if (multiPayments[i + 1].amountDebt - multiPayments[i].amountReturn <
              0) {
            multiPayments[i + 1].amountReturn =
                -(multiPayments[i + 1].amountDebt -
                    multiPayments[i].amountReturn);
          } else {
            multiPayments[i + 1].amountReturn =
                multiPayments[i + 1].amountDebt - multiPayments[i].amountReturn;
          }

          multiPayments[i + 1].amountDebt = 0;
        } else {
          multiPayments[i + 1].amountReturn = 0;
        }
      }
    } else {
      multiPayments[index].amountPaid = double.parse(value.replaceAll(".", ""));
      multiPayments[index].amountDebt = multiPayments[index].amountTotal -
          double.parse(value.replaceAll(".", ""));
      multiPayments[index].amountReturn =
          double.parse(value.replaceAll(".", "")) -
              multiPayments[index].amountTotal;
      if (multiPayments[index].amountDebt < 0) {
        multiPayments[index].amountDebt = 0;
      }
      if (multiPayments[index].amountReturn < 0) {
        multiPayments[index].amountReturn = 0;
      }

      for (var i = index; i < multiPayments.length - 1; i++) {
        multiPayments[i + 1].amountTotal = multiPayments[i].amountDebt;
        multiPayments[i + 1].amountDebt =
            (multiPayments[i].amountDebt) - multiPayments[i + 1].amountPaid;
        if (multiPayments[i + 1].amountDebt <= 0) {
          if (multiPayments[i + 1].amountDebt - multiPayments[i].amountReturn <
              0) {
            multiPayments[i + 1].amountReturn =
                -(multiPayments[i + 1].amountDebt -
                    multiPayments[i].amountReturn);
          } else {
            multiPayments[i + 1].amountReturn =
                multiPayments[i + 1].amountDebt - multiPayments[i].amountReturn;
          }
          multiPayments[i + 1].amountDebt = 0;
        } else {
          multiPayments[i + 1].amountReturn = 0;
        }
      }
    }

    notifyListeners();
  }

  Future<void> getMoneyCart(String position) async {
    setState(true);
    try {
      List<MoneyCart> moneyCarts = [];
      moneyCarts = await _dbFunction.queryGetMoneyCartPosition(position);
      if (moneyCarts.isNotEmpty) {
        discountMethod = moneyCarts[0]
            .discountMethod; // == 0: chiết khấu  , == 1 : giảm tiền
        discount = moneyCarts[0].discount;
      }
    } catch (e) {
      setState(false);
      _dialog.showError(title: "Thông báo", content: e.toString());
    }
    setState(false);
  }

  void handleDiscountCK(double amountTotal) {
    if (discount < 0) {
      discount = 0;
    } else if (discount > 100) {
      discount = 100;
    }
    amountDiscountCK = amountTotal - (1 - (discount / 100)) * amountTotal;
    amountDiscountCK = amountDiscountCK.roundToDouble();
    notifyListeners();
  }

  void handleDiscountMoney(double amountTotal) {
    if (discount > amountTotal) {
      if (amountTotal > 0) {
        discount = amountTotal;
      }
    } else if (discount < 0) {
      discount = 0;
    }
    notifyListeners();
  }

  void handleAmountTax(Tax tax, double amountTotal) {
    if (tax != null) {
      if (discountMethod == 0) {
        amountTax = (amountTotal - amountDiscountCK) * (tax.amount / 100);
      } else if (discountMethod == 1) {
        amountTax = (amountTotal - discount) * (tax.amount / 100);
      } else {
        amountTax = amountTotal * (tax.amount / 100);
      }
      amountTax = amountTax.roundToDouble();
    }
    notifyListeners();
  }

  void handleChangeMoneyPayment(String money, int idPayment) {
    for (var i = 0; i < multiPayments.length; i++) {
      if (idPayment == multiPayments[i].accountJournalId) {}
    }
  }

  Future<void> addInfoPayment(
      {String position,
      int partnerID,
      BuildContext context,
      String applicationUserID,
      int taxId,
      String userId,
      double tax,
      double amountDiscount,
      double amountTotal}) async {
    _payments.clear();
    final List<Lines> _lines =
        await _dbFunction.queryGetProductsForCart(position);
    final List<Session> _sessions = await _dbFunction.querySessions();
    final List<Companies> _companies = await _dbFunction.queryCompanys();
    final List<StateCart> _carts =
        await _dbFunction.queryCartByPosition(position);
    List<Partners> _partners = [];
    if (partnerID != null) {
      _partners = await _dbFunction.queryGetPartnersById(partnerID);
    }
    final List<PosApplicationUser> _applicationUsers =
        await _dbFunction.queryGetApplicationUserById(applicationUserID);
    final List<PosConfig> _posConfigs = await _dbFunction.queryGetPosConfig();

    double amountPaid = 0;

    payment.statementIds = [];
    for (var i = 0; i < multiPayments.length; i++) {
      // Tính tổng tiền khách đã trả
      amountPaid += multiPayments[i].amountPaid;

      final StatementIds statementId = StatementIds();
      statementId.amount = double.parse(
          vietnameseCurrencyFormat(multiPayments[i].amountPaid)
              .replaceAll(".", ""));
      statementId.journalId = multiPayments[i].accountJournalId;
      statementId.statementId = _sessions[0].id;
      statementId.accountId = _companies[0].transferAccountId;
      statementId.name = _carts[0].time;
      payment.statementIds.add(statementId);
    }

    // cập nhật và add số sản phẩm cho giỏ hàng
    for (var i = 0; i < _lines.length; i++) {
      _lines[i].productName = null;
      _lines[i].tb_cart_position = null;
      _lines[i].isPromotion = null;
      _lines[i].image = null;
      _lines[i].uomName = null;
    }

    payment.lines = _lines;
    // tính tổng số tiền khách đã trả

    payment.amountPaid =
        double.parse(vietnameseCurrencyFormat(amountPaid).replaceAll(".", ""));

    payment.amountReturn = double.parse(vietnameseCurrencyFormat(amountPaid -
            (discountMethod == 0
                ? amountTotal - amountDiscountCK + amountTax
                : amountTotal - discount + amountTax))
        .replaceAll(".", ""));
    payment.amountTax =
        double.parse(vietnameseCurrencyFormat(amountTax).replaceAll(".", ""));
    payment.amountTotal =
        double.parse(vietnameseCurrencyFormat(amountTotal).replaceAll(".", ""));

    payment.customerCount = 1;
    if (discountMethod == 0) {
      payment.discountType = "percentage";
      payment.discount = discount;
      payment.discountFixed = 0;
    } else if (discountMethod == 1) {
      payment.discountType = "amount_fixed";
      payment.discountFixed = discount;
      payment.discount = 0;
    } else {
      payment.discountType = "percentage";
      payment.discount = 0;
      payment.discountFixed = 0;
    }

    //payment.discountType = "";
    payment.loyaltyPoints = 0;
    //payment.name;
    payment.posSessionId = _sessions[0].id;
    payment.sequenceNumber = int.parse(position);
    payment.spentPoints = 0;
    payment.totalPoints = 0;
    payment.wonPoints = 0;
    payment.partnerId = partnerID;
    payment.userId = userId;
    payment.creationDate = DateTime.parse(_carts[0].time).toIso8601String();
//    payment.creationDate = _carts[0].time;
    payment.uid =
        "${limitNumber(_sessions[0].id.toString(), 5)}-${limitNumber(_carts[0].loginNumber.toString(), 3)}-${limitNumber(_carts[0].position, 4)}";
    payment.name =
        "ĐH ${limitNumber(_sessions[0].id.toString(), 5)}-${limitNumber(_carts[0].loginNumber.toString(), 3)}-${limitNumber(_carts[0].position, 4)}";
    payment.taxId = taxId;
    _payments.add(payment);

    // Xử lý add thông tin check hóa đơn
    final List<InvoicePayment> invoicePayments = [];
    final InvoicePayment invoicePayment = InvoicePayment();
    invoicePayment.isCheck = checkInvoice ? 1 : 0;
    invoicePayment.sequence = position;
    invoicePayments.add(invoicePayment);

    // Xử lý add thông tin để in hóa đơn
    printPostData.companyName = _companies[0].name;
    printPostData.companyId = _companies[0].id;
    printPostData.imageLogo = _companies[0].imageUrl;
    printPostData.companyPhone = _companies[0].phone;
    printPostData.companyAddress = _companies[0].street;
    if (_partners.isNotEmpty) {
      printPostData.partnerName = _partners[0].name;
      printPostData.partnerPhone = _partners[0].phone;
      printPostData.partnerAddress = _partners[0].street;
    }
    printPostData.dateSale = _carts[0].time;
    printPostData.employee = _applicationUsers[0].name;
    printPostData.amountTotal = payment.amountTotal;
    printPostData.amountPaid = payment.amountPaid;
    printPostData.amountReturn = payment.amountReturn;
    printPostData.namePayment = payment.name;
    printPostData.amountTax = payment.amountTax;

    if (discountMethod == 0) {
      printPostData.discount = discount;
      printPostData.discountCash = 0;
      printPostData.amountDiscount = amountDiscount;
    } else if (discountMethod == 1) {
      print(discount);
      printPostData.discountCash = discount;
      printPostData.discount = 0;
    } else {
      printPostData.discount = 0;
      printPostData.discountCash = 0;
    }

    printPostData.tax = tax;
    printPostData.amountBeforeTax = discountMethod == 0
        ? amountTotal - amountDiscountCK
        : amountTotal - discount;

    // Xử lý add thông tin để in hóa đơn
    printPostData.lines = await _dbFunction.queryGetProductsForCart(position);

    // Xét header và footer khi in
    if (_posConfigs[0].isHeaderOrFooter) {
      printPostData.header = _posConfigs[0].receiptHeader ?? "";
      printPostData.footer = _posConfigs[0].receiptFooter ?? "";
    }

    printPostData.isHeaderOrFooter = _posConfigs[0].isHeaderOrFooter;
    printPostData.isLogo = _posConfigs[0].ifaceLogo;

    if (_lines.isEmpty) {
      _dialog.showNotify(title: "Thông báo", message: "Giỏ hàng trống");
    } else if (multiPayments[multiPayments.length - 1].amountDebt > 0) {
      _dialog.showNotify(
          title: "Thông báo", message: "Bạn chưa thanh toán đủ tiền");
    } else {
      if (checkInvoice) {
        if (payment.partnerId != null) {
          handlePayment(context, _carts[0], _posConfigs[0].ifacePrintAuto);
        } else {
          _dialog.showError(
              title: "Thông báo",
              content:
                  "Bạn cần chọn khách hàng trước khi thực hiện hóa đơn cho đơn hàng này");
        }
      } else {
        handlePayment(context, _carts[0], _posConfigs[0].ifacePrintAuto);
      }
    }
    notifyListeners();
  }

  void addPayment(String value, double amountTotal, int accountJournalId) {
    if (value == "") {
      value = "0";
    }
    if (multiPayments.isNotEmpty) {
//      print(multiPayments[multiPayments.length - 1].amountDebt);
      if (multiPayments[multiPayments.length - 1].amountDebt <= 0) {
        final double amount = double.parse(value.replaceAll(".", ""));
        final MultiPayment payment = MultiPayment();
        payment.amountTotal = 0;
        if (amountTotal > 0) {
          payment.amountPaid = amount;
          payment.amountReturn =
              multiPayments[multiPayments.length - 1].amountReturn + amount;
        } else {
          print(amount);
          payment.amountPaid = 0;
          payment.amountReturn =
              multiPayments[multiPayments.length - 1].amountReturn;
        }
        payment.amountDebt = 0;

        payment.accountJournalId = accountJournalId;
        if (payment.amountDebt < 0) {
          payment.amountDebt = 0;
        }
        if (payment.amountReturn < 0) {
          payment.amountReturn = 0;
        }
        multiPayments.add(payment);
      } else {
        final double amount = double.parse(value.replaceAll(".", ""));
        final MultiPayment payment = MultiPayment();
        payment.amountTotal =
            multiPayments[multiPayments.length - 1].amountTotal -
                multiPayments[multiPayments.length - 1].amountPaid;
        payment.amountPaid = amount;
        payment.amountDebt =
            payment.amountTotal - double.parse(value.replaceAll(".", ""));
        payment.amountReturn =
            double.parse(value.replaceAll(".", "")) - payment.amountTotal;
        payment.accountJournalId = accountJournalId;
        if (payment.amountDebt < 0) {
          payment.amountDebt = 0;
        }
        if (payment.amountReturn < 0) {
          payment.amountReturn = 0;
        }

        multiPayments.add(payment);
      }
    } else {
      final double amount = double.parse(value.replaceAll(".", ""));
      final MultiPayment payment = MultiPayment();
      payment.amountTotal = amountTotal;
      payment.amountPaid = amount;
      payment.amountDebt =
          payment.amountTotal - double.parse(value.replaceAll(".", ""));
      payment.amountReturn =
          double.parse(value.replaceAll(".", "")) - payment.amountTotal;
      payment.accountJournalId = int.parse(position);
      if (payment.amountDebt < 0) {
        payment.amountDebt = 0;
      }
      if (payment.amountReturn < 0) {
        payment.amountReturn = 0;
      }

      multiPayments.add(payment);
    }
    notifyListeners();
  }

  void searchPaymentForDelete(int accountJournalId) {
    if (multiPayments.isNotEmpty) {
      for (var i = 0; i < multiPayments.length; i++) {
        if (multiPayments[i].accountJournalId == accountJournalId) {
          deletePayment(i);
        }
      }
    }
  }

  void deletePayment(int index) {
    if (multiPayments.isNotEmpty) {
      //xóa 1 payment => tiền nợ sẽ được cộng dồn vô payment cuối cùng
      for (var i = index; i < multiPayments.length - 1; i++) {
        if (index + 1 <= i) {
          if (multiPayments[i].amountDebt > 0) {
            multiPayments[i + 1].amountTotal = multiPayments[i].amountDebt;
            multiPayments[i + 1].amountReturn =
                (multiPayments[i].amountPaid - multiPayments[i].amountReturn) -
                    multiPayments[i + 1].amountPaid;
            multiPayments[i + 1].amountDebt =
                multiPayments[i].amountDebt - multiPayments[i + 1].amountPaid;

            if (multiPayments[i + 1].amountDebt < 0) {
              multiPayments[i + 1].amountReturn =
                  -multiPayments[i + 1].amountDebt;
              multiPayments[i + 1].amountDebt = 0;
            } else {
              multiPayments[i + 1].amountReturn = 0;
            }
          } else {
            multiPayments[i + 1].amountDebt = multiPayments[i].amountDebt;
            multiPayments[i + 1].amountTotal = multiPayments[i].amountDebt;
            if (multiPayments[i + 1].amountDebt <= 0) {
              multiPayments[i + 1].amountReturn =
                  multiPayments[i].amountReturn +
                      multiPayments[i + 1].amountPaid;
              multiPayments[i + 1].amountDebt = 0;
            } else {
//              multiPayments[i+1].amountReturn = multiPayments[i+1].amountPaid - multiPayments[i+1].amountDebt + multiPayments[i+1].amountReturn;

              multiPayments[i + 1].amountReturn = 0;
            }
          }
        } else {
          if (multiPayments[index].amountDebt > 0) {
            multiPayments[i + 1].amountDebt =
                (multiPayments[i].amountPaid + multiPayments[i].amountDebt) -
                    multiPayments[i + 1].amountPaid;
            multiPayments[i + 1].amountTotal =
                multiPayments[i].amountDebt + multiPayments[i].amountPaid;
            if (multiPayments[i + 1].amountDebt < 0) {
              multiPayments[i + 1].amountReturn =
                  -multiPayments[i + 1].amountDebt;
              multiPayments[i + 1].amountDebt = 0;
            } else {
              multiPayments[i + 1].amountReturn = 0;
            }
          } else {
            multiPayments[i + 1].amountDebt = (multiPayments[i].amountPaid +
                    multiPayments[i].amountDebt -
                    multiPayments[i].amountReturn) -
                multiPayments[i + 1].amountPaid;
            multiPayments[i + 1].amountTotal =
                multiPayments[i].amountPaid - multiPayments[i].amountReturn;
            if (multiPayments[i + 1].amountDebt <= 0) {
              multiPayments[i + 1].amountReturn -= multiPayments[i].amountPaid;
              multiPayments[i + 1].amountDebt = 0;
            } else {
//              multiPayments[i+1].amountReturn = multiPayments[i+1].amountPaid - multiPayments[i+1].amountDebt + multiPayments[i+1].amountReturn;

              multiPayments[i + 1].amountReturn = 0;
            }
          }
        }
      }

      multiPayments.removeAt(index);
    }
    notifyListeners();
  }

  String limitNumber(String number, int limit) {
    String res = number;
    if (number.length < limit) {
      final int count = limit - number.length;
      for (var i = 0; i < count; i++) {
        res = "0" + res;
      }
    }
    return res;
  }

  Future<void> handlePayment(
      BuildContext context, StateCart cart, bool autoPrint) async {
    setState(true);
    var result = false;
    try {
      result = await _tposApi.exePayment(_payments, checkInvoice);
      if (result) {
        showNotifyPayment("Thực hiện thanh toán thành công");
        await _dbFunction.deleteMoneyCartByPosition(position);
        if (autoPrint) {
          try {
            await _printService.printPos80mm(printPostData);
          } catch (e) {
            _dialog.showError(title: "Lỗi in", content: e.toString());
          }
        }
        Navigator.pop(context, [cart, false]);
      } else {
        if (checkInvoice) {
          try {
            await _printService.printPos80mm(printPostData);
          } catch (e) {
            _dialog.showError(title: "Lỗi in", content: e.toString());
          }
          await _dbFunction.deleteMoneyCartByPosition(position);
          await savePaymentSqlite(context, cart);
        } else {
          _dialog.showError(
              error: "Thanh toán thất bại. Kiểm tra lại giá tiền thanh toán!");
        }
      }
      setState(false);
    } on SocketException catch (e, s) {
      logger.error("SocketException", e, s);
      if (!result) {
        await _dbFunction.deleteMoneyCartByPosition(position);
        await savePaymentSqlite(context, cart);
      }
      setState(false);
    } catch (e, s) {
      logger.error("handlePaymentFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  void showNotifyPayment(String message) {
    _dialog.showNotify(title: "Thông báo", message: message);
  }

  Future<void> savePaymentSqlite(BuildContext context, StateCart cart) async {
    for (var i = 0; i < payment.statementIds.length; i++) {
      payment.statementIds[i].position = payment.sequenceNumber.toString();
      await _dbFunction.insertStatementIds(payment.statementIds[i]);
    }
    payment.lines = null;
    payment.statementIds = null;
    await _dbFunction.insertPayment(payment);
    Navigator.pop(context, [cart, true]);
  }

  double amountTotalDebt(double amountTotal) {
    double totalDebt = 0;
    if (multiPayments.isNotEmpty) {
      for (var i = 0; i < multiPayments.length; i++) {
        totalDebt += multiPayments[i].amountPaid;
      }
    }

    return amountTotal - totalDebt;
  }

  double handleTotalPaymentInfact(double amountTotal) {
    final double total = discountMethod == 0
        ? amountTotal - amountDiscountCK + amountTax
        : amountTotal - discount + amountTax;
    return total;
  }
}
