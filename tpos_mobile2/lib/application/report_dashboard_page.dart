import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

import 'package:tpos_mobile/feature_group/fast_purchase_order/helper/animation_helper.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/helper/screen_helper.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/helper/widget_helper.dart';
import 'package:tpos_mobile/feature_group/reports/business_result_page.dart';
import 'package:tpos_mobile/feature_group/reports/partner_report_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/uis/report_delivery_order_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/ui/report_order_page.dart';
import 'package:tpos_mobile/feature_group/reports/statistic_report/report_dashboard_other_report_page.dart';
import 'package:tpos_mobile/feature_group/reports/statistic_report/report_dashboard_page_change_password.dart';
import 'package:tpos_mobile/feature_group/reports/statistic_report/report_dashboard_page_columnchart.dart';
import 'package:tpos_mobile/feature_group/reports/statistic_report/report_dashboard_page_dataline.dart';
import 'package:tpos_mobile/feature_group/reports/statistic_report/report_dashboard_page_piechart.dart';
import 'package:tpos_mobile/feature_group/reports/statistic_report/viewmodels/report_dashboard_viewmodel.dart';
import 'package:tpos_mobile/feature_group/reports/supplier_report_page.dart';

import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';

import 'package:tpos_mobile/app_core/ui_base/ui_vm_base.dart';
import 'package:tpos_mobile/resources/app_route.dart';

import 'package:tpos_mobile/src/tpos_apis/models/DashboardReport.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_api.dart';

class ReportDashboardPage extends StatefulWidget {
  @override
  ReportDashboardPageState createState() => ReportDashboardPageState();
}

class ReportDashboardPageState extends State<ReportDashboardPage>
    with SingleTickerProviderStateMixin {
  final _vm = ReportDashboardViewModel();
  final dividerMin = const Divider(
    height: 1,
  );
  double myPadding = 5;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AnimationController _animationController;
  final iconRight = const Icon(Icons.chevron_right);
  double topBarOpacity = 0;
  ScrollController _scrollController;
  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _scrollController = ScrollController();
    _scrollController.addListener(
      () {
        if (_scrollController.offset <= 110) {
          setState(() {
            topBarOpacity = _scrollController.offset;
          });
        }
      },
    );

    _vm.dialogMessageController.listen(
      (message) {
        registerDialogToView(context, message,
            scaffState: _scaffoldKey.currentState);
      },
    );
    _vm.initCommand();
    super.initState();
    /* _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("bao cao"),
    ));*/
  }



  bool openMenu = false;

  @override
  Widget build(BuildContext context) {
    updateScreenResolution(context);

    return ScopedModel<ReportDashboardViewModel>(
      model: _vm,
      child: Scaffold(
        key: _scaffoldKey,
        /*appBar: AppBar(
          title: Text("Tổng quan"),
          elevation: 0,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                setState(() {
                  openMenu = !openMenu;
                });
              },
              icon: Icon(Icons.more_vert),
            )
          ],
        ),*/
        body: Stack(
          children: <Widget>[
            _buildBody(),
            _buildMenu(),
          ],
        ),
        backgroundColor: Colors.grey.shade200,
      ),
    );
  }

  Widget _buildBody() {
    return UIViewModelBase(
      viewModel: _vm,
      child: RefreshIndicator(
          child: Stack(
            children: <Widget>[
              clipShape(context),
              SafeArea(
                child: Stack(
                  children: <Widget>[
                    SingleChildScrollView(
                      controller: _scrollController,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 60, 0, myPadding),
                        child: Column(
                          //padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
                          children: <Widget>[
                            _buildSaleResultReportPanel(),
                            if (isTablet(context))
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Expanded(
                                    child: _buildPieChart(),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        _buildColumnChart(),
                                        _buildLineChart(),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            else
                              Column(
                                children: <Widget>[
                                  _buildLineChart(),
                                  _buildPieChart(),
                                  _buildColumnChart(),
                                ],
                              )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      color: Theme.of(context).primaryColor.withOpacity(
                          topBarOpacity / 100 >= 1 ? 1 : topBarOpacity / 100),
                      width: MediaQuery.of(context).size.width,
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.only(right: 8, left: 16),
                        // leading: IconButton(
                        //   icon: const Icon(
                        //     Icons.menu,
                        //     color: Colors.white,
                        //   ),
                        //   onPressed: () {
                        //     Scaffold.of(context).openDrawer();
                        //   },
                        // ),
                        title: Text(
                          S.of(context).statistics,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 20),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {
                                _buildBottomSheetOption(
                                    context,
                                    _vm.alert.items.length,
                                    _vm.alert.items,
                                    _vm.alert.id,
                                    productMax: _vm.reportProductMax,
                                    productMin: _vm.reportProductMin);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white.withOpacity(0.15),
                                ),
                                height: 38,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Row(
                                  children: [
                                    const Icon(
                                      FontAwesomeIcons.exclamationTriangle,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    ScopedModelDescendant<
                                            ReportDashboardViewModel>(
                                        builder: (context, child, model) {
                                      return Text(
                                        _vm.alert.items != null
                                            ? _vm.alert.items.length.toString()
                                            : "0",
                                        style: const TextStyle(
                                            color: Colors.white),
                                      );
                                    })
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Hero(
                              tag: 'hero',
                              child: FlatButton(
                                color: Colors.white.withOpacity(0.15),
                                textColor: Colors.white,
                                onPressed: () {
                                  onMenuTap();
                                },
                                shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide.none,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      FontAwesomeIcons.chartBar,
                                      size: 17,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(S.of(context).otherReport),
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          onRefresh: () async {
            await _vm.refreshReportCommand();
            return true;
          }),
    );
  }

  Widget _buildSaleResultReportPanel() {
    return _myCusContainer(
      child: ScopedModelDescendant<ReportDashboardViewModel>(
        builder: (context, child, model) {
          return Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 12, right: 12),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12)),
                  color: Colors.grey.shade100,
                ),
                child: Row(
                  children: <Widget>[
                    const Expanded(
                      child: Text(
                        "KẾT QUẢ BÁN HÀNG",
                        style: TextStyle(
                          color: Color(0xFF515967),
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Container(
                      child: DropdownButton<DashboardReportDataOverviewOption>(
                        //iconEnabledColor: Colors.white,
                        style: const TextStyle(
                          color: Colors.lightBlue,
                        ),
                        hint: const Text("Chọn thời gian"),
                        value: _vm.selectedOverviewOption,
                        onChanged: (value) {
                          _vm.selectedOverviewOption = value;
                          _vm.reloadOverviewCommand();
                        },
                        underline: const SizedBox(),
                        iconEnabledColor: Colors.lightBlue,
                        items: _vm.overviewFilter
                            ?.map(
                              (f) => DropdownMenuItem<
                                  DashboardReportDataOverviewOption>(
                                child: Text(
                                  "${f.text.toUpperCase()[0]}${f.text.substring(1).toLowerCase()}",
                                  style: TextStyle(
                                    color: _vm.selectedOverviewOption == f
                                        ? Colors.lightBlue
                                        : Colors.black,
                                  ),
                                ),
                                value: f,
                              ),
                            )
                            ?.toList(),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: ListTile(
                        contentPadding: const EdgeInsets.only(left: 7),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 20,
                          child: SvgPicture.asset(
                            "assets/icon/ic_invoice.svg",
                            alignment: Alignment.center,
                          ),
                        ),
                        title: Text(
                          "${_vm.report?.overview?.totalOrderCurrent ?? 0} hóa đơn",
                          style: const TextStyle(color: Color(0xFF2395FF)),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            AutoSizeText(
                              vietnameseCurrencyFormat(
                                  _vm.report?.overview?.totalSaleCurrent ?? 0),
                              maxLines: 1,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFF2C333A)),
                            ),
                            const Text(
                              "Doanh số",
                              style: TextStyle(color: Color(0xFF929DAA)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 1,
                    color: Colors.grey.shade300,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: ListTile(
                        contentPadding: const EdgeInsets.only(left: 12),
                        leading: const CircleAvatar(
                          backgroundColor: Colors.green,
                          radius: 20,
                          child: Icon(
                            FontAwesomeIcons.replyAll,
                            color: Colors.white,
                          ),
                        ),
                        title: AutoSizeText(
                          "${_vm.report?.overview?.totalOrderReturns ?? 0} phiếu",
                          maxLines: 1,
                          style: const TextStyle(color: Color(0xFF28A745)),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              vietnameseCurrencyFormat(
                                  _vm.report?.overview?.totalReturn ?? 0),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFF2C333A)),
                            ),
                            const Text("Trả hàng",
                                style: TextStyle(color: Color(0xFF929DAA)))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  bool isAppearMenu = false;
  void onMenuTap() {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => Hero(
          tag: 'hero',
          child: ReportDashboardOtherReportPage(),
        ),
      ),
    );
  }

  Widget _buildMenu() {
    final Widget myDivider = Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: Container(
        width: double.infinity,
        height: 1,
        color: Colors.grey.shade100,
      ),
    );
    return !isAppearMenu
        ? const SizedBox()
        : Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    onMenuTap();
                  },
                  child: const Scaffold(
                    backgroundColor: Colors.transparent,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      getScreenWidth(context) / (isTablet(context) ? 1.7 : 3),
                      80,
                      5,
                      8),
                  child: myFadeAnim(
                      controller: _animationController,
                      isFadeIn: openMenu,
                      fromTop: true,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black54,
                                  offset: Offset(0, 5),
                                  blurRadius: 20,
                                )
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                title: const Text(
                                  "Hóa đơn đã bán",
                                  style: TextStyle(color: Colors.black),
                                ),
                                trailing: const Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.black,
                                ),
                                onTap: () {
                                  onMenuTap();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ReportOrderPage(),
                                    ),
                                  );
                                },
                              ),
                              myDivider,
                              ListTile(
                                title: const Text(
                                  "Thống kê giao hàng",
                                  style: TextStyle(color: Colors.black),
                                ),
                                trailing: const Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.black,
                                ),
                                onTap: () {
                                  onMenuTap();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ReportDeliveryOrderPage()));
                                },
                              ),

                              ListTile(
                                title: const Text(
                                  "Thống kê xuất nhập tồn",
                                  style: TextStyle(color: Colors.black),
                                ),
                                trailing: const Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.black,
                                ),
                                onTap: () {
                                  onMenuTap();
                                  Navigator.pushNamed(
                                      context, AppRoute.inventoryReport);
                                },
                              ),
                              ListTile(
                                title: const Text(
                                  "Báo cáo kết quả kinh doanh",
                                  style: TextStyle(color: Colors.black),
                                ),
                                trailing: const Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.black,
                                ),
                                onTap: () {
                                  onMenuTap();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const BusinessResultPage()));
                                },
                              ),
                              ListTile(
                                title: const Text(
                                  "Báo cáo công nợ khách hàng",
                                  style: TextStyle(color: Colors.black),
                                ),
                                trailing: const Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.black,
                                ),
                                onTap: () {
                                  onMenuTap();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PartnerReportPage()));
                                },
                              ),
                              ListTile(
                                title: const Text(
                                  "Báo cáo công nợ nhà cung cấp",
                                  style: TextStyle(color: Colors.black),
                                ),
                                trailing: const Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.black,
                                ),
                                onTap: () {
                                  onMenuTap();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SupplierReportPage()));
                                },
                              ),

                              ///       Thử máy in

                              /*
                              myDivider,
                              ListTile(
                                title: Text(
                                  "Thử mẫu in",
                                  style: TextStyle(color: Colors.black),
                                ),
                                trailing: Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.black,
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PageTestPrinterCuaQuan()));
                                },
                              ),*/
//                              ListTile(
//                                title: Text(
//                                  "Lịch sử hoạt động",
//                                  style: TextStyle(color: Colors.black),
//                                ),
//                                trailing: Icon(
//                                  Icons.keyboard_arrow_right,
//                                  color: Colors.black,
//                                ),
//                                onTap: () {
//                                  onMenuTap();
//                                  Navigator.push(
//                                    context,
//                                    MaterialPageRoute(
//                                      builder: (context) =>
//                                          UserActivitiesPage(),
//                                    ),
//                                  );
//                                },
//                              ),
//                              myDivider,
//                              ListTile(
//                                title: Text(
//                                  "Đổi mật khẩu",
//                                  style: TextStyle(color: Colors.black),
//                                ),
//                                trailing: Icon(
//                                  Icons.keyboard_arrow_right,
//                                  color: Colors.black,
//                                ),
//                                onTap: () {
//                                  onMenuTap();
//                                  openChangePassWordDialog();
//                                },
//                              ),
                            ],
                          ),
                        ),
                      )),
                ),
              ],
            ),
          );
  }

  Widget _myCusContainer({Widget child}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        //clipBehavior: Clip.antiAlias,
        /*shape: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 0.5),
            gapPadding: 12),*/
        child: child,
      ),
    );
  }

  Widget _buildLineChart() {
    return _myCusContainer(child: LineChartPage(scaffoldKey: _scaffoldKey));
  }

  Widget _buildPieChart() {
    return _myCusContainer(child: PieChartPage(scaffoldKey: _scaffoldKey));
  }

  Widget _buildColumnChart() {
    return _myCusContainer(child: ColumnChartPage(scaffoldKey: _scaffoldKey));
  }

  void openChangePassWordDialog() {
    showDialog(
      context: context,
      builder: (context) => ChangePassWordDialog(_scaffoldKey),
    );
  }

  void _buildBottomSheetOption(BuildContext contextBuild, int countWarning,
      List<Items> items, String alertId,
      {List<StockWarehouseProduct> productMax,
      List<StockWarehouseProduct> productMin}) {
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
                  leading: const Icon(
                    FontAwesomeIcons.exclamationTriangle,
                    color: Colors.orange,
                    size: 16,
                  ),
                  title: Text("Cảnh báo ($countWarning)"),
                  onTap: () async {
                    Navigator.pop(contextBuild);
                    _showDialogAddTag(items, alertId);
                  },
                ),
                Divider(
                  height: 0.5,
                  color: Colors.grey[300],
                ),
                ListTile(
                  leading: SvgPicture.asset(
                    "assets/icon/ic_product_warning.svg",
                    width: 24,
                    height: 24,
                  ),
                  title: Text("Sản phẩm sắp hết(${productMin.length})"),
                  onTap: () async {
                    Navigator.pop(contextBuild);
                  },
                ),
                Divider(
                  height: 0.5,
                  color: Colors.grey[300],
                ),
                ListTile(
                  leading: SvgPicture.asset(
                    "assets/icon/ic_product_warning_green.svg",
                    width: 24,
                    height: 24
                  ),
                  title: Text("Sản phẩm vượt tầm tối đa(${productMax.length})"),
                  onTap: () async {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  void _showDialogAddTag(List<Items> items, String alertId) {
    showDialog(
      useRootNavigator: false,
      barrierDismissible: false,
      context: context,
      builder: (contxt) {
        return AlertDialog(
          titlePadding: const EdgeInsets.only(bottom: 12, top: 12),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              width: 0,
            ),
          ),
          title: Row(
            children: const [
              SizedBox(
                width: 16,
              ),
              Icon(
                FontAwesomeIcons.exclamationTriangle,
                color: Colors.orange,
                size: 16,
              ),
              SizedBox(
                width: 16,
              ),
              Text(
                "Cảnh báo",
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: items
                    .map((item) => ItemWarning(
                          item: item,
                        ))
                    .toList()),
          ),
          actions: <Widget>[
            Container(
              width: 120,
              height: 40,
              decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE9EDF2)),
                  borderRadius: BorderRadius.circular(5)),
              child: FlatButton(
                child: const Text(
                  "Đóng",
                  style: TextStyle(color: Color(0xFF5A6271)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Container(
              width: 120,
              height: 40,
              decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF28A745)),
                  borderRadius: BorderRadius.circular(5)),
              child: FlatButton.icon(
                icon: const Icon(
                  Icons.check,
                  color: Color(0xFF28A745),
                ),
                label: const Text(
                  "Đã xem",
                  style: TextStyle(color: Color(0xFF28A745)),
                ),
                onPressed: () async {
                  _vm.readAlert(alertId);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class ItemWarning extends StatelessWidget {
  const ItemWarning({this.item});
  final Items item;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 12, right: 12, top: 4),
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
              shape: BoxShape.circle, color: Color(0xFF28A745)),
        ),
        Expanded(
            child: Column(
          children: [
            splitContent(),
            const SizedBox(
              height: 6,
            ),
            Row(
              children: [
                SvgPicture.asset(
                  "assets/icon/tag-green.svg",
                  width: 13,
                  height: 13,
                  color: const Color(0xFF858F9B),
                ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                    child: Text(
                  item.typeText,
                  style:
                      const TextStyle(color: Color(0xFF858F9B), fontSize: 13),
                )),
                InkWell(
                  onTap: () {},
                  child: const Text(
                    "Chi tiết",
                    style: TextStyle(color: Color(0xFF2395FF), fontSize: 13),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_right,
                  color: Color(0xFF2395FF),
                  size: 18,
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ))
      ],
    );
  }

  Widget splitContent() {
    final String newContent = item.content.replaceAll("</strong>", "<strong>");
    final List<String> contents = newContent.split("<strong>");
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
              text: contents[0],
              style: const TextStyle(color: Color(0xFF2C333A), fontSize: 14)),
          TextSpan(
            text: contents[1],
            style: const TextStyle(
                color: Color(0xFF2C333A),
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: contents[2],
            style: const TextStyle(color: Color(0xFF2C333A), fontSize: 14),
          ),
          TextSpan(
            text: contents[3],
            style: const TextStyle(
                color: Color(0xFF2C333A),
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: contents[4],
            style: const TextStyle(color: Color(0xFF2C333A), fontSize: 14),
          ),
          TextSpan(
            text: contents[5],
            style: const TextStyle(
                color: Color(0xFF2C333A),
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
