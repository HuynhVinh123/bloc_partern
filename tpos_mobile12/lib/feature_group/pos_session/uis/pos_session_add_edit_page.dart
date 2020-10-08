import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/feature_group/pos_order/ui/pos_cart_page.dart';
import 'package:tpos_mobile/feature_group/pos_session/bloc/add_edit/pos_session_add_edit_bloc.dart';
import 'package:tpos_mobile/feature_group/pos_session/bloc/add_edit/pos_session_add_edit_event.dart';
import 'package:tpos_mobile/feature_group/pos_session/bloc/add_edit/pos_session_add_edit_state.dart';
import 'package:tpos_mobile/feature_group/pos_session/uis/pos_session_invoice_list_page.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_loading_screen.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_ui_provider.dart';
import 'package:tpos_mobile/widgets/my_step_view.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class PosSessionAddEditPage extends StatefulWidget {
  const PosSessionAddEditPage({this.id, this.companyId, this.nameSession});
  final int id; // sessionId
  final int companyId;
  final String nameSession;
  @override
  _PosSessionAddEditPageState createState() => _PosSessionAddEditPageState();
}

class _PosSessionAddEditPageState extends State<PosSessionAddEditPage> {
  final _bloc = PosSessionAddEditBloc();

  PosSession _session = PosSession();
  TextStyle detailFontStyle;
  TextStyle titleFontStyle;
  Widget spaceHeight = const SizedBox(
    height: 10,
  );

  @override
  Widget build(BuildContext context) {
    titleFontStyle = const TextStyle(color: Colors.green);
    detailFontStyle = const TextStyle(color: Colors.green);

    return BlocUiProvider(
      bloc: _bloc,
      listen: (state) {
        if (state is PosSessionActionSuccess) {
          Navigator.pop(context, true);
          showError(
              title: state.title, message: state.content, context: context);
        } else if (state is PosSessionInfoLoadFailure) {
          showError(
              title: state.title, context: context, message: state.content);
        }
      },
      child: Scaffold(
          backgroundColor: const Color(0xFFEBEDEF),
          appBar: AppBar(
            title:
                Text('${S.current.posSession_Session}: ${widget.nameSession}'),
            actions: <Widget>[
              InkWell(
                onTap: () {
                  _bloc.add(PosSessionSaved(posSession: _session));
                },
                child: Row(
                  children: <Widget>[
                    const Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(S.current.edit),
                    const SizedBox(
                      width: 8,
                    )
                  ],
                ),
              )
            ],
          ),
          body: _buildBody()),
    );
  }

  Widget _buildBody() {
    return BlocLoadingScreen<PosSessionAddEditBloc>(
      busyStates: const [PosSessionInfoLoading],
      child: BlocBuilder<PosSessionAddEditBloc, PosSessionAddEditState>(
          buildWhen: (preState, currState) {
        if (currState is PosSessionInfoLoadSuccess) {
          return true;
        }
        return false;
      }, builder: (context, state) {
        if (state is PosSessionInfoLoadSuccess) {
          _session = state.posSession;
          return SafeArea(
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      bottom: _session.state == 'opened' ? 60 : 12),
                  child: Container(
                    child: _buildInfoPointSale(state),
                  ),
                ),
                Visibility(
                  visible: _session.state == 'opened',
                  child: Positioned(
                    bottom: 6,
                    child: _buildButtonClosePointSale(state),
                  ),
                )
              ],
            ),
          );
        }
        return const SizedBox();
      }),
    );
  }

  Widget _buildButtonClosePointSale(PosSessionInfoLoadSuccess state) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, 2),
                        blurRadius: 2,
                        color: Colors.grey[400])
                  ],
                  color: const Color(0xFF89919A),
                  borderRadius: BorderRadius.circular(6)),
              child: RaisedButton(
                color: const Color(0xFF89919A),
                onPressed: () async {
                  final dialogResult = await showQuestionAction(
                    context: context,
                    title: S.current.close,
                    message: S.current.posSession_doYouWantToCloseSession,
                  );

                  if (dialogResult == DialogResultType.YES) {
                    _bloc.add(PosSessionAddEditClosed(sessionId: _session.id));
                  }
                },

                /// Kết thúc phiên
                child: Center(
                  child: Text(S.current.posSession_closeSession,
                      style:
                          const TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 18,
          ),
          Expanded(
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, 2),
                        blurRadius: 2,
                        color: Colors.grey[400])
                  ],
                  color: Colors.green[400],
                  borderRadius: BorderRadius.circular(6)),
              child: RaisedButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PosCartPage(_session.configId,
                            widget.companyId, _session.userId, true)),
                  );
                },
                color: const Color(0xFF28A745),
                child: Center(
                  child: Text(S.current.continues,
                      style:
                          const TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPointSale(PosSessionInfoLoadSuccess state) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _step(state.posSession),
          const SizedBox(
            height: 12,
          ),
          _buildInfoGeneral(state.posSession),
          spaceHeight,
          spaceHeight,
          _buildPaymentType(state.posAccountBanks)
        ],
      ),
    ));
  }

  Widget _buildPaymentType(List<PosAccountBank> posAccountBanks) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 12),
            child: Text(
              S.current.posSession_paymentType,
              style: titleFontStyle.copyWith(
                  fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ),
          spaceHeight,
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (ctx, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: _showItemAccountBank(posAccountBanks[index]),
              );
            },
            separatorBuilder: (ctx, index) {
              return const Divider(
                height: 1,
              );
            },
            itemCount: posAccountBanks.length,
          ),
          spaceHeight,
        ],
      ),
    );
  }

  Widget _showItemAccountBank(PosAccountBank item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F1F3),
        borderRadius: BorderRadius.circular(3),
      ),
      child: ExpansionTile(
        title: Text(
          item.journal?.name ?? '',
          style: const TextStyle(color: Colors.black),
        ),
        initiallyExpanded: true,
        backgroundColor: const Color(0xFFF0F1F3),
        children: <Widget>[
          InRow(
            contentTextStyle: titleFontStyle,

            /// Số dư bắt đầu
            title: Text(
              '${S.current.posSession_balanceStart}:',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            content: Text(vietnameseCurrencyFormat(item.balanceStart),
                textAlign: TextAlign.right,
                style: detailFontStyle.copyWith(
                    color: const Color(0xFF484D54),
                    fontWeight: FontWeight.w700)),
          ),
          InRow(
            contentTextStyle: titleFontStyle,

            /// Giao dịch
            title: Text(
              '${S.current.posSession_amountTransaction}:',
            ),
            content: Text(vietnameseCurrencyFormat(item.totalEntryEncoding),
                textAlign: TextAlign.right,
                style:
                    detailFontStyle.copyWith(color: const Color(0xFF484D54))),
          ),
//          const Divider(
//            height: 1,
//          ),
//          InRow(
//            contentTextStyle: titleFontStyle,
//            title: const Text(
//              'Số dư kết thúc lí thuyết:',
//            ),
//            content: Text('125.000.325',
//                textAlign: TextAlign.right,
//                style:
//                    detailFontStyle.copyWith(color: const Color(0xFF484D54))),
//          ),
          const Divider(
            height: 1,
          ),
          InRow(
            contentTextStyle: titleFontStyle,

            /// Số dư kết thúc
            title: Text(
              '${S.current.posSession_balanceEnd}:',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            content: Text(vietnameseCurrencyFormat(item.balanceEnd),
                textAlign: TextAlign.right,
                style:
                    detailFontStyle.copyWith(color: const Color(0xFF484D54))),
          ),
          const Divider(
            height: 1,
          ),
          InRow(
            contentTextStyle: titleFontStyle,
            title: Text(
              '${S.current.posSession_difference}:',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            content: Text(vietnameseCurrencyFormat(item.difference),
                textAlign: TextAlign.right,
                style: detailFontStyle.copyWith(
                    color: const Color(0xFF484D54),
                    fontWeight: FontWeight.w700)),
          ),
          InRow(
            content: Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => PosSessionInvoiceListPage(
                        accountBank: item,
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFFF0F1F3),
                      borderRadius: BorderRadius.circular(3)),
                  width: 75,
                  height: 30,
                  child: Center(
                    /// Chi tiết
                    child: Text(S.current.posSession_detail),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInfoGeneral(PosSession posSession) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          InRow(
            /// Tổng quam
            title: Text(
              S.current.posSession_overview,
              style: const TextStyle(
                  color: Color(0xFF28A745),
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ),
          ),
          InRow(
            contentTextStyle: titleFontStyle,
            title: Text(
              '${S.current.menu_posOfSale}: ',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            content: Text(posSession?.config?.nameGet ?? '',
                style:
                    detailFontStyle.copyWith(color: const Color(0xFF484D54))),
          ),
          InRow(
            contentTextStyle: titleFontStyle,
            title: Text(
              '${S.current.posSession_posSession}: ',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            content: Text(posSession?.name ?? '',
                style: detailFontStyle.copyWith(
                    color: const Color(0xFF484D54), fontSize: 16)),
          ),
          InRow(
            contentTextStyle: titleFontStyle,

            /// Chịu trách nhiệm
            title: Text(
              '${S.current.posSession_employee}: ',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            content: Text(posSession?.user?.name ?? '',
                style:
                    detailFontStyle.copyWith(color: const Color(0xFF484D54))),
          ),
          InRow(
            contentTextStyle: titleFontStyle,
            title: Text(
              '${S.current.dateCreated}: ',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            content: Text(
                posSession?.startAt == null
                    ? ''
                    : DateFormat('dd/MM/yyyy HH:mm')
                        .format(DateTime.parse(posSession.startAt).toLocal()),
                style:
                    detailFontStyle.copyWith(color: const Color(0xFF484D54))),
          ),
          InRow(
            contentTextStyle: titleFontStyle,
            title: Text(
              '${S.current.posSession_endDate}: ',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            content: Text(
                posSession?.stopAt == null
                    ? ''
                    : DateFormat('dd/MM/yyyy HH:mm')
                        .format(DateTime.parse(posSession.stopAt).toLocal()),
                style:
                    detailFontStyle.copyWith(color: const Color(0xFF484D54))),
          )
        ],
      ),
    );
  }

  Widget _step(PosSession item) {
    return MyStepView(
      currentIndex: 2,
      items: [
        MyStepItem(
          /// Kiểm soát mở
          title: Text(
            S.current.posSession_openControl,
            textAlign: TextAlign.center,
          ),
          icon: const Icon(
            Icons.check_circle,
            color: Colors.green,
          ),
          lineColor: Colors.red,
          isCompleted: item.isOpeningControl ?? true,
        ),
        MyStepItem(
          /// Đang xử lý
          title: Text(
            S.current.posSession_processing,
            textAlign: TextAlign.center,
          ),
          icon: const Icon(
            Icons.check_circle,
            color: Colors.green,
          ),
          lineColor: Colors.red,
          isCompleted: item.isOpened ?? true,
        ),
        MyStepItem(
          /// Kiểm soát đóng
          title: Text(
            S.current.posSession_closeControl,
            textAlign: TextAlign.center,
          ),
          icon: const Icon(
            Icons.check_circle,
            color: Colors.green,
          ),
          lineColor: Colors.red,
          isCompleted: item.isCloseControl ?? false,
        ),
        MyStepItem(
            title: Text(
              S.current.posSession_closed,
              textAlign: TextAlign.center,
            ),
            icon: const Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
            lineColor: Colors.red,
            isCompleted: item.isClosed ?? false),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _bloc.add(PosSessionInfoLoaded(id: widget.id));
  }
}

class InRow extends StatelessWidget {
  const InRow({
    this.title,
    this.content,
    this.padding =
        const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
    this.contentString,
    this.titleString,
    this.titleColor = Colors.black,
    this.contentColor = Colors.green,
    this.contentTextStyle,
  });
  final Widget title;
  final Widget content;
  final String titleString;
  final String contentString;
  final EdgeInsetsGeometry padding;
  final Color titleColor;
  final Color contentColor;
  final TextStyle contentTextStyle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            title ??
                (Text(
                  titleString ?? '',
                  style: TextStyle(color: titleColor),
                )),
            Expanded(
              child: content ??
                  (Text(
                    contentString ?? '',
                    style: contentTextStyle ?? TextStyle(color: contentColor),
                    textAlign: TextAlign.right,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
