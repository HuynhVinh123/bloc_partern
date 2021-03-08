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
import 'package:get_it/get_it.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/extensions.dart';
import 'package:tpos_mobile/feature_group/settings/setting_printer_list.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/resources/string_resources.dart';
import 'package:tpos_mobile/services/app_setting_service.dart';
import 'package:tpos_mobile/services/config_service/shop_config_service.dart';
import 'package:tpos_mobile/services/print_service.dart';
import 'package:tpos_mobile/services/print_service/printer_device.dart';
import 'package:tpos_mobile/src/tpos_apis/models/applicaton_config_current.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_api.dart';
import 'package:tpos_mobile/widgets/custom_widget.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
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
  final PrintService _printService = locator<PrintService>();
  final ITposApiService _tposApi = locator<ITposApiService>();
  final ShopConfigService _shopConfig = GetIt.I<ShopConfigService>();

  TextEditingController _computerPortTextEditController;
  TextEditingController _computerIpTextEditController;
  TextEditingController _lanPrinterIpTextEditController;
  TextEditingController _lanPrinterPortTextEditController;
  ApplicationConfigCurrent _saleOnlinConfig;

  PrinterDevice _saleOnlinePrinter;

  @override
  BuildContext get context => super.context;
  @override
  void initState() {
    locator<PrintService>().clearCache();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();

    /// Lấy máy in saleonline
    final allPrinter = _shopConfig.printerConfig.printerDevices;

    _saleOnlinePrinter = allPrinter.firstWhere(
        (element) =>
            element.name == _shopConfig.printerConfig.saleOnlinePrinterName,
        orElse: () => null);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(S.current.setting_settingSaleOnline),
      ),
      body: _showBody(context),
      backgroundColor: Colors.grey.shade300,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _showBody(BuildContext context) {
    // if (viewModel.saleOnlinePrintMethod == PrintSaleOnlineMethod.LanPrinter) {
    //   _tabController.index = 0;
    // } else if (viewModel.saleOnlinePrintMethod ==
    //     PrintSaleOnlineMethod.ComputerPrinter) {
    //   _tabController.index = 1;
    // }

    const dividerMin = Divider(height: 2);

    final layoutDecorate = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    );

    const layoutHeaderStyle = TextStyle(
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
                      const Icon(Icons.print),
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
                //In phiếu"
                ListTile(
                  title: Text(S.current.setting_settingSaleOnlinePrint),
                  subtitle: const Text('In phiếu gồm id, tên, Sđt qua máy in'),
                  trailing: Switch.adaptive(
                    dragStartBehavior: DragStartBehavior.down,
                    key: _printSaleOnlineSwitchKey,
                    value: _shopConfig.saleFacebookConfig.enablePrint,
                    onChanged: (value) {
                      setState(() {
                        _shopConfig.saleFacebookConfig.enablePrint = value;
                      });
                    },
                  ),
                ),
                dividerMin,
                // Chỉ có hiệu lực nếu 'Chỉ in 1 lần nều cùng khách hàng ở trạng thái tắt'
                ListTile(
                  title: Text(S.current.setting_settingSaleOnlineOnComment),
                  subtitle: Text(S.current.setting_settingSaleOnlyActive),
                  trailing: Switch.adaptive(
                      value: _shopConfig.saleFacebookConfig.allowPrintManyTime,
                      onChanged: (value) {
                        setState(() {
                          _shopConfig.saleFacebookConfig.allowPrintManyTime =
                              value;
                        });
                      }),
                ),

                dividerMin,
                //Chỉ in 1 lần nếu cùng khách hàng
                ListTile(
                  title: Text(S.current.setting_settingSaleOnlinePrintOnce),
                  // Sẽ không in nếu khách hàng đã có đơn hàng
                  subtitle:
                      Text(S.current.setting_settingSaleOnlineWillNotPrint),
                  trailing: Switch.adaptive(
                      value: _shopConfig
                          .saleFacebookConfig.printOnlyOneIfHaveOrder,
                      onChanged: (value) {
                        setState(() {
                          _shopConfig.saleFacebookConfig
                              .printOnlyOneIfHaveOrder = value;
                        });
                      }),
                ),

                dividerMin,

                /// chọn máy in
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 8, bottom: 0),
                  child: Text(
                    S.current.printer.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  title:
                      Text(_saleOnlinePrinter?.name ?? 'Nhấn để chọn máy in'),
                  subtitle: Text(_saleOnlinePrinter?.ip ?? ''),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    final printer =
                        await context.navigateTo(SettingPrinterListPage(
                      isSelectPage: true,
                      selectedPrinterName: _saleOnlinePrinter?.name,
                    ));

                    if (printer != null) {
                      _saleOnlinePrinter = printer;
                      _shopConfig.printerConfig.saleOnlinePrinterName =
                          _saleOnlinePrinter.name;
                      setState(() {});
                    }
                  },
                ),

                Row(children: [
                  const Spacer(),
                  TextButton(
                      onPressed: () {
                        if (_saleOnlinePrinter == null) {
                          App.showToast(message: 'Vui lòng chọn máy in trước');
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingPrinterEditPrinter(
                              device: _saleOnlinePrinter,
                            ),
                          ),
                        );
                      },
                      child: const Text('Sửa máy in')),
                ]),

                dividerMin,

                /// Mẫu in phiếu qua lan
                if (_saleOnlinePrinter?.type == 'esc_pos')
                  ListTile(
                    title: Text(
                        S.current.setting_settingSalePrintTemplateThroughLAN),
                    subtitle: Row(
                      children: <Widget>[
                        Expanded(
                          child: RadioListTile<String>(
                            value: "BILL80-NHANH",
                            title:
                                Text("BILL80-${S.current.fast.toUpperCase()}"),
                            groupValue:
                                _shopConfig.saleFacebookConfig.printPaperSize,
                            onChanged: (value) {
                              setState(() {
                                _shopConfig.saleFacebookConfig.printPaperSize =
                                    value;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            value: "BILL80-IMAGE",
                            title: Text(
                                "BILL80-${S.current.beautiful.toUpperCase()}"),
                            groupValue:
                                _shopConfig.saleFacebookConfig.printPaperSize,
                            onChanged: (value) {
                              setState(() {
                                _shopConfig.saleFacebookConfig.printPaperSize =
                                    value;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                dividerMin,
                //In địa chỉ
                ListTile(
                  title: Text(S.current.setting_settingSaleOnlinePrintAddress),
                  trailing: Switch.adaptive(
                      value: _shopConfig.saleFacebookConfig.printAddress,
                      onChanged: (value) {
                        setState(() {
                          _shopConfig.saleFacebookConfig.printAddress = value;
                        });
                      }),
                ),
                dividerMin,
                //In thêm bình luận vào ghi chú
                ListTile(
                  title:
                      Text(S.current.setting_settingSaleOnlineAddCommentToNote),
                  //Tự thêm bình luận vào ghi chú đơn hàng và in bình luận đó
                  subtitle: Text(
                      S.current.setting_settingSaleOnlineAutoAddCommentToNote),
                  trailing: Switch.adaptive(
                      value: _shopConfig.saleFacebookConfig.printComment,
                      onChanged: (value) {
                        setState(() {
                          _shopConfig.saleFacebookConfig.printComment = value;
                        });
                      }),
                ),
                dividerMin,
                // In toàn bộ ghi chú
                ListTile(
                  title: Text(S.current.setting_settingSaleOnlinePrintAllNotes),
                  subtitle: Text(S.current
                      .setting_settingSaleOnlinePrintAllNotesApplyTposPrinter),
                  trailing: Switch.adaptive(
                    value: _shopConfig.saleFacebookConfig.printAllOrderNote,
                    onChanged: (value) {
                      setState(() {
                        _shopConfig.saleFacebookConfig.printAllOrderNote =
                            value;
                      });
                    },
                  ),
                ),
                dividerMin,

                // In ghi chú đơn hàng khi in lại
                // Luôn in ghi chú đơn hàng khi in lại đơn hàng từ danh sách đơn onlin
                ListTile(
                  title: Text(S
                      .current.setting_settingSaleOnlinePrintNotWhenReprinting),
                  subtitle: Text(
                    S.current
                        .setting_settingSaleOnlinePrintNotWhenReprintingFromOnline,
                  ),
                  trailing: Switch.adaptive(
                    value: _shopConfig
                        .saleFacebookConfig.printAllOrderNoteWhenReprint,
                    onChanged: (value) {
                      setState(() {
                        _shopConfig.saleFacebookConfig
                            .printAllOrderNoteWhenReprint = value;
                      });
                    },
                  ),
                ),
                //Nội dung in
                //Tùy chỉnh nội dung sẽ in ra (Tạm thời chỉ khả dụng với máy in qua mạng LAN): Nhấn để cấu hinh"
                ListTile(
                  title: Text(S.current.setting_settingSaleOnlinePrintContent),
                  isThreeLine: true,
                  subtitle: Text(
                      S.current.setting_settingSaleOnlineCustomPrintContent),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pushNamed(
                        context, AppRoute.saleOnlinePrintContentSetting);
                  },
                ),
                dividerMin,
                // In header tùy chỉnh
                SwitchListTile.adaptive(
                  title: Text(
                      S.current.setting_settingSaleOnlineCustomPrintHeader),
                  subtitle: Text(S.current
                      .setting_settingSaleOnlineCustomPrintHeaderReplaceDefaultHeader),
                  value: _shopConfig.saleFacebookConfig.printCustomHeader,
                  onChanged: (value) {
                    setState(() {
                      _shopConfig.saleFacebookConfig.printCustomHeader = value;
                    });
                  },
                ),

                dividerMin,
                ListTile(
                  title: Text(S.current.setting_settingSaleOnlineCustomHeader),
                  subtitle: Text(_shopConfig.saleFacebookConfig.customHeader),
                  trailing: FlatButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            final headerTextController = TextEditingController(
                                text: _shopConfig
                                    .saleFacebookConfig.customHeader);
                            // /Nhập nội dung header
                            return AlertDialog(
                              title: Text(S.current
                                  .setting_settingSaleOnlineEnterHeaderContent),
                              content: TextField(
                                controller: headerTextController,
                                maxLines: null,
                              ),
                              actions: <Widget>[
                                //Xong
                                FlatButton(
                                  child: Text(S.current.completed),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    setState(() {
                                      _shopConfig
                                              .saleFacebookConfig.customHeader =
                                          headerTextController.text.trim();
                                    });
                                  },
                                )
                              ],
                            );
                          });
                    },
                    child: Text(S.current.edit),
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
                      const Icon(Icons.print),
                      const SizedBox(
                        width: 10,
                      ),
                      // ĐƠN HÀNG
                      Text(
                        "FACEBOOK + ${S.current.setting_settingSaleOnlineOrder.toUpperCase()}",
                        textAlign: TextAlign.left,
                        style: layoutHeaderStyle,
                      ),
                    ],
                  ),
                ),

                dividerMin,
                //Số bài đăng tải 1 lần
                ListTile(
                  title: Text(S.current.setting_settingSaleOnlinePostPerTime),
                  trailing: SizedBox(
                    width: 130,
                    child: NumberFieldWidget(
                      initNumber:
                          _shopConfig.saleFacebookConfig.postCountPerFetchTimes,
                      onChanged: (value) {
                        _shopConfig.saleFacebookConfig.postCountPerFetchTimes =
                            value;
                      },
                    ),
                  ),
                ),
                //"Số bình luận tải 1 lần
                dividerMin,
                ListTile(
                  title:
                      Text(S.current.setting_settingSaleOnlineCommentPerTime),
                  trailing: SizedBox(
                    width: 130,
                    child: NumberFieldWidget(
                      initNumber: _shopConfig
                          .saleFacebookConfig.commentCountPerFetchTimes,
                      onChanged: (value) {
                        _shopConfig.saleFacebookConfig
                            .commentCountPerFetchTimes = value;
                      },
                    ),
                  ),
                ),
                dividerMin,

                //Thời gian tự động tải (giây)
                ListTile(
                  title:
                      Text(S.current.setting_settingSaleOnlineAutoLoadSecond),
                  subtitle: Text(
                      "${S.current.setting_settingSaleOnlineAutoGetCommentPer} ${_shopConfig.saleFacebookConfig.fetchCommentDurationSecond} ${S.current.setting_settingSaleOnlineTimeIfNoConnectLive}"),
                  trailing: SizedBox(
                    width: 130,
                    child: NumberFieldWidget(
                      initNumber: _shopConfig
                          .saleFacebookConfig.fetchCommentDurationSecond,
                      onChanged: (value) {
                        _shopConfig.saleFacebookConfig
                            .fetchCommentDurationSecond = value;
                      },
                    ),
                  ),
                ),
                dividerMin,
                //Số thứ tự phiếu
                //ố thứ tự đơn hàng sẽ được reset về 0
                ListTile(
                  title: Text(
                      "${S.current.setting_settingSaleOnlineNumberOfSlip}."),
                  trailing: FlatButton(
                      textColor: ColorResource.hyperlinkColor,
                      onPressed: () async {
                        final result = await showQuestion(
                            context: context,
                            message: S.current
                                .setting_settingSaleOnlinePressResetToUpdateBack0,
                            title: "Vui lòng xác nhận");

                        if (result == OldDialogResult.Yes) {
                          // await viewModel.resetSaleOnlineSessionNumber();
                        }
                      },
                      child: const Text(
                        "Reset",
                        style: TextStyle(fontStyle: FontStyle.italic),
                      )),
                  subtitle: Text(
                    S.current.setting_settingSaleOnlinePressResetToUpdateBack0,
                  ),
                ),
                dividerMin,
                if (_saleOnlinConfig != null)
                  //Bật số thứ tự phiếu
                  SwitchListTile.adaptive(
                    title: Text(S.current.setting_settingSaleOnlineTurnOn),
                    value: _saleOnlinConfig?.saleOnlineFacebookSessionEnable ??
                        false,
                    subtitle: const Text(""),
                    onChanged: (value) async {
                      // Bật tắt số thứ tự phiếu
                      //Xác nhận
                      final confirmResult = await showQuestion(
                          context: context,
                          title: S.current.confirm,
                          message:
                              "${S.current.setting_settingSaleOnlineDoYouWant} ${_saleOnlinConfig.saleOnlineFacebookSessionEnable ? S.current.turnOff : S.current.turnOn} ${S.current.setting_settingSaleOnlineNumberOfSlip.toLowerCase()}");

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
//Kiểu hiển thị thời gian bình luận"
                SwitchListTile.adaptive(
                  title: Text(S.current.setting_settingSaleOnlineTypeShowTime),
                  subtitle: Text(
                      S.current.setting_settingSaleOnlineExampleTypeShowTime),
                  value:
                      _shopConfig.saleFacebookConfig.showCommentTimeAsTimeAgo,
                  onChanged: (value) {
                    setState(() {
                      _shopConfig.saleFacebookConfig.showCommentTimeAsTimeAgo =
                          value;
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
                //Tải toàn bộ bình luận

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

                //Sắp xếp bình luận khi vào bài live
                //Mới nhất ở đầu
                // Mới nhất ở cuối
                ListTile(
                  title: Text(S.current.setting_settingSaleOnlineSortComment),
                  trailing: DropdownButton<SaleOnlineCommentOrderBy>(
                      value: _shopConfig.saleFacebookConfig.orderCommentBy,
                      items: [
                        DropdownMenuItem<SaleOnlineCommentOrderBy>(
                          child: Text(
                              S.current.setting_settingSaleOnlineLatestOnTop),
                          value: SaleOnlineCommentOrderBy.DATE_CREATE_DESC,
                        ),
                        DropdownMenuItem<SaleOnlineCommentOrderBy>(
                          child: Text(
                              S.current.setting_settingSaleOnlineLatestOnEnd),
                          value: SaleOnlineCommentOrderBy.DATE_CREATED_ASC,
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _shopConfig.saleFacebookConfig.orderCommentBy = value;
                        });
                      }),
                ),

                dividerMin,

                ListTile(
                  // Chỉ có các bình luận chất lượng hiển thị theo tỉ lệ bạn chọn
                  title: Text(S.current.setting_settingSaleOnlineFilterByFB),
                  subtitle:
                      Text(S.current.setting_settingSaleOnlineCommentByRate),
                  trailing: DropdownButton(
                      value: _shopConfig.saleFacebookConfig.fetchCommentRate,
                      items: [
                        //1 bình luận/ 2 giây
                        DropdownMenuItem<CommentRate>(
                          child: Text(S.current
                              .setting_settingSaleOnlineOneCommentTwoSeconds),
                          value: CommentRate.one_per_two_seconds,
                        ),
                        // 10 bình luận/ giây
                        DropdownMenuItem<CommentRate>(
                          child: Text(S.current
                              .setting_settingSaleOnlineTenCommentsPerSecond),
                          value: CommentRate.ten_per_second,
                        ),
                        DropdownMenuItem<CommentRate>(
                          child: Text(S.current
                              .setting_settingSaleOnlineAsMuchAsPossible),
                          value: CommentRate.one_hundred_per_second,
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _shopConfig.saleFacebookConfig.fetchCommentRate =
                              value;
                        });
                      }),
                ),
                dividerMin,
                // Tự động lưu bình luận sau: (phút)
                ListTile(
                  title:
                      Text(S.current.setting_settingSaleOnlineAutoSaveComment),
                  trailing: SizedBox(
                    width: 130,
                    child: NumberFieldWidget(
                      initNumber: _shopConfig
                          .saleFacebookConfig.autoSaveCommentEveryInMinute,
                      onChanged: (value) {
                        setState(() {
                          _shopConfig.saleFacebookConfig
                              .autoSaveCommentEveryInMinute = value;
                        });
                      },
                    ),
                  ),
                ),

                dividerMin,
                //Ví đụ để ẩn các bình luận '[.], [..]' không có giá trị chốt đơn
                SwitchListTile.adaptive(
                  title: Text(S.current.setting_settingSaleOnlineHideComments),
                  subtitle: Text(
                      S.current.setting_settingSaleOnlineExampleHideComment),
                  value: _shopConfig.saleFacebookConfig.hideShortComment,
                  onChanged: (value) {
                    setState(() {
                      _shopConfig.saleFacebookConfig.hideShortComment = value;
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
                  // XONG
                  child: Text(
                    S.current.completed,
                    style: const TextStyle(
                        color: ColorResource.closeButtonTextColor),
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
          // Địa chỉ IP
          TextField(
            decoration: InputDecoration(
              hintText: S.current.setting_settingSaleOnlineIpAddress,
              labelText: S.current.setting_settingSaleOnlineIpAddress,
              suffixIcon: FlatButton(
                onPressed: () async {
                  final PrinterDevice printer = await showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return const FindIpPrinterPage();
                      });

                  if (printer != null) {
                    _computerIpTextEditController.text = printer.ip;
                    _computerPortTextEditController.text =
                        printer.port.toString();

                    //  viewModel.computerIp = priner.ip;
                    //viewModel.computerPort = priner.port.toString();
                  }
                },
                child: Text(S.current.search),
                textColor: Colors.blue,
              ),
            ),
            keyboardType: const TextInputType.numberWithOptions(
                decimal: true, signed: true),
            controller: _computerIpTextEditController,
            onChanged: (text) {
              //viewModel.computerIp = text;
            },
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp("[\\d|\.]")),
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
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLength: 5,
            onChanged: (text) {
              //  viewModel.computerPort = text;
            },
          ),
          // /In theo mẫu trong cài đặt nội dung in

          Container(
            child: RaisedButton(
              textColor: Colors.white,
              child: Text(
                S.current.setting_settingSaleOnlineTestPrint,
                style: const TextStyle(color: Colors.white),
              ),
              onPressed: () {
                // viewModel.printSaleOnlineTest();
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
          // Địa chỉ IP
          TextField(
            decoration: InputDecoration(
              hintText: S.current.setting_settingSaleOnlineIpAddress,
              labelText: S.current.setting_settingSaleOnlineIpAddress,
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

                    // viewModel.lanPrinterIp = printer.ip;
                    // viewModel.lanPrinterPort = printer.port.toString();
                  }
                },
                child: Text(S.current.search),
                textColor: Colors.blue,
              ),
            ),
            keyboardType: const TextInputType.numberWithOptions(
                decimal: true, signed: true),
            controller: _lanPrinterIpTextEditController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[\\d|\.]'))
            ],
            maxLength: 15,
            onChanged: (value) {
              //viewModel.lanPrinterIp = value;
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
              //viewModel.lanPrinterPort = value;
            },
          ),
          // In không dấu
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(S.current.setting_settingSaleOnlinePrintWithoutAccents),
              Expanded(
                child: Checkbox(
                  value: _shopConfig.saleFacebookConfig.printNoSign,
                  onChanged: (value) {
                    setState(() {
                      _shopConfig.saleFacebookConfig.printNoSign = value;
                    });
                  },
                ),
              ),
              //In thử"
              OutlineButton(
                child: Text(
                  S.current.setting_settingSaleOnlineTestPrint,
                  style: const TextStyle(color: Colors.blue),
                ),
                onPressed: () async {
                  try {
                    // viewModel.setBusy(true);
                    await _printService.printSaleOnlineLanTest();
                    // viewModel.setBusy(false);
                  } catch (e, s) {
                    // "In đã lỗi"

                    App.showDefaultDialog(
                        type: AlertDialogType.error,
                        title: S.current.printFailed,
                        content: e.toString());
                    //viewModel.setBusy(false);
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
