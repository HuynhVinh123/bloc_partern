import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/filter_report_delivery/filter_report_delivery_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/report_delivery_order_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/report_delivery_order_event.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/report_delivery_order_state.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/uis/report_delivery_order_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/ui/empty_data_page.dart';
import 'package:tpos_mobile/helpers/svg_icon.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_loading_screen.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import '../blocs/filter_report_delivery/filter_report_delivery_state.dart';

class ReportDeliveryOrderPartnerPage extends StatefulWidget {
  const ReportDeliveryOrderPartnerPage(
      {this.filterBloc, this.scaffoldKey, this.bloc,this.onChangeFilter});

  final ReportDeliveryOrderBloc bloc;
  final FilterReportDeliveryBloc filterBloc;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function onChangeFilter;

  @override
  _ReportDeliveryOrderPartnerPageState createState() =>
      _ReportDeliveryOrderPartnerPageState();
}

class _ReportDeliveryOrderPartnerPageState
    extends State<ReportDeliveryOrderPartnerPage> {
  final int _limit = 50;
  int _skip = 0;

  @override
  void initState() {
    super.initState();
    widget.bloc.add(DeliveryReportCustomerLoaded(skip: _skip, limit: _limit));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            _buildFilter(),
            Expanded(child: _buildBody()),
          ],
        ),
      ],
    );
  }

  Widget _buildBody() {
    return BlocLoadingScreen<ReportDeliveryOrderBloc>(
      busyStates: const [DeliveryReportCustomerLoading],
      child: BlocBuilder<ReportDeliveryOrderBloc, ReportDeliveryOrderState>(
          buildWhen: (prevState, currState) {
        if (currState is DeliveryReportCustomerLoadSuccess) {
          return true;
        }
        return false;
      }, builder: (context, state) {
        if (state is DeliveryReportCustomerLoadSuccess) {
          return state.deliveryReportCustomers.isEmpty
              ? EmptyDataPage()
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 10),
                  itemCount: state.deliveryReportCustomers.length,
                  itemBuilder: (context, index) => _buildItem(
                      state.deliveryReportCustomers[index],
                      state.deliveryReportCustomers,
                      index));
        }
        return const SizedBox();
      }),
    );
  }

  Widget _buildItem(ReportDeliveryCustomer item,
      List<ReportDeliveryCustomer> deliveryReportCustomers, int index) {
    return item.userName == "temp"
        ? _buildButtonLoadMore(index, deliveryReportCustomers)
        : InkWell(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
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
                      style: const TextStyle(color: Color(0xFF6B7280),fontWeight: FontWeight.bold),
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
                          child: InkWell(
                            onTap: (){
                              openCallPhone(item.phone);
                            },
                            child: Text(
                              "${S.current.phone}: ${item.phone ?? ""}",
                              style: const TextStyle(
                                  color: Color(0xFF929DAA), fontSize: 14),
                            ),
                          ),
                        ),
                        const Text("  |  "),
                        Flexible(
                          child: InkWell(
                            onTap: (){
                              openFacebook(item.partnerFacebookId);
                            },
                            child: Text(
                              "FB: ${item.partnerFacebookId ?? ""}",
                              style: const TextStyle(
                                  color: Color(0xFF929DAA), fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: <Widget>[
                        const SvgIcon(SvgIcon.revenue),
                        const SizedBox(
                          width: 6,
                        ),
                        Flexible(
                          child: Text(
                            item.totalBill != null
                                ? item.totalBill.toString()
                                : "0",
                            style: const TextStyle(color: Color(0xFF2C333A)),
                          ),
                        ),
                        const Text("  |  "),
                        const SvgIcon(SvgIcon.count),
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
                              vietnameseCurrencyFormat(item.deliveryPrice ?? 0),
                              style: const TextStyle(color: Color(0xFF2C333A))),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  void openCallPhone(String phoneNumber){
    if(phoneNumber != null && phoneNumber != ''){
      UrlLauncher.launch('tel: $phoneNumber');
    }

  }

  void openFacebook(String id){
    if(id != null && id!= ''){
      UrlLauncher.launch('https://www.facebook.com/$id');
    }
  }

  Widget _buildFilter() {
    return BlocBuilder<FilterReportDeliveryBloc, FilterReportDeliveryState>(
        buildWhen: (prevState, curState) {
          if (curState is FilterReportDeliveryLoadSuccess &&
              curState.isConfirm) {
            return true;
          }
          return false;
        },
        cubit: widget.filterBloc,
        builder: (context, state) {
          if (state is FilterReportDeliveryLoadSuccess) {
            return  Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                height: 40,
                child: FilterDateByDelivery(
                  state: state,
                  onChangeFilter: widget.onChangeFilter,
                )

            );
          }
          return const SizedBox();
        });
  }

  Widget _buildButtonLoadMore(
      int index, List<ReportDeliveryCustomer> deliveryReportCustomers) {
    return BlocBuilder<ReportDeliveryOrderBloc, ReportDeliveryOrderState>(
        builder: (context, state) {
      if (state is DeliveryReportCustomerLoadMoreLoading) {
        return Center(
          child: SpinKitCircle(
            color: Theme.of(context).primaryColor,
          ),
        );
      }
      return Center(
        child: Container(
            margin:
                const EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 8),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(3)),
            height: 45,
            child: FlatButton(
              onPressed: () {
                _skip += _limit;
                widget.bloc.add(DeliveryReportCustomerLoadMoreLoaded(
                    limit: _limit,
                    skip: _skip,
                    deliveryReportCustomers: deliveryReportCustomers));
              },
              color: Colors.blueGrey,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
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
