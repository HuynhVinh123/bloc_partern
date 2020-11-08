/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 7/5/19 4:54 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 7/5/19 9:47 AM
 *
 */

import 'package:facebook_api_client/facebook_api_client.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tpos_mobile/app_core/ui_base/ui_vm_base.dart';

import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/application/viewmodel/app_setting_viewmodel.dart';
import 'package:tpos_mobile/resources/string_resources.dart';
import 'package:tpos_mobile/services/app_setting_service.dart';
import 'package:tpos_mobile/services/print_service.dart';

import 'package:tpos_mobile/services/print_service/printer_device.dart';
import 'package:tpos_mobile/src/tpos_apis/models/applicaton_config_current.dart';

import 'package:tpos_mobile/helpers/messenger_helper.dart';

import 'package:tpos_mobile/src/tpos_apis/tpos_api.dart';

import 'package:tpos_mobile/widgets/custom_widget.dart';
import 'package:tpos_mobile_localization/generated/l10n.dart';

import '../../../resources/app_route.dart';
import 'find_ip_printer_page.dart';

class SaleFacebookCreateOrderSettingPage extends StatefulWidget {
  @override
  _SaleFacebookCreateOrderSettingPageState createState() =>
      _SaleFacebookCreateOrderSettingPageState();
}

class _SaleFacebookCreateOrderSettingPageState
    extends State<SaleFacebookCreateOrderSettingPage>
    with SingleTickerProviderStateMixin {
  //PROPERTY, CONTROLLER

  BuildContext scalfoldContext;
  final Key _printSaleOnlineSwitchKey = const Key("printSaleOnlineSwitch");
  final GlobalKey _scaffoldKey = GlobalKey(debugLabel: "scaffold");
  TabController _tabController;
  final ISettingService _setting = locator<ISettingService>();
  final PrintService _printService = locator<PrintService>();
  final ITposApiService _tposApi = locator<ITposApiService>();

  TextEditingController _computerPortTextEditController;
  TextEditingController _computerIpTextEditController;
  TextEditingController _lanPrinterIpTextEditController;
  TextEditingController _lanPrinterPortTextEditController;
  var viewModel = locator<ApplicationSettingViewModel>();
  var notifyProprtyChangeSubcribtion;
  ApplicationConfigCurrent _saleOnlinConfig;

  @override
  BuildContext get context => super.context;
  @override
  void initState() {
    locator<PrintService>().clearCache();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);

    // Tải dữ liệu setting
    viewModel.loadSetting().then((data) {});

    // Lắng nghe tab thay đổi
    _tabController.addListener(() {
      viewModel.saleOnlinePrintMethod = _tabController.index == 0
          ? PrintSaleOnlineMethod.LanPrinter
          : PrintSaleOnlineMethod.ComputerPrinter;
    });

    try {
      _tposApi.getCheckSaleOnlineSessionEnable().then((value) {
        setState(() {
          _saleOnlinConfig = value;
        });
      }).catchError((error) {});
    } catch (e) {
      print(e);
    }
    super.initState();

    viewModel.onStateAdd(false);
  }

  @override
  void didChangeDependencies() {
    // PropertyChange
    notifyProprtyChangeSubcribtion = viewModel.notifyPropertyChangedController
        .where((f) => f.isEmpty)
        .listen((name) {
      if (mounted) {
        setState(() {});
      }
    });

    // Dialog
    viewModel.dialogMessageController.listen((message) {
      registerDialogToView(context, message,
          scaffState: _scaffoldKey.currentState);
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Cài đặt bán hàng online"),
      ),
      body: UIViewModelBase(
        child: _showBody(context),
        viewModel: viewModel,
      ),
      backgroundColor: Colors.grey.shade300,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    viewModel.dispose();
    super.dispose();
  }

  Widget _showBody(BuildContext context) {
    _computerIpTextEditController =
        TextEditingController(text: viewModel.computerIp);

    _computerPortTextEditController =
        TextEditingController(text: viewModel.computerPort);

    _lanPrinterIpTextEditController =
        TextEditingController(text: viewModel.lanPrinterIp);

    _lanPrinterPortTextEditController =
        TextEditingController(text: viewModel.lanPrinterPort);

    if (viewModel.saleOnlinePrintMethod == PrintSaleOnlineMethod.LanPrinter) {
      _tabController.index = 0;
    } else if (viewModel.saleOnlinePrintMethod ==
        PrintSaleOnlineMethod.ComputerPrinter) {
      _tabController.index = 1;
    }

    const dividerMin = Divider(height: 2);

    final layoutDecorate = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    );

    final layoutHeaderStyle = TextStyle(
      color: Colors.blue,
      fontWeight: FontWeight.bold,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: layoutDecorate,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.print),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        S.current.printConfiguration.toUpperCase(),
                        textAlign: TextAlign.left,
                        style: layoutHeaderStyle,
                      ),
                    ],
                  ),
                ),
                dividerMin,
                ListTile(
                  title: const Text("In phiếu"),
                  trailing: GestureDetector(
                    onTap: () {},
                    child: Switch.adaptive(
                      dragStartBehavior: DragStartBehavior.down,
                      key: _printSaleOnlineSwitchKey,
                      value: viewModel.isEnablePrintSaleOnline,
                      onChanged: (value) {
                        setState(() {
                          viewModel.isEnablePrintSaleOnline = value;
                        });
                      },
                    ),
                  ),
                ),
                ListTile(
                  title: const Text("In được nhiều lần trên 1 comment"),
                  subtitle: const Text(
                      "Cho phép in nhiều lần trên 1 comment. Chỉ có hiệu lực nếu 'Chỉ in 1 lần nều cùng khách hàng ở trạng thái tắt'"),
                  trailing: Switch.adaptive(
                      value: viewModel.isAllowPrintSaleOnlineManyTime,
                      onChanged: (value) {
                        setState(() {
                          viewModel.isAllowPrintSaleOnlineManyTime = value;
                        });
                      }),
                ),

                dividerMin,
                ListTile(
                  title: const Text("Chỉ in 1 lần nếu cùng khách hàng"),
                  subtitle:
                      const Text("Sẽ không in nếu khách hàng đã có đơn hàng"),
                  trailing: Switch.adaptive(
                      value: _setting.saleOnlinePrintOnlyOneIfHaveOrder,
                      onChanged: (value) {
                        setState(() {
                          _setting.saleOnlinePrintOnlyOneIfHaveOrder = value;
                        });
                      }),
                ),

                dividerMin,
                Container(
                  height: 370,
                  child: DefaultTabController(
                    length: 2,
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TabBar(
                            controller: _tabController,
                            indicatorColor: Colors.green,
                            labelColor: Colors.red,
                            tabs: const <Widget>[
                              Tab(
                                child: Text("In máy in qua mạng"),
                              ),
//                         Tab(
//                          child: Text("In máy in bluetooth"),
//                        ),
                              Tab(
                                child: Text("In qua máy tính"),
                              ),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                _showLanPrinterSetting(context),
                                _showComputerSetting(context),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                ListTile(
                  title: const Text("Mẫu in phiếu qua Lan"),
                  subtitle: Row(
                    children: <Widget>[
                      Expanded(
                        child: RadioListTile<String>(
                          value: "BILL80-NHANH",
                          title: const Text("BILL80-NHANH"),
                          groupValue: _setting.saleOnlineSize,
                          onChanged: (value) {
                            setState(() {
                              _setting.saleOnlineSize = value;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          value: "BILL80-IMAGE",
                          title: const Text("BILL80-ĐẸP"),
                          groupValue: _setting.saleOnlineSize,
                          onChanged: (value) {
                            setState(() {
                              _setting.saleOnlineSize = value;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
                dividerMin,
                ListTile(
                  title: const Text("In địa chỉ"),
                  trailing: Switch.adaptive(
                      value: viewModel.isSaleOnlinePrintAddress,
                      onChanged: (value) {
                        setState(() {
                          viewModel.isSaleOnlinePrintAddress = value;
                        });
                      }),
                ),
                dividerMin,
                ListTile(
                  title: const Text("In thêm bình luận vào ghi chú & in"),
                  subtitle: const Text(
                      "Tự thêm bình luận vào ghi chú đơn hàng và in bình luận đó"),
                  trailing: Switch.adaptive(
                      value: viewModel.isSaleOnlinePrintComment,
                      onChanged: (value) {
                        setState(() {
                          viewModel.isSaleOnlinePrintComment = value;
                        });
                      }),
                ),
                dividerMin,
                // In toàn bộ ghi chú
                ListTile(
                  title: const Text("In toàn bộ ghi chú"),
                  subtitle: const Text(
                      "In toàn bộ ghi chú của đơn hàng (Khả dụng khi in qua  Tpos Printer)"),
                  trailing: Switch.adaptive(
                    value: viewModel.isSaleOnlinePrintAllOrderNote,
                    onChanged: (value) {
                      setState(() {
                        viewModel.isSaleOnlinePrintAllOrderNote = value;
                      });
                    },
                  ),
                ),
                dividerMin,

                // In toàn bộ ghi chú
                ListTile(
                  title: const Text("In ghi chú đơn hàng khi in lại"),
                  subtitle: const Text(
                    "Luôn in ghi chú đơn hàng khi in lại đơn hàng từ danh sách đơn online",
                  ),
                  trailing: Switch.adaptive(
                    value: _setting.saleOnlinePrintAllNoteWhenPreprint,
                    onChanged: (value) {
                      setState(() {
                        _setting.saleOnlinePrintAllNoteWhenPreprint = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text("Nội dung in"),
                  isThreeLine: true,
                  subtitle: const Text(
                      "Tùy chỉnh nội dung sẽ in ra (Tạm thời chỉ khả dụng với máy in qua mạng LAN): Nhấn để cấu hinh"),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pushNamed(
                        context, AppRoute.saleOnlinePrintContentSetting);
                  },
                ),
                dividerMin,
                SwitchListTile.adaptive(
                  title: const Text("In header tùy chỉnh"),
                  subtitle: const Text(
                      "In header tùy chỉnh thay cho header mặc định"),
                  value: _setting.isSaleOnlinePrintCustomHeader,
                  onChanged: (value) {
                    setState(() {
                      _setting.isSaleOnlinePrintCustomHeader = value;
                    });
                  },
                ),

                dividerMin,
                ListTile(
                  title: const Text("Header tùy chỉnh"),
                  subtitle: Text(_setting.saleOnlinePrintCustomHeaderContent),
                  trailing: FlatButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            final headerTextController = TextEditingController(
                                text: _setting
                                    .saleOnlinePrintCustomHeaderContent);
                            return AlertDialog(
                              title: const Text("Nhập nội dung header"),
                              content: TextField(
                                controller: headerTextController,
                                maxLines: null,
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: const Text("Xong"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    setState(() {
                                      _setting.saleOnlinePrintCustomHeaderContent =
                                          headerTextController.text.trim();
                                    });
                                  },
                                )
                              ],
                            );
                          });
                    },
                    child: const Text("Sửa"),
                    textColor: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            decoration: layoutDecorate,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.print),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "FACEBOOK + ĐƠN HÀNG",
                        textAlign: TextAlign.left,
                        style: layoutHeaderStyle,
                      ),
                    ],
                  ),
                ),

                dividerMin,
                ListTile(
                  title: const Text("Số bài đăng tải 1 lần"),
                  trailing: SizedBox(
                    width: 130,
                    child: NumberFieldWidget(
                      initNumber: _setting.getFacebookPostTake,
                      onChanged: (value) {
                        _setting.getFacebookPostTake = value;
                      },
                    ),
                  ),
                ),
                dividerMin,
                ListTile(
                  title: const Text("Số bình luận tải 1 lần"),
                  trailing: SizedBox(
                    width: 130,
                    child: NumberFieldWidget(
                      initNumber: _setting.getFacebookCommentTake,
                      onChanged: (value) {
                        _setting.getFacebookCommentTake = value;
                      },
                    ),
                  ),
                ),
                dividerMin,
                ListTile(
                  title: const Text("Tự động cập nhật bình luận ẩn"),
                  subtitle:
                      const Text("Tự động tải các bình luận có thể bị ẩn"),
                  trailing: Switch.adaptive(
                    value: _setting.saleOnlineFetchDurationEnableOnLive,
                    onChanged: (value) {
                      setState(() {
                        viewModel.isSaleOnlineEnableConnectFailAction = value;
                      });
                    },
                  ),
                ),
                dividerMin,
                ListTile(
                  title: const Text("Thời gian tự động tải (giây)"),
                  subtitle: Text(
                      "Tự lấy bình luận mỗi ${_setting.secondRefreshComment} giây nếu không kết nối được live"),
                  trailing: SizedBox(
                    width: 130,
                    child: NumberFieldWidget(
                      initNumber: viewModel.secondRefreshComment,
                      onChanged: (value) {
                        viewModel.secondRefreshComment = value;
                      },
                    ),
                  ),
                ),
                dividerMin,
                ListTile(
                  title: const Text("Số thứ tự phiếu."),
                  trailing: FlatButton(
                      textColor: ColorResource.hyperlinkColor,
                      onPressed: () async {
                        final result = await showQuestion(
                            context: context,
                            message: "Số thứ tự đơn hàng sẽ được reset về 0",
                            title: "Vui lòng xác nhận");

                        if (result == OldDialogResult.Yes) {
                          await viewModel.resetSaleOnlineSessionNumber();
                        }
                      },
                      child: const Text(
                        "Reset",
                        style: TextStyle(fontStyle: FontStyle.italic),
                      )),
                  subtitle: const Text(
                      "Nhấn reset để cập lại số thứ tự đơn hàng về 0"),
                ),
                dividerMin,
                if (_saleOnlinConfig != null)
                  SwitchListTile.adaptive(
                    title: const Text("Bật số thứ tự phiếu"),
                    value: _saleOnlinConfig?.saleOnlineFacebookSessionEnable ??
                        false,
                    subtitle: const Text(""),
                    onChanged: (value) async {
                      // Bật tắt số thứ tự phiếu

                      final confirmResult = await showQuestion(
                          context: context,
                          title: "Xác nhận",
                          message:
                              "Bạn có muốn ${_saleOnlinConfig.saleOnlineFacebookSessionEnable ? "Tắt" : "Bật"} số thứ tự phiếu");

                      if (confirmResult != OldDialogResult.Yes) {
                        return;
                      }
                      try {
                        _tposApi.updateSaleOnlineSessionEnable().then((value) {
                          setState(() {
                            _saleOnlinConfig = value;
                          });
                        });
                      } catch (e) {
                        print(e.toString());
                      }
                    },
                  ),
                dividerMin,

                // Cấu hình thời gian comment

                SwitchListTile.adaptive(
                  title: const Text("Kiểu hiển thị thời gian bình luận"),
                  subtitle: const Text(
                      "Ví dụ: Bật (5 phút trước), Tắt (21/05/2019  12:00)"),
                  value: _setting.isSaleOnlineViewTimeAgoOnLiveComment,
                  onChanged: (value) {
                    setState(() {
                      _setting.isSaleOnlineViewTimeAgoOnLiveComment = value;
                    });
                  },
                ),
//           Divider(),
//           SwitchListTile.adaptive(
//              title:
//                  Text("Hiện thời gian bình luận cũ ở dạng thời gian trước đó"),
//              subtitle: Text(
//                  "Ví dụ Now, 5 Min, 1 hr. Nếu để mặc định thời gian sẽ hiện thị ở dạng '21/05/2019 11:00'"),
//              value: _setting.isSaleOnlineViewTimeAgoOnPostComment,
//              onChanged: (value) {
//                setState(() {
//                  _setting.isSaleOnlineViewTimeAgoOnPostComment = value;
//                });
//              }),
                dividerMin,
                SwitchListTile.adaptive(
                    title: const Text("Tải toàn bộ bình luận"),
                    subtitle:
                        const Text("Tải toàn bộ bình luận khi vào bài live"),
                    value: _setting.isSaleOnlineAutoLoadAllCommentOnLive,
                    onChanged: (value) {
                      setState(() {
                        _setting.isSaleOnlineAutoLoadAllCommentOnLive = value;
                      });
                    }),
//           Divider(),
//           SwitchListTile.adaptive(
//              title: Text("Tải toàn bộ bình luận khi vào bài live cũ"),
//              subtitle: Text(""),
//              value: _setting.isSaleOnlineAutoLoadAllCommentOnPost,
//              onChanged: (value) {
//                setState(() {
//                  _setting.isSaleOnlineAutoLoadAllCommentOnPost = value;
//                });
//              }),

                dividerMin,

                ListTile(
                  title: const Text("Sắp xếp bình luận khi vào bài live"),
                  trailing: DropdownButton<SaleOnlineCommentOrderBy>(
                      value: _setting.saleOnlineCommentDefaultOrderByOnLive,
                      items: const [
                        DropdownMenuItem<SaleOnlineCommentOrderBy>(
                          child: Text("Mới nhất ở đầu"),
                          value: SaleOnlineCommentOrderBy.DATE_CREATE_DESC,
                        ),
                        DropdownMenuItem<SaleOnlineCommentOrderBy>(
                          child: Text("Mới nhất ở cuối"),
                          value: SaleOnlineCommentOrderBy.DATE_CREATED_ASC,
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _setting.saleOnlineCommentDefaultOrderByOnLive =
                              value;
                        });
                      }),
                ),

                dividerMin,

                ListTile(
                  title: const Text("Lọc bình luận theo facebook"),
                  subtitle: const Text(
                      "Chỉ có các bình luận chất lượng hiển thị theo tỉ lệ bạn chọn"),
                  trailing: DropdownButton(
                      value: _setting.saleOnlineFetchCommentOnRealtimeRate,
                      items: const [
                        DropdownMenuItem<CommentRate>(
                          child: Text("1 bình luận/ 2 giây"),
                          value: CommentRate.one_per_two_seconds,
                        ),
                        DropdownMenuItem<CommentRate>(
                          child: Text("10 bình luận/ giây"),
                          value: CommentRate.ten_per_second,
                        ),
                        DropdownMenuItem<CommentRate>(
                          child: Text("Nhiều nhất có thể"),
                          value: CommentRate.one_hundred_per_second,
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _setting.saleOnlineFetchCommentOnRealtimeRate = value;
                        });
                      }),
                ),
                dividerMin,
                ListTile(
                  title: const Text("Tự động lưu bình luận sau: (phút) "),
                  trailing: SizedBox(
                    width: 130,
                    child: NumberFieldWidget(
                      initNumber:
                          _setting.settingSaleOnlineAutoSaveCommentMinute,
                      onChanged: (value) {
                        setState(() {
                          _setting.settingSaleOnlineAutoSaveCommentMinute =
                              value;
                        });
                      },
                    ),
                  ),
                ),

                dividerMin,
                SwitchListTile.adaptive(
                  title: const Text("Ẩn bình luận ít hơn 3 kí tự"),
                  subtitle: const Text(
                      "Ví đụ để ẩn các bình luận '[.], [..]' không có giá trị chốt đơn"),
                  value: _setting.isSaleOnlineHideShortComment,
                  onChanged: (value) {
                    setState(() {
                      _setting.isSaleOnlineHideShortComment = value;
                    });
                  },
                ),

                dividerMin,
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  color: Colors.deepPurple,
                  shape: OutlineInputBorder(
                    borderSide: const BorderSide(width: 0),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    "XONG",
                    style: TextStyle(color: ColorResource.closeButtonTextColor),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _showComputerSetting(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              hintText: "Địa chỉ IP",
              labelText: "Địa chỉ IP",
              suffixIcon: FlatButton(
                onPressed: () async {
                  final PrinterDevice priner = await showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return const FindIpPrinterPage();
                      });

                  if (priner != null) {
                    _computerIpTextEditController.text = priner.ip;
                    _computerPortTextEditController.text =
                        priner.port.toString();

                    viewModel.computerIp = priner.ip;
                    viewModel.computerPort = priner.port.toString();
                  }
                },
                child: const Text("Tìm"),
                textColor: Colors.blue,
              ),
            ),
            keyboardType: const TextInputType.numberWithOptions(
                decimal: true, signed: true),
            controller: _computerIpTextEditController,
            onChanged: (text) {
              viewModel.computerIp = text;
            },
            inputFormatters: [
              WhitelistingTextInputFormatter(RegExp("[\\d|\.]")),
            ],
            maxLength: 15,
          ),
          TextField(
            decoration: const InputDecoration(
              hintText: "Port",
              labelText: "Port",
            ),
            keyboardType: TextInputType.number,
            controller: _computerPortTextEditController,
            inputFormatters: [
              WhitelistingTextInputFormatter.digitsOnly,
            ],
            maxLength: 5,
            onChanged: (text) {
              viewModel.computerPort = text;
            },
          ),
          SwitchListTile.adaptive(
            title: const Text("In theo mẫu trong cài đặt nội dung in"),
            value: _setting.printSaleOnlineViaComputerMobile,
            onChanged: (value) {
              setState(() {
                _setting.printSaleOnlineViaComputerMobile = value;
              });
            },
          ),
          Container(
            child: RaisedButton(
              textColor: Colors.white,
              child: Text(
                "In thử",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                viewModel.printSaleOnlineTest();
              },
            ),
            padding: const EdgeInsets.all(10),
          ),
        ],
      ),
    );
  }

  Widget _showLanPrinterSetting(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              hintText: "Địa chỉ IP",
              labelText: "Địa chỉ IP",
              suffixIcon: FlatButton(
                onPressed: () async {
                  final PrinterDevice printer = await showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return const FindIpPrinterPage(
                          isTposPrinterType: false,
                        );
                      });

                  if (printer != null) {
//                    _lanPrinterIpTextEditController.text = printer.ip;
//                    _lanPrinterPortTextEditController.text =
//                        printer.port.toString();

                    viewModel.lanPrinterIp = printer.ip;
                    viewModel.lanPrinterPort = printer.port.toString();
                  }
                },
                child: const Text("Tìm"),
                textColor: Colors.blue,
              ),
            ),
            keyboardType: const TextInputType.numberWithOptions(
                decimal: true, signed: true),
            controller: _lanPrinterIpTextEditController,
            inputFormatters: [
              WhitelistingTextInputFormatter(RegExp("[\\d|\.]")),
            ],
            maxLength: 15,
            onChanged: (value) {
              viewModel.lanPrinterIp = value;
            },
          ),
          TextField(
            decoration: const InputDecoration(
              hintText: "Port",
              labelText: "Port",
            ),
            keyboardType: TextInputType.number,
            controller: _lanPrinterPortTextEditController,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            maxLength: 5,
            onChanged: (value) {
              viewModel.lanPrinterPort = value;
            },
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text("In không dấu"),
              Expanded(
                child: Checkbox(
                  value: _setting.settingPrintSaleOnlineNoSign,
                  onChanged: (value) {
                    setState(() {
                      _setting.settingPrintSaleOnlineNoSign = value;
                    });
                  },
                ),
              ),
              OutlineButton(
                child: Text(
                  "In thử",
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () async {
                  try {
                    viewModel.onStateAdd(true);
                    await _printService.printSaleOnlineLanTest();
                    viewModel.onStateAdd(false);
                  } catch (e, s) {
                    showError(
                        exception: e, title: "In đã lỗi", context: context);
                    viewModel.onStateAdd(false);
                    print(s);
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
