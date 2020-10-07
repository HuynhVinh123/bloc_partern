import 'package:flutter/material.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/account_payment/viewmodel/type_account_payment_list_viewmodel.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class TypeAccountPaymentListPage extends StatefulWidget {
  // Nếu isAccountPayment = true : thực hiện lấy danh sách phiếu thu      isAccountPayment = false : thực hiện lấy danh sách phiếu chi
  const TypeAccountPaymentListPage(this.isAccountPayment);
  final bool isAccountPayment;
  @override
  _TypePaymentListPageState createState() => _TypePaymentListPageState();
}

class _TypePaymentListPageState extends State<TypeAccountPaymentListPage> {
  final _vm = locator<TypeAccountPaymentListViewModel>();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _vm.getAccounts(widget.isAccountPayment);
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
            color: Color(0xFF28A745),
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
                        autofocus: true,
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
    return ViewBase<TypeAccountPaymentListViewModel>(
        model: _vm,
        builder: (context, model, sizingInformation) {
          return Scaffold(
            appBar: AppBar(
              title: _vm.isSearch
                  ? _buildSearch()
                  : widget.isAccountPayment
                      ? Text(S.current.receiptType_receiptTypes)
                      : Text(S.current.paymentType_paymentTypes),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _searchController.text = "";
                    _vm.isSearch = !_vm.isSearch;
                    if (!_vm.isSearch) {
                      _vm.searchOrderCommand("");
                    }
                  },
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(
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
                          Navigator.pop(context, _vm.accounts[index]);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 12),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              _vm.accounts[index]?.name ?? "",
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              _vm.accounts[index].companyName ?? "",
                              style: const TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w600,
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
