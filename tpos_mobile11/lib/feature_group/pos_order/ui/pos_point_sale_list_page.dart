import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tpos_mobile/app_core/template_ui/empty_data_widget.dart';
import 'package:tpos_mobile/app_core/template_ui/reload_list_page.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/point_sale.dart';
import 'package:tpos_mobile/feature_group/pos_order/ui/pos_cart_page.dart';
import 'package:tpos_mobile/feature_group/pos_order/ui/pos_close_point_sale_page.dart';
import 'package:tpos_mobile/feature_group/pos_order/ui/pos_point_sale_info_page.dart';
import 'package:tpos_mobile/feature_group/pos_order/viewmodels/dialog_update_info_viewmodel.dart';
import 'package:tpos_mobile/feature_group/pos_order/viewmodels/pos_point_sale_list_viewmodel.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class PosPointSaleListPage extends StatefulWidget {
  @override
  _PosPointSaleListPageState createState() => _PosPointSaleListPageState();
}

class _PosPointSaleListPageState extends State<PosPointSaleListPage> {
  final _vm = locator<PosPointSaleListViewModel>();
  final _vmDialog = locator<DialogUpdateInfoViewModel>();

  @override
  Widget build(BuildContext context) {
    return ViewBase<PosPointSaleListViewModel>(
      model: _vm,
      builder: (context, model, _) => Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          /// Điểm bán hàng
          title: Text(S.current.menu_posOfSale),
        ),
        body: _vm.pointSales.isEmpty
            ? EmptyData(
                onPressed: () async {
                  await _vm.getUser();
                  await _vm.loadPointSales();
                },
              )
            : Container(
                color: Colors.white,
                child: Container(
                  decoration: BoxDecoration(color: Colors.grey[100]),
                  child: _showDanhSachDiemBanHang(),
                ),
              ),
      ),
    );
  }

  Widget _showDanhSachDiemBanHang() {
    return Container(
      child: RefreshIndicator(
          onRefresh: () async {
            await _vm.getUser();
            return await _vm.loadPointSales();
          },
          child: ReloadListPage(
              vm: _vm,
              onPressed: _vm.loadPointSales,
              child: ListView.builder(
                  itemCount: _vm.pointSales.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 11, right: 11, top: 10),
                      child: _showItem(_vm.pointSales[index], index),
                    );
                  }))),
    );
  }

  Widget _showItem(PointSale item, int index) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(3.0)),
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PosPointSaleInfoPage(item.id)),
              );
            },
            title: Padding(
              padding: const EdgeInsets.only(top: 9, bottom: 6),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      item.name ?? "",
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          color: Color(0xFF28A745),
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(4)),
                      height: 30,
                      width: item.currentSessionState != "opened" ? 95 : 74,
                      child: RaisedButton(
                          color: const Color(0xFFF0F1F3),
                          onPressed: () async {
                            bool result = false;
                            if (item.currentSessionState == "opened") {
                              result = await _vm.handleCreatePointSale(
                                  item.pOSSessionUserName,
                                  item.id,
                                  index,
                                  context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PosClosePointSalePage(
                                          id: int.parse(_vm.numberSession),
                                          pointSaleId: item.id,
                                          companyId: item.companyId,
                                          userId: _vm.tposUser.id,
                                        )),
                              ).then((value) async {
                                if (value != null) {
                                  await _vm.getUser();
                                  await _vm.loadPointSales();
                                }
                              });
                            } else {
                              result = await _vm.handleCreatePointSale(
                                  item.pOSSessionUserName,
                                  item.id,
                                  index,
                                  context);
                            }
                            if (result) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PosCartPage(item.id,
                                        item.companyId, _vm.tposUser.id, true)),
                              ).then((value) {
                                _vm.loadPointSales();
                              });
                            }
                          },

                          ///  Phiên mới   Đóng
                          child: AutoSizeText(
                            item.currentSessionState != "opened"
                                ? S.current.posOfSale_NewSession
                                : S.current.close,
                            style: const TextStyle(color: Color(0xFF484D54)),
                            maxLines: 1,
                          )),
                    ),
                    Visibility(
                      visible: item.currentSessionState == "opened",
                      child: const SizedBox(
                        width: 10,
                      ),
                    ),
                    Visibility(
                      visible: item.currentSessionState == "opened",
                      child: Container(
                        height: 30,
                        width: 93,
                        decoration: BoxDecoration(
                            color: const Color(0xFF28A745),
                            borderRadius: BorderRadius.circular(4)),
                        child: RaisedButton(
                            onPressed: () async {
                              if (_vmDialog.isFirstAccess) {
                                _vmDialog.isNoQuestion = true;
                              }
                              if (!_vmDialog.isNoQuestion) {
                                _vm.showNotifyUpdateData(context, _vmDialog,
                                    id: item.id, companyId: item.companyId);
                              } else {
                                if (_vmDialog.isFirstAccess) {
                                  _vmDialog.isFirstAccess = false;
                                  _vmDialog.isNoQuestion = false;
                                }

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PosCartPage(
                                          item.id,
                                          item.companyId,
                                          _vm.tposUser.id,
                                          _vmDialog.isLoadingData)),
                                ).then((value) {
                                  if (value != null) {
                                    _vm.loadPointSales();
                                  }
                                });
                              }
                            },
                            child: Text(
                              S.current.continues,
                              style: const TextStyle(color: Colors.white),
                            )),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                Divider(
                  color: Colors.grey.shade300,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          if (item.pOSSessionUserName != null)
                            const Icon(Icons.person, color: Color(0xFF28A745))
                          else
                            const Icon(
                              Icons.insert_drive_file,
                              size: 17,
                              color: Color(0xFF9CA2AA),
                            ),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(item.pOSSessionUserName ?? "Chưa sử dụng",
                              style: TextStyle(
//                          color: getFastSaleOrderStateOption(state: item.state)
//                              .textColor,
                                  fontWeight: FontWeight.bold,
                                  color: item.pOSSessionUserName != null
                                      ? const Color(0xFF28A745)
                                      : const Color(0xFF9CA2AA))),
                        ],
                      ),
                    ),
                    if (item.pOSSessionUserName != null)
                      const Icon(
                        Icons.open_in_browser,
                        color: Color(0xFF28A745),
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
                      item.lastSessionClosingDate == null
                          ? ""
                          : DateFormat("dd/MM/yyyy  HH:mm").format(
                              DateTime.parse(item.lastSessionClosingDate)
                                  .toLocal()),
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
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    await _vm.checkVersion(context);
    await _vm.getUser();
    await _vm.loadPointSales();
  }
}
