import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';

import 'package:tpos_mobile/feature_group/pos_order/models/partners.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/payment.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/state_cart.dart';
import 'package:tpos_mobile/feature_group/pos_order/ui/pos_close_point_sale_page.dart';
import 'package:tpos_mobile/feature_group/pos_order/ui/pos_invoice_list_page.dart';
import 'package:tpos_mobile/feature_group/pos_order/ui/pos_partner_list_page.dart';
import 'package:tpos_mobile/feature_group/pos_order/ui/pos_payment_print_page.dart';
import 'package:tpos_mobile/feature_group/pos_order/ui/pos_point_sale_list_tax_page.dart';
import 'package:tpos_mobile/feature_group/pos_order/ui/pos_product_list_page.dart';
import 'package:tpos_mobile/feature_group/pos_order/viewmodels/pos_cart_viewmodel.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/helpers/app_helper.dart';

import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import '../../../resources/app_route.dart';

class PosCartPage extends StatefulWidget {
  const PosCartPage(this.id, this.compaynyId, this.userId, this.isLoadingData);
  final int id;
  final int compaynyId;
  final String userId;
  final bool isLoadingData;
  @override
  _PosCartPageState createState() => _PosCartPageState();
}

class _PosCartPageState extends State<PosCartPage> {
  final _vm = locator<PosCartViewModel>();

  final TextEditingController _controllerSoLuong = TextEditingController();
  final TextEditingController _controllerDonGia = TextEditingController();
  final TextEditingController _controllerChietKhau = TextEditingController();
  final TextEditingController _controllerGhiChu = TextEditingController();
  final TextEditingController _controllerDiscount = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final FocusNode _focusSoLuong = FocusNode();
  final FocusNode _focusDonGia = FocusNode();
  final FocusNode _focusChietKhau = FocusNode();
  final FocusNode _focusDiscount = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ViewBase<PosCartViewModel>(
        backgroundColor: Colors.grey.withOpacity(0.7),
        model: _vm,
        builder: (context, model, sizingInformation) {
          return WillPopScope(
            onWillPop: () async {
              _vm.isLoadingData = false;
              await _vm.updateInfoMoneyCart(_controllerDiscount.text,
                  true); // save thông tin giỏ hàng trước
              return await confirmClosePage(context,
                  title: S.current.close,

                  /// Thoát tính năng điểm bán hàng
                  message: S.current.posOfSale_closePosOfSale);
            },
            child: Scaffold(
              appBar: _buildAppBar(),
              body: SafeArea(
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Colors.grey[50],
                      padding: const EdgeInsets.only(right: 4, top: 2),
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: _buildListItemCart(),
                          ),
                          _buildDeleteCart(),
                          _buildBtnAddCart(),
                        ],
                      ),
                    ),
                    showAddProduct(),
                    Expanded(child: _buildContent()),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget showAddProduct() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            blurRadius: 2, color: Colors.grey[300], offset: const Offset(0, 2))
      ]),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PosProductListPage(
                            _vm.positionCart, _vm.filterProducts)),
                  ).then((value) async {
                    _vm.getProductsForCart();
                    _vm.updateDiscountMoneyCurrent(_controllerDiscount.text);
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(20)),
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: <Widget>[
                      const SizedBox(
                        width: 12,
                      ),
                      const Icon(
                        Icons.search,
                        color: Color(0xFF28A745),
                        size: 20,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Hero(
                          tag: "search",
                          child: TextField(
                            style: TextStyle(fontSize: 15),
                            enabled: false,
                            decoration: InputDecoration(

                                ///  Thêm sản phẩm
                                hintText: S.current.posOfSale_addProduct,
                                border: InputBorder.none),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            InkWell(
              onTap: () {
                _vm.barcodeScanningProduct();
//                scanBarcode();
              },
              child: Image.asset(
                "images/scan_barcode.png",
                width: 40,
                height: 25,
                color: const Color(0xFF28A745),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      /// Điểm bán hàng
      title: Text(S.current.menu_posOfSale),
      actions: <Widget>[
        Center(
          child: InkWell(
            onTap: () async {
              if (_vm.countPayment > 0) {
                await _vm.excPayment();
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Badge(
                padding: EdgeInsets.all(_vm.countPayment > 0 ? 5 : 0),
                badgeColor: Colors.redAccent,
                badgeContent: Visibility(
                  // ignore: avoid_bool_literals_in_conditional_expressions
                  visible: _vm.countPayment > 0 ? true : false,
                  child: Text(
                    "${_vm.countPayment}",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                child: const Icon(Icons.shopping_cart),
              ),
            ),
          ),
        ),
        _childPopup()
      ],
    );
  }

  Widget _childPopup() => PopupMenuButton<String>(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: "invoice",
            child: Row(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Image.asset(
                      "images/ic_invoice.png",
                      width: 22,
                      height: 22,
                      color: Colors.green,
                    )),
                Expanded(
                  /// Hóa đơn
                  child: Text(
                    S.current.order,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: "update_data",
            child: Row(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.update,
                    color: Colors.green,
                  ),
                ),
                Expanded(
                  /// Cập nhật dữ liệu
                  child: Text(
                    S.current.posOfSale_updateData,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: "setting_printer",
            child: Row(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.settings,
                    color: Colors.green,
                  ),
                ),
                Expanded(
                  child: Text(
                    /// Cấu hình in
                    S.current.printConfiguration,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: "close_pos_order",
            child: Row(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.exit_to_app,
                    color: Colors.green,
                  ),
                ),
                Expanded(
                  /// Đóng phiên
                  child: Text(
                    S.current.posOfSale_closeSession,
                  ),
                ),
              ],
            ),
          ),
        ],
        icon: const Icon(Icons.more_vert),
        onSelected: (value) async {
          await _vm.updateInfoMoneyCart(
              _controllerDiscount.text, true); // save thông tin giỏ hàng trước
          if (value == "close_pos_order") {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PosClosePointSalePage(
                        id: _vm.sessions[0].id,
                        companyId: widget.compaynyId,
                        userId: widget.userId,
                        pointSaleId: widget.id,
                      )),
            ).then((value) {
              Navigator.pop(context, value);
            });
          } else if (value == "update_data") {
            _vm.isLoadingData = true;
            getDataOnline(isUpdateData: false);
          } else if (value == "setting_printer") {
            Navigator.pushNamed(
              context,
              AppRoute.setting,
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PosInvoiceListPage(
                        id: _vm.sessions[0].id,
                        positon: _vm.positionCart,
                        viewModel: _vm,
                      )),
            ).then((value) async {
              _vm.getProductsForCart();
              // Thực hiện cấp nhật lấy lại thông tin của giỏ hàng
              _vm.discountMoneyCurrent = 0;
              await _vm.updateInfoMoneyCart(_controllerDiscount.text, false);
              if (_vm.showReduceMoney) {
                _vm.showReduceMoney = !_vm.showReduceMoney;
                _vm.changeReduceMoney();
                _controllerDiscount.text =
                    vietnameseCurrencyFormat(_vm.discountMoney);
              } else if (_vm.showReduceMoneyCk) {
                _vm.showReduceMoneyCk = !_vm.showReduceMoneyCk;
                await _vm.changeReduceMoneyCK();
                _controllerDiscount.text =
                    vietnameseCurrencyFormat(_vm.discountMoneyCK);
              } else {
                _vm.showReduceMoneyOneInTwo = true;
                _vm.showReduceMoneyCKOneInTwo = false;
                _controllerDiscount.text = "0";
              }
            });
          }
        },
      );

  Widget _childPopupProduct(Lines item) => PopupMenuButton<int>(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,

            /// Chỉnh sửa sản phẩm
            child: Text(
              S.current.posOfSale_editProduct,
            ),
          ),
          const PopupMenuItem(
            value: 2,
            child: Text(
              "Copy",
            ),
          ),
        ],
        icon: Icon(
          Icons.more_vert,
          color: Colors.grey[500],
          size: 19,
        ),
        onSelected: (value) async {
          if (value == 2) {
            _vm.copyProductCart(item);
          }
          if (value == 1) {
            _buildDialogEditProduct(context, item);
          }
        },
      );

  Widget _buildContent() {
    _focusDiscount.addListener(() {
      if (_focusDiscount.hasFocus) {
        _controllerDiscount.selection = TextSelection(
            baseOffset: 0, extentOffset: _controllerDiscount.text.length);
      }
    });

    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(bottom: 52, top: 3),
          decoration: const BoxDecoration(color: Color(0xFFEBEDEF)),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate([
                  _showDanhSachSanPham(),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PosPartnerListPage(
                                  partner: _vm.partner,
                                )),
                      ).then((value) {
                        if (value != null) {
                          if (value.name != null) {
                            _vm.partner = value;
                          } else {
                            _vm.partner = null;
                          }
                        }
                      });
                    },
                    child: Container(
                        margin: const EdgeInsets.only(top: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        height: 55,
                        color: Colors.white,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  const Icon(Icons.person,
                                      color: Color(0xFF28A745)),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(S.current.partner)
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Expanded(
                                      child: Text(
                                    "${_vm.partner?.name ?? ""} ",
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700),
                                  )),
                                  Visibility(
                                    visible: _vm.partner?.name != null,
                                    child: InkWell(
                                      onTap: () {
                                        _vm.partner = Partners();
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
                  ),
                  const Divider(
                    height: 0.5,
                    color: Color(0xFFEBEDEF),
                  ),
                  Visibility(
                    visible: !(_vm.posConfig?.ifaceDiscount == false &&
                        _vm.posConfig?.ifaceDiscountFixed == false),
                    child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        height: 55,
                        color: Colors.white,
                        child: Row(
                          children: <Widget>[
                            Visibility(
                              visible: _vm.showReduceMoneyOneInTwo,
                              child: const Icon(Icons.monochrome_photos,
                                  color: Color(0xFF28A745)),
                            ),
                            Visibility(
                              visible: _vm.showReduceMoneyCKOneInTwo,
                              child: const Icon(Icons.unarchive,
                                  color: Color(0xFF28A745)),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Visibility(
                                visible: _vm.showReduceMoneyOneInTwo,
                                child: Text(S.current.posOfSale_discountFixed)),
                            Visibility(
                                visible: _vm.showReduceMoneyCKOneInTwo,
                                child:
                                    Text("${S.current.posOfSale_discount}(%)")),
                            const SizedBox(
                              width: 8,
                            ),
                            Visibility(
                              visible: _vm.posConfig.ifaceDiscount ?? false,
                              child: InkWell(
                                onTap: () async {
                                  await _vm.changeReduceMoneyCK();
                                  if (_vm.showReduceMoneyCk) {
                                    _controllerDiscount.text =
                                        vietnameseCurrencyFormat(
                                            _vm.discountMoneyCK);
                                    _vm.updateDiscountMoneyCurrent(
                                        _controllerDiscount.text);
                                  } else {
                                    _controllerDiscount.text = "0";
                                    _vm.updateDiscountMoneyCurrent("0");
                                  }
                                },
                                child: Container(
                                  width: 45,
                                  height: 25,
                                  decoration: BoxDecoration(
                                      color: !_vm.showReduceMoneyCk
                                          ? const Color(0xFFF0F1F3)
                                          : const Color(0xFF28A745),
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Center(
                                    child: Text(
                                      "%",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: !_vm.showReduceMoneyCk
                                            ? Colors.grey[700]
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Visibility(
                              visible:
                                  _vm.posConfig.ifaceDiscountFixed ?? false,
                              child: InkWell(
                                onTap: () {
                                  _vm.changeReduceMoney();
                                  if (_vm.showReduceMoney) {
                                    _controllerDiscount.text =
                                        vietnameseCurrencyFormat(
                                            _vm.discountMoney);
                                    _vm.updateDiscountMoneyCurrent(
                                        _controllerDiscount.text);
                                  } else {
                                    _controllerDiscount.text = "0";
                                    _vm.updateDiscountMoneyCurrent("0");
                                  }
                                },
                                child: Container(
                                  width: 45,
                                  height: 25,
                                  decoration: BoxDecoration(
                                      color: _vm.showReduceMoney
                                          ? const Color(0xFF28A745)
                                          : const Color(0xFFF0F1F3),
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Center(
                                    child: Text(
                                      "đ",
                                      style: TextStyle(
                                          color: _vm.showReduceMoney
                                              ? Colors.white
                                              : Colors.grey[700],
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Expanded(
                                    child: TextField(
                                      enabled: !(!_vm.showReduceMoneyCk &&
                                          !_vm.showReduceMoney),
                                      focusNode: _focusDiscount,
                                      controller: _controllerDiscount,
                                      textAlign: TextAlign.end,
                                      decoration: const InputDecoration(
                                        hintText: "0",
                                      ),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        // FilteringTextInputFormatter.digitsOnly,
                                        NumberInputFormat.vietnameDong(),
                                      ],
                                      onChanged: (value) {
                                        _vm.updateDiscountMoneyCurrent(value);
                                      },
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        )),
                  ),
                  const Divider(
                    height: 0.5,
                    color: Color(0xFFEBEDEF),
                  ),
                  Visibility(
                    visible: _vm.posConfig?.ifaceTax ?? false,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PosPointSaleListTaxPage()),
                        ).then((value) {
                          _vm.tax = value;
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
                                    const Icon(Icons.monetization_on,
                                        color: Color(0xFF28A745)),
//                                        Image.asset(
//                                          "images/ic_tax.png",
//                                          height: 26,
//                                          width: 26,
//                                          color: Color(0xFF28A745),
//                                        ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(S.current.posOfSale_tax)
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      _vm.tax?.name ?? "",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(
                                      width: 8,
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
                    ),
                  ),
                  const Divider(
                    height: 0.5,
                    color: Color(0xFFEBEDEF),
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      height: 55,
                      color: Colors.white,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                const Icon(Icons.card_giftcard,
                                    color: Color(0xFF28A745)),
                                const SizedBox(
                                  width: 8,
                                ),

                                /// Khuyến mãi
                                Text(S.current.posOfSale_promotions)
                              ],
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                _vm.handlePromotion();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  const Icon(
                                    Icons.add,
                                    size: 19,
                                    color: Color(0xFF28A745),
                                  ),
                                  Text(
                                    S.current.posOfSale_add,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF28A745),
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ))
                ]),
              ),
            ],
          ),
        ),
//        _buildButtonAddProduct(),
        _buildButtonTinhTien()
      ],
    );
  }

  Widget _buildBtnAddCart() {
    return Container(
        margin: const EdgeInsets.only(left: 2),
        height: 53,
        width: 50,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  offset: const Offset(-2, 2),
                  color: Colors.grey[300],
                  blurRadius: 2)
            ],
            borderRadius: BorderRadius.circular(3),
            color: const Color(0xFF28A745)),
        child: Center(
          child: FlatButton(
            onPressed: () async {
              await _vm.updateInfoMoneyCart(_controllerDiscount.text,
                  true); // save thông tin giỏ hàng trước
              await _vm.addCart(true);
              await _vm.updateInfoMoneyCart(_controllerDiscount.text, false,
                  isNoDeleteCart:
                      true); // get thông tin giỏ hàng mới tạo(Xử lý thông tin về chiết khấu và thuế sẵn)
              /// Kiểm tra nếu cả 2 phương thức đều true(Thêm giỏ hàng ko cần set phương thức),nếu 1 true 1 false (thêm giỏ hàng phải chọn đúng phương thức mở)
              if (_vm.posConfig?.ifaceDiscountFixed != true ||
                  _vm.posConfig?.ifaceDiscount != true) {
                if (_vm.posConfig?.ifaceDiscountFixed == true) {
                  _vm.showReduceMoney = true;
                  _vm.showReduceMoneyCk = false;
                  _vm.showReduceMoneyOneInTwo = true;
                  _vm.showReduceMoneyCKOneInTwo = false;
                } else {
                  _vm.showReduceMoney = false;
                  _vm.showReduceMoneyCk = true;
                  _vm.showReduceMoneyCKOneInTwo = true;
                  _vm.showReduceMoneyOneInTwo = false;
                }
              }
              if (_vm.showReduceMoney) {
                _controllerDiscount.text =
                    vietnameseCurrencyFormat(_vm.discountMoney);
              } else if (_vm.showReduceMoneyCk) {
                _controllerDiscount.text =
                    vietnameseCurrencyFormat(_vm.discountMoneyCK);
              } else {
                _controllerDiscount.text = "0";
              }
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ));
  }

  Widget _buildDeleteCart() {
    return Container(
      margin: const EdgeInsets.only(left: 12),
      height: 53,
      width: 50,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                offset: const Offset(-2, 2),
                color: Colors.grey[300],
                blurRadius: 2)
          ],
          borderRadius: BorderRadius.circular(3),
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.blueGrey[200], Colors.blueGrey[200]]),
          //shape: BoxShape.circle,
          color: Colors.grey[300]),
      child: Center(
        child: FlatButton(
          onPressed: () async {
            _vm.getProductsForCart();
            if (_vm.lstLine.isNotEmpty) {
              if (_vm.positionCart != "-1") {
                final dialogResult = await showQuestion(
                    context: context,
                    title: S.current.delete,
                    message: S.current.posOfSale_confirmDeleteCart);
                if (dialogResult == DialogResultType.YES) {
                  await _vm.deleteMoneyCart(); // delete money cart ở giỏ cũ
                  await _vm.deleteCart(
                      isDelete:
                          true); // delte cart then update new position cart
                  await _vm.updateInfoMoneyCart(
                      _controllerDiscount.text, false); // get position new cart
                  if (_vm.showReduceMoney) {
                    _controllerDiscount.text =
                        vietnameseCurrencyFormat(_vm.discountMoney);
                  } else if (_vm.showReduceMoneyCk) {
                    _controllerDiscount.text =
                        vietnameseCurrencyFormat(_vm.discountMoneyCK);
                  } else {
                    _controllerDiscount.text = "0";
                  }
                }
              }
            } else {
              await _vm.deleteMoneyCart(); // delete money cart ở giỏ cũ
              await _vm.deleteCart(isDelete: true);
              await _vm.updateInfoMoneyCart(
                  _controllerDiscount.text, false); // get position new cart
              if (_vm.showReduceMoney) {
                _vm.showReduceMoney = !_vm.showReduceMoney;
                _vm.changeReduceMoney();
                _controllerDiscount.text =
                    vietnameseCurrencyFormat(_vm.discountMoney);
              } else if (_vm.showReduceMoneyCk) {
                _vm.showReduceMoneyCk = !_vm.showReduceMoneyCk;
                await _vm.changeReduceMoneyCK();
                _controllerDiscount.text =
                    vietnameseCurrencyFormat(_vm.discountMoneyCK);
              } else {
                _controllerDiscount.text = "0";
              }
            }
          },
          child: const Icon(
            Icons.remove,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildButtonTinhTien() {
    return Positioned(
      bottom: 6,
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 12,
          ),
          Container(
            padding: const EdgeInsets.only(right: 12, left: 8),
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
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: FlatButton(
                          onPressed: () async {
                            // Save money card
                            await _vm.updateInfoMoneyCart(
                                _controllerDiscount.text, true);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PosPaymentPrintPage(
                                        partner: _vm.partner,
                                        tax: _vm.tax,
                                        position: _vm.positionCart,
                                        amountTotal: _vm.cartAmountTotal(),
                                        numProduct: _vm.lstLine.length,
                                        applicationUserId:
                                            _vm.applicationUserID,
                                        userId: widget.userId,
                                      )),
                            ).then((value) async {
                              if (value != null) {
                                if (value is Partners) {
                                } else {
                                  await _vm.deleteCart(
                                      cart: value[0],
                                      isDelete: false,
                                      checkInvoice: value[1]);
                                  await _vm.countInvoicePayment();
                                }
                              }
//                            Thực hiện cấp nhật lấy lại thông tin của giỏ hàng
                              _vm.discountMoneyCurrent = 0;
                              await _vm.updateInfoMoneyCart(
                                  _controllerDiscount.text, false);
                              if (_vm.showReduceMoney) {
                                _controllerDiscount.text =
                                    vietnameseCurrencyFormat(_vm.discountMoney);
                              } else if (_vm.showReduceMoneyCk) {
                                _controllerDiscount.text =
                                    vietnameseCurrencyFormat(
                                        _vm.discountMoneyCK);
                              } else {
                                _controllerDiscount.text = "0";
                              }

                              /// thực hiện gán partner khi chọn bên thanh toán
                              if (value != null) {
                                if (value is Partners) {
                                  _vm.partner = value;
                                }
                              }
                            });
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(S.current.posOfSale_payment,
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white)),
                              const SizedBox(
                                width: 8,
                              ),
                              RichText(
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                    text:
                                        "${vietnameseCurrencyFormat(_vm.showReduceMoney ? _vm.amountTotalReduceMoney() : _vm.amountTotalReduceMoneyCK())} đ",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ]),
                              ),
                            ],
                          )),
                    ),
                    InkWell(
                      onTap: () {
                        _buildBottomSheetOption(context);
                      },
                      child: Container(
                        height: 45,
                        width: 50,
                        decoration: const BoxDecoration(
                            color: Color(0xFF54B86B),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(6),
                                bottomRight: Radius.circular(6))),
                        child: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItemCart() {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _vm.childCarts.length,
        itemBuilder: (context, index) {
          return _showItemCart(_vm.childCarts[index], index);
        });
  }

  Widget _showItemCart(StateCart item, int index) {
    return Container(
      margin: const EdgeInsets.only(left: 2),
      decoration: BoxDecoration(
          color: _vm.childCarts[index].check == 0
              ? const Color(0xFFEBEDEF)
              : Colors.white,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(1), topRight: Radius.circular(1)),
          boxShadow: const <BoxShadow>[
            BoxShadow(offset: Offset(-1, 1), blurRadius: 1, color: Colors.grey)
          ]),
      height: 40,
      width: _vm.childCarts[index].check == 0 ? 60 : 90,
      child: Center(
        child: FlatButton(
          padding: const EdgeInsets.all(0),
          onPressed: () async {
            await _vm.updateInfoMoneyCart(_controllerDiscount.text,
                true); // save thông tin giỏ hàng trước
            await _vm.handleCheckCart(index);
            await _vm.updateInfoMoneyCart(_controllerDiscount.text, false);
            if (_vm.showReduceMoney) {
              _vm.showReduceMoney = !_vm.showReduceMoney;
              _vm.changeReduceMoney();
              _controllerDiscount.text =
                  vietnameseCurrencyFormat(_vm.discountMoney);
            } else if (_vm.showReduceMoneyCk) {
              _vm.showReduceMoneyCk = !_vm.showReduceMoneyCk;
              await _vm.changeReduceMoneyCK();
              _controllerDiscount.text =
                  vietnameseCurrencyFormat(_vm.discountMoneyCK);
            } else {
              _controllerDiscount.text = "0";
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "${S.current.posOfSale_cart}: ${_vm.childCarts[index].position}",
                style: TextStyle(
                    color: _vm.childCarts[index].check == 0
                        ? Colors.grey
                        : const Color(0xFF484D54),
                    fontSize: 16),
                textAlign: TextAlign.center,
              ),
              Visibility(
                visible: _vm.childCarts[index].check != 0,
                child: Text(
                  DateFormat('HH:mm').format(
                      DateTime.parse(_vm.childCarts[index]?.time).toLocal()),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showDanhSachSanPham() {
    return Container(
      height: 300,
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(offset: Offset(0, 2), blurRadius: 2, color: Color(0xFFEBEDEF))
      ]),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: _vm.lstLine.isEmpty
                  ? _buildEmptyProduct()
                  : ListView.builder(
                      controller: _scrollController,
                      addRepaintBoundaries: false,
                      addAutomaticKeepAlives: false,
                      itemCount: _vm.lstLine.length,
                      itemBuilder: (context, index) {
                        return _showItemPro(_vm.lstLine[index], index);
                      }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _showItemPro(Lines item, int index) {
    const space = SizedBox(
      height: 4,
    );
    return Dismissible(
      background: Container(
        color: Colors.green,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                S.current.deleteALine,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            const Icon(
              Icons.delete_forever,
              color: Colors.red,
              size: 30,
            )
          ],
        ),
      ),
      direction: DismissDirection.endToStart,
      key: UniqueKey(),
      confirmDismiss: (direction) async {
        final dialogResult = await showQuestion(
            context: context,
            title: S.current.delete,
            message:
                "${S.current.posOfSale_confirmDeleteProduct} ${item.productName ?? ""}");
        if (dialogResult == DialogResultType.YES) {
          final result = await _vm.deleteProductCart(item);
          if (result) {
            _vm.removeProduct(item);
            _vm.showNotifyDeleteProduct();
            return result;
          } else {
            return result;
          }
        } else {
          return false;
        }
      },
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.only(left: 4),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                      height: 41,
                      width: 41,
                      child: item.image == null || item.image == ""
                          ? Image.asset("images/no_image.png")
                          : Image.network(
                              item.image ?? "",
                            )),
                  const SizedBox(
                    width: 6,
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                item.productName ?? "",
                                style: const TextStyle(
                                    color: Color(0xFF484D54), fontSize: 15),
                              ),
                              space,
                              Text(
                                item.uomName ?? "",
                                style:
                                    const TextStyle(color: Color(0xFF9CA2AA)),
                              ),
                              space,
                              Text(
                                vietnameseCurrencyFormat(item.priceUnit),
                                style: const TextStyle(
                                    color: Color(0xFF484D54),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                              Visibility(
                                  visible: item.discount != 0, child: space),
                              Visibility(
                                visible: item.discount != 0,
                                child: Row(
                                  children: <Widget>[
                                    Image.asset(
                                      "images/ic_percent.png",
                                      width: 17,
                                      height: 17,
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Expanded(
                                      /// Chiết khấu
                                      child: Text(
                                        "${S.current.posOfSale_discount} ${vietnameseCurrencyFormat(item.discount)}%",
                                        style: const TextStyle(
                                            fontFamily: "fonts/timesi.ttf",
                                            color: Color(0xFF28A745),
                                            fontSize: 14),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              space,
                              Visibility(
                                visible:
                                    !(item.note == "" || item.note == null),
                                child: Text(
                                  "*${item.note}",
                                  style:
                                      const TextStyle(color: Color(0xFF9CA2AA)),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                _vm.decrementQty(index);
                              },
                              child: Container(
                                width: 38,
                                height: 38,
                                child: Center(
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                        color: const Color(0xFF28A745),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: const Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Text(
                              "${item.qty}",
                              style: const TextStyle(fontSize: 17),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            InkWell(
                              onTap: () {
                                _vm.incrementQty(index);
                              },
                              child: Container(
                                height: 38,
                                width: 38,
                                child: Center(
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                        color: const Color(0xFF28A745),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 17,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: _childPopupProduct(item),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(
                height: 1,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _buildDialogEditProduct(BuildContext context, Lines item) {
    _controllerGhiChu.text = item.note;
    _controllerSoLuong.text = item.qty.toString();
    _controllerDonGia.text =
        vietnameseCurrencyFormat(item.priceUnit).toString();
    _controllerChietKhau.text = item.discount.floor().toString();
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
            S.current.posOfSale_editProduct,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6)),
                        child: item.image == null
                            ? Image.asset("images/no_image.png")
                            : Image.network(
                                item.image ?? "",
                              )),
                    const SizedBox(
                      width: 6,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(item.productName ?? ""),
                          Text("${S.current.unit}: ${item.uomName ?? ""}"),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      "${S.current.posOfSale_quantity}:",
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 16),
                    )),
                    const SizedBox(
                      width: 8,
                    ),
                    Container(
                      width: 120,
                      child: _formThongTin(
                          controller: _controllerSoLuong,
                          isGhiChu: false,
                          focusNode: _focusSoLuong),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  children: <Widget>[
                    Expanded(

                        /// Giá bán
                        child: Text(
                      "${S.current.posOfSale_price}:",
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 16),
                    )),
                    const SizedBox(
                      width: 8,
                    ),
                    Container(
                      width: 120,
                      child: _formThongTin(
                          controller: _controllerDonGia,
                          isGhiChu: false,
                          focusNode: _focusDonGia),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  children: <Widget>[
                    Expanded(

                        /// Chiết khấu
                        child: Text(
                      "${S.current.posOfSale_discount}:",
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 16),
                    )),
                    const SizedBox(
                      width: 8,
                    ),
                    Container(
                      width: 120,
                      child: _formThongTin(
                          controller: _controllerChietKhau,
                          isGhiChu: false,
                          focusNode: _focusChietKhau),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Visibility(
                    visible: _vm.posConfig.ifaceOrderlineNotes,
                    child: _formThongTin(
                        controller: _controllerGhiChu, isGhiChu: true))
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(S.current.cancel.toUpperCase()),
              onPressed: () {
                Navigator.of(context).pop(DialogResultType.CANCEL);
              },
            ),
            FlatButton(
              child: Text(S.current.confirm.toUpperCase()),
              onPressed: () {
                updateInfoProduct(item);
                Navigator.of(context).pop(DialogResultType.YES);
              },
            ),
          ],
        );
      },
    );
  }

  void updateInfoProduct(Lines line) {
    line.qty = int.parse(_controllerSoLuong.text.replaceAll(".", ""));
    line.discount = double.parse(_controllerChietKhau.text.replaceAll(".", ""));
    line.priceUnit = double.parse(_controllerDonGia.text.replaceAll(".", ""));
    line.note = _controllerGhiChu.text;
    _vm.updateProductCart(line, true);
  }

  Widget _formThongTin(
      {TextEditingController controller, bool isGhiChu, FocusNode focusNode}) {
    //controller.text = value;
    if (!isGhiChu) {
      focusNode.addListener(() {
        if (focusNode.hasFocus) {
          controller.selection = TextSelection(
              baseOffset: 0, extentOffset: controller.text.length);
        }
      });
    }
    return isGhiChu
        ? TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: S.current.posOfSale_notes,
            ),
          )
        : TextField(
            textAlign: TextAlign.right,
            controller: controller,
            decoration: const InputDecoration(
              hintText: "",
            ),
            focusNode: focusNode,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly,
              NumberInputFormat.vietnameDong(),
            ],
          );
  }

  void _buildBottomSheetOption(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(18),
                    topLeft: Radius.circular(18))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(
                  height: 6,
                ),
                ListTile(
                  leading: Icon(
                    Icons.print,
                    color: Colors.grey[400],
                  ),
                  title: Text(S.current.confirm),
                  onTap: () async {
                    Navigator.pop(context);
                    final bool result = await _vm.addInfoPayment(
                        context: context, userId: widget.userId);
                    if (result) {
                      _vm.updateDiscountMoneyCurrent("0");
                      // Thực hiện cấp nhật lấy lại thông tin của giỏ hàng
                      await _vm.updateInfoMoneyCart(
                          _controllerDiscount.text, false);
                      if (_vm.showReduceMoney) {
                        _controllerDiscount.text =
                            vietnameseCurrencyFormat(_vm.discountMoney);
                      } else if (_vm.showReduceMoneyCk) {
                        _controllerDiscount.text =
                            vietnameseCurrencyFormat(_vm.discountMoneyCK);
                      } else {
                        _controllerDiscount.text = "0";
                      }
                    }
                  },
                ),
                const SizedBox(
                  height: 16,
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
                          borderRadius: BorderRadius.circular(3)),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: FlatButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  // Save money card
                                  await _vm.updateInfoMoneyCart(
                                      _controllerDiscount.text, true);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PosPaymentPrintPage(
                                              partner: _vm.partner,
                                              tax: _vm.tax,
                                              position: _vm.positionCart,
                                              amountTotal:
                                                  _vm.cartAmountTotal(),
                                              numProduct: _vm.lstLine.length,
                                              applicationUserId:
                                                  _vm.applicationUserID,
                                              userId: widget.userId,
                                            )),
                                  ).then((value) async {
                                    if (value != null) {
                                      if (value is Partners) {
                                      } else {
                                        await _vm.deleteCart(
                                            cart: value[0],
                                            isDelete: false,
                                            checkInvoice: value[1]);
                                        await _vm.countInvoicePayment();
                                      }
                                    }
//                            Thực hiện cấp nhật lấy lại thông tin của giỏ hàng
                                    _vm.discountMoneyCurrent = 0;
                                    await _vm.updateInfoMoneyCart(
                                        _controllerDiscount.text, false);
                                    if (_vm.showReduceMoney) {
                                      _controllerDiscount.text =
                                          vietnameseCurrencyFormat(
                                              _vm.discountMoney);
                                    } else if (_vm.showReduceMoneyCk) {
                                      _controllerDiscount.text =
                                          vietnameseCurrencyFormat(
                                              _vm.discountMoneyCK);
                                    } else {
                                      _controllerDiscount.text = "0";
                                    }

                                    /// thực hiện gán partner khi chọn bên thanh toán
                                    if (value != null) {
                                      if (value is Partners) {
                                        _vm.partner = value;
                                      }
                                    }
                                  });
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    /// Thanh toán
                                    Text(S.current.posOfSale_payment,
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.white)),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    RichText(
                                      text: TextSpan(children: <TextSpan>[
                                        TextSpan(
                                          text:
                                              "${vietnameseCurrencyFormat(_vm.showReduceMoney ? _vm.amountTotalReduceMoney() : _vm.amountTotalReduceMoneyCK())} đ",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ]),
                                    ),
                                  ],
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 45,
                              width: 50,
                              decoration: const BoxDecoration(
                                  color: Color(0xFF54B86B),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(6),
                                      bottomRight: Radius.circular(6))),
                              child: const Icon(
                                Icons.arrow_drop_up,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                )
              ],
            ),
          );
        });
  }

  Widget _buildEmptyProduct() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PosProductListPage(_vm.positionCart, _vm.filterProducts)),
        ).then((value) {
          _vm.getProductsForCart();
          _vm.updateDiscountMoneyCurrent(_controllerDiscount.text);
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            S.current.posOfSale_noProduct,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(
            height: 12,
          ),
          Badge(
            padding: const EdgeInsets.all(8),
            badgeColor: const Color(0xFF54B86B),
            badgeContent: const Text(
              "0",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            child: const Icon(
              Icons.shopping_cart,
              size: 68,
              color: Color(0xFFEBEDEF),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _vm.isLoadingData = widget.isLoadingData;
    if (_vm.isLoadingData) {
      getDataOnline(isUpdateData: true);
    } else {
      updateInfoPayment();
    }
  }

  Future<void> getDataOnline({bool isUpdateData}) async {
    _vm.lstLine = [];
    await _vm.configPos(widget.id);
    await _vm.getConfigForPos(widget.id);
    await _vm.getSession(widget.userId);
    await _vm.getProducts();
    await _vm.getPartners();
    await _vm.getPriceLists();
    await _vm.getAccountJournal();
    await _vm.getCompanies(widget.compaynyId);
    await _vm.getPointSaleTaxs();
    await _vm.countInvoicePayment();
    await _vm.getPriceList();

    // kiểm tra show giảm tiền cho giỏ hàng
    if (isUpdateData) {
      await updateInfoPayment();
    }
  }

  Future<void> updateInfoPayment() async {
    _vm.posConfig.ifaceDiscountFixed ??= false;
    _vm.posConfig.ifaceDiscount ??= false;
    if (_vm.posConfig.ifaceDiscountFixed != null &&
        _vm.posConfig.ifaceDiscount != null) {
      if (_vm.posConfig.ifaceDiscountFixed && !_vm.posConfig.ifaceDiscount) {
        _vm.showReduceMoneyCk = false;
        _vm.showReduceMoney = true;
        _vm.showReduceMoneyOneInTwo = true;
        _vm.showReduceMoneyCKOneInTwo = false;
      } else if (!_vm.posConfig.ifaceDiscountFixed &&
          !_vm.posConfig.ifaceDiscount) {
        _vm.showReduceMoneyCk = false;
        _vm.showReduceMoney = false;
        _vm.showReduceMoneyOneInTwo = false;
        _vm.showReduceMoneyCKOneInTwo = false;
      }
    }

    await _vm.updateInfoMoneyCart(_controllerDiscount.text, false);
    if (_vm.showReduceMoney) {
      _vm.showReduceMoney = !_vm.showReduceMoney;
      _vm.changeReduceMoney();
      _controllerDiscount.text = vietnameseCurrencyFormat(_vm.discountMoney);
    } else if (_vm.showReduceMoneyCk) {
      _vm.showReduceMoneyCk = !_vm.showReduceMoneyCk;
      await _vm.changeReduceMoneyCK();
      _controllerDiscount.text = vietnameseCurrencyFormat(_vm.discountMoneyCK);
    } else {
      _vm.showReduceMoneyOneInTwo = true;
      _vm.showReduceMoneyCKOneInTwo = false;
      _controllerDiscount.text = "0";
    }

    // kiểm tra nếu cả 2 phương thức đều tắt thì chiết khấu và giảm tiền bằng 0
    if (_vm.posConfig?.ifaceDiscountFixed != true ||
        _vm.posConfig?.ifaceDiscount != true) {
      _controllerDiscount.text = "0";
      _vm.discountMoneyCurrent = 0;
    }
  }
}
