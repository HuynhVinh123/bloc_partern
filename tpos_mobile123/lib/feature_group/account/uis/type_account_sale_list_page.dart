import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tpos_mobile/app_core/template_ui/empty_data_widget.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/account/uis/search_company_list_page.dart';
import 'package:tpos_mobile/feature_group/account/uis/type_account_sale_add_edit_page.dart';
import 'package:tpos_mobile/feature_group/account/viewmodels/type_account_sale_list_viewmodel.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/account.dart';

import '../../../locator.dart';

class TypeAccountSaleListPage extends StatefulWidget {
  @override
  _TypeAccountSaleListPageState createState() =>
      _TypeAccountSaleListPageState();
}

class _TypeAccountSaleListPageState extends State<TypeAccountSaleListPage> {
  final TypeAccountSaleListViewModel _vm =
      locator<TypeAccountSaleListViewModel>();

  @override
  Widget build(BuildContext context) {
    return ViewBase<TypeAccountSaleListViewModel>(
        model: _vm,
        builder: (context, model, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Danh sách loại phiếu chi"),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    TypeAccountSaleAddEditPage()))
                        .then((value) async {
                      if (value != null) {
                        if (value) {
                          await _vm.getAccounts();
                        }
                      }
                    });
                  },
                )
              ],
            ),
            body: SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  await _vm.getAccounts();
                },
                child: Column(
                  children: <Widget>[
                    _buildFilter(),
                    Expanded(
                      child: _vm.accounts.isEmpty
                          ? EmptyData(
                              onPressed: () {
                                _vm.getAccounts();
                              },
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 12),
                              itemCount: _vm.accounts.length,
                              itemBuilder: (BuildContext context, int index) {
                                return _buildItem(_vm.accounts[index], index);
                              }),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  /// Giao diện hiển thị icon Filter để open Drawer(Giao diện filter loại phiếu chi) và thông tin cty  filter.
  Widget _buildFilter() {
    return Container(
      height: 48,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(blurRadius: 1, offset: Offset(0, 1), color: Colors.grey[200])
      ]),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SearchCompanyListPage())).then((value) {
            if (value != null) {
              _vm.company = value;
              _vm.getAccounts();
            }
          });
        },
        child: Row(
          children: <Widget>[
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                "${_vm.company != null ? _vm.company?.name : "<Chọn công ty>"}",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
            )),
            Visibility(
              visible: _vm.company != null,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.grey[600],
                  size: 20,
                ),
                onPressed: () {
                  _vm.company = null;
                  _vm.getAccounts();
                },
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.grey[600],
            ),
            SizedBox(
              width: 18,
            )
          ],
        ),
      ),
    );
  }

  /// Hiển thị thông tin từng loại phiếu chi.
  Widget _buildItem(Account item, int index) {
    Widget sizedBox = SizedBox(
      height: 8,
    );
    return Dismissible(
      background: Container(
        color: Colors.green,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Text(
                "Xóa dòng này?",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.delete_forever,
                  color: Colors.white,
                  size: 30,
                ),
                Text(
                  "Xóa",
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
            SizedBox(
              width: 32,
            )
          ],
        ),
      ),
      direction: DismissDirection.endToStart,
      key: UniqueKey(),
      confirmDismiss: (direction) async {
        var dialogResult = await showQuestion(
            context: context,
            title: "Xác nhận xóa",
            message: "Bạn có muốn xóa loại phiếu chi ${item.name ?? ""}");
        if (dialogResult == DialogResultType.YES) {
          bool result = await _vm.deleteAccount(item.id, item);
          if (result) {
            return true;
          }
          return false;
        } else {
          return false;
        }
      },
      onDismissed: (direction) {
        setState(() {});
        _vm.showNotify("Xử lý xóa thành công!");
      },
      child: item == tempAccount
          ? _vm.isLoadMore
              ? Center(
                  child: SpinKitCircle(
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : Center(
                  child: Container(
                      margin: EdgeInsets.only(top: 12, bottom: 8),
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(3)),
                      height: 45,
                      child: FlatButton(
                        onPressed: () {
                          setState(() {
                            _vm.isLoadMore = true;
                          });
                          _vm.handleItemCreated(index);
                        },
                        color: Colors.blueGrey,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Tải tiếp",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16)),
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
                )
          : InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TypeAccountSaleAddEditPage(
                              id: item.id,
                              callback: (value) {
                                setState(() {
                                  _vm.accounts[index] = value;
                                });
                              },
                            )));
              },
              child: Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                decoration: BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: Colors.grey[300]))),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      child: Text("${item.name.substring(0, 1).toUpperCase()}"),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "${item.name} ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF484D54),
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                    "${item.code ?? ""}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.blueGrey[600]),
                                    textAlign: TextAlign.right,
                                  )),
                            ],
                          ),
                          sizedBox,
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.home,
                                color: Colors.green.withOpacity(0.5),
                                size: 20,
                              ),
                              Expanded(
                                child: Text(
                                  " ${item.companyName}",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  /// Lấy danh sách loại phiếu chi.
  void initData() async {
    await _vm.getAccounts();
  }
}
