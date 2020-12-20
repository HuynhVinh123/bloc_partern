import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:random_color/random_color.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/partner_ext/bloc/partner_ext_bloc.dart';
import 'package:tpos_mobile/feature_group/category/partner_ext/bloc/partner_ext_event.dart';
import 'package:tpos_mobile/feature_group/category/partner_ext/bloc/partner_ext_state.dart';
import 'package:tpos_mobile/widgets/bloc_widget/base_bloc_listener_ui.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/load_status.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

///Xây dựng màn hình tìm kiếm nhà cung cấp [PartnerExt]
class PartnerExtPage extends StatefulWidget {
  const PartnerExtPage({Key key, this.title}) : super(key: key);

  @override
  _PartnerExtPageState createState() => _PartnerExtPageState();

  final String title;
}

class _PartnerExtPageState extends State<PartnerExtPage> {
  PartnerExtBloc _partnerExtBloc;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _partnerExtBloc = PartnerExtBloc();
    _partnerExtBloc.add(PartnerExtStarted());
  }

  @override
  void dispose() {
    _partnerExtBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: TextField(
        autofocus: true,
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search, color: Colors.white),
            hintText: widget.title ?? S.of(context).selectParam(S.of(context).producer.toLowerCase()),
            hintStyle: const TextStyle(color: Colors.white)),
        onChanged: (text) {},
      ),
      leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          }),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.cancel),
          onPressed: () {
            _searchController.clear();
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    return BaseBlocListenerUi<PartnerExtBloc, PartnerExtState>(
      loadingState: PartnerExtLoading,
      busyState: PartnerExtBusy,
      bloc: _partnerExtBloc,
      errorState: PartnerExtLoadFailure,
      errorBuilder: (BuildContext context, PartnerExtState state) {
        String error = S.of(context).canNotGetDataFromServer;
        if (state is PartnerExtLoadFailure) {
          error = state.error ?? S.of(context).canNotGetDataFromServer;
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50 * (MediaQuery.of(context).size.height / 700)),
              LoadStatusWidget(
                statusName: S.of(context).loadDataError,
                content: error,
                statusIcon: SvgPicture.asset('assets/icon/error.svg', width: 170, height: 130),
                action: AppButton(
                  onPressed: () {
                    _partnerExtBloc.add(PartnerExtStarted());
                  },
                  width: 180,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 40, 167, 69),
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          FontAwesomeIcons.sync,
                          color: Colors.white,
                          size: 23,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          S.of(context).refreshPage,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      builder: (BuildContext context, PartnerExtState state) {
        return state.partnerExts.isEmpty
            ? _buildEmptyList()
            : ListView.separated(
                itemCount: state.partnerExts.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox();
                },
                itemBuilder: (BuildContext context, int index) {
                  return _buildItem(state.partnerExts[index]);
                },
              );
      },
    );
  }

  Widget _buildItem(PartnerExt partnerExt) {
    return Column(
      children: <Widget>[
        const Divider(height: 2.0),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: ListTile(
            onTap: () {
              Navigator.pop(context, partnerExt);
            },
            contentPadding: const EdgeInsets.all(5),
            title: Text(partnerExt.name ?? '', textAlign: TextAlign.start),
            leading: CircleAvatar(
              backgroundColor: RandomColor().randomColor(),
              child: Text(partnerExt.name != null && partnerExt.name != '' ? partnerExt.name.substring(0, 1) : ''),
            ),
          ),
        ),
      ],
    );
  }

  ///Xây dựng giao diện trống
  Widget _buildEmptyList() {
    return SingleChildScrollView(
        child: Column(
      children: [
        SizedBox(height: 50 * (MediaQuery.of(context).size.height / 700)),
        LoadStatusWidget.empty(
          statusName: S.of(context).noData,
          content: S.of(context).emptyNotificationParam(S.of(context).producer.toLowerCase()),
          action: AppButton(
            onPressed: () async {},
            width: 250,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 40, 167, 69),
              borderRadius: BorderRadius.all(Radius.circular(24)),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 23,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    S.of(context).addNewParam(S.of(context).producer.toLowerCase()),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
