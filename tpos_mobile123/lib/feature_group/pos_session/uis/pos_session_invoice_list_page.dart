import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/account_bank.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/accountbank_line.dart';
import 'package:tpos_mobile/feature_group/pos_order/viewmodels/pos_close_point_sale_list_invoice_viewmodel.dart';
import 'package:tpos_mobile/feature_group/pos_session/bloc/add_edit_detail_account/add_edit_detail_account_bloc.dart';
import 'package:tpos_mobile/feature_group/pos_session/bloc/add_edit_detail_account/add_edit_detail_account_event.dart';
import 'package:tpos_mobile/feature_group/pos_session/bloc/add_edit_detail_account/add_edit_detail_account_state.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_loading_screen.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_ui_provider.dart';
import 'package:tpos_mobile/widgets/info_row.dart';

class PosSessionInvoiceListPage extends StatefulWidget {
  const PosSessionInvoiceListPage({this.accountBank});
  final PosAccountBank accountBank;
  @override
  _PosSessionInvoiceListPageState createState() =>
      _PosSessionInvoiceListPageState();
}

class _PosSessionInvoiceListPageState extends State<PosSessionInvoiceListPage> {
  TextStyle detailFontStyle;
  TextStyle titleFontStyle;
  final _bloc = PosAddEditDetailAccountBloc();

  @override
  Widget build(BuildContext context) {
    titleFontStyle = TextStyle(color: Colors.green);
    detailFontStyle = TextStyle(color: Colors.green);
    return BlocUiProvider<PosAddEditDetailAccountBloc>(
      bloc: _bloc,
      listen: (state) {},
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Chi tiết thanh toán"),
          ),
          body: _buildInfoPointSale()),
    );
  }

  Widget _buildInfoPointSale() {
    const Widget spaceHeight = SizedBox(
      height: 10,
    );
    return BlocLoadingScreen<PosAddEditDetailAccountBloc>(
      busyStates: const [PosSessionDetailAccountLoading],
      child: BlocBuilder<PosAddEditDetailAccountBloc,
          PosAddEditDetailAccountState>(builder: (context, state) {
        if (state is PosSessionDetailAccountLoadSuccess) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildInfoGeneral(state.posAccountBankDetail),
                    spaceHeight,
                    SizedBox(
                      height: 12,
                      child: Container(
                        color: const Color(0xFFEBEDEF),
                      ),
                    ),
                    spaceHeight,
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        "DANH SÁCH HÓA ĐƠN",
                        style: titleFontStyle.copyWith(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                    ),
                    spaceHeight,
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3)),
                        child: Container(
                          child: ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (ctx, index) {
                              return item(state.posAccountBankLines[index]);
                            },
                            separatorBuilder: (ctx, index) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Divider(
                                  height: 1,
                                  color: Color(0xFFEBEDEF),
                                ),
                              );
                            },
                            itemCount: state.posAccountBankLines.length,
                          ),
                        ))
                  ],
                ),
              ),
            ),
          );
        }
        return const SizedBox();
      }),
    );
  }

  Widget item(PosAccountBankLine item) {
    const Widget spaceHeight = SizedBox(
      height: 4,
    );
    return Container(
      child: Column(
        children: <Widget>[
          ListTile(
            onTap: () {},
            title: Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      item.name ?? "",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontWeight: FontWeight.bold),
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
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.calendar_today,
                            size: 15,
                            color: const Color(0xFF9CA2AA),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy')
                                .format(DateTime.parse(item.date).toLocal()),
                            style: const TextStyle(color: Color(0xFF9CA2AA)),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          SizedBox(
                            width: 1,
                            height: 8,
                            child: Container(color: const Color(0xFF9CA2AA)),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Icon(
                            Icons.person,
                            size: 16,
                            color: const Color(0xFF9CA2AA),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Expanded(
                            child: Text(
                              item.partnerName ?? "<Chưa có>",
                              style: const TextStyle(color: Color(0xFF9CA2AA)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      vietnameseCurrencyFormat(item.amount),
                      style: const TextStyle(color: Color(0xFF9CA2AA)),
                    ),
                  ],
                ),
                spaceHeight,
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInfoGeneral(PosAccountBank itemAccount) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          InfoRow(
            title: Text(
              "THÔNG TIN",
              style: TextStyle(
                  color: const Color(0xFF28A745),
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ),
          ),
          InfoRow(
            contentTextStyle: titleFontStyle,
            title: Text(
              "Nhật ký: ",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            content: Text(itemAccount?.journal?.name ?? "",
                style: detailFontStyle.copyWith(
                    color: const Color(0xFF484D54), fontSize: 16)),
          ),
          InfoRow(
            contentTextStyle: titleFontStyle,
            title: Text(
              "Ngày: ",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            content: Text(
                itemAccount?.date == null
                    ? ""
                    : DateFormat('dd/MM/yyyy')
                        .format(DateTime.parse(itemAccount?.date).toLocal()),
                style:
                    detailFontStyle.copyWith(color: const Color(0xFF484D54))),
          ),
          InfoRow(
            contentTextStyle: titleFontStyle,
            title: Text(
              "Số dư bắt đầu: ",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            content: Text(
                vietnameseCurrencyFormat(itemAccount?.balanceStart ?? 0),
                style:
                    detailFontStyle.copyWith(color: const Color(0xFF484D54))),
          ),
          //dividerMin,
          InfoRow(
            contentTextStyle: titleFontStyle,
            title: Text(
              "Số dư kết thúc: ",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            content: Text(
                vietnameseCurrencyFormat(itemAccount?.balanceEnd ?? 0),
                style:
                    detailFontStyle.copyWith(color: const Color(0xFF484D54))),
          ),
          //dividerMin,
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc.add(PosSessionDetailLoaded(id: widget.accountBank.id));
  }
}
