import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/settings/configuration/bloc/configuration_bloc.dart';
import 'package:tpos_mobile/feature_group/settings/configuration/bloc/configuration_event.dart';
import 'package:tpos_mobile/feature_group/settings/configuration/bloc/configuration_state.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

enum ConfigAction { SERVER_SYNC, UPLOAD }

/// Đồng bộ cấu hình trên điện thoại và máy chủ
class MobileConfigSyncPage extends StatefulWidget {
  @override
  _MobileConfigSyncPageState createState() => _MobileConfigSyncPageState();
}

class _MobileConfigSyncPageState extends State<MobileConfigSyncPage> {
  List<MobileConfig> _configurations;
  MobileConfigBloc _configurationBloc;

  @override
  void initState() {
    _configurationBloc = MobileConfigBloc();
    _configurationBloc.add(MobileConfigLoaded());
    super.initState();
  }

  @override
  void dispose() {
    _configurationBloc.close();
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
      title: Text(
        S.current.configurationSynchronized,
        style: const TextStyle(color: Colors.white, fontSize: 21),
      ),
    );
  }

  Widget _buildBody() {
    return BlocProvider<MobileConfigBloc>(
      create: (context) => _configurationBloc,
      child: BlocListener<MobileConfigBloc, MobileConfigState>(
        listener: (context, state) {
          if (state is MobileConfigValidateSuccess) {
            if (state.showWarning) {
              showDialog(
                context: context,
                child: AlertDialog(
                  title: const Text(
                      'Phiên bản cấu hình hiện tại trên máy thấp hơn phiên bản trên server'),
                  actions: [
                    FlatButton(
                      onPressed: () {},
                      child: const Text("Vẫn lưu"),
                    ),
                    FlatButton(
                        onPressed: () {},
                        child: const Text('Lấy cấu hình từ máy chủ.'))
                  ],
                ),
              );
            }
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BlocBuilder<MobileConfigBloc, MobileConfigState>(
                buildWhen: (last, current) =>
                    current is MobileConfigLoadSuccess,
                builder: (context, state) {
                  if (state is MobileConfigLoadSuccess) {
                    final MobileConfigLoadSuccess ssstate = state;
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          ssstate.url ?? '',
                          style: const TextStyle(fontSize: 17),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Tên đăng nhập: ${ssstate.username ?? ''}",
                          style: const TextStyle(fontSize: 17),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Thiết bị: ${ssstate.deviceBranch} ${ssstate.deviceModel}",
                          style: const TextStyle(fontSize: 17),
                          textAlign: TextAlign.center,
                        ),
                        const Text(
                          "Đã lưu gần nhất vào 16/01/2021 lúc 6h21",
                          style: TextStyle(fontSize: 17),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    );
                  }
                  return const SizedBox();
                }),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.cloud_upload),
                onPressed: () {
                  _configurationBloc.add(MobileConfigValidated());
                },
                label: const Text('LƯU CẤU HÌNH'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: TextButton.icon(
                icon: const Icon(Icons.cloud_download),
                onPressed: () {},
                label: const Text('TẢI VỀ CẤU HÌNH'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: TextButton.icon(
                icon: const Icon(Icons.cloud_download),
                onPressed: () {},
                label: const Text('TẢI VỀ TỪ MÁY KHÁC'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
