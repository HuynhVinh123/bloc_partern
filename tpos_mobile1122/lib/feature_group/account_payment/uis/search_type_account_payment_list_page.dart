import 'package:flutter/material.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/account/uis/type_account_add_edit_page.dart';
import 'package:tpos_mobile/feature_group/account/uis/type_account_sale_add_edit_page.dart';
import 'package:tpos_mobile/feature_group/account_payment/viewmodel/search_type_account_payment_list_viewmodel.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/widgets/page_state/page_state.dart';
import 'package:tpos_mobile/widgets/page_state/page_state_type.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class SearchTypeAccountPaymentListPage extends StatefulWidget {
  // Nếu isAccountPayment = true : thực hiện lấy danh sách phiếu thu      isAccountPayment = false : thực hiện lấy danh sách phiếu chi
  const SearchTypeAccountPaymentListPage(this.isAccountPayment);
  final bool isAccountPayment;

  @override
  _SearchAccountPaymentListPageState createState() =>
      _SearchAccountPaymentListPageState();
}

class _SearchAccountPaymentListPageState
    extends State<SearchTypeAccountPaymentListPage> {
  final _vm = locator<SearchTypeAccountPaymentListViewModel>();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    await _vm.getAccounts(widget.isAccountPayment);
    _focusNode.requestFocus();
  }

  Widget _buildSearch() {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(24)),
      height: 40,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: <Widget>[
          const SizedBox(
            width: 12,
          ),
          const Icon(
            Icons.search,
            color: Color(0xFF5A6271),
          ),
          Expanded(
            child: Center(
              child: Container(
                  height: 35,
                  margin: const EdgeInsets.only(left: 4),
                  child: Center(
                    child: TextField(
                        focusNode: _focusNode,
                        controller: _searchController,
                        onChanged: (value) {
                          if (value == "" || value.length == 1) {
                            setState(() {});
                          }
                          _vm.searchOrderCommand(value);
                        },
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(0),
                            isDense: true,
                            hintText: S.current.search,
                            border: InputBorder.none)),
                  )),
            ),
          ),
          Visibility(
            visible: _searchController.text != "",
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.grey,
                size: 18,
              ),
              onPressed: () {
                setState(() {
                  _searchController.text = "";
                });
                _vm.searchOrderCommand("");
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewBase<SearchTypeAccountPaymentListViewModel>(
        model: _vm,
        builder: (context, model, sizingInformation) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFF858F9B),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: _buildSearch(),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.add_circle,
                    color: Color(0xFF28A745),
                    size: 28,
                  ),
                  onPressed: () {
                    if (widget.isAccountPayment) {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const TypeAccountAddEditPage()))
                          .then((value) async {
                        if (value != null) {
                          await _vm.getAccounts(widget.isAccountPayment);
                          _vm.isSearch = true;
                          _searchController.text = (value as Account).name;
                          _vm.searchOrderCommand(value.name);
                        }
                      });
                    } else {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const TypeAccountSaleAddEditPage()))
                          .then((value) async {
                        if (value != null) {
                          await _vm.getAccounts(widget.isAccountPayment);
                          _vm.isSearch = true;
                          _searchController.text = (value as Account).name;
                          _vm.searchOrderCommand(value.name);
                        }
                      });
                    }
                  },
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: _vm.isBusy
                  ? const SizedBox()
                  : _vm.isError
                      ? PageState(
                          type: PageStateType.dataError,
                          actions: [
                            Container(
                              width: 110,
                              height: 35,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5)),
                              child: FlatButton(
                                  color: Colors.green,
                                  onPressed: () {
                                    _vm.getAccounts(widget.isAccountPayment);
                                  },
                                  child: Text(
                                    S.current.reload,
                                    style: const TextStyle(color: Colors.white),
                                  )),
                            )
                          ],
                        )
                      : _vm.accounts.isEmpty
                          ? PageState(
                              title: _vm.isSearch
                                  ? "${S.current.notifySearchEmpty} \"${_searchController.text}\""
                                  : null,
                              actions: [
                                  Visibility(
                                    visible: !_vm.isSearch,
                                    child: Container(
                                      width: 110,
                                      height: 35,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: FlatButton(
                                          color: Colors.green,
                                          onPressed: () {
                                            if (widget.isAccountPayment) {
                                              Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const TypeAccountAddEditPage()))
                                                  .then((value) async {
                                                if (value != null) {
                                                  await _vm.getAccounts(
                                                      widget.isAccountPayment);
                                                  _vm.isSearch = true;
                                                  _searchController.text =
                                                      (value as Account).name;
                                                  _vm.searchOrderCommand(
                                                      value.name);
                                                }
                                              });
                                            } else {
                                              Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const TypeAccountSaleAddEditPage()))
                                                  .then((value) async {
                                                if (value != null) {
                                                  await _vm.getAccounts(
                                                      widget.isAccountPayment);
                                                  _vm.isSearch = true;
                                                  _searchController.text =
                                                      (value as Account).name;
                                                  _vm.searchOrderCommand(
                                                      value.name);
                                                }
                                              });
                                            }
                                          },
                                          child: Text(
                                            S.current.add,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          )),
                                    ),
                                  )
                                ])
                          : ListView.separated(
                              separatorBuilder:
                                  (BuildContext context, int index) => Divider(
                                        height: 1,
                                        color: Colors.grey[400],
                                      ),
                              itemCount: _vm.accounts.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    if (_vm.accounts[index].id == null) {
                                      Navigator.pop(context, null);
                                    } else {
                                      Navigator.pop(
                                          context, _vm.accounts[index]);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 12),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(2)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          _vm.accounts[index]?.name,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Color(0xFF2C333A)),
                                        ),
                                        Text(
                                          _vm.accounts[index]?.companyName ??
                                              "",
                                          style: const TextStyle(
                                              color: Color(0xFF929DAA),
                                              fontSize: 15),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
            ),
          );
        });
  }
}
