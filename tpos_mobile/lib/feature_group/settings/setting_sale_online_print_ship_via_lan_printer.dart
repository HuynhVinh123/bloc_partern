import 'package:flutter/material.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/sale_online_support_print_content_list_page.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/services/app_setting_service.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class SettingSaleOnlinePrintShipViaLanPrinter extends StatefulWidget {
  @override
  _SettingSaleOnlinePrintShipViaLanPrinterState createState() =>
      _SettingSaleOnlinePrintShipViaLanPrinterState();
}

class _SettingSaleOnlinePrintShipViaLanPrinterState
    extends State<SettingSaleOnlinePrintShipViaLanPrinter> {
  final _setting = locator<ISettingService>();
  List<SupportPrintSaleOnlineRow> contents = <SupportPrintSaleOnlineRow>[];

  String currentName;

  void _save() {
    _setting.settingSaleOnlinePrintContents = contents;
    Navigator.pop(context);
  }

  @override
  void initState() {
    // ignore: avoid_function_literals_in_foreach_calls
    _setting.settingSaleOnlinePrintContents?.forEach(
      (value) {
        final row = _setting.supportSaleOnlinePrintRow
            .firstWhere((f) => f.name == value.name, orElse: () => null);
        if (row != null) {
          contents.add(value..description = row.description);
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //Nội dung in
        title: Text(S.current.setting_settingSaleOnlinePrintContent),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              final selectedItem = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SaleOnlineSupportPrintContentListPage(
                    selectedList: contents,
                  ),
                ),
              );

              if (selectedItem != null) {
                setState(() {
                  contents.add(selectedItem);
                });
              }
            },
            icon: const Icon(Icons.add),
          ),
          FlatButton.icon(
            textColor: Colors.white,
            onPressed: () {
              _save();
            },
            icon: const Icon(Icons.save),
            label: Text(S.current.save.toUpperCase()),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            color: Colors.white,
            onPressed: () async {
              final result = await showQuestion(
                  context: context,
                  title: S.current.confirm,
                  message: S.current.setting_settingSaleOnlineDoYouWantToReset);

              if (result != OldDialogResult.Yes) {
                return;
              }

              setState(() {
                contents = _setting.defaultSaleOnlinePrintRow.map(
                  (f) {
                    final value = _setting.supportSaleOnlinePrintRow
                        .firstWhere((g) => g.name == f.name);
                    return f..description = value.description;
                  },
                ).toList();
              });
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        Expanded(
          child: ReorderableListView(
            padding: const EdgeInsets.all(12),
            header: Container(
              padding: const EdgeInsets.all(8),
              //"- Nhấn (+) để thêm dòng mới\n- Nhấn giữ 1 dòng và kéo tới vị trí mong muốn để sắp xếp lại\n- Nhấn vào một dòng để mở cài đặt (đậm, nghiêng, cỡ chữ)\n- Kéo 1 dòng qua trái để xóa khỏi danh sách\n- Nhấn (↻)  để khôi phục mặc định"
              child: Text(
                  "- ${S.current.press}(+) ${S.current.setting_settingSaleOnlineToAddNewLine}\n- ${S.current.setting_settingSaleOnlineHoldAndDrag}\n- ${S.current.setting_settingSaleOnlinePressALneToOpenSetting}\n- ${S.current.setting_settingSaleOnlineDragOneLineLeft}\n- ${S.current.press} (↻)  ${S.current.setting_settingSaleOnlineToRestoreDefault}"),
            ),
            onReorder: (start, current) {
              if (start < current) {
                final int end = current - 1;
                final startItem = contents[start];
                int i = 0;
                int local = start;
                do {
                  contents[local] = contents[++local];
                  i++;
                } while (i < end - start);
                contents[end] = startItem;
              }
              // dragging from bottom to top
              else if (start > current) {
                final startItem = contents[start];
                for (int i = start; i > current; i--) {
                  contents[i] = contents[i - 1];
                }
                contents[current] = startItem;
              }
              setState(() {});
            },
            children: [
              for (int i = 0; i < contents.length; i++) ...[
                Dismissible(
                  direction: DismissDirection.endToStart,
                  key: Key(contents[i].name),
                  onDismissed: (direction) {
                    setState(() {
                      contents.removeAt(i);
                    });
                  },
                  confirmDismiss: (direction) async {
                    return true;
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 2, bottom: 2),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ExpansionTile(
                      initiallyExpanded: currentName == contents[i].name,
                      onExpansionChanged: (value) {
                        if (value == true) if (currentName != contents[i].name)
                          setState(() {});

                        currentName = contents[i].name;
                      },
                      title: Text(
                        contents[i].description,
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: contents[i].fontSize * 14.0,
                            fontWeight: contents[i].bold
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontStyle: contents[i].itanic
                                ? FontStyle.italic
                                : FontStyle.normal),
                        textAlign: TextAlign.center,
                      ),
                      trailing: const Icon(Icons.menu),
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Row(
                              children: const <Widget>[
                                SizedBox(
                                    width: 50, child: Icon(Icons.format_bold)),
                                SizedBox(
                                    width: 50,
                                    child: Icon(Icons.format_italic)),
                                SizedBox(
                                    width: 50, child: Icon(Icons.looks_one)),
                                SizedBox(
                                    width: 50, child: Icon(Icons.looks_two)),
                                SizedBox(width: 50, child: Icon(Icons.looks_3)),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 50,
                                  child: Checkbox(
                                    value: contents[i].bold,
                                    onChanged: (value) {
                                      setState(() {
                                        contents[i].bold = value;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                  child: Checkbox(
                                    value: contents[i].itanic,
                                    onChanged: (value) {
                                      setState(() {
                                        contents[i].itanic = value;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                  child: Radio(
                                    value: 1,
                                    groupValue: contents[i].fontSize,
                                    onChanged: (value) {
                                      if (value == 1) {
                                        setState(() {
                                          contents[i].fontSize = 1;
                                        });
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                  child: Radio(
                                    value: 2,
                                    groupValue: contents[i].fontSize,
                                    onChanged: (value) {
                                      setState(() {
                                        contents[i].fontSize = 2;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                    width: 50,
                                    child: Radio(
                                      value: 3,
                                      groupValue: contents[i].fontSize,
                                      onChanged: (value) {
                                        setState(() {
                                          contents[i].fontSize = 3;
                                        });
                                      },
                                    )),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),
      ],
    );
  }
}
