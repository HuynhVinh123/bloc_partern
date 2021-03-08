import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/app_core/template_ui/creation_aware_list_item.dart';
import 'package:tpos_mobile/app_core/template_ui/empty_data_widget.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/reports/viewmodels/partner_staff_detail_report_viewmodel.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/src/tpos_apis/models/partner_staff_detail_report.dart';

// ignore: must_be_immutable
class PartnerStaffDetailReportPage extends StatefulWidget {
  PartnerStaffDetailReportPage(
      {this.dataFrom, this.dateTo, this.resultSelection, this.partnerId});

  String dataFrom;
  String dateTo;
  String resultSelection;
  String partnerId;

  @override
  _PartnerStaffDetailReportPageState createState() =>
      _PartnerStaffDetailReportPageState();
}

class _PartnerStaffDetailReportPageState
    extends State<PartnerStaffDetailReportPage> {
  final _vm = locator<PartnerStaffDetailReportViewModel>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _vm.getPartnerStaffDetailReports(
        dateTo: widget.dateTo,
        dataFrom: widget.dataFrom,
        resultSelection: widget.resultSelection,
        partnerId: widget.partnerId);
  }

  @override
  Widget build(BuildContext context) {
    return ViewBase<PartnerStaffDetailReportViewModel>(
        model: _vm,
        builder: (context, model, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Chi tiết báo cáo"),
            ),
            body: _vm.partnerStaffDetailReports.isNotEmpty &&
                    _vm.partnerStaffDetailReports != null
                ? buildListItem()
                : EmptyData(
                    onPressed: () {
                      _vm.getPartnerStaffDetailReports(
                          dateTo: widget.dateTo,
                          dataFrom: widget.dataFrom,
                          resultSelection: widget.resultSelection,
                          partnerId: widget.partnerId);
                    },
                  ),
          );
        });
  }

  Widget buildListItem() {
    return ListView.builder(
        itemCount: _vm.partnerStaffDetailReports?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return CreationAwareListItem(
            itemCreated: () {
              SchedulerBinding.instance
                  .addPostFrameCallback((duration) => _vm.handleItemCreated(
                        index,
                        dateTo: widget.dateTo,
                        dataFrom: widget.dataFrom,
                        resultSelection: widget.resultSelection,
                        partnerId: widget.partnerId,
                      ));
            },
            child: _vm.partnerStaffDetailReports[index] == temp
                ? Center(
                    child: SpinKitCircle(
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                : Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    child: _showItem(_vm.partnerStaffDetailReports[index]),
                  ),
          );
        });
  }

  Widget _showItem(PartnerStaffDetailReport item) {
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
                          text: "Mã: ",
                          style: const TextStyle(
                              fontSize: 16.0, color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                                text: "${item.number ?? ""} ",
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
                Row(
                  children: <Widget>[
                    Text(
                      "Tiền đơn hàng: ",
                      style: TextStyle(color: Colors.grey[900], fontSize: 16),
                    ),
                    Text(
                      vietnameseCurrencyFormat(item.amountTotal ?? 0),
                      style: const TextStyle(
                          color: Colors.green,
                          fontSize: 17,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                Divider(
                  color: Colors.grey.shade400,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Còn nợ: ",
                            style: TextStyle(
                                color: Colors.grey[900], fontSize: 16),
                          ),
                          Text(
                            vietnameseCurrencyFormat(item.residual ?? 0),
                            style: const TextStyle(
                                color: Colors.red,
                                fontSize: 17,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Ngày: ${DateFormat("dd/MM/yyyy").format(DateTime.fromMicrosecondsSinceEpoch(int.parse(item.dateInvoice.toString().substring(6, item.dateInvoice.toString().length - 2)) * 1000))}",
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          )
        ],
      ),
    );
  }
}
