import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/report_delivery_order_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/report_delivery_order_event.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/report_delivery_order_state.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/ui/empty_data_page.dart';
import 'package:tpos_mobile/widgets/loading_indicator.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import '../report_delivery_helpers.dart';

class ReportDeliveryOrderEmployeeInfoPage extends StatefulWidget {
  const ReportDeliveryOrderEmployeeInfoPage({this.bloc, this.id});
  final ReportDeliveryOrderBloc bloc;
  final String id;
  @override
  _ReportDeliveryOrderEmployeeInfoPageState createState() =>
      _ReportDeliveryOrderEmployeeInfoPageState();
}

class _ReportDeliveryOrderEmployeeInfoPageState
    extends State<ReportDeliveryOrderEmployeeInfoPage> {
  final int _limit = 50;
  int _skip = 0;

  @override
  void initState() {
    super.initState();

    widget.bloc.add(DetailDeliveryReportStaffLoaded(
        limit: _limit, skip: _skip, userId: widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        body: Stack(
          children: <Widget>[
            _buildBody(),
            BlocBuilder<ReportDeliveryOrderBloc, ReportDeliveryOrderState>(
                cubit: widget.bloc,
                builder: (context, state) {
                  if (state is DeliveryReportStaffLoading) {
                    return LoadingIndicator();
                  }
                  return const SizedBox();
                })
          ],
        ));
  }

  Widget _buildAppBar() {
    return AppBar(
      /// Danh sách hóa đơn
      title: Text(S.current.reportOrder_Invoices),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<ReportDeliveryOrderBloc, ReportDeliveryOrderState>(
        cubit: widget.bloc,
        buildWhen: (prevState, currState) {
          if (currState is DetailDeliveryReportStaffLoadSuccess) {
            return true;
          }
          return false;
        },
        builder: (context, state) {
          if (state is DetailDeliveryReportStaffLoadSuccess) {
            return state.detailReportStaffs.isEmpty ? EmptyDataPage() : ListView.builder(
                padding: const EdgeInsets.only(top: 10),
                itemCount: state.detailReportStaffs.length ?? 0,
                itemBuilder: (context, index) => _buildItem(
                    state.detailReportStaffs[index],
                    index,
                    state.detailReportStaffs));
          }
          return const SizedBox();
        });
  }

  Widget _buildItem(ReportDeliveryOrderDetail item, int index,
      List<ReportDeliveryOrderDetail> detailReportStaffs) {
    return item.userName == "detailTemp"
        ? _buildButtonLoadMore(index, detailReportStaffs)
        : Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            margin: const EdgeInsets.only(right: 12, left: 12, bottom: 10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(6)),
            child: ListTile(
              title: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      item.partnerDisplayName ?? "",
                      style: const TextStyle(
                          color: Color(0xFF28A745),
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Text(
                    vietnameseCurrencyFormat(item.amountTotal ?? 0),
                    style: const TextStyle(color: Color(0xFFF25D27)),
                  )
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          item.number ?? "",
                          style: const TextStyle(
                              color: Color(0xFF929DAA), fontSize: 16),
                        ),
                      ),
                      const Text("  |  "),
                      Text(
                        DateFormat("dd/MM/yyyy").format(item.dateInvoice),
                        style: const TextStyle(color: Color(0xFF929DAA)),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: <Widget>[
                      SvgPicture.asset(
                        "assets/icon/ic_count.svg",
                        alignment: Alignment.center,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Flexible(
                        child: Text(
                          vietnameseCurrencyFormat(item.cashOnDelivery ?? 0),
                          style: const TextStyle(color: Color(0xFF2C333A)),
                        ),
                      ),
                      const Text("  |  "),
                      const Icon(
                        FontAwesomeIcons.truck,
                        color: const Color(0xFF929daa),
                        size: 13,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Text(
                            vietnameseCurrencyFormat(
                                item.customerDeliveryPrice ?? 0),
                            style: const TextStyle(color: Color(0xFF2C333A))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: <Widget>[
                      if (getImageLinkDeliverCarrierPartner(
                              item.carrierDeliveryType) ==
                          "")
                        const SizedBox()
                      else
                        Image.asset(
                          getImageLinkDeliverCarrierPartner(
                              item.carrierDeliveryType),
                          alignment: Alignment.center,
                          width: 35,
                          height: 30,
                          fit: BoxFit.fill,
                        ),
                      Visibility(
                        visible: getImageLinkDeliverCarrierPartner(
                                item.carrierDeliveryType) !=
                            "",
                        child: const SizedBox(
                          width: 4,
                        ),
                      ),
                      Flexible(child: Text(item.trackingRef ?? "")),
                      const Text(" / "),
                      Text(item.shipPaymentStatus ?? "")
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: <Widget>[
                      /// Đối soát giao hàng
                      Text("${S.current.reportOrder_deliveryControl}: "),
                      Text(item.showShipStatus,
                          style: const TextStyle(color: Color(0xFF28A745)))
                    ],
                  )
                ],
              ),
            ),
          );
  }

  Widget _buildButtonLoadMore(
      int index, List<ReportDeliveryOrderDetail> detailReportStaffs) {
    return BlocBuilder<ReportDeliveryOrderBloc, ReportDeliveryOrderState>(
        cubit: widget.bloc,
        builder: (context, state) {
          if (state is DeliveryReportStaffLoadMoreLoading) {
            return Center(
              child: SpinKitCircle(
                color: Theme.of(context).primaryColor,
              ),
            );
          }
          return Center(
            child: Container(
                margin: const EdgeInsets.only(
                    top: 12, left: 12, right: 12, bottom: 8),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(3)),
                height: 45,
                child: FlatButton(
                  onPressed: () {
                    _skip += _limit;
                    widget.bloc.add(DetailDeliveryReportStaffLoadMoreLoaded(
                        limit: _limit,
                        skip: _skip,
                        detailReportStaffs: detailReportStaffs,
                        userId: widget.id));
                  },
                  color: Colors.blueGrey,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  <Widget>[
                        /// Tải thêm
                        Text(S.current.loadMore,
                            style:
                                const TextStyle(color: Colors.white, fontSize: 16)),
                        const SizedBox(
                          width: 12,
                        ),
                        const Icon(
                          Icons.save_alt,
                          color: Colors.white,
                          size: 18,
                        )
                      ],
                    ),
                  ),
                )),
          );
        });
  }
}
