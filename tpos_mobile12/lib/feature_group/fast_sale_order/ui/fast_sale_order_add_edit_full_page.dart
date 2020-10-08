/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 7/4/19 6:25 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 7/4/19 11:14 AM
 *
 */

import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/ui_base/ui_vm_base.dart';

import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/feature_group/category/partner_edit_address_page.dart';
import 'package:tpos_mobile/feature_group/category/partner_list_page.dart';
import 'package:tpos_mobile/feature_group/category/product_search_page.dart';
import 'package:tpos_mobile/feature_group/fast_sale_order/viewmodels/fast_sale_order_add_edit_full_viewmodel.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/partner_add_edit_page.dart';

import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/services/app_setting_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_sale_order.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_sale_order_line.dart';

import 'package:tpos_mobile/src/tpos_apis/tpos_api.dart';
import 'package:tpos_mobile/widgets/info_row.dart';
import 'package:tpos_mobile/widgets/my_step_view.dart';
import 'package:tpos_mobile/widgets/number_input_left_right_widget.dart';
import 'package:flutter/services.dart';
import 'package:tpos_mobile_localization/generated/l10n.dart';

import 'fast_sale_order_add_edit_full_other_info_page.dart';
import 'fast_sale_order_add_edit_full_payment_info_page.dart';

import 'fast_sale_order_add_edit_full_ship_address_page.dart';
import 'fast_sale_order_add_edit_full_ship_page.dart';
import 'fast_sale_order_info_page.dart';
import 'fast_sale_order_line_edit_page.dart';

class FastSaleOrderAddEditFullPage extends StatefulWidget {
  const FastSaleOrderAddEditFullPage(
      {this.editOrder,
      this.saleOnlineIds,
      this.partnerId,
      this.onEditCompleted});
  final FastSaleOrder editOrder;
  final List<String> saleOnlineIds;
  final int partnerId;
  final Function(FastSaleOrder) onEditCompleted;

  @override
  _FastSaleOrderAddEditFullPageState createState() =>
      _FastSaleOrderAddEditFullPageState();
}

class _FastSaleOrderAddEditFullPageState
    extends State<FastSaleOrderAddEditFullPage> {
  final _vm = locator<FastSaleOrderAddEditFullViewModel>();
  final _setting = locator<ISettingService>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _defaultBox = BoxDecoration(
      borderRadius: BorderRadius.circular(7), color: Colors.white);
  final _defaultSizebox = const SizedBox(
    height: 10,
  );

  /// Text có nội dung "Sửa"
  final Text _editText = Text(S.current.edit);

  Future _selectPatner() async {
    final partner = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => const PartnerListPage(
          isSearchMode: true,
          isSupplier: false,
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

  /// Đi tới màn hình sửa 'Đơn vị giao hàng và phí'
  void _handleNavigateToEditCarrier() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => FastSaleOrderAddEditFullShipInfoPage(
          editVm: _vm,
        ),
      ),
    );
  }

  /// Nhấn nút làm mới để chọn dịch vụ và mở màn hình chọn dịch vụ
  void _handleSelectServiceAndShowService() {
    _handleNavigateToEditCarrier();
    _vm.calculateDeliveryFee(isReCalculate: true);
  }

  /// Xử lý lưu và xác nhận đơn hàng
  /// Trước khi xác nhận thì kiểm tra các điều kiện như chưa chọn dịch vụ
  Future<void> _handleSaveAndConfirm(
      {bool isPrintShip = false,
      bool isPrintOrder = false,
      @required BuildContext context}) async {
    assert(context != null);
    // validate ui

    bool isValidate = true;

    /// Nếu đối tác giao hàng có dịch vụ
    if (_vm.carrier != null) {
      if (_vm.carrier.deliveryType.toLowerCase().contains("viettel") ||
          _vm.carrier.deliveryType.toLowerCase().contains("ghn") ||
          _vm.carrier.deliveryType.toLowerCase().contains('vnpost')) {
        if (_vm.carrierService == null) {
          isValidate = false;
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Chưa chọn dịch vụ'),
              content: const Text(
                  "Bạn chưa chọn dịch vụ cho đối tác giao hàng\n- Nhấn [Chọn dịch vụ] để lựa chọn sau đó hãy nhấn nút xác nhận lại"),
              actions: <Widget>[
                FlatButton(
                  child: const Text("Chọn dịch vụ"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _handleSelectServiceAndShowService();
                  },
                ),
                FlatButton(
                  child: const Text("Đóng"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        }
      }
    }

    if (!isValidate) {
      return;
    }

    _vm.saveAndConfirmCommand(
        isPrintOrder: isPrintOrder, isPrintShip: isPrintShip);
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

    /// subcribe view model event
    _vm.eventController.listen(
      (event) {
        if (event.eventName ==
                FastSaleOrderAddEditFullViewModel.SAVE_DRAFT_SUCCESS_EVENT ||
            event.eventName ==
                FastSaleOrderAddEditFullViewModel.SAVE_CONFIRM_SUCCESS_EVENT) {
          if (_setting.isShowInfoInvoiceAfterSaveFastSaleOrder &&
              _vm.editType == EditType.ADD_NEW) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => FastSaleOrderInfoPage(
                  order: FastSaleOrder(id: event.param),
                ),
              ),
            );
          } else {
            Navigator.of(context)?.pop();
          }
        } else if (event.eventName ==
            FastSaleOrderAddEditFullViewModel.REQUIRED_CLOSE_UI) {
          Navigator.pop(context);
        }
      },
    );

    // Listen event
    super.initState();
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<FastSaleOrderAddEditFullViewModel>(
      model: _vm,
      child: WillPopScope(
        onWillPop: () async {
          if (_vm.partner != null) {
            return await confirmClosePage(context,
                title: "Cảnh báo",
                message:
                    "Các thông tin bạn đã chỉnh sửa và chưa lưu sẽ bị xóa?");
          } else
            return true;
        },
        child: ScopedModelDescendant<FastSaleOrderAddEditFullViewModel>(
          builder: (context, child, model) => Scaffold(
            backgroundColor: Colors.grey.shade200,
            key: _scaffoldKey,
            appBar: AppBar(
              leading: const CloseButton(),
              backgroundColor: Colors.white,
              textTheme: const TextTheme(
                headline6: TextStyle(color: Colors.black, fontSize: 17),
              ),
              iconTheme: const IconThemeData(color: Colors.black54),
              title: Text(widget.editOrder?.number ?? "HĐ Mới"),
              actions: <Widget>[
                if (_vm.cantEditProduct)
                  Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                    padding: const EdgeInsets.only(left: 3, right: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.grey.shade100,
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Icon(
                            Icons.add,
                            color: Colors.green,
                          ),
                          InkWell(
                            child: const Text(
                              "Tìm sản phẩm",
                              style: TextStyle(color: Colors.blue),
                            ),
                            onTap: () {
                              _findProduct();
                            },
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 5, right: 0, top: 5, bottom: 5),
                            width: 1,
                            color: Colors.white,
                          ),
                          IconButton(
                            icon: SvgPicture.asset(
                              "images/barcode_scan.svg",
                              width: 22,
                              height: 22,
                              color: Colors.blue,
                            ),
                            onPressed: () async {
                              final result = await scanBarcode();
                              if (result.isError) {}
                              if (result.result != null &&
                                  result.result.isNotEmpty)
                                _findProduct(keyword: result.result);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                StreamBuilder<bool>(
                    stream: _vm.isBusyController,
                    initialData: false,
                    builder: (context, snapshot) {
                      return FlatButton.icon(
                        onPressed: _vm.isBusy || !_vm.isValidToConfirm
                            ? null
                            : () {
                                _vm.saveDraftCommand();
                              },
                        textColor: Colors.green,
                        icon: const Icon(
                          Icons.save,
                          color: Colors.green,
                        ),
                        label: Text(_vm.order?.id != null && _vm.order?.id != 0
                            ? S.current.save
                            : S.current.draft),
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
      ),
    );
  }

  Widget _buildBody() {
    return ScopedModelDescendant<FastSaleOrderAddEditFullViewModel>(
      rebuildOnChange: true,
      builder: (ctx, sdl, slkd) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 0, right: 0, top: 8, bottom: 0),
                      child: _buildSelectedPartnerPanel(),
                    ),

                    if (_vm.partner != null) ...[
                      _defaultSizebox,
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 0, right: 0, top: 0, bottom: 0),
                        child: _buildAddItemBar(context),
                      )
                    ],

                    if (_vm.isPaymentInfoEnable) ...[
                      _defaultSizebox,
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 0, right: 0, top: 0, bottom: 0),
                        child: _buildPaymentInfo(),
                      )
                    ],

                    // Panel địa chỉ nhận hàng
                    if (_vm.isShippingAddressEnable)
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 0, right: 0, top: 8, bottom: 0),
                        child: _buildShipingAddress(),
                      ),

                    // Panel giao hàng
                    if (_vm.isShippingCarrierEnable)
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 0, right: 0, top: 8, bottom: 0),
                        child: _buildSelectedDeliveryPanel(),
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
              _buildBottomMenu(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddItemBar(context) {
    print(_vm.priceLists.length);
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
                  border: Border.all(width: 0.5, color: Colors.grey.shade300),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(3),
                    topRight: Radius.circular(3),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(
                          height: 37,
                          child: DropdownButton<ProductPrice>(
                            hint: const Text("Chọn bảng giá"),
                            onChanged: (value) {
                              _vm.priceList = value;
                            },
                            value: _vm.priceLists.firstWhere(
                                (element) => element.id == _vm.priceList?.id,
                                orElse: () => null),
                            items: _vm.priceLists
                                ?.map(
                                  (f) => DropdownMenuItem<ProductPrice>(
                                    value: f,
                                    child: Text(f.name ?? ''),
                                  ),
                                )
                                ?.toList(),
                            isExpanded: true,
                            underline: const SizedBox(),
                          ),
                        ),
                      ),
                      Container(
                        width: 1,
                        color: Colors.grey.shade200,
                        height: 25,
                      ),
                      SizedBox(
                        height: 30,
                        child: FlatButton.icon(
                          icon: const Icon(
                            Icons.search,
                            color: Colors.green,
                          ),
                          label: const Text(
                            "Tìm SP",
                            style: TextStyle(color: Colors.blue),
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
                      ),
                      Container(
                        width: 1,
                        color: Colors.grey.shade200,
                        height: 25,
                      ),
                      SizedBox(
                        width: 50,
                        height: 30,
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
                              final barcode = await BarcodeScanner.scan();
                              if (barcode != null) {
                                _findProduct(keyword: barcode.rawContent);
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
      decoration: _defaultBox.copyWith(
          color: _vm.cantEditAndChangePartner
              ? Colors.white
              : Colors.grey.shade200),
      child: AbsorbPointer(
        absorbing: !_vm.cantEditAndChangePartner,
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
                S.current.customer,
              )
            ],
          ),
          title: Text(
            _vm.partner?.name ?? S.current.selectCustomer,
            textAlign: TextAlign.right,
          ),
          trailing: const Icon(Icons.chevron_right),
          subtitle: _vm.partner == null
              ? const SizedBox()
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Material(
                      color: getPartnerStatusColor(_vm.partner?.status),
                      type: MaterialType.button,
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(
                          _vm.partner?.statusText ?? "",
                          textAlign: TextAlign.right,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
          onTap: () async {
            if (_vm.partner != null) {
              //Đã chọn khách hàng rồi. hiện menu chọn sửa, thay đổi...

              showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.only(
                        left: 10, right: 10, top: 20, bottom: 20),
                    children: <Widget>[
                      Container(
                        child: Column(
                          children: <Widget>[
                            Text(
                              _vm.partner.name ?? '',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.green, fontSize: 20),
                            ),
                            const SizedBox(
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
                              child: const Text("Sửa thông tin"),
                              color: Colors.green,
                              textColor: Colors.white,
                              onPressed: !_vm.cantEditPartner
                                  ? null
                                  : () async {
                                      Navigator.pop(context);
                                      _editPatner();
                                    },
                            ),
                            RaisedButton(
                              textColor: Colors.white,
                              color: Colors.green,
                              child: const Text("Thay đổi"),
                              onPressed: !_vm.cantChangePartner
                                  ? null
                                  : () {
                                      Navigator.pop(context);
                                      _selectPatner();
                                    },
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
          },
        ),
      ),
    );
  }

  /// Địa chỉ giao hàng

  Widget _buildShipingAddress() {
    return AbsorbPointer(
      absorbing: !_vm.cantEditDeliveryAddress,
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 0, bottom: 8),
        decoration: _defaultBox.copyWith(
            color: _vm.cantEditDeliveryAddress
                ? Colors.white
                : Colors.grey.shade200),
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
                  child: Text(
                    S.current.shippingAddress,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                FlatButton.icon(
                  textColor: Colors.blue,
                  onPressed: () {
                    if (_vm.partner == null) {
                      showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: const Text("Chưa chọn khách hàng"),
                            content: const Text(
                                "Vui lòng chọn khách hàng trước để tiếp chỉnh sửa mục này"),
                            actions: <Widget>[
                              FlatButton(
                                child: const Text("OK"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          );
                        },
                      );
                      return;
                    }

                    if (!_vm.isPartnerShipAddressValid) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => PartnerEditAddressPage(
                            partnerId: _vm.partner?.id,
                            closeAfterSaved: true,
                            onSaved: () {
                              _vm.refreshPartnerInfo();
                            },
                          ),
                        ),
                      );
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) =>
                            FastSaleOrderAddEditFullShipAddressPage(
                          viewModel: _vm,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_right),
                  label: Text(S.current
                      .edit), //TODO(namnv) Khai báo và sử dụng const cho trường hợp nhiều text có cùng nội dung này
                )
              ],
            ),
            RichText(
              text: TextSpan(
                  text: _vm.shipAddressName != null && _vm.shipAddressName != ""
                      ? _vm.shipAddressName
                      : "N/A",
                  style: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    if (_vm.shipAddressPhone != "")
                      TextSpan(
                        text: " | ${_vm.shipAddressPhone}",
                      ),
                  ]),
            ),
            Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  if (_vm.shipAddressStreet != null &&
                      _vm.shipAddressStreet != "")
                    Text(_vm.shipAddressStreet)
                  else
                    const Text(
                      "<Chưa có địa chỉ>",
                      style: TextStyle(color: Colors.red),
                    ),
                ]),
          ],
        ),
      ),
    );
  }

  /// Đối tác giao hàng

  Widget _buildSelectedDeliveryPanel() {
    return AbsorbPointer(
      absorbing: !_vm.cantEditDelivery,
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 0, bottom: 8),
        decoration: _defaultBox.copyWith(
            color: _vm.cantEditDelivery ? Colors.white : Colors.grey.shade200),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                const Icon(Icons.directions_car),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    S.current.deliveryCarrierAndFee,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                FlatButton.icon(
                    textColor: Colors.blue,
                    onPressed: () async {
                      bool isContinue = true;
                      if (!_vm.isShipAddressValid) {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Chưa có địa chỉ giao hàng!"),
                              content: const Text(
                                  "Phí giao hàng sẽ không được tính. Bạn có muốn tiếp tục?"),
                              actions: <Widget>[
                                FlatButton(
                                  child: const Text("Quay lại sửa"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    isContinue = false;
                                  },
                                ),
                                FlatButton(
                                  child: const Text("Tiếp tục"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    isContinue = true;
                                  },
                                )
                              ],
                            );
                          },
                        );
                      }

                      if (isContinue) {
                        _handleNavigateToEditCarrier();
                      }
                    },
                    icon: const Icon(Icons.arrow_right),
                    label: _editText),
              ],
            ),
            Builder(
              builder: (context) {
                if (_vm.carrier != null) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              "${_vm.carrier?.name} | ${_vm.carrierService?.serviceName ?? ""} "),
                          const Text(""),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5))),
                              child: Text(
                                  "Phí giao hàng: ${vietnameseCurrencyFormat(_vm.deliveryPrice)} | Thu hộ: ${vietnameseCurrencyFormat(_vm.cashOnDelivery)}"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  return SizedBox(
                    child: Text(
                        "[${S.current.addFastSaleOrder_delieryEmptyNotify}]"),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderInfoPanel() {
    return AbsorbPointer(
      absorbing: !_vm.cantEditOtherInfo,
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 0, bottom: 8),
        decoration: _defaultBox.copyWith(
            color: _vm.cantEditOtherInfo ? Colors.white : Colors.grey.shade200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                const Icon(Icons.info),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    S.current.otherInformation,
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
                        builder: (ctx) => FastSaleOrderAddEditFullOtherInfoPage(
                          editVm: _vm,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_right),
                  label: _editText,
                )
              ],
            ),
            Builder(
              builder: (ctx) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Builder(builder: (ctx) {
                      if (_vm.order?.dateInvoice != null) {
                        return Text(
                            "${S.current.invoiceDate} : ${DateFormat("dd/MM/yyyy").format(_vm.order.dateInvoice)} | ${S.current.seller}: ${_vm.user?.name ?? "[Chưa có]"}");
                      } else {
                        return const SizedBox();
                      }
                    }),
                    Text("${S.current.note}: ${_vm.order?.comment ?? ""}"),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentInfo() {
    return AbsorbPointer(
      absorbing: !_vm.cantEditPayment,
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 0, bottom: 8),
        decoration: _defaultBox.copyWith(
            color: _vm.cantEditPayment ? Colors.white : Colors.grey.shade200),
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
                  child: Text(
                    S.current.paymentInformation,
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
                        builder: (ctx) =>
                            FastSaleOrderAddEditFullPaymentInfoPage(
                          editVm: _vm,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_right),
                  label: _editText,
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
                          Text("${S.current.paymentMethod}: "),
                          Text(_vm.paymentJournal?.name ?? "Chưa chọn")
                        ],
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      if (_vm.discount == null || _vm.discount == 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                                "${S.current.discount} (${_vm.order?.discount}): "),
                            Text(
                              "- ${vietnameseCurrencyFormat(_vm.discountAmount)}",
                              style: const TextStyle(color: Colors.black),
                            )
                          ],
                        ),
                      const SizedBox(
                        height: 3,
                      ),
                      if (_vm.order?.decreaseAmount == null ||
                          _vm.order?.decreaseAmount == 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("${S.current.discountAmount}: "),
                            Text(
                              "- ${vietnameseCurrencyFormat(_vm.order?.decreaseAmount)}",
                              style: const TextStyle(color: Colors.black),
                            )
                          ],
                        ),
                      const SizedBox(
                        height: 3,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("${S.current.total}: "),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("${S.current.paid}: "),
                          Text(
                            vietnameseCurrencyFormat(_vm.paymentAmount ?? 0),
                            style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("${S.current.left}: "),
                          Text(
                            vietnameseCurrencyFormat(_vm.rechargeAmount ?? 0),
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          )
                        ],
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
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.orange.shade100),
                color: Colors.orange.shade50),
            padding:
                const EdgeInsets.only(left: 5, right: 10, top: 10, bottom: 5),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.shopping_cart,
                    size: 70,
                    color: Colors.grey.shade300,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, top: 12, bottom: 8),
                    child: Text(
                      S.current.addFastSaleOrder_emptyProductNotify,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
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

            _findProduct();
          },
        ),
      );
    }
    return AbsorbPointer(
      absorbing: !_vm.cantEditProduct,
      child: Container(
        decoration: _defaultBox.copyWith(
            color: _vm.cantEditProduct ? Colors.white : Colors.grey.shade200),
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
      ),
    );
  }

  Widget _buildSummaryPanel() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InfoRow(
          title: Text(
            '${S.current.quantity}: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          padding: const EdgeInsets.only(right: 5, bottom: 8, top: 8, left: 10),
          content: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Text(
              '${_vm.totalQuantity?.toInt()}',
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        // Khối lượng
        InfoRow(
          title: Text(
            '${S.current.weight} (Kg):',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          padding: const EdgeInsets.only(right: 5, bottom: 8, top: 8, left: 10),
          content: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Text(
              (_vm.shipWeight / 1000).toStringAsPrecision(3),
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        InfoRow(
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
        ),
      ],
    );
  }

  Widget _buildBottomMenu() {
    final theme = Theme.of(context);
    return Container(
      height: 60,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.grey.shade100,
          border:
              Border(top: BorderSide(width: 1, color: Colors.grey.shade400))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: RaisedButton(
                padding: const EdgeInsets.all(0),
                shape: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.primaryColor, width: 0.5),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  ),
                ),
                color: theme.primaryColor,
                disabledColor: Colors.grey.shade300,
                textColor: Colors.white,
                child: Text(_vm.bottomActionName ?? ""),
                onPressed: !_vm.cantConfirm
                    ? null
                    : () {
                        if (_vm.editType == EditType.ADD_NEW ||
                            _vm.editType == EditType.EDIT_DRAFT) {
                          _handleSaveAndConfirm(context: context);
                        } else {
                          _vm.saveDraftCommand();
                        }
                      }),
          ),
          const SizedBox(
            width: 0,
          ),
          RaisedButton(
            padding: const EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: theme.primaryColor, width: 0.5),
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
            ),
            color: Colors.grey.shade100,
            disabledColor: Colors.grey.shade300,
            child: const Icon(Icons.more_horiz),
            onPressed: !_vm.isValidToConfirm
                ? null
                : () {
                    const Divider dividerMin = Divider(
                      height: 2,
                      indent: 50,
                    );

                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) => BottomSheet(
                        shape: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade200),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            )),
                        onClosing: () {},
                        builder: (context) => Container(
                          child: ListView(
                            shrinkWrap: true,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8, top: 12, bottom: 8),
                                child: MyStepView(
                                  currentIndex: 2,
                                  items: [
                                    MyStepItem(
                                      title: const Text(
                                        "Nháp",
                                        textAlign: TextAlign.center,
                                      ),
                                      icon: const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      ),
                                      lineColor: Colors.red,
                                      isCompleted:
                                          _vm.order?.isStepDraft ?? false,
                                    ),
                                    MyStepItem(
                                      title: Text(
                                        S.current.confirm,
                                        textAlign: TextAlign.center,
                                      ),
                                      icon: const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      ),
                                      lineColor: Colors.red,
                                      isCompleted:
                                          _vm.order?.isStepConfirm ?? false,
                                    ),
                                    MyStepItem(
                                      title: Text(
                                        S.current.paid,
                                        textAlign: TextAlign.center,
                                      ),
                                      icon: const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      ),
                                      lineColor: Colors.red,
                                      isCompleted:
                                          _vm.order?.isStepPay ?? false,
                                    ),
                                    MyStepItem(
                                        title: const Text(
                                          "Hoàn thành",
                                          textAlign: TextAlign.center,
                                        ),
                                        icon: const Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                        ),
                                        lineColor: Colors.red,
                                        isCompleted:
                                            _vm.order?.isStepCompleted ??
                                                false),
                                  ],
                                ),
                              ),
                              if (_vm.editType == EditType.ADD_NEW ||
                                  _vm.editType == EditType.EDIT_DRAFT) ...[
                                dividerMin,
                                ListTile(
                                  leading: const Icon(
                                    Icons.print,
                                    color: Colors.blue,
                                  ),
                                  title: const Text("Xác nhận & In phiếu ship"),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _handleSaveAndConfirm(
                                        context: context, isPrintShip: true);
                                  },
                                ),
                                dividerMin,
                                ListTile(
                                  leading: const Icon(Icons.print),
                                  title: const Text("Xác nhận & In hóa đơn"),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _handleSaveAndConfirm(
                                        context: context, isPrintOrder: true);
                                  },
                                ),
                              ],
                              dividerMin,
                              const ListTile(),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
          ),
        ],
      ),
    );
  }

  Widget _buildListProductItem(FastSaleOrderLine item, [int index = 0]) {
    const itemTextStyle = TextStyle(color: Colors.black);
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: Key("${item.id}_${item.productId}_${item.priceUnit}"),
      child: ListTile(
        contentPadding:
            const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
        title: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: CircleAvatar(
                child: Text(
                  "${index + 1}",
                  style: const TextStyle(fontSize: 12),
                ),
                radius: 8,
              ),
            ),
            RichText(
              text: TextSpan(
                text: "",
                style: itemTextStyle.copyWith(color: Colors.green),
                children: [
                  TextSpan(
                    text: item.productNameGet ?? item.productName ?? "",
                    style: itemTextStyle,
                  ),
                  TextSpan(
                    text: " (${item.productUomName})",
                    style: itemTextStyle.copyWith(color: Colors.blue),
                  )
                ],
              ),
            ),
          ],
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
                      return Text(" (Giảm ${item.discount}%) ");
                    } else if ((item.discountFixed ?? 0) > 0) {
                      return Text(
                          " (Giảm ${vietnameseCurrencyFormat(item.discountFixed)}) ");
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
                child: SizedBox(
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
                ),
              )
            ],
          ),
        ),
        onTap: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (ctx) => FastSaleOrderLineEditPage(item)));
          _vm.onOrderLineChanged(item);
        },
        onLongPress: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Chọn thao thác"),
              content: Container(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      title: const Text("Sao chép"),
                      onTap: () {
                        Navigator.pop(context);
                        _vm.copyOrderLinecommand(item);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
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
  }
}
