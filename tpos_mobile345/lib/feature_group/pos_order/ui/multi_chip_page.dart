import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/pos_order/viewmodels/multi_chip_viewmodel.dart';
import 'package:tpos_mobile/feature_group/pos_order/viewmodels/pos_payment_print_viewmodel.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/locator.dart';

import 'package:tpos_mobile/src/tpos_apis/models/account_journal.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class MultiChipPage extends StatefulWidget {
  const MultiChipPage(
      {this.price,
      this.viewModel,
      this.accountJournals,
      this.accountJournalId});
  final double price;
  final PosPaymentPrintViewModel viewModel;
  final List<AccountJournal> accountJournals;
  final int accountJournalId;
  @override
  _MultiChipPageState createState() => _MultiChipPageState();
}

class _MultiChipPageState extends State<MultiChipPage>
    with SingleTickerProviderStateMixin {
  final _viewModel = locator<MultiChipViewModel>();
  final TextEditingController _controllerAmountPaid = TextEditingController();
  FocusNode focusNode = FocusNode();
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: widget.accountJournals.length, vsync: this);
    _controllerAmountPaid.text = vietnameseCurrencyFormat(widget.price);
    if (widget.price <= 0) {
      _controllerAmountPaid.text = "0";
      widget.viewModel.lstMoney = [0];
      _viewModel.amountHandle = widget.price < 0 ? -widget.price : widget.price;
      widget.viewModel.inputAmountPaid = "0";
    } else {
      widget.viewModel.lstMoney = getCalcAmountSuggestions(widget.price);
      widget.viewModel.inputAmountPaid = widget.price.floor().toString();
    }

    for (var i = 0; i < widget.accountJournals.length; i++) {
      if (widget.accountJournalId == widget.accountJournals[i].id) {
        _tabController.index = i;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewBase<MultiChipViewModel>(
        model: _viewModel,
        builder: (context, model, _) {
          return SingleChildScrollView(
            child: Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TabBar(
                    controller: _tabController,
                    indicatorColor: const Color(0xFF28A745),
                    tabs: widget.accountJournals.map((item) {
                      return Tab(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.credit_card,
                              color: item.id == widget.accountJournalId
                                  ? const Color(0xFF28A745)
                                  : const Color(0xFFEBEDEF),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Text(
                              item.name ?? "",
                              style: TextStyle(
                                  color: item.id == widget.accountJournalId
                                      ? const Color(0xFF484D54)
                                      : const Color(0xFF9CA2AA)),
                            ),
                          ],
                        ),
                      );
                    }).toList()),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  "${S.current.posOfSale_enterAmount}:",
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(
                  height: 6,
                ),
                Container(
                  decoration: const BoxDecoration(color: Color(0xFFEBEDEF)),
                  child: _formThongTin(
                      controller: _controllerAmountPaid,
                      focusNode: focusNode,
                      isUpdate: true,
                      amountPaid: widget.price),
                ),
                const SizedBox(
                  height: 8,
                ),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: _viewModel.amountHandle > 0
                            ? "${S.current.posOfSale_debt} : "
                            : "${S.current.posOfSale_amountReturn} : ",
                        style: const TextStyle(
                            color: Color(0xFF9CA2AA), fontSize: 14)),
                    TextSpan(
                        text: _viewModel.amountHandle > 0
                            ? vietnameseCurrencyFormat(_viewModel.amountHandle)
                            : _viewModel.amountHandle == 0
                                ? vietnameseCurrencyFormat(
                                    _viewModel.amountHandle)
                                : vietnameseCurrencyFormat(
                                    -_viewModel.amountHandle),
                        style: const TextStyle(
                            color: Color(0xFF9CA2AA),
                            fontSize: 15,
                            fontWeight: FontWeight.w600)),
                  ]),
                ),
                const SizedBox(
                  height: 8,
                ),
                Wrap(
                  direction: Axis.horizontal,
                  children: widget.viewModel.lstMoney
                      .map((item) => InkWell(
                            onTap: () {
                              setState(() {
                                focusNode.unfocus();
                                _controllerAmountPaid.text =
                                    vietnameseCurrencyFormat(item);
                                _viewModel.handleMoney(
                                    amountTotal: widget.price,
                                    amountDebtStr: _controllerAmountPaid.text);
                                widget.viewModel.inputAmountPaid =
                                    _controllerAmountPaid.text;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 8, top: 6),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 3),
                              height: 40,
                              width: 80,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: const Color(0xFFEBEDEF)),
                              ),
                              child: Center(
                                  child: AutoSizeText(
                                vietnameseCurrencyFormat(item),
                                maxLines: 1,
                              )),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
          );
        });
  }

  Widget _formThongTin(
      {TextEditingController controller,
      FocusNode focusNode,
      bool isUpdate,
      double amountPaid}) {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        controller.selection =
            TextSelection(baseOffset: 0, extentOffset: controller.text.length);
      }
    });
    return Container(
      height: 45,
      decoration: const BoxDecoration(
        color: Color(0xFFEBEDEF),
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      child: Row(
        children: <Widget>[
          const SizedBox(
            width: 12.0,
          ),
          Expanded(
              child: TextField(
            style: const TextStyle(
                fontSize: 20,
                color: Color(0xFF484D54),
                fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
            autofocus: true,
            controller: controller,
            decoration: InputDecoration.collapsed(
              hintText: "${S.current.posOfSale_enterAmount}...",
            ),
            focusNode: focusNode,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly,
              NumberInputFormat.vietnameDong(),
            ],
            onChanged: (value) {
              _viewModel.handleMoney(
                  amountTotal: widget.price, amountDebtStr: value);
              widget.viewModel.inputAmountPaid = value;
            },
          ))
        ],
      ),
    );
  }

  List<double> getCalcAmountSuggestions(amount) {
    final coins = [500, 1e3, 2e3, 5e3, 1e4, 2e4, 5e4, 1e5, 2e5, 5e5];

    dynamic greedy(amount, max) {
      final result = [];
      for (var temp = amount; temp > 0;) {
        temp -= max;
        result.add(max);
      }

      return result.reduce((a, b) {
        return a + b;
      });
    }

    //Tính suggest
    final List<double> results = [];
    var preNumber = 0;
    if (amount >= 1e7) {
      preNumber = (amount / 1e7).floor();
      amount %= 1e7;
    }
    for (var i = 1; i < coins.length; i++) {
      var coin = coins[i], sum = greedy(amount, coin);
      //Trường hợp lớp hơn 1e7
      if (preNumber > 0) sum = 1e7 * preNumber + sum;

      ///Không có thì thêm vào
      if (!results.contains(sum)) results.add(sum);
    }

    results.sort((a, b) {
      return a > b ? 1 : a < b ? -1 : 0;
    });
    return results;
  }
}
