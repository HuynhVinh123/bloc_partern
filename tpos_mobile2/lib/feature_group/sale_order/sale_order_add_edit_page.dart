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
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class SaleOrderAddEditPage extends StatefulWidget {
  const SaleOrderAddEditPage({
    this.editOrder,
    this.saleOnlineIds,
    this.partnerId,
    this.onEditCompleted,
    this.isCopy,
  });

  final SaleOrder editOrder;
  final List<String> saleOnlineIds;
  final int partnerId;
  final Function(SaleOrder) onEditCompleted;
  final bool isCopy;

  @override
  _SaleOrderAddEditPageState createState() => _SaleOrderAddEditPageState();
}

class _SaleOrderAddEditPageState extends State<SaleOrderAddEditPage> {
  final SaleOrderAddEditViewModel _vm = SaleOrderAddEditViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _defaultBox = BoxDecoration(
      borderRadius: BorderRadius.circular(7), color: Colors.white);
  final _defaultSizebox = const SizedBox(
    height: 10,
  );

  bool isSale;

  Future _selectPatner() async {
    final partner = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => const PartnerSearchPage(
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
      /// Chưa có sản phẩm
      /// Thêm 1 hoặc nhiều sản phẩm để tiếp tục
      showWarning(
          context: context,
          title: S.current.noProduct,
          message: S.current.purchaseOrder_addProduct);
      return;
    }

    if (_vm.partner == null) {
      /// Bạn cần phải chọn một khách hàng
      /// Chưa chọn khách hàng!
      showWarning(
          context: context,
          title: S.current.purchaseOrder_partnerEmpty,
          message: S.current.purchaseOrder_choosePartner);
      return;
    }

    if (isDraft) {
      final bool isSuccess = await _vm.saveDraftCommand();

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
        final confirmOk = await showQuestion(
            context: context,
            title: S.current.confirm,
            message: S.current.purchaseOrder_confirmOrder);
        if (confirmOk != OldDialogResult.Yes) {
          return;
        }
      } else {
        final confirmOk = await showQuestion(
            context: context,
            title: S.current.confirm,
            message: S.current.purchaseOrder_confirmSaveOrder);
        if (confirmOk != OldDialogResult.Yes) {
          return;
        }
      }

      final bool isSuccess = await _vm.saveAndConfirmCommand();
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
    final product = await Navigator.push(
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
          /// Xác nhận đóng
          return await confirmClosePage(context,
              title: S.current.close,
              message: S.current.posOfSale_confirmBackProduct);
        },
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          key: _scaffoldKey,
          appBar: AppBar(
            title: ScopedModelDescendant<SaleOrderAddEditViewModel>(
              builder: (context, child, model) => Text(widget.isCopy == true

                  /// Thêm đơn đặt hàng
                  ? S.current.purchaseOrder_addPurchaseOrder
                  : _vm.order?.name ?? ""),
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
                                _save(true, false);
                              },
                        textColor: Colors.white,
                        icon: const Icon(Icons.save),
                        label: widget.editOrder != null
                            ? Text(S.current.save.toUpperCase())
                            : Text(S.current.draft.toUpperCase()),
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
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        if (isSale && !_vm.isCopy)
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.orange),
                                color: Colors.orange.shade100),
                            padding: const EdgeInsets.all(10),
                            child: Center(
                              ///Đơn đặt hàng đã xác nhận. Chỉ chỉnh sửa được ghi chú
                              child: Text(
                                S.current.purchaseOrder_notifyCannotEdit,
                                style: const TextStyle(color: Colors.red),
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
                          /// Bảng giá
                          hint: Text(S.current.priceList),
                          onChanged: (value) {
                            _vm.priceList = value;
                          },
                          value: _vm.priceList,
                          items: _vm.priceLists
                              ?.map(
                                (f) => DropdownMenuItem<ProductPrice>(
                                  value: f,
                                  child: Text(f.name ?? ""),
                                ),
                              )
                              ?.toList(),
                          isExpanded: true,
                          underline: const SizedBox(),
                        ),
                      ),
                      Container(
                        width: 1,
                        color: Colors.grey.shade200,
                        height: 30,
                      ),
                      FlatButton.icon(
                        icon: const Icon(
                          Icons.search,
                          color: Colors.green,
                        ),
                        label: Text(
                          S.current.searchProduct,
                          style:
                              const TextStyle(color: Colors.blue, fontSize: 14),
                        ),
                        onPressed: () async {
                          if (_vm.partner == null) {
                            showWarning(
                                title: S.current.purchaseOrder_partnerEmpty,
                                context: context,
                                message: S.current.purchaseOrder_choosePartner);
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
                                  title: S.current.purchaseOrder_partnerEmpty,
                                  context: context,
                                  message:
                                      S.current.purchaseOrder_choosePartner);
                              return;
                            }
                            try {
                              final result = await BarcodeScanner.scan();
                              if (result != null && result.rawContent != null) {
                                _findProduct(keyword: result.rawContent);
                              }
                            } on PlatformException catch (e) {
                              if (e.code == BarcodeScanner.cameraAccessDenied) {
                                /// Không có quyền sử dụng camera
                                showError(
                                    context: context,
                                    title: S.current.permission,
                                    message: S.current.settingPermission);
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
                                  message: S.current.pleaseTryToAgain);
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
            const Divider(),
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
            Text(
              S.current.partner,
            )
          ],
        ),
        title: Text(
          _vm.partner?.name ?? S.current.choosePartner,
          textAlign: TextAlign.right,
          style: Theme.of(context).textTheme.subtitle,
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: isSale == false || _vm.isCopy
            ? () async {
                if (_vm.partner != null) {
                  //Đã chọn khách hàng rồi. hiện menu chọn sửa, thay đổi...

                  showDialog(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        contentPadding: const EdgeInsets.only(
                            left: 10, right: 10, top: 20, bottom: 20),
                        children: <Widget>[
                          Container(
                            child: Column(
                              children: <Widget>[
                                /// Tên khách hàng
                                Text(
                                  _vm.partner.name ?? "",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.green, fontSize: 20),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),

                                /// SĐT
                                Text(
                                  "${S.current.phone}: ${_vm.partner.phone ?? ""}",
                                  textAlign: TextAlign.center,
                                ),

                                /// Địa chỉ
                                Text(
                                  "${S.current.address}: ${_vm.partner.street ?? ""}",
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
                                  child: Text(S.current.purchaseOrder_editInfo),
                                  color: Colors.green,
                                  textColor: Colors.white,
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _editPatner();
                                  },
                                ),
                                RaisedButton(
                                  textColor: Colors.white,
                                  color: Colors.green,

                                  /// Thay đôi
                                  child: Text(S.current.purchaseOrder_change),
                                  onPressed: _vm.cantChangePartner
                                      ? () {
                                          Navigator.pop(context);
                                          _selectPatner();
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
      padding: const EdgeInsets.only(left: 16, right: 0, bottom: 8),
      decoration: _defaultBox,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(Icons.map),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                /// "Thông tin khác
                child: Text(
                  S.current.purchaseOrder_otherInfo,
                  style: const TextStyle(
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
                        editVm: _vm,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_right),
                label: Text(S.current.edit),
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
                      /// Ngày HĐ   Người bán
                      return Text(
                          "${S.current.purchaseOrder_dateInvoice} : ${DateFormat("dd/MM/yyyy").format(_vm.order.dateOrder)} | ${S.current.purchaseOrder_employee}: ${_vm.user?.name ?? "[Chưa có]"}");
                    } else {
                      return const SizedBox();
                    }
                  }),

                  /// Ghi chú
                  Text("${S.current.note}: ${_vm.order?.note ?? ""}"),
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
        padding: const EdgeInsets.only(left: 16, right: 0, bottom: 8),
        decoration: _defaultBox.copyWith(
            color: _vm.cantEditPayment ? Colors.white : Colors.transparent),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                const Icon(Icons.payment),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  /// Thông tin thanh toán
                  child: Text(
                    S.current.paymentInformation,
                    style: const TextStyle(
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
                            editVm: _vm,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.arrow_right),
                    label: Text(S.current.edit),
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
                          /// Phương thức thanh toán
                          Text("${S.current.paymentMethod}: "),
                          Text(
                            _vm.paymentJournal?.name ?? "",
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("${S.current.depositAmount}: "),
                          Text(
                            vietnameseCurrencyFormat(
                                _vm.order.amountDeposit ?? 0),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("${S.current.totalAmount}: "),
                          Text(
                            vietnameseCurrencyFormat(_vm.total ?? 0),
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
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
    if (_vm.orderLines == null || _vm.orderLines.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        child: GestureDetector(
          child: Container(
            height: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.orange.shade100),
                color: Colors.orange.shade50),
            padding:
                const EdgeInsets.only(left: 5, right: 10, top: 10, bottom: 5),
            child: Center(
              child: Text(
                S.current.purchaseOrder_pressToAddProduct,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
          onTap: () async {
            if (_vm.partner == null) {
              showWarning(
                  title: S.current.purchaseOrder_partnerEmpty,
                  context: context,
                  message: S.current.purchaseOrder_choosePartner);
              return;
            }

            final ProductSearchDelegate dg = ProductSearchDelegate();
            final selectedProduct =
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
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _vm.orderLines.length,
        separatorBuilder: (context, index) {
          return const Divider();
        },
        itemBuilder: (context, index) {
          return _buildListProductItem(_vm.orderLines[index], index);
        },
      ),
    );
  }

  Widget _buildSummaryPanel() {
    return InfoRow(
      /// Tổng tiền
      title: Text(
        "${S.current.totalAmount.toUpperCase()}:",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      padding: const EdgeInsets.only(right: 5, bottom: 8, top: 8, left: 10),
      content: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Text(
          vietnameseCurrencyFormat(_vm.subTotal ?? 0),
          textAlign: TextAlign.right,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomMenu() {
    final theme = Theme.of(context);
    return Container(
      height: 45,
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: 8, top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: RaisedButton(
              padding: const EdgeInsets.all(0),
              color: theme.primaryColor,
              disabledColor: Colors.grey,
              textColor: Colors.white,
              child: Text(S.current.confirm.toUpperCase()),
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              onPressed: !_vm.isValidToConfirm
                  ? null
                  : () async {
                      const bool isValid = true;
                      const bool isConfirm = true;
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
    const TextStyle itemTextStyle = TextStyle(color: Colors.black);
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
                  S.current.deleteALine,
                  style: itemTextStyle.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              const Icon(
                Icons.delete_forever,
                color: Colors.red,
                size: 40,
              )
            ],
          ),
        ),
        confirmDismiss: (direction) async {
          final dialogResult = await showQuestion(
              context: context,
              title: S.current.delete,
              message:
                  "${S.current.quotation_doYouWantToDeleteProduct} ${item.productName}?");

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
    const TextStyle itemTextStyle = TextStyle(color: Colors.black);
    return ListTile(
      contentPadding:
          const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
      title: RichText(
        text: TextSpan(
          text: "",
          style: itemTextStyle.copyWith(color: Colors.green),
          children: [
            TextSpan(
              text: item.productNameGet ?? item.productName ?? "",
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
                vietnameseCurrencyFormat(item.priceUnit ?? 0),
                style: itemTextStyle.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 1,
              child: Builder(
                builder: (ctxt) {
                  if (item.discount > 0) {
                    return Text(
                        " (${S.current.purchaseOrder_reduce} ${item.discount}%) ");
                  } else if ((item.discountFixed ?? 0) > 0) {
                    return Text(
                        " (${S.current.purchaseOrder_reduce} ${vietnameseCurrencyFormat(item.discountFixed)}) ");
                  } else {
                    return const SizedBox();
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
                        const SizedBox(
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
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: SizedBox(
                            //width: double.infinity,
                            child: Material(
                              color: Colors.white,
                              child: OutlineButton(
                                color: Colors.white,
                                borderSide: const BorderSide(
                                    width: 0, style: BorderStyle.none),
                                child: Text(
                                  vietnameseCurrencyFormat(
                                      item.productUOMQty ?? 0),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () async {},
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const SizedBox(
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
