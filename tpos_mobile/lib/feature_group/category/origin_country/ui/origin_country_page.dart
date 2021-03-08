import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/origin_country/bloc/origin_country_bloc.dart';
import 'package:tpos_mobile/feature_group/category/origin_country/bloc/origin_country_event.dart';
import 'package:tpos_mobile/feature_group/category/origin_country/bloc/origin_country_state.dart';
import 'package:tpos_mobile/widgets/bloc_widget/base_bloc_listener_ui.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/load_status.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class OriginCountryPage extends StatefulWidget {
  const OriginCountryPage({Key key, this.title}) : super(key: key);

  @override
  _OriginCountryPageState createState() => _OriginCountryPageState();

  final String title;
}

class _OriginCountryPageState extends State<OriginCountryPage> {
  OriginCountryBloc _originCountryBloc;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _originCountryBloc = OriginCountryBloc();
    _originCountryBloc.add(OriginCountryStarted());
  }

  @override
  void dispose() {
    _originCountryBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            hintText: widget.title ??
                S.of(context).selectParam(S.of(context).origin.toLowerCase()),
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
    return BaseBlocListenerUi<OriginCountryBloc, OriginCountryState>(
      loadingState: OriginCountryLoading,
      busyState: OriginCountryBusy,
      bloc: _originCountryBloc,
      errorState: OriginCountryLoadFailure,
      errorBuilder: (BuildContext context, OriginCountryState state) {
        String error = S.of(context).canNotGetDataFromServer;
        if (state is OriginCountryLoadFailure) {
          error = state.error ?? S.of(context).canNotGetDataFromServer;
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50 * (MediaQuery.of(context).size.height / 700)),
              LoadStatusWidget(
                statusName: S.of(context).loadDataError,
                content: error,
                statusIcon: SvgPicture.asset('assets/icon/error.svg',
                    width: 170, height: 130),
                action: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: AppButton(
                    onPressed: () {
                      _originCountryBloc.add(OriginCountryStarted());
                    },
                    width: null,
                    padding: const EdgeInsets.only(left: 20, right: 20),
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
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      builder: (BuildContext context, OriginCountryState state) {
        return state.originCountrys.isEmpty
            ? _buildEmptyList()
            : ListView.separated(
                itemCount: state.originCountrys.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox();
                },
                itemBuilder: (BuildContext context, int index) {
                  return _buildItem(state.originCountrys[index]);
                },
              );
      },
    );
  }

  Widget _buildItem(OriginCountry originCountry) {
    return Column(
      children: <Widget>[
        const Divider(height: 2.0),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: ListTile(
            onTap: () {
              Navigator.pop(context, originCountry);
            },
            contentPadding: const EdgeInsets.all(5),
            title: Text(originCountry.name ?? '', textAlign: TextAlign.start),
            leading: CircleAvatar(
              backgroundColor: const Color(0xffE9F6EC),
              child: Text(originCountry.name != null && originCountry.name != ''
                  ? originCountry.name.substring(0, 1)
                  : ''),
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
          content: S
              .of(context)
              .emptyNotificationParam(S.of(context).origin.toLowerCase()),
          action: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: AppButton(
              onPressed: () async {},
              width: null,
              padding: const EdgeInsets.only(left: 20, right: 20),
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
                      S
                          .of(context)
                          .addNewParam(S.of(context).origin.toLowerCase()),
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
