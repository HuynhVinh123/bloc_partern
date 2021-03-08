import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/app_core/template_ui/creation_aware_list_item.dart';
import 'package:tpos_mobile/app_core/template_ui/empty_data_widget.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/reports/viewmodels/supplier_detail_report_viewmodel.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/src/tpos_apis/models/partner_detail_report.dart';

// ignore: must_be_immutable
class SupplierDetailReportPage extends StatefulWidget {
  SupplierDetailReportPage(
      {this.dataFrom,
      this.dateTo,
      this.resultSelection,
      this.companyId,
      this.partnerId});

  String dataFrom;
  String dateTo;
  String resultSelection;
  String companyId;
  String partnerId;

  @override
  _SupplierDetailReportPageState createState() =>
      _SupplierDetailReportPageState();
}

class _SupplierDetailReportPageState extends State<SupplierDetailReportPage> {
  final _vm = locator<SupplierDetailReportViewModel>();

  @override
  void initState() {
    super.initState();
    _vm.getSupplierDetailReports(
        dateTo: widget.dateTo,
        dataFrom: widget.dataFrom,
        resultSelection: widget.resultSelection,
        companyId: widget.companyId,
        partnerId: widget.partnerId);
  }

  @override
  Widget build(BuildContext context) {
    return ViewBase<SupplierDetailReportViewModel>(
        model: _vm,
        builder: (context, model, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Chi tiết báo cáo"),
            ),
            body: _vm.supplierDetailReports.isNotEmpty &&
                    _vm.supplierDetailReports != null
                ? buildListItem()
                : EmptyData(
                    onPressed: () {
                      _vm.getSupplierDetailReports(
                          dateTo: widget.dateTo,
                          dataFrom: widget.dataFrom,
                          resultSelection: widget.resultSelection,
                          companyId: widget.companyId,
                          partnerId: widget.partnerId);
                    },
                  ),
          );
        });
  }

  Widget buildListItem() {
    return ListView.builder(
        itemCount: _vm.supplierDetailReports?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return CreationAwareListItem(
            itemCreated: () {
              SchedulerBinding.instance
                  .addPostFrameCallback((duration) => _vm.handleItemCreated(
                        index,
                        dateTo: widget.dateTo,
                        dataFrom: widget.dataFrom,
                        resultSelection: widget.resultSelection,
                        companyId: widget.companyId,
                        partnerId: widget.partnerId,
                      ));
            },
            child: _vm.supplierDetailReports[index] == temp
                ? Center(
                    child: SpinKitCircle(
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                : Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    child: _showItem(_vm.supplierDetailReports[index]),
                  ),
          );
        });
  }

  Widget _showItem(PartnerDetailReport item) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(3.0)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey[400],
                offset: const Offset(0, 2),
                blurRadius: 3)
          ]),
      child: Column(
        children: <Widget>[
          ListTile(
            onTap: () async {},
            title: Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 2),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                          text: "Diễn giải: ",
                          style: const TextStyle(
                              fontSize: 16.0, color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                                text: "${item.name ?? ""} ",
                                style: const TextStyle(
                                    color: Colors.blue, fontSize: 18)),
                          ]),
                    ),
                  ),
                ],
              ),
            ),
            subtitle: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "Ngày: ${DateFormat("dd/MM/yyyy").format(DateTime.fromMicrosecondsSinceEpoch(int.parse(item.date.toString().substring(6, item.date.toString().length - 2)) * 1000))}",
                        style:
                            const TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                    Text(
                      "Bút toán: ${item.moveName ?? ""}",
                      style: TextStyle(color: Colors.grey[500], fontSize: 16),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey.shade400,
                ),
                const SizedBox(
                  height: 4,
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
                            style: TextStyle(color: Colors.green, fontSize: 16),
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
            onLongPress: () {},
          )
        ],
      ),
    );
  }

  void _settingModalBottomSheet(context, PartnerDetailReport item) {
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
