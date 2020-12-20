/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 7/5/19 5:35 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 7/5/19 5:32 PM
 *
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

import 'package:tpos_mobile/feature_group/sale_online/ui/sale_online_order_edit_products_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/sale_online_select_address.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/sale_online_select_partner_status_dialog_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/new_facebook_post_comment_viewmodel.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/sale_online_order_edit_viewmodel.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';
import 'package:tpos_mobile/helpers/ui_help.dart';

import 'package:tpos_mobile/src/tpos_apis/models/Address.dart';
import 'package:tpos_mobile/src/tpos_apis/models/sale_online_facebook_comment.dart';

import 'package:tpos_mobile/src/tpos_apis/tpos_models.dart';
import 'package:tpos_mobile/widgets/custom_widget.dart';
import 'package:tpos_mobile/widgets/listview_data_error_info_widget.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import 'check_address_page.dart';

class SaleOnlineEditOrderPage extends StatefulWidget {
  const SaleOnlineEditOrderPage(
      {this.order,
      this.orderId,
      this.comment,
      this.facebookPostId,
      this.crmTeam,
      this.product,
      this.productQuantity,
      this.liveCampaign});
  final SaleOnlineOrder order;
  final String orderId;
  final CommentItemModel comment;
  final String facebookPostId;
  final CRMTeam crmTeam;
  final Product product;
  final double productQuantity;
  final LiveCampaign liveCampaign;

  @override
  _SaleOnlineEditOrderPageState createState() =>
      _SaleOnlineEditOrderPageState(order: order);
}

class _SaleOnlineEditOrderPageState extends State<SaleOnlineEditOrderPage> {
  _SaleOnlineEditOrderPageState({this.order});
  SaleOnlineEditOrderViewModel viewModel = SaleOnlineEditOrderViewModel();

  final GlobalKey<ScaffoldState> _scafffoldKey = GlobalKey<ScaffoldState>();
  //  _formKey and _autoValidate
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _validate = false;

  var customerNameTextController = TextEditingController();
  var phoneNumberTextController = TextEditingController();
  var emailTextController = TextEditingController();
  TextEditingController noteTextController = TextEditingController();

  var checkAddressTextController = TextEditingController();
  var addressTextController = TextEditingController();
  var cityAddressTextController = TextEditingController();
  var districtAddressTextController = TextEditingController();
  var wardAddressTextController = TextEditingController();

  TextEditingController quantityTextController = TextEditingController();

  SaleOnlineOrder order;

  Divider dv = const Divider(
    indent: 10,
    color: Colors.red,
  );

  @override
  void initState() {
    viewModel.init(
        editOrder: order,
        orderId: widget.orderId,
        comment: widget.comment,
        facebookPostId: widget.facebookPostId,
        crmTeam: widget.crmTeam,
        product: widget.product,
        productQuantity: widget.productQuantity,
        liveCampaign: widget.liveCampaign);

    viewModel.initData();
    viewModel.dialogMessageController.stream.listen((message) {
      registerDialogToView(context, message,
          scaffState: _scafffoldKey?.currentState);
    });

    viewModel.editOrderStream.listen((newOrder) {
      customerNameTextController.text = newOrder.name;
      phoneNumberTextController.text = newOrder.telephone;
      emailTextController.text = newOrder.email;
      noteTextController.text = newOrder.note;
      addressTextController.text = newOrder.address;
      cityAddressTextController.text = newOrder.cityName;
      districtAddressTextController.text = newOrder.districtName;
      wardAddressTextController.text = newOrder.wardName;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      key: _scafffoldKey,
      appBar: AppBar(
        leading: const CloseButton(),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.print,
            ),
            onPressed: () {
              viewModel.printSaleOnlineTag();
            },
          ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              viewModel.editOrder.name = customerNameTextController.text;
              viewModel.editOrder.email = emailTextController.text;
              viewModel.editOrder.telephone = phoneNumberTextController.text;
              viewModel.editOrder.note = noteTextController.text;
              viewModel.editOrder.address = addressTextController.text;

              await viewModel.save();

              Navigator.pop(context, viewModel.editOrder);
            },
          ),
        ],
        // "Sửa đơn hàng" : "Đơn hàng mới"
        title: Text(viewModel.editOrderId != null
            ? S.current.saleOnline_EditOrder
            : S.current.saleOnline_NewOrder),
      ),
      body: ViewBaseWidget(
        isBusyStream: viewModel.isBusyController,
        child: _showBody(),
      ),
    );
  }

  Widget _showBody() {
    return Form(
      key: _formKey,
      autovalidate: _validate,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Thông tin đơn hàng
            Container(
              child: StreamBuilder<SaleOnlineOrder>(
                  stream: viewModel.editOrderStream,
                  initialData: viewModel.editOrder,
                  builder: (context, snapshot) {
                    return ExpansionTile(
                      initiallyExpanded: true,
                      title: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          Text(
                              "#${viewModel.editOrder?.sessionIndex ?? ""}. ${viewModel.editOrder?.code}"),
                          const SizedBox(
                            width: 8,
                          ),
                          // Lần tạo
                          Text(
                            "${S.current.timesCreated}: ${viewModel.editOrder?.printCount ?? "N/A"}",
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          SizedBox(
                            child: StreamBuilder<Partner>(
                              stream: viewModel.parterStream,
                              initialData: viewModel.partner,
                              builder:
                                  (context, AsyncSnapshot<Partner> snapshot) {
                                if (snapshot.hasData) {
                                  return Container(
                                    height: 25,
                                    color: getPartnerStatusColor(
                                        snapshot.data.statusStyle),
                                    child: OutlineButton(
                                      textColor: getTextColorFromParterStatus(
                                          snapshot.data.status)[1],
                                      child: Text(
                                          viewModel.partner?.statusText ?? ""),
                                      onPressed: () async {
                                        final PartnerStatus selectStatus =
                                            await showDialog(
                                                context: context,
                                                builder: (ctx) {
                                                  return AlertDialog(
                                                    content:
                                                        SaleOnlineSelectPartnerStatusDialogPage(),
                                                  );
                                                });

                                        if (selectStatus != null) {
                                          viewModel.updateParterStatus(
                                              selectStatus.value,
                                              selectStatus.text);
                                        }

                                        //}
                                      },
                                    ),
                                  );
                                } else
                                  return const SizedBox();
                              },
                            ),
                          ),
                        ],
                      ),
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Column(
                            children: <Widget>[
                              //Tên
                              TextField(
                                controller: customerNameTextController,
                                maxLines: null,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  hintText: "",
                                  labelText: S.current.name,
                                  prefixIcon: const Icon(Icons.account_circle),
                                ),
                              ),
                              // Số điện thoại
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: TextField(
                                      controller: phoneNumberTextController,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                          Icons.phone_android,
                                        ),
                                        hintText: '',
                                        labelText: S.current.phone,
                                      ),
                                    ),
                                  ),
                                  Tooltip(
                                    child: IconButton(
                                      icon: const Icon(Icons.phone),
                                      onPressed: () {
                                        urlLauch(
                                            "tel:${viewModel.partner?.phone}");
                                      },
                                    ),
                                    message: S.current.saleOnlineOrder_OpenCall,
                                  ),
                                  Tooltip(
                                    child: IconButton(
                                      icon:
                                          const Icon(FontAwesomeIcons.facebook),
                                      onPressed:
                                          viewModel.partner?.facebookId == null
                                              ? null
                                              : () {
                                                  urlLauch(
                                                      "fb://profile/${viewModel.partner?.facebookId}");
                                                },
                                    ),
                                    // Mở facebook
                                    message:
                                        S.current.saleOnlineOrder_OpenFacebook,
                                  ),
                                  Tooltip(
                                    child: IconButton(
                                      icon: const Icon(
                                          FontAwesomeIcons.facebookMessenger),
                                      onPressed:
                                          viewModel.partner?.facebookId == null
                                              ? null
                                              : () {
                                                  urlLauch(
                                                      "fb://messaging/${viewModel.partner?.facebookId}");
                                                },
                                    ),
                                    message: "Messenger",
                                  ),
                                ],
                              ),
                              // Email
                              TextFormField(
                                onSaved: (text) {
                                  viewModel.editOrder.email =
                                      emailTextController.text;
                                },
                                controller: emailTextController,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.email,
                                  ),
                                  hintText: 'abcdef@gmail.com',
                                  labelText: 'Email',
                                ),
                                //validator: viewModel.validateFormEmail,
                              ),
                              // Địa chỉ
                              TextField(
                                controller: addressTextController,
                                maxLines: null,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.location_on,
                                  ),
                                  hintText: '',
                                  labelText: S.current.address,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 18, top: 10),
                          child: Column(
                            children: <Widget>[
                              // Tỉnh thành
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, top: 10, right: 10),
                                child: GestureDetector(
                                  onTap: () async {
                                    final Address selectCity =
                                        await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (ctx) =>
                                            const SelectAddressPage(
                                          cityCode: null,
                                          districtCode: null,
                                        ),
                                      ),
                                    );

                                    viewModel.editOrder.cityCode =
                                        selectCity?.code;
                                    viewModel.editOrder.cityName =
                                        selectCity?.name;

                                    viewModel.editOrder.districtCode = null;
                                    viewModel.editOrder.districtName = null;
                                    viewModel.editOrder.wardCode = null;
                                    viewModel.editOrder.wardName = null;
                                    viewModel.editOrderSink
                                        .add(viewModel.editOrder);
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          viewModel.editOrder?.cityName ??
                                              S.current
                                                  .saleOnline_ChooseProvinceCity,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      const Icon(Icons.keyboard_arrow_right),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(),
                              //Quận huyện
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, top: 10, right: 10),
                                child: GestureDetector(
                                  onTap: () async {
                                    if (viewModel.editOrder?.cityCode == null)
                                      return;
                                    final Address selectCity =
                                        await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (ctx) =>
                                                    SelectAddressPage(
                                                      cityCode: viewModel
                                                          .editOrder?.cityCode,
                                                      districtCode: null,
                                                    )));

                                    viewModel.editOrder?.districtCode =
                                        selectCity?.code;
                                    viewModel.editOrder?.districtName =
                                        selectCity?.name;
                                    viewModel.editOrder?.wardCode = null;
                                    viewModel.editOrder?.wardName = null;
                                    viewModel.editOrderSink
                                        .add(viewModel?.editOrder);
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          viewModel.editOrder?.districtName ??
                                              S.current
                                                  .saleOnline_ChooseDistrict,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: viewModel.editOrder
                                                          ?.districtName ==
                                                      null
                                                  ? Colors.red
                                                  : Colors.black),
                                        ),
                                      ),
                                      const Icon(Icons.keyboard_arrow_right),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(),
                              // Phường
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, top: 10, right: 10),
                                child: GestureDetector(
                                  onTap: () async {
                                    if (viewModel.editOrder.districtCode ==
                                        null) {
                                      return;
                                    }
                                    final Address selectCity =
                                        await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (ctx) => SelectAddressPage(
                                          cityCode:
                                              viewModel.editOrder?.cityCode,
                                          districtCode:
                                              viewModel.editOrder?.districtCode,
                                        ),
                                      ),
                                    );

                                    viewModel.editOrder.wardCode =
                                        selectCity?.code;
                                    viewModel.editOrder.wardName =
                                        selectCity?.name;
                                    viewModel.editOrderSink
                                        .add(viewModel.editOrder);
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          viewModel.editOrder?.wardName ??
                                              S.current.saleOnline_ChooseWard,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: viewModel.editOrder
                                                          ?.wardName ==
                                                      null
                                                  ? Colors.red
                                                  : Colors.black),
                                        ),
                                      ),
                                      const Icon(Icons.keyboard_arrow_right),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),

                        // Số nhà
                        Row(
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Icon(
                                Icons.streetview,
                                color: Colors.green,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: TextField(
                                  controller: checkAddressTextController,
                                  autofocus: false,
                                  decoration: InputDecoration(
                                    hintText:
                                        '${S.current.example}: 54/35 tsn, tp, tp hcm',
                                  ),
                                  onTap: () {},
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                  height: 35,
                                  child: FlatButton(
                                    textColor: Colors.blue,
                                    padding: const EdgeInsets.all(0),
                                    // Kiểm tra
                                    child: Text(S.current.check),
                                    onPressed: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CheckAddressPage(
                                            keyword: checkAddressTextController
                                                .text
                                                .trim(),
                                          ),
                                        ),
                                      );
//
//
                                      if (result != null) {
                                        viewModel.selectedCheckAddress = result;
                                        viewModel.fillCheckAddress(
                                            viewModel.selectedCheckAddress);
                                      }

                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                    },
                                  )),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 8,
                        ),
                        const Divider(),
                        //Ghi chú
                        Row(
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Icon(
                                Icons.event_note,
                                color: Colors.green,
                              ),
                            ),
                            // Ghi chú
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: TextField(
                                  onChanged: (text) {},
                                  maxLines: null,
                                  controller: noteTextController,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    hintText: '',
                                    labelText: S.current.note,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
              color: Colors.white,
            ),
            const SizedBox(
              height: 10,
            ),
            // Chi tiết đơn hàng
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(right: 10),
              child: StreamBuilder<SaleOnlineOrder>(
                  stream: viewModel.editOrderStream,
                  initialData: viewModel.editOrder,
                  builder: (context, snapshot) {
                    return ListTile(
                      contentPadding: const EdgeInsets.all(6),
                      leading: const Padding(
                        padding: EdgeInsets.only(left: 14.0),
                        child: Icon(
                          Icons.account_balance_wallet,
                          color: Colors.green,
                        ),
                      ),
                      // Chi tiết đơn hàng
                      title: Text(
                        "${S.current.saleOnline_OrderDetail} (${viewModel.editOrder?.details?.length ?? 0})",
                        style: const TextStyle(color: Colors.orange),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: <Widget>[
                                // sản phẩm
                                Expanded(
                                  child: Text(
                                    "${snapshot.data?.details?.length ?? 0} ${S.current.product}",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                //Tổng tiền
                                Expanded(
                                  child: Text(
                                    "${S.current.totalAmount}: ${vietnameseCurrencyFormat(viewModel.totalAmount)}",
                                    style: const TextStyle(fontSize: 16),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Chạm để chỉnh sửa chi tiết đơn hàng
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              S.current.saleOnline_TouchToEdit,
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        viewModel.editOrder.details ??=
                            <SaleOnlineOrderDetail>[];
                        Navigator.push(context,
                            MaterialPageRoute(builder: (ctx) {
                          return SaleOnlineOrderEditProductsPage(
                              viewModel.editOrder.details);
                        })).then((value) {
                          setState(() {});
                        });
                      },
                    );
                  }),
            ),
            const SizedBox(
              height: 10,
            ),
            // Nút
            Container(color: Colors.white, child: _showButton()),
            const SizedBox(
              height: 10,
            ),
            Container(color: Colors.white, child: _showRecentComments()),
          ],
        ),
      ),
    );
  }

  Widget _showRecentComments() {
    return StreamBuilder<List<SaleOnlineFacebookComment>>(
      stream: viewModel.recentCommentsObservable,
      initialData: viewModel.recentComments,
      builder: (ctx, recentCommentsSnapshot) {
        if (recentCommentsSnapshot.hasError) {
          return ListViewDataErrorInfoWidget();
        }

        if (recentCommentsSnapshot.data == null) {
          return const SizedBox();
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ExpansionTile(
            title: Text(S.current.saleOnline_RecentComments),
            initiallyExpanded: true,
            children: <Widget>[
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recentCommentsSnapshot.data.length,
                itemBuilder: (ctx, index) {
                  return FlatButton(
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          const Icon(
                            Icons.message,
                            color: Colors.green,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: SizedBox(
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text:
                                          "${recentCommentsSnapshot.data[index].message} ",
                                      style:
                                          const TextStyle(color: Colors.black)),
                                  TextSpan(
                                      text:
                                          "(${DateFormat("dd/MM/yyyy HH:mm").format(
                                        recentCommentsSnapshot
                                            .data[index].createdTime
                                            .toLocal(),
                                      )})",
                                      style:
                                          const TextStyle(color: Colors.blue)),
                                ]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (ctx) {
                            return ListView(
                              shrinkWrap: true,
                              children: <Widget>[
                                // Kiểm tra địa chỉ
                                ListTile(
                                  title: Text(S.current.checkAddress),
                                  onTap: () {
                                    Navigator.pop(context);
                                    setState(() async {
                                      checkAddressTextController.text =
                                          recentCommentsSnapshot
                                              .data[index].message;
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CheckAddressPage(
                                            keyword: checkAddressTextController
                                                .text
                                                .trim(),
                                          ),
                                        ),
                                      );
//
//
                                      if (result != null) {
                                        viewModel.selectedCheckAddress = result;
                                        viewModel.fillCheckAddress(
                                            viewModel.selectedCheckAddress);
                                      }

                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                    });
                                  },
                                ),
                                // Thêm vào ghi chú
                                const Divider(),
                                ListTile(
                                  title: Text(S.current.addNote),
                                  onTap: () {
                                    Navigator.pop(context);
                                    noteTextController.text = noteTextController
                                            .text +=
                                        "\n${recentCommentsSnapshot.data[index].message}";
                                  },
                                ),
                              ],
                            );
                          });
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _showButton() {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 25, bottom: 0),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: OutlineButton(
                padding: const EdgeInsets.all(10),
                color: theme.primaryColor,
                // IN PHIẾU
                child: Text(
                  S.current.print.toUpperCase(),
                  style: const TextStyle(color: Colors.black),
                ),
                onPressed: () async {
                  viewModel.printSaleOnlineTag();
                },
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 1,
              child: RaisedButton(
                padding: const EdgeInsets.all(10),
                color: theme.primaryColor,
                // LƯU
                child: Text(
                  S.current.save.toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  viewModel.editOrder.name = customerNameTextController.text;
                  viewModel.editOrder.email = emailTextController.text;
                  viewModel.editOrder.telephone =
                      phoneNumberTextController.text;
                  viewModel.editOrder.note = noteTextController.text;
                  viewModel.editOrder.address = addressTextController.text;

                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    await viewModel.save();
                    Navigator.pop(context, viewModel.editOrder);
                  } else {
                    setState(
                      () {
                        _validate = true;
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    phoneNumberTextController.dispose();
    emailTextController.dispose();
    noteTextController.dispose();

    checkAddressTextController.dispose();
    addressTextController.dispose();
    cityAddressTextController.dispose();
    districtAddressTextController.dispose();
    wardAddressTextController.dispose();
    viewModel.dispose();
    super.dispose();
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
