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
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/feature_group/reports/partner_detail_report_page.dart';
import 'package:tpos_mobile/feature_group/reports/partner_staff_detail_report_page.dart';
import 'package:tpos_mobile/feature_group/reports/viewmodels/partner_report_viewmodel.dart';

import 'package:tpos_mobile/src/tpos_apis/models/partner_report.dart';
import 'package:url_launcher/url_launcher.dart';

import 'filter_search_page.dart';

class PartnerReportPage extends StatefulWidget {
  @override
  _PartnerReportPageState createState() => _PartnerReportPageState();
}

class _PartnerReportPageState extends State<PartnerReportPage> {
  var _viewModel = locator<PartnerReportViewModel>();
  var _key = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _viewModel.getPartnerReports();
  }

  @override
  Widget build(BuildContext context) {
    return ViewBase<PartnerReportViewModel>(
        model: _viewModel,
        builder: (context, model, sizingInformation) {
          return Scaffold(
              key: _key,
              endDrawer: buildFilterPanel(),
              appBar: AppBar(
                title: Text("Công nợ khách hàng"),
                actions: <Widget>[SizedBox()],
              ),
              body: Column(
                children: <Widget>[
                  buildFilter(),
                  Expanded(
                    child: _viewModel.partnerReports.isNotEmpty &&
                            _viewModel.partnerReports != null
                        ? buildListItem()
                        : EmptyData(
                            onPressed: () {
                              _viewModel.getPartnerReports();
                            },
                          ),
                  )
                ],
              ));
        });
  }

  Widget buildListItem() {
    return ListView.builder(
        itemCount: _viewModel.partnerReports?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return CreationAwareListItem(
            itemCreated: () {
              SchedulerBinding.instance.addPostFrameCallback(
                  (duration) => _viewModel.handleItemCreated(index));
            },
            child: _viewModel.partnerReports[index] == temp
                ? Center(
                    child: SpinKitCircle(
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                : Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                    child: _showItem(_viewModel.partnerReports[index]),
                  ),
          );
        });
  }

  Widget _showItem(PartnerReport item) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(3.0)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey[400], offset: Offset(-2, 2), blurRadius: 1)
          ]),
      child: new Column(
        children: <Widget>[
          new ListTile(
            onTap: () async {
              if (_viewModel.positionReport == "1") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PartnerDetailReportPage(
                            dateTo: DateFormat("dd/MM/yyyy")
                                .format(_viewModel.filterToDate),
                            dataFrom: DateFormat("dd/MM/yyyy")
                                .format(_viewModel.filterFromDate),
                            resultSelection: "customer",
                            companyId: _viewModel.companyOfUser == null
                                ? null
                                : _viewModel.companyOfUser.value,
                            partnerId: item.partnerId.toString())));
              } else if (_viewModel.positionReport == "2") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PartnerStaffDetailReportPage(
                            dateTo: DateFormat("dd/MM/yyyy")
                                .format(_viewModel.filterToDate),
                            dataFrom: DateFormat("dd/MM/yyyy")
                                .format(_viewModel.filterFromDate),
                            resultSelection: "customer",
                            partnerId: item.partnerId.toString())));
              }
            },
            title: Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 6),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        if (item.partnerFacebookUserId != null &&
                            item.partnerFacebookUserId != "") {
                          var url =
                              "https://www.facebook.com/${item.partnerFacebookUserId}";
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        }
                      },
                      child: RichText(
                        text: TextSpan(
                            text: "Tên KH/FB: ",
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: "${item.partnerName ?? ""} ",
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 17)),
                              TextSpan(
                                  text:
                                      "${item.partnerFacebookUserId == null ? "" : "(${item.partnerFacebookUserId})"}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange))
                            ]),
                      ),
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
                      child: new Text(
                        "Số ĐT: ${item.partnerPhone ?? ""}",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                    new Text(
                      "Mã: ${item.code ?? ""}",
                      style: TextStyle(color: Colors.grey[500], fontSize: 16),
                    ),
                  ],
                ),
                new Divider(
                  color: Colors.grey.shade300,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "Nợ cuối kỳ: ",
                      style: TextStyle(color: Colors.grey[900]),
                    ),
                    Text(
                      "${vietnameseCurrencyFormat(item.end)}",
                      style: TextStyle(
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
                          child: Text(
                            "Chi tiết",
                            style: TextStyle(color: Colors.blue, fontSize: 16),
                          ),
                        ),
                      ),
                    )
                  ],
                ),

                SizedBox(
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
        _viewModel.getPartnerReports();
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
          SizedBox(
            height: 4,
          ),
          Visibility(
            visible: _viewModel.positionReport == "1" ? true : false,
            child: Padding(
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
                          "${_viewModel.companyOfUser == null ? "Chọn công ty" : _viewModel.companyOfUser.text}",
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                      ),
                      Visibility(
                        visible:
                            _viewModel.companyOfUser == null ? false : true,
                        child: Container(
                          width: 45,
                          height: 45,
                          child: InkWell(
                            onTap: () {
                              _viewModel.companyOfUser = null;
                            },
                            child: Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FilterSearchPage(
                              nameSelect: "groupPartner",
                            ))).then((value) {
                  if (value != null) {
                    _viewModel.partnerCategory = value;
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
                        " ${_viewModel.partnerCategory == null ? "Chọn nhóm khách hàng" : "${_viewModel.partnerCategory.name}"}",
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ),
                    Visibility(
                      visible:
                          _viewModel.partnerCategory == null ? false : true,
                      child: Container(
                        width: 45,
                        height: 45,
                        child: InkWell(
                          onTap: () {
                            _viewModel.partnerCategory = null;
                          },
                          child: Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
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
                              nameSelect: "partner",
                            ))).then((value) {
                  if (value != null) {
                    _viewModel.partnerFPO = value;
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
                        " ${_viewModel.partnerFPO == null ? "Chọn khách hàng" : _viewModel.partnerFPO.displayName}",
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ),
                    Visibility(
                      visible: _viewModel.partnerFPO == null ? false : true,
                      child: Container(
                        width: 45,
                        height: 45,
                        child: InkWell(
                          onTap: () {
                            _viewModel.partnerFPO = null;
                          },
                          child: Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
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
                              nameSelect: "employee",
                            ))).then((value) {
                  if (value != null) {
                    _viewModel.applicationUserFPO = value;
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
                        " ${_viewModel.applicationUserFPO == null ? "Chọn nhân viên" : _viewModel.applicationUserFPO.name}",
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ),
                    Visibility(
                      visible:
                          _viewModel.applicationUserFPO == null ? false : true,
                      child: Container(
                        width: 45,
                        height: 45,
                        child: InkWell(
                          onTap: () {
                            _viewModel.applicationUserFPO = null;
                          },
                          child: Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
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
          SizedBox(
            height: 6,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
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
              Text(
                "Tất cả",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                width: 24,
              ),
              Radio(
                value: 1,
                groupValue: _viewModel.display,
                onChanged: (value) {
                  _viewModel.changeDisplay(value);
                },
              ),
              Text(
                "Nợ khác 0",
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
        BoxShadow(offset: Offset(0, 1), blurRadius: 1, color: Colors.grey[400])
      ]),
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 12, right: 15.0),
        child: new GestureDetector(
          onTap: () {
            _key.currentState.openEndDrawer();
          },
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Container(
                    child: _selectReport(),
                  ),
                ),
              ),
              Badge(
                badgeColor: Colors.redAccent,
                badgeContent: Text(
                  "${_viewModel.countFilter()}",
                  style: const TextStyle(color: Colors.white),
                ),
                child: Row(
                  children: <Widget>[
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

  void _settingModalBottomSheet(context, PartnerReport item) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                ListTile(
                  title: Row(
                    children: <Widget>[
                      Text(
                        "Nợ đầu kỳ:  ",
                        style: TextStyle(color: Colors.grey[900]),
                      ),
                      Text(
                        "${vietnameseCurrencyFormat(item.begin)}",
                        style: TextStyle(
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
                      "${vietnameseCurrencyFormat(item.end)}",
                      style: TextStyle(
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
                      "${vietnameseCurrencyFormat(item.debit)}",
                      style: TextStyle(
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
                      "${vietnameseCurrencyFormat(item.credit)}",
                      style: TextStyle(
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

  DropdownButton _selectReport() => DropdownButton<String>(
        items: [
          DropdownMenuItem(
            value: "1",
            child: Text(
              "Công nợ khách hàng",
            ),
          ),
          DropdownMenuItem(
            value: "2",
            child: Text(
              "Công nợ khách hàng theo nhân viên",
            ),
          ),
        ],
        onChanged: (value) {
          _viewModel.changePosition(value);
        },
        value: "${_viewModel.positionReport}",
        isDense: true,
        underline: SizedBox(),
      );
}
