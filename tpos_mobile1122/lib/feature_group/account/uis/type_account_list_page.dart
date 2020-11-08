import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/template_ui/empty_data_widget.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/account/uis/search_company_list_page.dart';
import 'package:tpos_mobile/feature_group/account/uis/type_account_add_edit_page.dart';
import 'package:tpos_mobile/feature_group/account/viewmodels/type_account_list_viewmodel.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

// Danh sách loại chi
class TypeAccountListPage extends StatefulWidget {
  @override
  _TypeAccountListPageState createState() => _TypeAccountListPageState();
}

class _TypeAccountListPageState extends State<TypeAccountListPage> {
  final TypeAccountListViewModel _vm = locator<TypeAccountListViewModel>();

  @override
  Widget build(BuildContext context) {
    return ViewBase<TypeAccountListViewModel>(
        model: _vm,
        builder: (context, model, _) {
          return Scaffold(
            appBar: AppBar(
              /// "Danh sách loại phiếu thu"
              title: Text(S.current.receiptType_receiptTypes),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const TypeAccountAddEditPage()))
                        .then((value) async {
                      if (value != null) {
                        await _vm.getAccounts();
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

  /// Giao diện hiển thị icon Filter để open Drawer(Giao diện filter loại phiếu thu) và thông tin cty filter.
  Widget _buildFilter() {
    return Container(
      height: 48,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            blurRadius: 1, offset: const Offset(0, 1), color: Colors.grey[200])
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

              /// Chọn công ty
              child: Text(
                _vm.company != null
                    ? _vm.company?.name
                    : "<${S.current.receiptType_chooseCompany}>",
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
            const SizedBox(
              width: 18,
            )
          ],
        ),
      ),
    );
  }

  /// Hiển thị thông tin từng loại phiếu thu.
  Widget _buildItem(Account item, int index) {
    const Widget sizedBox = SizedBox(
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
                S.current.deleteALine,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(
                  Icons.delete_forever,
                  color: Colors.white,
                  size: 30,
                ),
                Text(
                  S.current.delete,
                  style: const TextStyle(color: Colors.white),
                )
              ],
            ),
            const SizedBox(
              width: 32,
            )
          ],
        ),
      ),
      direction: DismissDirection.endToStart,
      key: UniqueKey(),
      confirmDismiss: (direction) async {
        final dialogResult = await showQuestion(
            context: context,
            title: S.current.delete,
            message:
                "${S.current.receiptType_confirmDelete} ${item.name ?? ""}");
        if (dialogResult == DialogResultType.YES) {
          final bool result = await _vm.deleteAccount(item.id, item);
          return result;
        } else {
          return false;
        }
      },
      onDismissed: (direction) {
        setState(() {});
        _vm.showNotify(S.current.receiptType_deleteSuccessful);
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
                      margin: const EdgeInsets.only(top: 12, bottom: 8),
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
                              Text(S.current.loadMore,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16)),
                              const SizedBox(
                                width: 12,
                              ),
                              const Icon(
                                Icons.save_alt,
                                color: Colors.white,
                                size: 18,
                              )
                            ],
                          ),
                        ),
                      )))
          : InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TypeAccountAddEditPage(
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
                      child: Text(item.name.substring(0, 1).toUpperCase()),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "${item.name} ",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF484D54),
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        // ignore: unnecessary_string_interpolations
                                        "${item.code ?? ""}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.blueGrey[600]),
                                      ))),
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
                                  style: const TextStyle(fontSize: 15),
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

  /// Gọi hàm để lấy danh sách phiếu thu
  Future<void> initData() async {
    await _vm.getAccounts();
  }
}
