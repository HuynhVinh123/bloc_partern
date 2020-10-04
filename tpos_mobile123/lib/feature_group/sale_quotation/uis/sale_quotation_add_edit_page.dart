import 'package:badges/badges.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/category/partner_list_page.dart';
import 'package:tpos_mobile/feature_group/category/product_search_page.dart';

import 'package:tpos_mobile/feature_group/sale_order/sale_order_user_page.dart';
import 'package:tpos_mobile/feature_group/sale_quotation/viewmodel/sale_quotation_add_edit_viewmodel.dart';
import 'package:tpos_mobile/helpers/app_helper.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/order_line.dart';

import 'package:tpos_mobile/src/tpos_apis/models/sale_quotation_detail.dart';

class SaleQuotationAddEditPage extends StatefulWidget {
  SaleQuotationAddEditPage(
      {this.saleQuotationDetail,
      this.orderLines,
      this.isCopy = false,
      this.quotationId});

  final SaleQuotationDetail saleQuotationDetail;
  final List<OrderLines> orderLines;
  final bool isCopy;
  final int quotationId;
  @override
  _SaleQuotationAddEditPageState createState() =>
      _SaleQuotationAddEditPageState();
}

class _SaleQuotationAddEditPageState extends State<SaleQuotationAddEditPage> {
  TextEditingController _controllerNote;
  var _vm = locator<SaleQuotationAddEditViewModel>();

  TextEditingController _controllerSoLuong = TextEditingController();
  TextEditingController _controllerDonGia = TextEditingController();
  TextEditingController _controllerChietKhau = TextEditingController();
  TextEditingController _controllerDescription = TextEditingController();

  FocusNode _focusSoLuong = FocusNode();
  FocusNode _focusDonGia = FocusNode();
  FocusNode _focusChietKhau = FocusNode();
  FocusNode _focusNote = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ViewBase<SaleQuotationAddEditViewModel>(
        model: _vm,
        builder: (context, model, _) {
          return WillPopScope(
              onWillPop: () async {
                if (_vm.isChangeData) {
                  return await confirmClosePage(context,
                      title: "Xác nhận đóng",
                      message:
                          "Các thông tin thay đổi chưa được lưu sẽ bị mất!");
                } else {
                  return true;
                }
              },
              child: Scaffold(
                backgroundColor: Colors.grey[100],
                appBar: AppBar(
                  title: widget.saleQuotationDetail == null
                      ? Text("Thêm thông tin báo giá")
                      : Text("Sửa thông tin báo giá"),
                  actions: <Widget>[
                    InkWell(
                      onTap: () {
                        if (_vm.partner?.name == null) {
                          _vm.showNotify("Bạn chưa chọn khách hàng!");
                        } else {
                          if (_vm.orderLines.length == 0) {
                            _vm.showNotify("Hãy thêm sản phẩm!");
                          } else {
                            if (widget.saleQuotationDetail != null) {
                              _vm.updateInfoQuotation(
                                  _controllerNote.text, context, false, true);
                            } else {
                              _vm.updateInfoQuotation(
                                  _controllerNote.text, context, false, false);
                            }
                          }
                        }
                      },
                      child: Row(
                        children: <Widget>[
                          Text("Lưu"),
                          SizedBox(
                            width: 6,
                          ),
                          Icon(Icons.save),
                          SizedBox(
                            width: 12,
                          )
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.more_vert),
                      onPressed: () {
                        _buildBottomSheetOption(context);
                      },
                    )
                  ],
                ),
                body: SafeArea(
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 60,
                        child: ListView(
//                      crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _buildInfoSale(),
                            Container(
                              margin: EdgeInsets.only(
                                  left: 12, right: 12, top: 6, bottom: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5)),
                              child: ExpansionTile(
                                initiallyExpanded: true,
                                title: RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Danh sách sản phẩm',
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Color(0xFF28A745),
                                            fontWeight: FontWeight.w600),
                                      ),
                                      TextSpan(
                                          text:
                                              _vm.saleQuotationDetail?.state ==
                                                      "draft"
                                                  ? ""
                                                  : ' (Không được phép sửa)',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600))
                                    ],
                                  ),
                                ),
                                children: <Widget>[
                                  _showAddProduct(),
                                  if (_vm.orderLines.isEmpty)
                                    Container(
                                        color: Colors.white,
                                        width: double.infinity,
                                        height: 210,
                                        child:
                                            Center(child: _buildEmptyProduct()))
                                  else
                                    Container(
                                        margin: const EdgeInsets.only(
                                            top: 12, bottom: 12),
                                        padding: const EdgeInsets.only(
                                            left: 12,
                                            right: 12,
                                            top: 6,
                                            bottom: 6),
                                        color: Colors.white,
                                        child: _buildListItem()),
                                  Visibility(
                                    visible: _vm.orderLines.isNotEmpty,
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          top: 8, bottom: 8),
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(5),
                                              bottomLeft: Radius.circular(5))),
                                      child: Row(
                                        children: <Widget>[
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Text("Tổng tiền:",
                                              style: TextStyle(
                                                  color: Colors.grey[900],
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16)),
                                          Expanded(
                                            child: Text(
                                                "${vietnameseCurrencyFormat(_vm.amountTotalPayment())}",
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18)),
                                          ),
                                          SizedBox(
                                            width: 28,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _buildInfoBaseQuotation(),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 24,
                        left: 24,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xFF28A745),
                              borderRadius: BorderRadius.circular(4)),
                          child: FlatButton(
                            child: Text(
                                _vm.saleQuotationDetail?.state == "draft"
                                    ? "Đánh dấu báo giá"
                                    : "Lưu",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17)),
                            onPressed: () {
                              if (_vm.partner?.name == null) {
                                _vm.showNotify("Bạn chưa chọn khách hàng!");
                              } else {
                                if (_vm.orderLines.length == 0) {
                                  _vm.showNotify("Hãy thêm sản phẩm!");
                                } else {
                                  if (_vm.saleQuotationDetail?.state ==
                                      "draft") {
                                    if (widget.saleQuotationDetail != null) {
                                      _vm.updateInfoQuotation(
                                          _controllerNote.text,
                                          context,
                                          true,
                                          true);
                                    } else {
                                      _vm.updateInfoQuotation(
                                          _controllerNote.text,
                                          context,
                                          true,
                                          false);
                                    }
                                  } else {
                                    if (widget.saleQuotationDetail != null) {
                                      _vm.updateInfoQuotation(
                                          _controllerNote.text,
                                          context,
                                          false,
                                          true);
                                    } else {
                                      _vm.updateInfoQuotation(
                                          _controllerNote.text,
                                          context,
                                          false,
                                          false);
                                    }
                                  }
                                }
                              }
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ));
        });
  }

  Widget _showAddProduct() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(color: Colors.grey[200]),
              top: BorderSide(color: Colors.grey[200]))),
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () {
                if (_vm.saleQuotationDetail?.state == "draft") {
                  if (_vm.partner.name != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductSearchPage(),
                      ),
                    ).then((value) {
                      if (value != null) {
                        _vm.isChangeData = true;
                        _vm.setDataForProduct(value);
                      }
                    });
                  } else {
                    _vm.showNotify("Bạn chưa chọn khách hàng!");
                  }
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(right: BorderSide(color: Colors.grey[200]))),
                height: 40,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 12,
                    ),
                    Icon(
                      Icons.add,
                      color: Color(0xFF28A745),
                      size: 20,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Hero(
                          tag: "search",
                          child: Text(
                            "Thêm sản phẩm",
                            style: TextStyle(
                                color: Colors.grey[700], fontSize: 15),
                          )),
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 40,
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.grey[200]))),
            child: Center(
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'SL:',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500),
                    ),
                    TextSpan(
                        text: ' ${_vm.orderLines.length} ',
                        style: TextStyle(
                            color: Colors.lightBlue,
                            fontWeight: FontWeight.w600,
                            fontSize: 17)),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 12,
          ),
          InkWell(
            onTap: () async {
              if (_vm.saleQuotationDetail?.state == "draft") {
                if (_vm.partner.name != null) {
                  final barcode = await BarcodeScanner.scan();
                  if (barcode != null && barcode.rawContent != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductSearchPage(
                          keyword: barcode.rawContent,
                        ),
                      ),
                    ).then((value) {
                      if (value != null) {
                        _vm.isChangeData = true;
                        _vm.setDataForProduct(value);
                      }
                    });
                  }
                } else {
                  _vm.showNotify("Bạn chưa chọn khách hàng!");
                }
              }
            },
            child: Image.asset(
              "images/scan_barcode.png",
              width: 40,
              height: 25,
              color: Color(0xFF28A745),
            ),
          ),
          SizedBox(
            width: 12,
          ),
        ],
      ),
    );
  }

  void _buildDialogEditProduct(
      BuildContext context, OrderLines item, int index) {
    _controllerSoLuong.text = item.productUOMQty.floor().toString();
    _controllerDonGia.text = vietnameseCurrencyFormat(item.priceUnit);
    _controllerChietKhau.text = item.discount.toString();
    _controllerNote.text = item.description;
    _controllerDescription.text = item.name;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding: EdgeInsets.only(bottom: 12, top: 12),
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              width: 0,
            ),
          ),
          title: new Text(
            "Chỉnh sửa sản phẩm",
            style: TextStyle(color: Colors.red),
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
                        margin: EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6)),
                        child: item.imageUrl == null
                            ? Image.asset("images/no_image.png")
                            : Image.network(
                                "${item.imageUrl}",
                              )),
                    Expanded(child: Text("${item.nameGet ?? ""}")),
                    SizedBox(
                      width: 8,
                    ),
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      "Số lượng:",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    )),
                    Container(
                      width: 120,
                      margin: EdgeInsets.only(left: 8),
                      child: _formThongTin(
                          controller: _controllerSoLuong,
                          isGhiChu: false,
                          focusNode: _focusSoLuong,
                          suffix: item.productUOMName),
                    ),
                  ],
                ),
                SizedBox(
                  height: 6,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      "Giá bán:",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    )),
                    Container(
                      width: 120,
                      margin: EdgeInsets.only(left: 8),
                      child: _formThongTin(
                          controller: _controllerDonGia,
                          isGhiChu: false,
                          focusNode: _focusDonGia,
                          suffix: "đ"),
                    ),
                  ],
                ),
                SizedBox(
                  height: 6,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      "Chiết khấu:",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    )),
                    Container(
                      width: 120,
                      margin: EdgeInsets.only(left: 8),
                      child: _formThongTin(
                          controller: _controllerChietKhau,
                          isGhiChu: false,
                          focusNode: _focusChietKhau,
                          suffix: "%"),
                    ),
                  ],
                ),
                SizedBox(
                  height: 2,
                ),
                Visibility(
                    visible: true,
                    child: _formThongTin(
                        controller: _controllerDescription, isGhiChu: true))
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("HỦY BỎ"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("XÁC NHẬN"),
              onPressed: () {
                _vm.isChangeData = true;
                Navigator.pop(context);
                updateInfoProduct(item, index);
              },
            ),
          ],
        );
      },
    );
  }

  void updateInfoProduct(OrderLines item, int index) {
    item.productUOMQty = _controllerSoLuong.text == ""
        ? item.productUOMQty
        : double.parse(_controllerSoLuong.text.replaceAll(".", ""));
    item.priceUnit = _controllerDonGia.text == ""
        ? item.priceUnit
        : double.parse(_controllerDonGia.text.replaceAll(".", ""));
    item.discount = _controllerChietKhau.text == ""
        ? item.discount
        : double.parse(_controllerChietKhau.text.replaceAll(".", "")) > 100 ||
                double.parse(_controllerChietKhau.text.replaceAll(".", "")) < 0
            ? item.discount
            : double.parse(_controllerChietKhau.text.replaceAll(".", ""));
    item.name = _controllerDescription.text;
    _vm.updateInfoProduct(item, index);
  }

  Widget _formThongTin(
      {TextEditingController controller,
      bool isGhiChu,
      FocusNode focusNode,
      String suffix}) {
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
              labelText: "Mô tả",
            ),
          )
        : TextField(
            textAlign: TextAlign.right,
            controller: controller,
            decoration:
                InputDecoration(hintText: "", suffix: Text("($suffix)")),
            focusNode: focusNode,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly,
              NumberInputFormat.vietnameDong(),
            ],
          );
  }

  Widget _buildInfoBaseQuotation() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey[300], offset: Offset(0, 1), blurRadius: 1)
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 4, left: 4),
            child: Text(
              "Thông tin:",
              style: TextStyle(
                  color: Color(0xFF28A745),
                  fontWeight: FontWeight.w600,
                  fontSize: 17),
            ),
          ),
          _buildInfoDetail(),
        ],
      ),
    );
  }

  Widget _buildInfoDetail() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 16,
        ),
        Container(
            margin: EdgeInsets.only(bottom: 15, top: 15),
            padding: EdgeInsets.symmetric(horizontal: 8),
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Icon(Icons.star_border, color: Color(0xFF28A745)),
                SizedBox(
                  width: 8,
                ),
                Text("Trạng thái"),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                          child: Text(
                        "${_vm.saleQuotationDetail?.state == "draft" ? "Báo giá" : "Báo giá đã gửi"}",
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Color(0xFF28A745)),
                      )),
                      SizedBox(
                        width: 5,
                      )
                    ],
                  ),
                )
              ],
            )),
        Divider(
          height: 0.5,
          color: Colors.grey[300],
        ),
        SizedBox(
          height: 4,
        ),
        Row(
          children: <Widget>[
            SizedBox(
              width: 8,
            ),
            Icon(Icons.style, color: Color(0xFF28A745)),
            SizedBox(
              width: 8,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Điều khoản thanh toán:"),
                Container(
                    margin: EdgeInsets.only(right: 3),
                    height: 25,
                    child: _itemDown())
              ],
            ))
          ],
        ),
        SizedBox(
          height: 4,
        ),
        Divider(
          height: 0.5,
          color: Colors.grey[300],
        ),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: _vm.dateQuotation,
              lastDate: DateTime(2100),
            );
            if (date != null) {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(_vm.dateQuotation != null
                    ? DateTime.now()
                    : _vm.dateQuotation),
              );
              _vm.isChangeData = true;
              _vm.setDateTimeQuotation(DateTimeField.combine(date, time));
            }
          },
          child: Container(
//              margin: EdgeInsets.only(top: 6),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Icon(Icons.date_range, color: Color(0xFF28A745)),
                  SizedBox(
                    width: 8,
                  ),
                  Text("Ngày báo giá"),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "${DateFormat("dd-MM-yyyy HH:mm").format(_vm.dateQuotation)}",
                        textAlign: TextAlign.right,
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 13,
                    color: Colors.grey[300],
                  ),
                ],
              )),
        ),
        Divider(
          height: 0.5,
          color: Colors.grey[300],
        ),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
                context: context,
                firstDate: DateTime(1900),
                initialDate: _vm.validityDate == null
                    ? DateTime.now()
                    : _vm.validityDate,
                lastDate: DateTime(2100));
            if (date != null) {
              _vm.isChangeData = true;
              _vm.setValidityDate(date);
            }
          },
          child: Container(
//              margin: EdgeInsets.only(top: 6),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Icon(Icons.date_range, color: Color(0xFF28A745)),
                  SizedBox(
                    width: 8,
                  ),
                  Text("Ngày hết hạn"),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "${_vm.validityDate == null ? "<Chọn ngày>" : DateFormat("dd-MM-yyyy").format(_vm.validityDate)}",
                        textAlign: TextAlign.right,
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _vm.validityDate != null,
                    child: InkWell(
                      onTap: () {
                        _vm.setValidityDate(null);
                      },
                      child: Container(
                        width: 30,
                        height: 15,
                        child: Center(
                          child: Icon(
                            Icons.clear,
                            size: 19,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 13,
                    color: Colors.grey[300],
                  ),
                ],
              )),
        ),
        Divider(
          height: 0.5,
          color: Colors.grey[300],
        ),
        Container(
//            margin: EdgeInsets.only(top: 6),
            padding: EdgeInsets.symmetric(horizontal: 8),
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Icon(Icons.note, color: Color(0xFF28A745)),
                Expanded(child: _buildInfoContent("Ghi chú", _controllerNote))
              ],
            )),
      ],
    );
  }

  DropdownButton _itemDown() {
    return DropdownButton<String>(
        style: TextStyle(
            fontWeight: FontWeight.w700, color: Colors.grey[800], fontSize: 16),
        items: _vm.accountPaymentTerms
            .map((value) => DropdownMenuItem<String>(
                  value: "${value.id}",
                  child: Text(
                    "${value.name}",
                  ),
                ))
            .toList(),
        onChanged: (value) {
          _vm.isChangeData = true;
          _vm.selectAccountPaymentTerm = value;
        },
        value: "${_vm.selectAccountPaymentTerm}",
        isExpanded: true,
        underline: SizedBox());
  }

  Widget _buildInfoContent(String hintText, TextEditingController controller) {
    return Container(
        margin: EdgeInsets.only(left: 8, right: 12),
        child: TextField(
          focusNode: _focusNote,
          controller: controller,
          decoration:
              InputDecoration(labelText: "$hintText", border: InputBorder.none),
          onChanged: (value) {
            _vm.isChangeData = true;
          },
        ));
  }

  Widget _buildListItem() {
    return ListView.builder(
        reverse: true,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _vm.orderLines.length,
        itemBuilder: (BuildContext context, int index) {
          return _showItem(item: _vm.orderLines[index], index: index);
        });
  }

  Widget _showItem({OrderLines item, int index}) {
    return Dismissible(
      background: Container(
        color: Colors.green,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                "Xóa dòng này?",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            Icon(
              Icons.delete_forever,
              color: Colors.white,
              size: 30,
            ),
            SizedBox(
              width: 36,
            )
          ],
        ),
      ),
      direction: DismissDirection.endToStart,
      key: UniqueKey(),
      confirmDismiss: (direction) async {
        if (_vm.saleQuotationDetail?.state == "draft") {
          var dialogResult = await showQuestion(
              context: context,
              title: "Xác nhận xóa",
              message: "Bạn có muốn xóa sản phẩm ${item.productName ?? ""}");
          if (dialogResult == DialogResultType.YES) {
            _vm.isChangeData = true;
            _vm.orderLines.remove(item);
            return true;
          } else {
            return false;
          }
        } else {
          return false;
        }
      },
      onDismissed: (value) {
        setState(() {});
      },
      child: InkWell(
        onTap: () {
          if (_vm.saleQuotationDetail?.state == "draft") {
            _buildDialogEditProduct(context, item, index);
          }
        },
        child: Container(
          margin: EdgeInsets.only(top: 8),
          padding: EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[300]))),
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text("${item.nameGet ?? ""}",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600)),
                subtitle: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      "${vietnameseCurrencyFormat(item.priceUnit)}",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[800],
                                  )),
                            ],
                          ),
                        )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                if (_vm.saleQuotationDetail?.state == "draft") {
                                  _vm.decrementQty(index);
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Colors.grey[300])),
                                width: 30,
                                height: 30,
                                margin: EdgeInsets.only(right: 12),
                                child: Center(
                                  child: Icon(
                                    Icons.remove,
                                    color: Colors.grey,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              "${item.productUOMQty.floor()} ",
                              style: TextStyle(fontSize: 17),
                            ),
                            InkWell(
                              onTap: () {
                                if (_vm.saleQuotationDetail?.state == "draft") {
                                  _vm.incrementQty(index);
                                }
                              },
                              child: Container(
                                height: 30,
                                margin: EdgeInsets.only(left: 12),
                                width: 30,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Colors.grey[300])),
                                child: Center(
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.grey,
                                    size: 17,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: <Widget>[
                        Text("CK: ${item.discount} %"),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          ' ${vietnameseCurrencyFormat(_vm.amountTotal(item))}',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyProduct() {
    return InkWell(
      onTap: () {
        if (_vm.saleQuotationDetail?.state == "draft") {
          if (_vm.partner.name != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductSearchPage(),
              ),
            ).then((value) {
              if (value != null) {
                _vm.isChangeData = true;
                _vm.setDataForProduct(value);
              }
            });
          } else {
            _vm.showNotify("Bạn chưa chọn khách hàng!");
          }
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Chưa có sản phẩm nào!",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            height: 12,
          ),
          Badge(
            padding: EdgeInsets.all(8),
            badgeColor: Color(0xFF54B86B),
            badgeContent: Text(
              "0",
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600),
            ),
            child:
                Icon(Icons.shopping_cart, size: 68, color: Color(0xFFEBEDEF)),
          )
        ],
      ),
    );
  }

  Widget _buildInfoSale() {
    return Container(
        margin: EdgeInsets.only(bottom: 12, left: 12, right: 12, top: 12),
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[300], blurRadius: 1, offset: Offset(0, 0))
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              height: 0.5,
              color: Colors.grey[300],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 12),
              child: Text(
                "Thông tin bán hàng:",
                style: TextStyle(
                    color: Color(0xFF28A745),
                    fontWeight: FontWeight.w600,
                    fontSize: 17),
              ),
            ),
            InkWell(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => PartnerListPage(
                      isSearchMode: true,
                      isSupplier: false,
                    ),
                  ),
                ).then((value) async {
                  if (value != null) {
                    _vm.isChangeData = true;
                    _vm.partner = value;
                    await _vm.getPriceList();
                  }
                });
              },
              child: Container(
                  margin: EdgeInsets.only(top: 6),
                  padding:
                      EdgeInsets.only(left: 8, top: 16, bottom: 16, right: 4),
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.people, color: Color(0xFF28A745)),
                      SizedBox(
                        width: 8,
                      ),
                      Text("Khách hàng"),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                                child: Text(
                              "${_vm.partner?.name == null ? "<Chưa có>" : _vm.partner?.name}",
                              textAlign: TextAlign.right,
                              style: TextStyle(fontWeight: FontWeight.w700),
                            )),
                            SizedBox(
                              width: 6,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                              color: Colors.grey[300],
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
            ),
            Divider(
              height: 0.5,
              color: Colors.grey[300],
            ),
            InkWell(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SaleOrderUserPage(
                      isSearchMode: true,
                    ),
                  ),
                ).then((value) {
                  if (value != null) {
                    _vm.isChangeData = true;
                    _vm.applicationUser = value;
                  }
                });
              },
              child: Container(
                  padding:
                      EdgeInsets.only(left: 8, top: 16, bottom: 16, right: 4),
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.person, color: Color(0xFF28A745)),
                      SizedBox(
                        width: 8,
                      ),
                      Text("Người bán"),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                                child: Text(
                              " ${_vm.applicationUser?.name ?? "<Chưa có>"}",
                              textAlign: TextAlign.right,
                              style: TextStyle(fontWeight: FontWeight.w700),
                            )),
                            SizedBox(
                              width: 6,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                              color: Colors.grey[300],
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
            ),
          ],
        ));
  }

  void _buildBottomSheetOption(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(18),
                    topLeft: Radius.circular(18))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 6,
                ),
                ListTile(
                  leading: Icon(
                    Icons.explicit,
                    color: Colors.green,
                  ),
                  title: Text("Xuất Excel"),
                  onTap: () async {
                    if (widget.saleQuotationDetail != null) {
                      _vm.exportExcel(
                          widget.saleQuotationDetail.id.toString(), context);
                    }
                  },
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    await _vm.getAccountPaymentTerms();
    if (widget.saleQuotationDetail != null) {
      _vm.saleQuotationDetail = widget.saleQuotationDetail;
      _vm.orderLines = List<OrderLines>();
      _vm.orderLines = widget.orderLines;
    } else {
      if (widget.isCopy) {
        await _vm.getInfoSaleQuotation(widget.quotationId);
        await _vm.getOrderLines(widget.quotationId);
      } else {
        await _vm.getDefaultSaleQuotation();
      }
    }
    _controllerNote = TextEditingController(text: _vm.saleQuotationDetail.note);
    _vm.partner = _vm.saleQuotationDetail.partner == null
        ? Partner()
        : _vm.saleQuotationDetail.partner;
    _vm.applicationUser = _vm.saleQuotationDetail.user;
    _vm.selectAccountPaymentTerm = _vm.saleQuotationDetail.paymentTermId == null
        ? "0"
        : _vm.saleQuotationDetail.paymentTermId.toString();
    print(_vm.saleQuotationDetail?.dateQuotation);
    _vm.setDateTimeQuotation(
        DateFormat("yyyy-MM-ddTHH:mm:ss")
            .parse(DateTime.parse(_vm.saleQuotationDetail?.dateQuotation)
                .toLocal()
                .toIso8601String())
            .toLocal(),
        isFirstData: false);

    _vm.setValidityDate(_vm.saleQuotationDetail?.validityDate == null
        ? null
        : DateFormat("yyyy-MM-ddTHH:mm:ss")
            .parse(DateTime.parse(_vm.saleQuotationDetail?.validityDate)
                .toLocal()
                .toIso8601String())
            .toLocal());
  }
}
