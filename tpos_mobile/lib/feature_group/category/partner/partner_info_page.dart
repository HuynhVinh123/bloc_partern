import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tmt_flutter_untils/tmt_flutter_extensions.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/app_core/ui_base/ui_vm_base.dart';
import 'package:tpos_mobile/feature_group/category/partner/partner_page.dart';

import 'package:tpos_mobile/feature_group/sale_online/ui/sale_online_order_list_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/sale_online_select_partner_status_dialog_page.dart';

import 'package:tpos_mobile/helpers/app_helper.dart';
import 'package:tpos_mobile/widgets/custom_bottom_sheet.dart';
import 'package:tpos_mobile/widgets/info_row.dart';
import 'package:tpos_mobile_localization/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:tpos_mobile/extensions.dart';
import '../../fast_sale_order/ui/fast_sale_order_list_page.dart';
import 'viewmodel/partner_info_viewmodel.dart';

class PartnerInfoPage extends StatefulWidget {
  const PartnerInfoPage(
      {this.partnerId, this.onEditPartner, this.onChangeStatus});
  final int partnerId;
  final Function onEditPartner;
  final Function(String status, String statusStyle, String statusText)
      onChangeStatus;

  @override
  _PartnerInfoPageState createState() => _PartnerInfoPageState();
}

class _PartnerInfoPageState extends State<PartnerInfoPage> {
  PartnerInfoViewModel viewModel = PartnerInfoViewModel();
  Key refreshIndicatorKey = const Key("refreshIndicator");

  /// Xử lý khi nhấn nút 'Sửa'
  Future<void> _handleEdit() async {
    await context.navigateTo(PartnerAddEditPage(
      partnerId: viewModel.partner.id,
      closeWhenSaved: true,
      onEditPartner: (value) {
        viewModel.partner = value;
      },
    ));
    if (widget.onEditPartner != null) {
      widget.onEditPartner(viewModel.partner);
    }
  }

  /// Xử lý khi thay đổi trạng thái khách hàng
  Future<void> _handleChangeStatus() async {
    if (widget.partnerId != null) {
      final PartnerStatus selectStatus = await showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              content: SaleOnlineSelectPartnerStatusDialogPage(),
            );
          });

      if (selectStatus != null) {
        final updateResult = await viewModel.updatePartnerStatus(
            selectStatus.value, selectStatus.text);

        if (updateResult) {
          if (widget.onChangeStatus != null) {
            widget.onChangeStatus(viewModel.partner.status,
                viewModel.partner.statusStyle, viewModel.partner.statusText);
          }
        }
      }
    }
  }

  static const _infoRowStyle = TextStyle(
    color: Colors.green,
    fontWeight: FontWeight.bold,
  );

  Widget _buildAppbar() {
    return AppBar(
      title: ScopedModelDescendant<PartnerInfoViewModel>(
        builder: (_, child, model) => Text(model.partner?.name ?? ''),
      ),
      actions: <Widget>[
        FlatButton.icon(
          textColor: Colors.white,
          icon: const Icon(Icons.edit),
          label: Text(S.current.edit),
          onPressed: () => _handleEdit(),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return ScopedModelDescendant<PartnerInfoViewModel>(
      builder: (context, index, vm) {
        if (vm.partner == null) {
          return const SizedBox();
        }
        return DefaultTabController(
          length: 4,
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                constraints: const BoxConstraints(maxHeight: 40.0),
                child: TabBar(
                  indicatorColor: Colors.green,
                  labelColor: Colors.green,
                  tabs: [
                    Tab(
                      text: S.current.info,
                    ),
                    Tab(
                      text: S.current.order,
                    ),
                    Tab(
                      text: S.current.invoice,
                    ),
                    Tab(
                      text: S.current.dept,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(children: <Widget>[
                  _buildInfo(),
                  SaleOnlineOrderListPage(
                    partner: viewModel.partner,
                  ),
                  FastSaleOrderListPage(
                    partnerId: viewModel.partner.id,
                  ),
                  _buildCredit(),
                ]),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return UIViewModelBase<PartnerInfoViewModel>(
      viewModel: viewModel,
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: _buildAppbar(),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildInfo() {
    Uint8List _bytesImage;
    if (viewModel.partner.image != null &&
        viewModel.partner.image != "" &&
        viewModel.partner.image.contains("https://") == false) {
      _bytesImage = const Base64Decoder().convert(viewModel.partner.image);
    }

    const Divider dividerMin = Divider(
      height: 2,
    );
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 120,
                  height: 120,
                  child: viewModel.partner.imageUrl != null &&
                          viewModel.partner.imageUrl != ""
                      ? Image.network(
                          viewModel.partner.imageUrl,
                          height: 120,
                          width: 120,
                        )
                      : _bytesImage != null
                          ? Image.memory(_bytesImage)
                          : Image.asset("images/no_image.png"),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          child: Material(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3),
                                side: const BorderSide(
                                    color: Colors.green,
                                    width: 1,
                                    style: BorderStyle.solid)),
                            color: getTextColorFromParterStatus(
                                viewModel.partner.status)[0],
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  // Chưa có trạng thái
                                  Text(
                                    "${viewModel.partner?.statusText ?? S.current.noStatus} ",
                                    style: TextStyle(
                                        color: getTextColorFromParterStatus(
                                            viewModel.partner.status)[1]),
                                    textAlign: TextAlign.center,
                                  ),
                                  Icon(
                                    Icons.edit,
                                    color: getTextColorFromParterStatus(
                                        viewModel.partner.status)[1],
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () => _handleChangeStatus(),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            // Doanh số đầu kỳ
                            Flexible(
                                child: Text("${S.current.partner_begin}: ")),
                            Text(
                              "${vietnameseCurrencyFormat(viewModel.partnerRevenue.revenueBegan) ?? 0}",
                              style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("${S.current.revenue}: "),
                            Text(
                              "${vietnameseCurrencyFormat(viewModel.partnerRevenue.revenue) ?? 0}",
                              style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("${S.current.totalRevenue}: "),
                            Text(
                              "${vietnameseCurrencyFormat(viewModel.partnerRevenue.revenueTotal) ?? 0}",
                              style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("${S.current.currentDept}: "),
                            Text(
                              vietnameseCurrencyFormat(
                                  viewModel.partner.credit ?? 0),
                              style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              margin: const EdgeInsets.only(top: 10),
              child: ExpansionTile(
                title: Text(S.current.customerInfo),
                initiallyExpanded: true,
                children: <Widget>[
                  InfoRow(
                    titleString: "${S.current.customerNumber}: ",
                    content: Text(
                      viewModel.partner.ref ?? "",
                      textAlign: TextAlign.right,
                      style: _infoRowStyle,
                    ),
                  ),
                  dividerMin,
                  InfoRow(
                    titleString: "${S.current.customerName}: ",
                    content: Text(
                      viewModel.partner.name ?? "",
                      textAlign: TextAlign.right,
                      style: _infoRowStyle,
                    ),
                  ),
                  dividerMin,
                  InfoRow(
                    titleString: "${S.current.phone}: ",
                    content: GestureDetector(
                      onTap: () {
                        showModalBottomSheetFullPage(
                          context: context,
                          builder: (context) {
                            return Container(
                              color: const Color(0xFF737373),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                  ),
                                ),
                                child: ListView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  children: <Widget>[
                                    ListTile(
                                      leading: const Icon(Icons.phone,
                                          color: Colors.green),
                                      // gọi
                                      title: Text(
                                          "${S.current.call} ${viewModel.partner.phone}"),
                                      onTap: () async {
                                        _launchURL(
                                            "tel:${viewModel.partner.phone}");
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.message,
                                          color: Colors.green),
                                      // Nhắn tin
                                      title: Text(
                                          "${S.current.sendMessage} ${viewModel.partner.phone}"),
                                      onTap: () async {
                                        _launchURL(
                                            "sms:${viewModel.partner.phone}");
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Text(
                        viewModel.partner.phone ?? "",
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  dividerMin,
                  InfoRow(
                    titleString: "Facebook: ",
                    content: GestureDetector(
                      onTap: () {
                        _launchURL(viewModel.partner.facebook);
                      },
                      child: Text(
                        viewModel.partner.facebook ?? "",
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  dividerMin,
                  InfoRow(
                    titleString: "${S.current.address}: ",
                    content: GestureDetector(
                      onTap: () {
                        String url = "https://www.google.com/maps/dir//";
                        if (viewModel.partner.addressFull.contains("/")) {
                          url = url.substring(0, url.length - 1);
                        }
                        _launchURL("$url${viewModel.partner.addressFull}");
                      },
                      child: Text(
                        viewModel.partner.street ?? "",
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.right,
                        maxLines: null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Thông tin khác
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              child: ExpansionTile(
                title: Text(S.current.partnerInfo_otherInfo),
                initiallyExpanded: true,
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Text(S.current.customerGroups),
                  ),
                  _buildPartnerCategory(context),
                  dividerMin,
                  InfoRow(
                    titleString: "Email: ",
                    content: Text(
                      viewModel.partner.email ?? "",
                      textAlign: TextAlign.right,
                      style: _infoRowStyle,
                    ),
                  ),
                  dividerMin,
                  InfoRow(
                    titleString: "${S.current.birthday}: ",
                    content: Text(
                      viewModel.partner.birthDay != null
                          ? DateFormat("dd/MM/yyyy")
                              .format(viewModel.partner.birthDay)
                          : "",
                      style: _infoRowStyle,
                      textAlign: TextAlign.right,
                      maxLines: null,
                    ),
                  ),
                  dividerMin,
                  InfoRow(
                    titleString: "Zalo",
                    content: Text(
                      viewModel.partner?.zalo ?? "",
                      style: _infoRowStyle,
                      textAlign: TextAlign.right,
                    ),
                  ),
                  dividerMin,
                  InfoRow(
                    titleString: S.current.taxCode,
                    content: Text(
                      viewModel.partner?.taxCode ?? "",
                      style: _infoRowStyle,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            // Thông tin bán hàng, mua hàng
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              child: ExpansionTile(
                title: Text(S.current.partnerInfo_saleInfo),
                initiallyExpanded: true,
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InfoRow(
                    titleString: "${S.current.partner}: ",
                    content: Text(
                      '${viewModel.partner?.customer?.toCustomString(S.current.customer, '')}, ${viewModel.partner?.supplier?.toCustomString(S.current.menu_supplier, '')}',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  dividerMin,
                  InfoRow(
                    titleString: "${S.current.priceList}: ",
                    content: Text(
                      viewModel.partner?.propertyProductPricelist?.name ?? '',
                      style: _infoRowStyle,
                      textAlign: TextAlign.right,
                      maxLines: null,
                    ),
                  ),
                  dividerMin,
                  InfoRow(
                    titleString: "${S.current.defaultDiscount}:",
                    content: Text(
                      viewModel.partner?.discount?.toStringAsPrecision(2) ?? "",
                      style: _infoRowStyle,
                      textAlign: TextAlign.right,
                    ),
                  ),
                  dividerMin,
                  InfoRow(
                    titleString: S.current.defaultAmountDiscount,
                    content: Text(
                      viewModel.partner?.amountDiscount
                              ?.toStringFormat('###,###,###,###') ??
                          "",
                      style: _infoRowStyle,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPartnerCategory(BuildContext context) {
    if (viewModel.partner.partnerCategories != null) {
      return Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Wrap(
          spacing: 8.0,
          runSpacing: 0.0,
          children: List<Widget>.generate(
              viewModel.partner?.partnerCategories?.length, (index) {
            return Chip(
              backgroundColor: Colors.greenAccent.shade100,
              label:
                  Text(viewModel.partner?.partnerCategories[index]?.name ?? ''),
            );
          }),
        ),
      );
    } else
      return const SizedBox();
  }

  Widget _buildCredit() {
    return Container(
      color: Colors.grey.shade200,
      child: RefreshIndicator(
        key: refreshIndicatorKey,
        onRefresh: () async {
          return await viewModel.loadCreditDebitCustomerDetail();
        },
        child: Scrollbar(
          child: (viewModel.creditDebitCustomerDetails?.isEmpty ?? false)
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    // Không có dữ liệu
                    child: Text(
                      S.current.noData,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.orangeAccent),
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.only(
                      right: 8, left: 8, top: 8, bottom: 8),
                  itemCount: viewModel.creditDebitCustomerDetails?.length ?? 0,
                  separatorBuilder: (ctx, index) {
                    return const SizedBox(
                      height: 7,
                    );
                  },
                  itemBuilder: (context, position) {
                    return _buildItemCredit(
                        viewModel.creditDebitCustomerDetails[position]);
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildItemCredit(CreditDebitCustomerDetail item) {
    return Container(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 1,
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child:
                        Text(DateFormat("dd/MM/yyyy").format(item.date ?? ""),
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            )),
                  ),
                  Expanded(
                    child: Text(
                        vietnameseCurrencyFormat(item.amountResidual ?? 0) ??
                            "",
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ],
              ),
            ),
            subtitle: Text(
              item.displayedName ?? '',
              style: const TextStyle(color: Colors.black),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  @override
  void initState() {
    viewModel.init(partnerId: widget.partnerId);
    viewModel.initData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    viewModel.dispose();
  }
}
