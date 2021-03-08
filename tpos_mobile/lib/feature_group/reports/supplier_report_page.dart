import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_datetime.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_drawer.dart';
import 'package:tpos_mobile/app_core/template_ui/creation_aware_list_item.dart';
import 'package:tpos_mobile/app_core/template_ui/empty_data_widget.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/reports/supplier_detail_report_page.dart';
import 'package:tpos_mobile/feature_group/reports/viewmodels/supplier_report_viewmodel.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/src/tpos_apis/models/supplier_report.dart';

import 'filter_search_page.dart';

class SupplierReportPage extends StatefulWidget {
  @override
  _SupplierReportPageState createState() => _SupplierReportPageState();
}

class _SupplierReportPageState extends State<SupplierReportPage> {
  final _viewModel = locator<SupplierReportViewModel>();
  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _viewModel.getSupplierReports();
  }

  @override
  Widget build(BuildContext context) {
    return ViewBase<SupplierReportViewModel>(
        model: _viewModel,
        builder: (context, model, sizingInformation) {
          return Scaffold(
              key: _key,
              endDrawer: buildFilterPanel(),
              appBar: AppBar(
                title: const Text("Công nợ nhà cung cấp"),
                actions: const <Widget>[SizedBox()],
              ),
              body: Column(
                children: <Widget>[
                  buildFilter(),
                  Expanded(
                    child: _viewModel.supplierReports.isNotEmpty &&
                            _viewModel.supplierReports != null
                        ? buildListItem()
                        : EmptyData(
                            onPressed: () {
                              _viewModel.getSupplierReports();
                            },
                          ),
                  )
                ],
              ));
        });
  }

  Widget buildListItem() {
    return ListView.builder(
        itemCount: _viewModel.supplierReports?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return CreationAwareListItem(
            itemCreated: () {
              SchedulerBinding.instance.addPostFrameCallback(
                  (duration) => _viewModel.handleItemCreated(index));
            },
            child: _viewModel.supplierReports[index] == temp
                ? Center(
                    child: SpinKitCircle(
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                : Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                    child: _showItem(_viewModel.supplierReports[index]),
                  ),
          );
        });
  }

  Widget _showItem(SupplierReport item) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(3.0)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey[400],
                offset: const Offset(-2, 2),
                blurRadius: 1)
          ]),
      child: Column(
        children: <Widget>[
          ListTile(
            onTap: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SupplierDetailReportPage(
                          dateTo: DateFormat("dd/MM/yyyy")
                              .format(_viewModel.filterToDate),
                          dataFrom: DateFormat("dd/MM/yyyy")
                              .format(_viewModel.filterFromDate),
                          resultSelection: "supplier",
                          companyId: _viewModel.companyOfUser == null
                              ? null
                              : _viewModel.companyOfUser.value,
                          partnerId: item.partnerId.toString())));
            },
            title: Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 6),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                          text: "Tên KH/FB: ",
                          style: const TextStyle(
                              fontSize: 16.0, color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                                text: "${item.partnerName ?? ""} ",
                                style: const TextStyle(
                                    color: Colors.blue, fontSize: 17)),
                          ]),
                    ),
                  ),
                ],
              ),
            ),
            subtitle: Column(
              children: <Widget>[
//                new Text(
//                  "Mã KH: ${item.code ?? ""}",
//                  style: TextStyle(color: Colors.black, fontSize: 16),
//                ),
//                SizedBox(
//                  height: 2,
//                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "Số ĐT: ${item.partnerPhone ?? ""}",
                        style:
                            const TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                    Text(
                      "Mã: ${item.code ?? ""}",
                      style: TextStyle(color: Colors.grey[500], fontSize: 16),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey.shade300,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "Nợ cuối kỳ: ",
                      style: TextStyle(color: Colors.grey[900]),
                    ),
                    Text(
                      vietnameseCurrencyFormat(item.end ?? 0),
                      style: const TextStyle(
                          color: Colors.red,
                          fontSize: 17,
                          fontWeight: FontWeight.w600),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            _settingModalBottomSheet(context, item);
                          },
                          child: const Text(
                            "Chi tiết",
                            style: TextStyle(color: Colors.blue, fontSize: 16),
                          ),
                        ),
                      ),
                    )
                  ],
                ),

                const SizedBox(
                  height: 4,
                )
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          )
        ],
      ),
    );
  }

  Widget buildFilterPanel() {
    return AppFilterDrawerContainer(
      onRefresh: () {
        _viewModel.resetFilter();
      },
      closeWhenConfirm: true,
      onApply: () {
        _viewModel.getSupplierReports();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppFilterDateTime(
            isSelected: _viewModel.isFilterByDate,
            initDateRange: _viewModel.filterDateRange,
            toDate: _viewModel.filterToDate,
            fromDate: _viewModel.filterFromDate,
            dateRangeChanged: (value) {
              _viewModel.filterDateRange = value;
            },
            onFromDateChanged: (value) {
              _viewModel.filterFromDate = value;
            },
            onToDateChanged: (value) {
              _viewModel.filterToDate = value;
            },
          ),
          const SizedBox(
            height: 4,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FilterSearchPage(
                              nameSelect: "company",
                            ))).then((value) {
                  if (value != null) {
                    _viewModel.companyOfUser = value;
                  }
                });
              },
              child: Container(
                height: 45,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey[300])),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        " ${_viewModel.companyOfUser == null ? "Chọn công ty" : _viewModel.companyOfUser.text}",
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ),
                    Visibility(
                      visible: _viewModel.companyOfUser != null,
                      child: Container(
                        width: 45,
                        height: 45,
                        child: InkWell(
                          onTap: () {
                            _viewModel.companyOfUser = null;
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey[600],
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FilterSearchPage(
                              nameSelect: "supplier",
                            ))).then((value) {
                  if (value != null) {
                    _viewModel.supplier = value;
                  }
                });
              },
              child: Container(
                height: 45,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey[300])),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        " ${_viewModel.supplier != null ? _viewModel.supplier.displayName : "Chọn nhà cung cấp"}",
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ),
                    Visibility(
                      visible: _viewModel.supplier != null,
                      child: Container(
                        width: 45,
                        height: 45,
                        child: InkWell(
                          onTap: () {
                            _viewModel.supplier = null;
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey[600],
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "Hiển thị",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ),
          Row(
            children: <Widget>[
              Radio(
                value: 0,
                groupValue: _viewModel.display,
                onChanged: (value) {
                  _viewModel.changeDisplay(value);
                },
              ),
              const Text(
                "Tất cả",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(
                width: 24,
              ),
              Radio(
                value: 1,
                groupValue: _viewModel.display,
                onChanged: (value) {
                  _viewModel.changeDisplay(value);
                },
              ),
              const Text(
                "Nợ cuối kỳ khác 0",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildFilter() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            offset: const Offset(0, 2), blurRadius: 2, color: Colors.grey[400])
      ]),
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 12, right: 15.0),
        child: GestureDetector(
          onTap: () {
            _key.currentState.openEndDrawer();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Badge(
                badgeColor: Colors.redAccent,
                badgeContent: Text(
                  "${_viewModel.countFilter()}",
                  style: const TextStyle(color: Colors.white),
                ),
                child: Row(
                  children: const <Widget>[
                    Text(
                      "Lọc",
                    ),
                    Icon(
                      Icons.filter_list,
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _settingModalBottomSheet(context, SupplierReport item) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  title: Row(
                    children: <Widget>[
                      Text(
                        "Nợ đầu kỳ:  ",
                        style: TextStyle(color: Colors.grey[900]),
                      ),
                      Text(
                        vietnameseCurrencyFormat(item.begin ?? 0),
                        style: const TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
                ListTile(
                    title: Row(
                  children: <Widget>[
                    Text(
                      "Nợ cuối kỳ:  ",
                      style: TextStyle(color: Colors.grey[900]),
                    ),
                    Text(
                      vietnameseCurrencyFormat(item.end ?? 0),
                      style: const TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                )),
                ListTile(
                    title: Row(
                  children: <Widget>[
                    Text(
                      "Phát sinh:  ",
                      style: TextStyle(color: Colors.grey[900]),
                    ),
                    Text(
                      vietnameseCurrencyFormat(item.debit ?? 0),
                      style: const TextStyle(
                          color: Colors.green,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                )),
                ListTile(
                    title: Row(
                  children: <Widget>[
                    Text(
                      "Thanh toán:  ",
                      style: TextStyle(color: Colors.grey[900]),
                    ),
                    Text(
                      vietnameseCurrencyFormat(item.credit ?? 0),
                      style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                )),
              ],
            ),
          );
        });
  }
}
