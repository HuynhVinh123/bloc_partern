import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/point_sale.dart';
import 'package:tpos_mobile/feature_group/pos_order/ui/pos_account_tax_page.dart';
import 'package:tpos_mobile/feature_group/pos_order/ui/pos_method_payment_list_page.dart';
import 'package:tpos_mobile/feature_group/pos_order/ui/pos_picking_type_page.dart';
import 'package:tpos_mobile/feature_group/pos_order/ui/pos_price_list_page.dart';
import 'package:tpos_mobile/feature_group/pos_order/ui/pos_stock_location_page.dart';
import 'package:tpos_mobile/feature_group/pos_order/viewmodels/pos_point_sale_edit_viewmodel.dart';
import 'package:tpos_mobile/helpers/app_helper.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class PosPointSaleEditPage extends StatefulWidget {
  const PosPointSaleEditPage({this.pointSale});
  final PointSale pointSale;
  @override
  _PosPointSaleEditPageState createState() => _PosPointSaleEditPageState();
}

class _PosPointSaleEditPageState extends State<PosPointSaleEditPage> {
  final TextEditingController _controllerNamePointSale =
      TextEditingController();
  final TextEditingController _controllerDiscount = TextEditingController();
  TextEditingController controller = TextEditingController();
  final TextEditingController _controllerTitle = TextEditingController();
  final TextEditingController _controllerFooter = TextEditingController();

  FocusNode focusNode = FocusNode();
  final _vm = locator<PosPointSaleEditViewModel>();

  @override
  void initState() {
    super.initState();
    _vm.pointSale = widget.pointSale;
    _vm.setDataSetting(widget.pointSale);
    _vm.discount = widget.pointSale.discountPc;
    _controllerNamePointSale.text = widget.pointSale.name;
    _controllerDiscount.text = _vm.discount?.floor().toString();
    _controllerTitle.text = widget.pointSale.receiptHeader;
    _controllerFooter.text = widget.pointSale.receiptFooter;
//    _vm.getAccountJournalsPointSale();
  }

  @override
  Widget build(BuildContext context) {
    return ViewBase<PosPointSaleEditViewModel>(
        model: _vm,
        builder: (context, model, _) {
          return WillPopScope(
            onWillPop: () async {
              return await confirmClosePage(context,
                  title: S.current.close,
                  message: S.current.posOfSale_closePage);
            },
            child: Scaffold(
              backgroundColor: Colors.grey[200],
              appBar: AppBar(
                title: Text(S.current.posOfSale_editPosOfSale),
              ),
              body: Material(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0)),
                shadowColor: Colors.grey[500],
                elevation: 4.0,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    children: <Widget>[_buildInfoEdit(), _buildBtnXacNhan()],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget _buildInfoEdit() {
    _vm.countName = 0;
    const Widget _spaceHeight = SizedBox(
      height: 6,
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 60),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          const Padding(
            padding: EdgeInsets.only(left: 12, top: 12),
            child: Text(
              "THÔNG TIN CHUNG",
              style: TextStyle(color: Color(0xFF28A745), fontSize: 18),
            ),
          ),
          _spaceHeight,
          Row(
            children: <Widget>[
              Expanded(flex: 2, child: _header(S.current.name)),
              Expanded(flex: 4, child: _formThongTin()),
            ],
          ),
          _spaceHeight,
          _spaceHeight,
          Row(
            children: <Widget>[
              /// Loại hoạt động
              Expanded(flex: 2, child: _header(S.current.posOfSale_activeType)),
              Expanded(flex: 4, child: _buildLoaiHoatDong()),
            ],
          ),
          _spaceHeight,
          Row(
            children: <Widget>[
              /// Địa điểm kho
              Expanded(
                  flex: 2, child: _header(S.current.posOfSale_stockLocation)),
              Expanded(flex: 4, child: _buildDiaDiemKho()),
            ],
          ),
          _spaceHeight,
          Row(
            children: <Widget>[
              /// Bảng giá
              Expanded(flex: 2, child: _header(S.current.posOfSale_price)),
              Expanded(flex: 4, child: _buildBangGia()),
            ],
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 0),
            child: CheckboxListTile(
              activeColor: Colors.green,

              /// HIệu lực
              title: Text(
                S.current.posOfSale_active,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              value: _vm.actives["isActive"],
              onChanged: (bool value) {
                setState(() {
                  _vm.actives["isActive"] = value;
                });
              },
            ),
          ),
          _spaceHeight,
          SizedBox(
            height: 8,
            child: Container(
              color: const Color(0xFFEBEDEF),
            ),
          ),
          _spaceHeight,

          /// Phương thức thanh toán khả dụng
          _header(S.current.posSession_paymentType),
          _spaceHeight,
          _buildPhuongThucThanhToan(),
          _spaceHeight,
          _spaceHeight,
          SizedBox(
            height: 8,
            child: Container(
              color: const Color(0xFFEBEDEF),
            ),
          ),
          _spaceHeight,
          _buildConfigGeneral(),
          _spaceHeight,
          SizedBox(
            height: 8,
            child: Container(
              color: const Color(0xFFEBEDEF),
            ),
          ),
          _buildCashMoney(),
          SizedBox(
            height: 8,
            child: Container(
              color: const Color(0xFFEBEDEF),
            ),
          ),
          _buildTax(),
          SizedBox(
            height: 8,
            child: Container(
              color: const Color(0xFFEBEDEF),
            ),
          ),
          _buildConfigInvoice(),
          _buildConfigPrinter()
        ]),
      ),
    );
  }

  Widget _buildCashMoney() {
    return ExpansionTile(
        backgroundColor: Colors.white,

        /// KIẾM SOÁT TIỀN MẶT
        title: Text(
          S.current.posOfSale_cashControl.toUpperCase(),
          style: const TextStyle(color: Color(0xFF28A745)),
        ),
        initiallyExpanded: true,
        children: _vm.cashMoneys.keys.map((String key) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 0),
            child: CheckboxListTile(
              activeColor: Colors.green,
              title: Text(S.current.posOfSale_cashControl),
              value: _vm.cashMoneys[key],
              onChanged: (bool value) {
                setState(() {
                  _vm.cashMoneys[key] = value;
                });
              },
            ),
          );
        }).toList());
  }

  Widget _buildConfigGeneral() {
    return ExpansionTile(
        backgroundColor: Colors.white,

        /// Tính năng
        title: Text(
          S.current.posOfSale_feature.toUpperCase(),
          style: const TextStyle(color: Color(0xFF28A745)),
        ),
        initiallyExpanded: true,
        children: _vm.values.keys.map((String key) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 0),
            child: CheckboxListTile(
              activeColor: Colors.green,
              title: Text(_vm.nameConfigs[_vm.countName++]),
              value: _vm.values[key],
              onChanged: (bool value) {
                setState(() {
                  _vm.values[key] = value;
                });
              },
            ),
          );
        }).toList());
  }

  DropdownButton printers() => DropdownButton<String>(
          items: const [
            DropdownMenuItem<String>(
              value: "1",
              child: Text(
                "Bill 80",
              ),
            ),
            DropdownMenuItem<String>(
              value: "2",
              child: Text(
                "Bill 58",
              ),
            ),
          ],
          onChanged: (value) {
            _vm.changeValuePrint(value);
          },
          value: _vm.valuePrint,
          elevation: 2,
          style: TextStyle(color: Colors.grey[800], fontSize: 17),
          isExpanded: true,
          underline: const SizedBox());

  Widget _buildConfigInvoice() {
    return ExpansionTile(
      backgroundColor: Colors.white,
      title: Text(
        S.current.posOfSale_invoiceAndReceipts.toUpperCase(),
        style: const TextStyle(color: Color(0xFF28A745)),
      ),
      initiallyExpanded: true,
      children: <Widget>[
        Card(
          margin: const EdgeInsets.symmetric(vertical: 1),
          child: Column(
            children: <Widget>[
              CheckboxListTile(
                activeColor: Colors.green,

                /// Thêm thông điệp vào đầu chân tran
                title: Text(S.current.posOfSale_addMessages),
                value: _vm.isHeaderOrFooter,
                onChanged: (bool value) {
                  setState(() {
                    _vm.isHeaderOrFooter = value;
                  });
                },
              ),
              Visibility(
                  visible: _vm.isHeaderOrFooter,
                  child: _buildTitleHeaderInvoice(
                      title: S.current.posOfSale_header,
                      controller: _controllerTitle,
                      maxLine: 1)),
              const SizedBox(
                height: 5,
              ),
              Visibility(
                  visible: _vm.isHeaderOrFooter,
                  child: _buildTitleHeaderInvoice(
                      title: S.current.posOfSale_footer,
                      controller: _controllerFooter,
                      maxLine: 2)),
              const SizedBox(
                height: 3,
              )
            ],
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(vertical: 0),
          child: CheckboxListTile(
            activeColor: Colors.green,
            title: Text(S.current.posOfSale_showLogo),
            value: _vm.ifaceLogo,
            onChanged: (bool value) {
              setState(() {
                _vm.ifaceLogo = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildConfigPrinter() {
    return Padding(
      padding: const EdgeInsets.only(right: 20, top: 8, bottom: 8, left: 16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              S.current.posOfSale_printerConfiguration,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
              child: Container(
                  padding: const EdgeInsets.only(left: 12),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]),
                      borderRadius: const BorderRadius.all(Radius.circular(3))),
                  child: printers()))
        ],
      ),
    );
  }

  Widget _buildTax() {
    return ExpansionTile(
      backgroundColor: Colors.white,

      /// CHIẾT KHẤU & THUẾ VAT
      title: Text(
        "${S.current.posOfSale_discount.toUpperCase()} & ${S.current.posOfSale_tax} VAT",
        style: const TextStyle(color: Color(0xFF28A745)),
      ),
      initiallyExpanded: true,
      children: <Widget>[
        Card(
          margin: const EdgeInsets.symmetric(vertical: 0),
          child: Column(
            children: <Widget>[
              CheckboxListTile(
                activeColor: Colors.green,

                /// Cho phép chiết khấu đơn hàng trên toàn bộ đơn hàng
                title: Text(S.current.posOfSale_allowDiscount),
                value: _vm.ifaceDiscount,
                onChanged: (bool value) {
                  setState(() {
                    _vm.ifaceDiscount = value;
                  });
                },
              ),
              Visibility(
                  visible: _vm.ifaceDiscount,
                  child: Row(
                    children: <Widget>[
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        flex: 2,
                        child:
                            Text("${S.current.posOfSale_discountDefault} (%)"),
                      ),
                      Expanded(flex: 3, child: defaultTax()),
                    ],
                  )),
              const SizedBox(
                height: 6,
              )
            ],
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(vertical: 0),
          child: CheckboxListTile(
            activeColor: Colors.green,

            /// Cho phép giảm tiền trên toàn bộ đơn hàng"
            title: Text(S.current.posOfSale_allowDiscountFixed),
            value: _vm.ifaceDiscountFixed,
            onChanged: (bool value) {
              setState(() {
                _vm.ifaceDiscountFixed = value;
              });
            },
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(vertical: 0),
          child: Column(
            children: <Widget>[
              CheckboxListTile(
                activeColor: Colors.green,

                /// Áp dụng thuế trên toàn bộ đơn hàng
                title: Text(S.current.posOfSale_applyToTax),
                value: _vm.ifaceTax,
                onChanged: (bool value) {
                  setState(() {
                    _vm.ifaceTax = value;
                  });
                },
              ),
              Visibility(
                visible: _vm.ifaceTax,
                child: Row(
                  children: <Widget>[
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      flex: 2,
                      child: Text("${S.current.posOfSale_discountDefault} (%)"),
                    ),
                    Expanded(flex: 3, child: _buildThue()),
                  ],
                ),
              ),
              const SizedBox(
                height: 2,
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _header(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Text(
        title ?? "",
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _formThongTin() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(3.0),
          ),
        ),
        child: Row(
          children: <Widget>[
            const SizedBox(
              width: 12.0,
            ),
            Expanded(
                child: TextField(
              textAlign: TextAlign.right,
              controller: _controllerNamePointSale,
              decoration: const InputDecoration(
                hintText: "",
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget _buildLoaiHoatDong() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PosPickingTypePage()),
          ).then((value) {
            if (value != null) {
              _vm.pickingType = value;
            }
          });
        },
        child: Container(
          height: 40,
          padding: const EdgeInsets.only(left: 12),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(3)),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Text(
                _vm.pickingType == null
                    ? S.current.posOfSale_activeType
                    : _vm.pickingType.nameGet,
                textAlign: TextAlign.right,
              )),
              Visibility(
                visible: _vm.pickingType != null,
                child: InkWell(
                  onTap: () {
                    _vm.resetPickingType();
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    child: const Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 15,
                color: Colors.grey[300],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDiaDiemKho() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PosStockLocationPage()),
          ).then((value) {
            if (value != null) {
              _vm.stockLocation = value;
            }
          });
        },
        child: Container(
          height: 40,
          padding: const EdgeInsets.only(left: 12),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(3)),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Text(
                _vm.stockLocation == null
                    ? S.current.posOfSale_stockLocation
                    : _vm.stockLocation.nameGet,
                textAlign: TextAlign.right,
              )),
              Visibility(
                visible: _vm.stockLocation != null,
                child: InkWell(
                  onTap: () {
                    _vm.resetStockLocation();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 15,
                color: Colors.grey[300],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleHeaderInvoice(
      {String title, TextEditingController controller, int maxLine}) {
    return Padding(
      padding: const EdgeInsets.only(left: 18),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Text(
              title ?? "",
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.only(left: 18, right: 24),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[400]),
                color: Colors.white,
                borderRadius: const BorderRadius.all(
                  Radius.circular(3.0),
                ),
              ),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration.collapsed(
                  hintText: "",
                ),
                maxLines: maxLine,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBangGia() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const PosPriceListPage(true)),
          ).then((value) {
            if (value != null) {
              _vm.prices = value;
            }
          });
        },
        child: Container(
          height: 40,
          padding: const EdgeInsets.only(left: 12),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(3)),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Text(
                " ${_vm.prices == null ? S.current.posOfSale_priceList : _vm.prices.name}",
                textAlign: TextAlign.right,
              )),
              Visibility(
                visible: _vm.prices != null,
                child: InkWell(
                  onTap: () {
                    _vm.resetPriceList();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 15,
                color: Colors.grey[300],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhuongThucThanhToan() {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: 35,
          padding: const EdgeInsets.only(left: 4, right: 0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(3)),
          child: Row(
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PosMethodPaymentListPage()),
                  ).then((value) {
                    if (value != null) {
                      _vm.handleAddAccountJournal(value);
                    }
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 12),
                  height: 35,
                  decoration: BoxDecoration(
                      color: const Color(0xFFEBEDEF),
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const SizedBox(
                        width: 8,
                      ),
                      Icon(
                        Icons.add,
                        color: Colors.grey[700],
                        size: 20,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        S.current.add,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _vm.pointSale.journals.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color(0xFF28A745),
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  _vm.deleteAccountJournal(index);
                                },
                                child: Container(
                                  height: 35,
                                  width: 35,
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                              Text(
                                _vm.pointSale?.journals[index]?.name ?? "",
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                            ],
                          ),
//                          shadowColor: Colors.grey[500],
//                          avatar: Icon(
//                            Icons.close,
//                            color: Colors.red,
//                          ),
//                          label: Text("${_vm.pointSale.journals[index].name}"),
//                          backgroundColor: Colors.transparent,
//                          shape: BeveledRectangleBorder(
//                            side:
//                                BorderSide(width: 0.5, color: Colors.grey[400]),
//                            borderRadius: BorderRadius.circular(2.0),
//                          ),
//                          onSelected: (bool value) {
//                            _vm.deleteAccountJournal(index);
//                          },
                        ),
                      );
                    }),
              ),
              const SizedBox(
                width: 4,
              ),
//              Container(
//                height: 40,
//                width: 40,
//                decoration: BoxDecoration(
//                    shape: BoxShape.circle,
//                    color: Colors.green,
//                    gradient: LinearGradient(
//                        begin: Alignment.topRight,
//                        end: Alignment.bottomLeft,
//                        colors: [Colors.blueGrey[400], Colors.grey[400]])),
//                child: IconButton(
//                  icon: Icon(
//                    Icons.add,
//                    color: Colors.white,
//                  ),
//                  onPressed: () {
//                    Navigator.push(
//                      context,
//                      new MaterialPageRoute(
//                          builder: (context) => PosMethodPaymentListPage()),
//                    ).then((value) {
//                      if (value != null) {
//                        _vm.handleAddAccountJournal(value);
//                      }
//                    });
//                  },
//                ),
//              ),
//              SizedBox(
//                width: 4,
//              ),
            ],
          )),
    );
  }

  Widget _buildThue() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 24.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PosAccountTaxPage()),
          ).then((value) {
            if (value != null) {
              _vm.tax = value;
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(3)),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Text(
                      " ${_vm.tax == null ? S.current.posOfSale_tax : _vm.tax.name}")),
              Visibility(
                visible: _vm.tax != null,
                child: InkWell(
                  onTap: () {
                    _vm.resetTax();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Color(0xFFEBEDEF),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget defaultTax() {
    if (_vm.isClick) {
      _controllerDiscount.text = vietnameseCurrencyFormat(_vm.discount);
    }
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        _vm.isClick = false;
        _controllerDiscount.selection = TextSelection(
            baseOffset: 0, extentOffset: _controllerDiscount.text.length);
      }
    });

    return Container(
        height: 45,
        margin: const EdgeInsets.only(left: 18, right: 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(3.0),
          ),
        ),
        child: Row(
          children: <Widget>[
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: TextField(
                textAlign: TextAlign.right,
                focusNode: focusNode,
                controller: _controllerDiscount,
                decoration: const InputDecoration(
                  hintText: "",
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  NumberInputFormat.vietnameDong(),
                ],
              ),
            ),
//            InkWell(
//              onTap: () {
//                _vm.isClick = true;
//                _vm.reduceDiscount(_controllerDiscount.text);
//              },
//              child: Container(
//                decoration:
//                    BoxDecoration(border: Border.all(color: Colors.grey[400])),
//                width: 45,
//                height: 45,
//                child: Center(
//                    child: Icon(
//                  Icons.remove,
//                  color: Colors.grey[700],
//                )),
//              ),
//            ),
//            InkWell(
//              onTap: () {
//                _vm.isClick = true;
//                _vm.incrementDiscount(_controllerDiscount.text);
//              },
//              child: Container(
//                decoration:
//                    BoxDecoration(border: Border.all(color: Colors.grey[400])),
//                width: 45,
//                child: Center(
//                  child: Icon(
//                    Icons.add,
//                    color: Colors.grey[700],
//                  ),
//                ),
//              ),
//            ),
          ],
        ));
  }

  Widget _buildBtnXacNhan() {
    return Positioned(
      bottom: 6,
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        padding: const EdgeInsets.only(top: 8, right: 24),
        child: Center(
          child: Container(
            margin: EdgeInsets.only(
                right: MediaQuery.of(context).size.width / 5,
                left: MediaQuery.of(context).size.width / 5),
            height: 45,
            decoration: const BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.all(Radius.circular(3.0)),
            ),
            child: FlatButton(
              onPressed: () {
                _vm.updateData(
                    name: _controllerNamePointSale.text,
                    context: context,
                    receiptFooter: _controllerFooter.text,
                    receiptHeader: _controllerTitle.text,
                    discount: _controllerDiscount.text);
              },
              child: Center(
                child: Text(
                  S.current.confirm,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
