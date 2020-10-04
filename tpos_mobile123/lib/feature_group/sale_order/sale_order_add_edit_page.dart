import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/ui_base/ui_vm_base.dart';

import 'package:tpos_mobile/feature_group/category/product_search_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/partner_add_edit_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/partner_search_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/product_search.dart';
import 'package:tpos_mobile/feature_group/sale_order/sale_order.dart';
import 'package:tpos_mobile/feature_group/sale_order/sale_order_add_edit_other_info_page.dart';
import 'package:tpos_mobile/feature_group/sale_order/sale_order_add_edit_payment_info_page.dart';
import 'package:tpos_mobile/feature_group/sale_order/sale_order_info_page.dart';
import 'package:tpos_mobile/feature_group/sale_order/sale_order_line.dart';
import 'package:tpos_mobile/feature_group/sale_order/sale_order_line_edit_page.dart';
import 'package:tpos_mobile/feature_group/sale_order/viewmodels/sale_order_add_edit_viewmodel.dart';

import 'package:tpos_mobile/helpers/helpers.dart';


import 'package:tpos_mobile/widgets/info_row.dart';
import 'package:tpos_mobile/widgets/number_input_left_right_widget.dart';
import 'package:flutter/services.dart';

class SaleOrderAddEditPage extends StatefulWidget {
  final SaleOrder editOrder;
  final List<String> saleOnlineIds;
  final int partnerId;
  final Function(SaleOrder) onEditCompleted;
  final bool isCopy;
  SaleOrderAddEditPage({
    this.editOrder,
    this.saleOnlineIds,
    this.partnerId,
    this.onEditCompleted,
    this.isCopy,
  });
  @override
  _SaleOrderAddEditPageState createState() => _SaleOrderAddEditPageState();
}

class _SaleOrderAddEditPageState extends State<SaleOrderAddEditPage> {
  SaleOrderAddEditViewModel _vm = SaleOrderAddEditViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _defaultBox = BoxDecoration(
      borderRadius: BorderRadius.circular(7), color: Colors.white);
  final _defaultSizebox = SizedBox(
    height: 10,
  );

  bool isSale;

  Future _selectPatner() async {
    var partner = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => PartnerSearchPage(
          isSearchMode: true,
          closeWhenDone: true,
        ),
      ),
    );

    if (partner != null) {
      _vm.selectPartnerCommand(partner);
    }
  }

  Future _editPatner() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => PartnerAddEditPage(
          partnerId: _vm.partner.id,
          closeWhenDone: true,
          onEditPartner: (result) {
            if (result.name != _vm.partner.name) {
              _vm.partner.name = result.name;
            }
            _vm.selectPartnerCommand(_vm.partner);
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    _vm.init(
        editOrder: widget.editOrder,
        saleOnlineIds: widget.saleOnlineIds,
        partnerId: widget.partnerId);

    _vm.initCommand();
    _vm.notifyPropertyChangedController.listen((f) {
      if (mounted) {
        setState(() {});
      }
    });

    _vm.dialogMessageController.listen((f) {
      registerDialogToView(context, f, scaffState: _scaffoldKey.currentState);
    });

    _vm.eventController.listen((event) {
      if (event.eventName == SaleOrderAddEditViewModel.EVENT_CLOSE_UI) {
        Navigator.pop(context);
      }
    });

    if (widget.editOrder != null)
      isSale = widget.editOrder.state == "sale";
    else {
      isSale = false;
    }

    _vm.isCopy = widget.isCopy;

    super.initState();
  }

  Future _save(bool isDraft, bool isPrint, {bool isConfirm = true}) async {
    if (_vm.orderLines == null || _vm.orderLines.isEmpty) {
      showWarning(
          context: context,
          title: "Chưa có sản phẩm!",
          message: "Thêm 1 hoặc nhiều sản phẩm để tiếp tục");
      return;
    }

    if (_vm.partner == null) {
      showWarning(
          context: context,
          title: "Chưa chọn khách hàng!",
          message: "Bạn cần phải chọn một khách hàng");
      return;
    }

    if (isDraft) {
      bool isSuccess = await _vm.saveDraftCommand();

      if (isSuccess) {
        if (isSuccess && widget.editOrder == null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SaleOrderInfoPage(_vm.order)));
        } else {
          // close
          Navigator.pop(context);
        }

        if (widget.onEditCompleted != null) {
          widget.onEditCompleted(_vm.order);
        }
      }
    } else {
      if (isConfirm) {
        var confirmOk = await showQuestion(
            context: context,
            title: "Xác nhận?",
            message: "Bạn muốn xác nhận đơn đặt hàng này?");
        if (confirmOk != OldDialogResult.Yes) {
          return;
        }
      } else {
        var confirmOk = await showQuestion(
            context: context,
            title: "Xác nhận?",
            message: "Bạn muốn lưu đơn đặt hàng này?");
        if (confirmOk != OldDialogResult.Yes) {
          return;
        }
      }

      bool isSuccess = await _vm.saveAndConfirmCommand();
      if (isSuccess) {
        if (isSuccess && widget.editOrder == null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SaleOrderInfoPage(_vm.order),
            ),
          );
        } else {
          // close
          Navigator.pop(context);
        }

        if (widget.onEditCompleted != null) {
          widget.onEditCompleted(_vm.order);
        }
      }
    }
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  Future _findProduct({String keyword}) async {
    var product = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductSearchPage(
          priceList: _vm.priceList,
          keyword: keyword,
        ),
      ),
    );

    if (product != null) {
      _vm.addOrderLineCommand(product);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<SaleOrderAddEditViewModel>(
      model: _vm,
      child: WillPopScope(
        onWillPop: () async {
          return await confirmClosePage(context,
              title: "Xác nhận đóng",
              message:
                  "Các thông tin chưa lưu sẽ bị xóa. Bạn có muốn đóng trang này?");
        },
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          key: _scaffoldKey,
          appBar: AppBar(
            title: ScopedModelDescendant<SaleOrderAddEditViewModel>(
              builder: (context, child, model) => Text(
                  "${widget.isCopy == true ? "Thêm đơn đặt hàng" : _vm.order?.name}"),
            ),
            actions: <Widget>[
              if (isSale == false || _vm.isCopy)
                StreamBuilder<bool>(
                    stream: _vm.isBusyController,
                    initialData: false,
                    builder: (context, snapshot) {
                      return FlatButton.icon(
                        onPressed: _vm.isBusy || !_vm.isValidToConfirm
                            ? null
                            : () {
                                this._save(true, false);
                              },
                        textColor: Colors.white,
                        icon: Icon(Icons.save),
                        label: widget.editOrder != null
                            ? Text("LƯU")
                            : Text("NHÁP"),
                      );
                    }),
            ],
          ),
          body: UIViewModelBase(
            viewModel: _vm,
            child: _buildBody(),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return ScopedModelDescendant<SaleOrderAddEditViewModel>(
      rebuildOnChange: true,
      builder: (ctx, sdl, slkd) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: ListView(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        if (isSale && !_vm.isCopy)
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.orange),
                                color: Colors.orange.shade100),
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Text(
                                "Đơn đặt hàng đã xác nhận. Chỉ chỉnh sửa được ghi chú",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                        _defaultSizebox,
                        _buildSelectedPartnerPanel(),
                        if (_vm.partner != null) ...[
                          _defaultSizebox,
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 0, right: 0, top: 0, bottom: 0),
                            child: _buildAddItemBar(),
                          )
                        ],
                        _defaultSizebox,
                        if (_vm.isPaymentInfoEnable)
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 0, right: 0, top: 0, bottom: 0),
                            child: _buildPaymentInfo(),
                          ),
//                      /_defaultSizebox,
                      ],
                    ),
                    _defaultSizebox,
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 0, right: 0, top: 0, bottom: 0),
                      child: _buildOrderInfoPanel(),
                    ),
                  ],
                ),
              ),
              if (_vm.canConfirm) _buildBottomMenu(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddItemBar() {
    return AbsorbPointer(
      absorbing: !_vm.cantEditProduct,
      child: Container(
        decoration: _defaultBox.copyWith(
            color: _vm.cantEditProduct ? Colors.white : Colors.grey.shade200),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 5, top: 5, right: 5),
              child: DecoratedBox(
                decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: Colors.grey.shade500)
                    //borderRadius: BorderRadius.circular(3),
                    ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: DropdownButton<ProductPrice>(
                          hint: Text("Chọn bảng giá"),
                          onChanged: (value) {
                            _vm.priceList = value;
                          },
                          value: _vm.priceList,
                          items: _vm.priceLists
                              ?.map(
                                (f) => DropdownMenuItem<ProductPrice>(
                                  value: f,
                                  child: Text("${f.name}"),
                                ),
                              )
                              ?.toList(),
                          isExpanded: true,
                          underline: SizedBox(),
                        ),
                      ),
                      Container(
                        width: 1,
                        color: Colors.grey.shade200,
                        height: 30,
                      ),
                      FlatButton.icon(
                        icon: Icon(
                          Icons.search,
                          color: Colors.green,
                        ),
                        label: Text(
                          "Tìm sản phẩm",
                          style: TextStyle(color: Colors.blue, fontSize: 14),
                        ),
                        onPressed: () async {
                          if (_vm.partner == null) {
                            showWarning(
                                title: "Chưa chọn khách hàng!",
                                context: context,
                                message: "Vui lòng chọn khách hàng trước");
                            return;
                          }

                          _findProduct();
                        },
                      ),
                      Container(
                        width: 1,
                        color: Colors.grey.shade200,
                        height: 30,
                      ),
                      SizedBox(
                        width: 50,
                        child: FlatButton(
                          child: SvgPicture.asset(
                            "images/barcode_scan.svg",
                            width: 30,
                            height: 30,
                          ),
                          onPressed: () async {
                            if (_vm.partner == null) {
                              showWarning(
                                  title: "Chưa chọn khách hàng!",
                                  context: context,
                                  message: "Vui lòng chọn khách hàng trước");
                              return;
                            }
                            try {
                              final result = await BarcodeScanner.scan();
                              if (result != null && result.rawContent != null) {
                                _findProduct(keyword: result.rawContent);
                              }
                            } on PlatformException catch (e) {
                              if (e.code == BarcodeScanner.cameraAccessDenied) {
                                showError(
                                    context: context,
                                    title: "Không có quyền sử dụng camera",
                                    message:
                                        "Vào cài đặt máy-> Ứng dụng-> Tpos Mobile và cho phép ứng dụng sử dụng camera");
                              } else {
//                  showError(
//                      context: context,
//                      title: "Chưa quét được mã vạch",
//                      message: "Vui lòng thử lại");
                              }
                            } on FormatException {
//                showError(
//                    context: context,
//                    title: "Định dạng không đọc được",
//                    message: "Vui lòng thử lại");
                            } catch (e) {
                              showError(
                                  context: context,
                                  title: "Chưa quét được mã vạch",
                                  message: "Vui lòng thử lại");
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _buildListProduct(),
            Divider(),
            _buildSummaryPanel(),
          ],
        ),
      ),
    );
  }

  /// Chọn khách hàng

  Widget _buildSelectedPartnerPanel() {
    return Container(
      decoration: _defaultBox,
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.people,
              color: Theme.of(context).iconTheme.color,
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              "Khách hàng",
            )
          ],
        ),
        title: Text(
          _vm.partner?.name ?? "Chọn khách hàng",
          textAlign: TextAlign.right,
          style: Theme.of(context).textTheme.subtitle,
        ),
        trailing: Icon(Icons.chevron_right),
        onTap: isSale == false || _vm.isCopy
            ? () async {
                if (_vm.partner != null) {
                  //Đã chọn khách hàng rồi. hiện menu chọn sửa, thay đổi...

                  showDialog(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        contentPadding: EdgeInsets.only(
                            left: 10, right: 10, top: 20, bottom: 20),
                        children: <Widget>[
                          Container(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "${_vm.partner.name}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 20),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "SĐT: ${_vm.partner.phone ?? ""}",
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  "Địa chỉ: ${_vm.partner.street ?? ""}",
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 50,
                            width: 50,
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                RaisedButton(
                                  child: Text("Sửa thông tin"),
                                  color: Colors.green,
                                  textColor: Colors.white,
                                  onPressed: () {
                                    Navigator.pop(context);
                                    this._editPatner();
                                  },
                                ),
                                RaisedButton(
                                  textColor: Colors.white,
                                  color: Colors.green,
                                  child: Text("Thay đổi"),
                                  onPressed: _vm.cantChangePartner
                                      ? () {
                                          Navigator.pop(context);
                                          this._selectPatner();
                                        }
                                      : null,
                                )
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  );
                  return;
                }
                _selectPatner();
              }
            : null,
      ),
    );
  }

  Widget _buildOrderInfoPanel() {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 0, bottom: 8),
      decoration: _defaultBox,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.map),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  "Thông tin khác",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              FlatButton.icon(
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => SaleOrderAddEditOtherInfoPage(
                        editVm: this._vm,
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.arrow_right),
                label: Text("Sửa"),
              )
            ],
          ),
          Builder(
            builder: (ctx) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Builder(builder: (ctx) {
                    if (_vm.order?.dateOrder != null) {
                      return Text(
                          "Ngày HD : ${DateFormat("dd/MM/yyyy").format(_vm.order.dateOrder)} | Người bán: ${_vm.user?.name ?? "[Chưa có]"}");
                    } else {
                      return SizedBox();
                    }
                  }),
                  Text("Ghi chú: ${_vm.order?.note ?? ""}"),
                ],
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildPaymentInfo() {
    return AbsorbPointer(
      absorbing: !_vm.cantEditPayment,
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 0, bottom: 8),
        decoration: _defaultBox.copyWith(
            color: _vm.cantEditPayment ? Colors.white : Colors.transparent),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(Icons.payment),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    "Thông tin thanh toán",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                if (isSale == false || _vm.isCopy)
                  FlatButton.icon(
                    textColor: Colors.blue,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => SaleOrderAddEditPaymentInfoPage(
                            editVm: this._vm,
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.arrow_right),
                    label: Text("Sửa"),
                  )
              ],
            ),
            Builder(
              builder: (ctx) {
                return Padding(
                  padding: const EdgeInsets.only(left: 0, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Phương thức thanh toán: "),
                          Text(
                            "${_vm.paymentJournal?.name ?? ""}",
                          )
                        ],
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Tiền cọc: "),
                          Text(
                            "${vietnameseCurrencyFormat(_vm.order.amountDeposit ?? 0)}",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Tổng tiền: "),
                          Text(
                            "${vietnameseCurrencyFormat(_vm.total ?? 0)}",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 3,
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  /// Danh sách hàng hóa/ sản phẩm
  Widget _buildListProduct() {
    if (_vm.orderLines == null || _vm.orderLines.length == 0) {
      return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        child: GestureDetector(
          child: Container(
            height: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.orange.shade100),
                color: Colors.orange.shade50),
            padding: EdgeInsets.only(left: 5, right: 10, top: 10, bottom: 5),
            child: Center(
              child: Text(
                "Chưa có sản phẩm nào trong danh sách. Nhấn 'Tìm sản phẩm' để thêm",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
          onTap: () async {
            if (_vm.partner == null) {
              showWarning(
                  title: "Chưa chọn khách hàng!",
                  context: context,
                  message: "Vui lòng chọn khách hàng trước");
              return;
            }

            ProductSearchDelegate dg = new ProductSearchDelegate();
            var selectedProduct =
                await showSearch(context: context, delegate: dg);
            if (selectedProduct != null) {
              _vm.addOrderLineCommand(selectedProduct);
            }
          },
        ),
      );
    }
    return Container(
      color: Colors.white,
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _vm.orderLines.length,
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemBuilder: (context, index) {
          return _buildListProductItem(_vm.orderLines[index], index);
        },
      ),
    );
  }

  Widget _buildSummaryPanel() {
    return InfoRow(
      title: Text(
        "CỘNG TIỀN:",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      padding: EdgeInsets.only(right: 5, bottom: 8, top: 8, left: 10),
      content: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Text(
          "${vietnameseCurrencyFormat(_vm.subTotal ?? 0)}",
          textAlign: TextAlign.right,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomMenu() {
    var theme = Theme.of(context);
    return Container(
      height: 45,
      margin: EdgeInsets.only(left: 12, right: 12, bottom: 8, top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: RaisedButton(
              padding: EdgeInsets.all(0),
              color: theme.primaryColor,
              disabledColor: Colors.grey,
              textColor: Colors.white,
              child: Text("XÁC NHẬN"),
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              onPressed: !_vm.isValidToConfirm
                  ? null
                  : () async {
                      bool isValid = true;
                      bool isConfirm = true;
                      if (isValid) {
                        _save(false, false,
                            isConfirm: isSale == false || _vm.isCopy
                                ? isConfirm
                                : !isConfirm);
                      }
                    },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListProductItem(SaleOrderLine item, [int index = 0]) {
    TextStyle itemTextStyle = new TextStyle(color: Colors.black);
    if (isSale == false || _vm.isCopy)
      return Dismissible(
        direction: DismissDirection.endToStart,
        key: Key("${item.id}_${item.productId}_${item.priceUnit}"),
        child: _buildListProductItemDetail(item, index),
        background: Container(
          color: Colors.green,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  "Xóa dòng này?",
                  style: itemTextStyle.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              Icon(
                Icons.delete_forever,
                color: Colors.red,
                size: 40,
              )
            ],
          ),
        ),
        confirmDismiss: (direction) async {
          var dialogResult = await showQuestion(
              context: context,
              title: "Xác nhận xóa",
              message: "Bạn có muốn xóa sản phẩm ${item.productName}?");

          if (dialogResult == OldDialogResult.Yes) {
            return true;
          } else {
            return false;
          }
        },
        onDismissed: (direction) {
          _vm.deleteOrderLineCommand(item);
        },
      );
    else {
      return _buildListProductItemDetail(item, index);
    }
  }

  Widget _buildListProductItemDetail(SaleOrderLine item, [int index = 0]) {
    TextStyle itemTextStyle = new TextStyle(color: Colors.black);
    return ListTile(
      contentPadding: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
      title: RichText(
        text: TextSpan(
          text: "",
          style: itemTextStyle.copyWith(color: Colors.green),
          children: [
            TextSpan(
              text: "${item.productNameGet ?? item.productName ?? ""}",
              style: itemTextStyle,
            ),
            TextSpan(
              text: " (${item.productUOMName})",
              style: itemTextStyle.copyWith(color: Colors.blue),
            )
          ],
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Text(
                "${vietnameseCurrencyFormat(item.priceUnit ?? 0)}",
                style: itemTextStyle.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 1,
              child: Builder(
                builder: (ctxt) {
                  if (item.discount > 0) {
                    return Text(" (Giảm ${item.discount}%) ");
                  } else if ((item.discountFixed ?? 0) > 0) {
                    return Text(
                        " (Giảm ${vietnameseCurrencyFormat(item.discountFixed)}) ");
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ),
            Expanded(
                flex: 1,
                child: Text(
                  "x",
                  style: itemTextStyle.copyWith(color: Colors.green),
                  textAlign: TextAlign.left,
                )),
            Expanded(
              flex: 2,
              child: isSale == false || _vm.isCopy
                  ? SizedBox(
                      child: NumberInputLeftRightWidget(
                        key: Key(item.id.toString()),
                        value: item.productUOMQty ?? 0,
                        fontWeight: FontWeight.bold,
                        onChanged: (value) {
                          setState(() {
                            _vm.changeProductQuantityCommand(item, value);
                          });
                        },
                      ),
                      height: 35,
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new SizedBox(
                          width: 30,
                          child: Material(
                            color: Colors.white,
                            child: OutlineButton(
                              onPressed: null,
                              color: Colors.white,
                              child: Icon(
                                Icons.remove,
                                size: 12,
                              ),
                              padding: EdgeInsets.all(0),
                            ),
                          ),
                        ),
                        new SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: new SizedBox(
                            //width: double.infinity,
                            child: Material(
                              color: Colors.white,
                              child: OutlineButton(
                                color: Colors.white,
                                borderSide: BorderSide(
                                    width: 0, style: BorderStyle.none),
                                child: Text(
                                  "${vietnameseCurrencyFormat(item.productUOMQty)}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                onPressed: () async {},
                              ),
                            ),
                          ),
                        ),
                        new SizedBox(
                          width: 5,
                        ),
                        new SizedBox(
                          width: 30,
                          child: Material(
                            color: Colors.white,
                            child: OutlineButton(
                              onPressed: null,
                              color: Colors.white,
                              child: Icon(
                                Icons.add,
                                size: 12,
                              ),
                              padding: EdgeInsets.all(0),
                            ),
                          ),
                        ),
                      ],
                    ),
            )
          ],
        ),
      ),
      onTap: () async {
        if (isSale == false || _vm.isCopy) {
          await Navigator.push(context,
              MaterialPageRoute(builder: (ctx) => SaleOrderLineEditPage(item)));
          _vm.calculateOrderLinePrice(item);
        }
      },
    );
  }
}
