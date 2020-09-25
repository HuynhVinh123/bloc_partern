import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/pos_session/bloc/pos_sesion_bloc.dart';
import 'package:tpos_mobile/feature_group/pos_session/bloc/pos_session_event.dart';
import 'package:tpos_mobile/feature_group/pos_session/bloc/pos_session_state.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_loading_screen.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_ui_provider.dart';

class PosSessionListPage extends StatefulWidget {
  @override
  _PosSessionListPageState createState() => _PosSessionListPageState();
}

class _PosSessionListPageState extends State<PosSessionListPage> {
  final _bloc = PosSessionBloc();
  final int _limit = 80;
  int _skip = 0;
  @override
  void initState() {
    super.initState();
    _bloc.add(PosSessionLoaded(limit: _limit,skip: _skip));
  }

  @override
  Widget build(BuildContext context) {
    return BlocUiProvider(
      bloc: _bloc,
      listen: (state) {},
      child: Scaffold(
        backgroundColor: const Color(0xFFEBEDEF),
        appBar: AppBar(
          title: const Text("Phiên bán hàng"),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return BlocLoadingScreen<PosSessionBloc>(
      busyStates: const [PosSessionLoading],
      child: BlocBuilder<PosSessionBloc, PosSessionState>(
          buildWhen: (prevState, currState) {
            if (currState is PosSessionLoadSuccess) {
              return true;
            }
            return false;
          },
          builder: (context, state) {
        if (state is PosSessionLoadSuccess) {
          return Container(
            child: RefreshIndicator(
              onRefresh: () async {
                return false;
              },
              child: ListView.builder(
                  itemCount: state.posSessions.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 11, right: 11, top: 10),
                      child: _showItem(state.posSessions[index],index
                      ,state.posSessions),
                    );
                  }),
            ),
          );
        }
        return const SizedBox();
      }),
    );
  }

  Widget _showItem(PosSession item,int index,List<PosSession> posSessions) {
    return item.name == "temp"
        ? _buildButtonLoadMore(index, posSessions)
        : Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(3.0)),
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            onTap: () async {},
            title: Padding(
              padding: const EdgeInsets.only(top: 9, bottom: 6),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "Phiên bán: ${item.name ?? ""}",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: const Color(0xFF28A745),
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            subtitle: Column(
              children: <Widget>[
                const SizedBox(
                  height: 14,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.home,
                      color: item.state == "closed"
                          ? const Color(0xFFA7B2BF)
                          : const Color(0xFF91D2A0),
                      size: 18,
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Text(
                      item.configName ?? "",
                      style: const TextStyle(color: Color(0xFF929DAA)),
                    )
                  ],
                ),
                const SizedBox(
                  height: 14,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.person,
                      color: item.state == "closed"
                          ? const Color(0xFFA7B2BF)
                          : const Color(0xFF91D2A0),
                      size: 18,
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Expanded(
                      child: Text(item.userName ?? ""),
                    ),
                    Visibility(
                      visible: item.state == "opened",
                      child: Container(
                        decoration:
                            BoxDecoration(borderRadius: BorderRadius.circular(4)),
                        height: 30,
                        width: 74,
                        child: RaisedButton(
                            color: const Color(0xFFF0F1F3),
                            onPressed: () async {},
                            child: const AutoSizeText(
                              "Đóng",
                              style: TextStyle(color: Color(0xFF484D54)),
                              maxLines: 1,
                            )),
                      ),
                    ),
                    const Visibility(
                      visible: true,
                      child: SizedBox(
                        width: 10,
                      ),
                    ),
                    Visibility(
                      visible: item.state == "opened",
                      child: Container(
                        height: 30,
                        width: 93,
                        decoration: BoxDecoration(
                            color: const Color(0xFF28A745),
                            borderRadius: BorderRadius.circular(4)),
                        child: RaisedButton(
                            onPressed: () async {},
                            color: const Color(0xFF28A745),
                            child: const Text(
                              "Tiếp tục",
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                    ),
                    Visibility(
                      visible: item.state == "opening_control",
                      child: Container(
                        decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(4)),
                        height: 30,
                        width: 90,
                        child: RaisedButton(
                            color: const Color(0xFFF0F1F3),
                            onPressed: () async {},
                            child: const AutoSizeText(
                              "Mở phiên",
                              style: TextStyle(color: Color(0xFF484D54)),
                              maxLines: 1,
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey.shade300,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(left: 4),
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: item.state == "closed"
                            ? const Color(0xFFA7B2BF)
                            : const Color(0xFF28A745),
                      ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Expanded(
                      child: Text(item.showState ?? "",
                          style: TextStyle(
                            color: item.state == "closed"
                                ? const Color(0xFFA7B2BF)
                                : const Color(0xFF28A745),
                          )),
                    ),
                    if (item.state != "closed")
                      const Icon(
                        Icons.open_in_browser,
                        color: const Color(0xFF28A745),
                        size: 18,
                      )
                    else
                      const Icon(
                        Icons.system_update_alt,
                        size: 17,
                        color: Colors.orange,
                      ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      item.dateCreated != null ?DateFormat("dd-MM-yyyy").format(DateTime.fromMicrosecondsSinceEpoch(int.parse(item.dateCreated.substring(6, item.dateCreated.length - 2)) * 1000).toLocal()): "",
                      style: const TextStyle(color: Color(0xFF9CA2AA)),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 4,
                )
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonLoadMore(
      int index, List<PosSession> posSessions) {
    return BlocBuilder<PosSessionBloc, PosSessionState>(
        builder: (context, state) {
          if (state is PosSessionLoadMoreLoading) {
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
                    _bloc.add(PosSessionLoadMoreLoaded(
                        limit: _limit,
                        skip: _skip,
                        posSessions: posSessions));
                  },
                  color: Colors.blueGrey,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Text("Tải tiếp",
                            style: TextStyle(color: Colors.white, fontSize: 16)),
                        SizedBox(
                          width: 12,
                        ),
                        Icon(
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
