import 'package:flutter/material.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/account/uis/type_account_add_edit_page.dart';
import 'package:tpos_mobile/feature_group/account/uis/type_account_sale_add_edit_page.dart';
import 'package:tpos_mobile/feature_group/account_payment/viewmodel/account_payment_type_list_viewmodel.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/widgets/page_state/page_state.dart';
import 'package:tpos_mobile/widgets/page_state/page_state_type.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

/// UI danh sách loại phiếu thu, loại phiếu chi
class AccountPaymentTypeListPage extends StatefulWidget {
  // Nếu isAccountPayment = true : thực hiện lấy danh sách phiếu thu      isAccountPayment = false : thực hiện lấy danh sách phiếu chi
  const AccountPaymentTypeListPage(this.isAccountPayment);
  final bool isAccountPayment;
  @override
  _TypePaymentListPageState createState() => _TypePaymentListPageState();
}

class _TypePaymentListPageState extends State<AccountPaymentTypeListPage> {
  final _vm = locator<AccountPaymentTypeListViewModel>();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    setUpData();
  }

  Future setUpData() async {
    _vm.isAccountPayment = widget.isAccountPayment;
    await _vm.getAccounts(widget.isAccountPayment);
    if (_vm.accounts.length > 10) {
      _focusNode.requestFocus();
    }
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
                        controller: _searchController,
                        onChanged: (value) {
                          if (value == "" || value.length == 1) {
                            setState(() {});
                          }
                          _vm.searchOrderCommand(value);
                        },
                        focusNode: _focusNode,
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
    return ViewBase<AccountPaymentTypeListViewModel>(
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
              title: _vm.isSearch
                  ? _buildSearch()
                  : widget.isAccountPayment
                      ? Text(S.current.receiptType_receiptTypes,
                          style: const TextStyle(
                            color: Color(0xFF858F9B),
                          ))
                      : Text(S.current.paymentType_paymentTypes,
                          style: const TextStyle(
                            color: Color(0xFF858F9B),
                          )),
              actions: <Widget>[
//                IconButton(
//                  icon: const Icon(
//                    Icons.search,
//                    color: Color(0xFF858F9B),
//                  ),
//                  onPressed: () {
//                    _searchController.text = "";
//                    _vm.isSearch = !_vm.isSearch;
//                    if (!_vm.isSearch) {
//                      _vm.searchOrderCommand("");
//                    }
//                  },
//                ),
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
                      ? AppPageState(
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
                                    setUpData();
                                  },
                                  child: Text(
                                    S.current.reload,
                                    style: const TextStyle(color: Colors.white),
                                  )),
                            )
                          ],
                        )
                      : _vm.accounts.isEmpty
                          ? const AppPageState()
                          : RefreshIndicator(
                              onRefresh: () async {
                                setUpData();
                                return true;
                              },
                              child: ListView.separated(
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          Divider(
                                            height: 1,
                                            color: Colors.grey[400],
                                          ),
                                  itemCount: _vm.accounts.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
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
                                            borderRadius:
                                                BorderRadius.circular(2)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "[${_vm.accounts[index]?.code ?? ""}] ${_vm.accounts[index]?.nameGet ?? ""}",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xFF2C333A)),
                                            ),
                                            Text(
                                              _vm.accounts[index].companyName ??
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
            ),
          );
        });
  }
}
