import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/partners.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/point_sale.dart';
import 'package:tpos_mobile/feature_group/pos_order/ui/pos_partner_list_page.dart';
import 'package:tpos_mobile/feature_group/pos_order/viewmodels/pos_payment_print_viewmodel.dart';
import 'package:tpos_mobile/locator.dart';

import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import 'multi_chip_page.dart';

class PosPaymentPrintPage extends StatefulWidget {
  PosPaymentPrintPage(
      {this.partner,
      this.tax,
      this.position,
      this.amountTotal,
      this.numProduct,
      this.applicationUserId,
      this.userId});
  Partners partner;
  final Tax tax;
  final String position;
  final double amountTotal;
  final int numProduct;
  final String applicationUserId;
  final String userId;

  @override
  _PosPaymentPrintPageState createState() => _PosPaymentPrintPageState();
}

class _PosPaymentPrintPageState extends State<PosPaymentPrintPage> {
  final _viewModel = locator<PosPaymentPrintViewModel>();

  final ScrollController _scrollController = ScrollController();
  FocusNode focusMoney = FocusNode();

  @override
  void initState() {
    super.initState();
    getInfoMoneyCart();
  }

  Future<void> getInfoMoneyCart() async {
    await _viewModel.updateDataConfig(widget.amountTotal, widget.position);
    await _viewModel.getMoneyCart(widget.position);
    if (_viewModel.discountMethod == 0) {
      _viewModel.handleDiscountCK(widget.amountTotal);
    } else if (_viewModel.discountMethod == 1) {
      _viewModel.handleDiscountMoney(widget.amountTotal);
    }
    _viewModel.handleAmountTax(widget.tax, widget.amountTotal);
    _viewModel.updateInfoMultiPayment(widget.amountTotal, 0);
    _viewModel.partner = widget.partner;
  }

  @override
  Widget build(BuildContext context) {
    return ViewBase<PosPaymentPrintViewModel>(
        model: _viewModel,
        builder: (context, model, _) {
          return WillPopScope(
            onWillPop: () async {
              Navigator.pop(context, _viewModel.partner);
              return true;
            },
            child: Scaffold(
              backgroundColor: const Color(0xFFEBEDEF),
              appBar: AppBar(
                title: Text(S.current.posOfSale_payment),
              ),
              body: SafeArea(
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 60),
                      child: ListView(
                        children: <Widget>[
                          _buildPaymentType(),
                          Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              height: 55,
                              color: Colors.white,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          S.current.posOfSale_amountTotal,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18),
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Container(
                                          width: 18,
                                          height: 18,
                                          decoration: BoxDecoration(
                                              color: const Color(0xFFF0F1F3),
                                              borderRadius:
                                                  BorderRadius.circular(3)),
                                          child: Center(
                                            child: Text(
                                              "${widget.numProduct}",
                                              style: const TextStyle(
                                                  color: Color(0xFF28A745)),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          vietnameseCurrencyFormat(
                                              widget.amountTotal),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )),
                          buildDivider(),
                          buildItemPartner(
                              const Icon(Icons.person,
                                  color: Color(0xFF28A745)),
                              S.current.partner,
                              _viewModel.partner?.name ?? ""),
                          buildDivider(),
                          buildItem(
                              _viewModel.discountMethod == 0
                                  ? const Icon(Icons.unarchive,
                                      color: Color(0xFF28A745))
                                  : const Icon(Icons.monochrome_photos,
                                      color: Color(0xFF28A745)),
                              _viewModel.discountMethod == 0
                                  ? "${S.current.posOfSale_discount} (${vietnameseCurrencyFormat(_viewModel.discount)}%)"
                                  : S.current.posOfSale_discountFixed,
                              vietnameseCurrencyFormat(
                                  _viewModel.discountMethod == 0
                                      ? _viewModel.amountDiscountCK
                                      : _viewModel.discount)),
                          buildDivider(),
                          Visibility(
                            visible: widget.tax != null,
                            child: buildItem(
                              const Icon(Icons.monetization_on,
                                  color: Color(0xFF28A745)),
                              S.current.posOfSale_amountBeforeTax,
                              vietnameseCurrencyFormat(
                                  _viewModel.discountMethod == 0
                                      ? widget.amountTotal -
                                          _viewModel.amountDiscountCK
                                      : widget.amountTotal -
                                          _viewModel.discount),
                            ),
                          ),
                          Visibility(
                              visible: widget.tax != null,
                              child: buildDivider()),
                          buildItem(
                              const Icon(Icons.monetization_on,
                                  color: Color(0xFF28A745)),
                              widget.tax?.name ?? S.current.posOfSale_tax,
                              vietnameseCurrencyFormat(_viewModel.amountTax)),
                          const SizedBox(
                            height: 12,
                          ),
                          _buildInvoice(),
                          const SizedBox(
                            height: 12,
                          ),
                          Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              height: 55,
                              color: Colors.white,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          S.current.posOfSale_totalPayment,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 17),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          vietnameseCurrencyFormat(_viewModel
                                              .handleTotalPaymentInfact(
                                                  widget.amountTotal)),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 17,
                                              color: Color(0xFFF25D27)),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )),
                          Container(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, bottom: 6),
                              color: Colors.white,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          S.current.posOfSale_debt,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          vietnameseCurrencyFormat(
                                              _viewModel.multiPayments.length -
                                                          1 >=
                                                      0
                                                  ? _viewModel
                                                      .multiPayments[_viewModel
                                                              .multiPayments
                                                              .length -
                                                          1]
                                                      .amountDebt
                                                  : _viewModel
                                                      .handleTotalPaymentInfact(
                                                          widget.amountTotal)),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16,
                                              color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )),
                          buildDivider(),
                          _buildListPayment(context)
//                      Visibility(
//                          visible: _viewModel.checkMoney, child: _buildMoney()),
//                      Visibility(
//                          visible: _viewModel.checkCard, child: _buildCard())
                        ],
                      ),
                    ),
                    _buildButtonThanhToan()
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _buildListPayment(BuildContext context) {
    return ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 3),
        controller: _scrollController,
        shrinkWrap: true,
        reverse: true,
        addRepaintBoundaries: false,
        addAutomaticKeepAlives: false,
        itemCount: _viewModel.multiPayments.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(
              height: 1,
            ),
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
              onTap: () {
                _buildDialogEditMoneyPayment(
                    context, _viewModel.multiPayments[index].amountTotal,
                    index: index);
              },
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: <Widget>[
                          Image.asset(
                            "images/ic_tax.png",
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 5,
                            child: Text(
                              _viewModel.getAccountNameJournal(_viewModel
                                  .multiPayments[index].accountJournalId),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  vietnameseCurrencyFormat(_viewModel
                                      .multiPayments[index].amountPaid),
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                const Divider()
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Align(
                        alignment: Alignment.centerRight,

                        /// Tiền thừa
                        child: Text(
                          "${S.current.posOfSale_amountReturn}: ${vietnameseCurrencyFormat(_viewModel.multiPayments[index].amountReturn)}",
                          style: const TextStyle(
                              color: Color(0xFF9CA2AA), fontSize: 16),
                        ),
                      )
                    ],
                  )));
        });
  }

  Widget _buildInvoice() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        children: <Widget>[
          Checkbox(
              activeColor: const Color(0xFF28A745),
              value: _viewModel.checkInvoice,
              onChanged: (value) {
                _viewModel.changeCheckInvoice(value);
              }),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                /// Tạo hóa đơn
                child: Text(
                  S.current.posOfSale_createInvoice,
                  style:
                      const TextStyle(color: Color(0xFF2C333A), fontSize: 16),
                ),
              ),

              /// Cho phép KH ghi nợ và thanh toán sau
              Text(
                S.current.posOfSale_allowDebit,
                style: const TextStyle(fontSize: 14, color: Color(0xFF9CA2AA)),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildButtonThanhToan() {
    return Positioned(
      bottom: 6,
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 12,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 45,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(0, 2),
                          blurRadius: 2,
                          color: Colors.grey[400])
                    ],
                    color: const Color(0xFF28A745),
                    borderRadius: BorderRadius.circular(6)),
                child: FlatButton(
                    onPressed: () {
                      if (widget.numProduct == 0) {
                        _viewModel
                            .showNotifyPayment(S.current.posOfSale_noProduct);
                      } else {
                        if (_viewModel.multiPayments.isNotEmpty) {
                          _viewModel.addInfoPayment(
                              position: widget.position,
                              partnerID: _viewModel.partner.id,
                              context: context,
                              applicationUserID: widget.applicationUserId,
                              taxId: widget.tax?.id,
                              userId: widget.userId,
                              tax: widget.tax?.amount,
                              amountDiscount: _viewModel.amountDiscountCK,
                              amountTotal: widget.amountTotal);
                        }
                      }
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Text(S.current.confirm,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white)),
                        ),
                      ],
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDivider() {
    return Divider(
      height: 1,
      color: Colors.grey[300],
    );
  }

  Widget buildItem(Icon icon, String title, String value) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        height: 55,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  icon,
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    title ?? "",
                    style: const TextStyle(fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    value ?? "",
                    style: const TextStyle(color: Color(0xFF9CA2AA)),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  Widget buildItemPartner(Icon icon, String title, String value) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PosPartnerListPage(
                    partner: _viewModel.partner,
                  )),
        ).then((value) {
          if (value != null) {
            _viewModel.partner = value;
            widget.partner = value;
          }
        });
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          height: 55,
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    icon,
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      title ?? "",
                      style: const TextStyle(
                          color: const Color(0xFF2C333A),
                          fontWeight: FontWeight.w400),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                        child: Text(value ?? "",
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                                color: const Color(0xFF2C333A),
                                fontWeight: FontWeight.w600))),
                    Visibility(
                      visible: _viewModel.partner?.name != null,
                      child: InkWell(
                        onTap: () {
                          _viewModel.partner = Partners();
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          child: const Center(
                            child: Icon(
                              Icons.clear,
                              size: 19,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 17,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }

  Widget _buildPaymentType() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Container(
        height: 80,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _viewModel.accountJournals.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  _viewModel.changeCheckMoney(index);
                  if (_viewModel.accountJournals[index].isCheckSelect) {
                    if (_viewModel.multiPayments.isNotEmpty) {
                      _viewModel.addPayment(
                          _viewModel.multiPayments.isNotEmpty
                              ? _viewModel
                                  .amountTotalDebt(
                                      _viewModel.handleTotalPaymentInfact(
                                          widget.amountTotal))
                                  .floor()
                                  .toString()
                              : widget.amountTotal.floor().toString(),
                          widget.amountTotal,
                          _viewModel.accountJournals[index].id);
                    } else {
                      _viewModel.updateInfoMultiPayment(
                          widget.amountTotal, index);
                    }
                  } else {
                    _viewModel.searchPaymentForDelete(
                        _viewModel.accountJournals[index].id);
                  }
                },
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 9, right: 4),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: _viewModel
                                        .accountJournals[index].isCheckSelect
                                    ? const Color(0xFF28A745)
                                    : Colors.white),
                            boxShadow: const <BoxShadow>[
                              BoxShadow(
                                  offset: Offset(0, 2),
                                  blurRadius: 2,
                                  color: Colors.white)
                            ]),
                        height: 60,
                        width: 115,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                "images/ic_tax.png",
                                width: 38,
                                height: 31,
                              ),
                              Text(
                                  _viewModel.accountJournals[index]?.name ?? "")
                            ],
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _viewModel.accountJournals[index].isCheckSelect,
                      child: Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Color(0xFF28A745), shape: BoxShape.circle),
                          width: 18,
                          height: 18,
                          child: const Icon(
                            Icons.check,
                            size: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }

  void _buildDialogEditMoneyPayment(BuildContext context, double amountPaid,
      {int index}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.only(bottom: 12, top: 12),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              width: 0,
            ),
          ),
          title: Text(
            S.current.posOfSale_enterAmount,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          content: MultiChipPage(
            price: amountPaid,
            viewModel: _viewModel,
            accountJournals: _viewModel.accountJournals,
            accountJournalId: _viewModel.multiPayments[index].accountJournalId,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(S.current.cancel.toUpperCase()),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text(S.current.confirm.toUpperCase()),
              onPressed: () {
                _viewModel.updatePayment(index, _viewModel.inputAmountPaid);
                Navigator.of(context).pop(DialogResultType.YES);
              },
            ),
          ],
        );
      },
    );
  }
}
