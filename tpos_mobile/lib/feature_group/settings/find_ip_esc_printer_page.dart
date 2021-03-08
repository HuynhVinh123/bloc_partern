import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/settings/viewmodels/find_ip_viewmodel.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class FindIpEscPrinterPage extends StatefulWidget {
  const FindIpEscPrinterPage(
      {@required this.port, this.isTposPrinterType = false, this.ip = ''})
      : assert(port != null);
  final int port;
  final bool isTposPrinterType;
  final String ip;

  @override
  _FindIpEscPrinterPageState createState() => _FindIpEscPrinterPageState();
}

class _FindIpEscPrinterPageState extends State<FindIpEscPrinterPage> {
  final FindIpViewModel _viewModel = FindIpViewModel();

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    await _viewModel.getIpWifi(context);
    _viewModel.findPrinter(widget.port, context);
  }

  @override
  Widget build(BuildContext context) {
    return ViewBase<FindIpViewModel>(
        model: _viewModel,
        builder: (context, model, _) {
          return Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(18),
                    topLeft: Radius.circular(18))),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                          'MÁY IN ĐÃ TÌM THẤY (${_viewModel.printers?.length ?? 0})',
                          style: const TextStyle(
                              color: Colors.black, fontSize: 16),
                          textAlign: TextAlign.center),
                    ),
                  ),
                  IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.transparent,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Flexible(
                  child: _viewModel.isLoading
                      ? SizedBox(
                          height: 50,
                          child: SpinKitCircle(
                              size: 28, color: Theme.of(context).primaryColor),
                        )
                      : _viewModel.printers.isEmpty
                          ? SizedBox(
                              height: 50,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: FlatButton.icon(
                                    icon: const Icon(Icons.refresh),
                                    // label:  Text('Nhấn để tải lại'),
                                    label: Text(S.current.pressToReload),
                                    onPressed: () async {
                                      await _viewModel.getIpWifi(context);

                                      _viewModel.findPrinter(
                                          widget.port, context, true);
                                    },
                                  )),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: _viewModel.printers?.length ?? 0,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: const Icon(
                                    Icons.print,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                  title: Text(_viewModel.printers[index].ip),
                                  onTap: () {
                                    Navigator.pop(
                                        context, _viewModel.printers[index]);
                                  },
                                  trailing:
                                      widget.ip == _viewModel.printers[index].ip
                                          ? const Icon(Icons.check_circle,
                                              color: Colors.green)
                                          : null,
                                );
                              })),
              const SizedBox(
                height: 8,
              ),
            ]),
          );
        });
  }
}
