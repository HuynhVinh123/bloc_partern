import 'package:flutter/material.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/account_payment/viewmodel/search_contact_partner_viewmodel.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import '../../../locator.dart';
import 'account_payment_add_contact_page.dart';

class SearchContactPartnerPage extends StatefulWidget {
  @override
  _SearchContactPartnerPageState createState() =>
      _SearchContactPartnerPageState();
}

class _SearchContactPartnerPageState extends State<SearchContactPartnerPage> {
  final _vm = locator<SearchContactPartnerViewModel>();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _vm.getContactPartners();
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
    return ViewBase<SearchContactPartnerViewModel>(
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
                  : Text(S.current.contacts,
                      style: const TextStyle(
                        color: Color(0xFF858F9B),
                      )),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.search, color: Color(0xFF858F9B)),
                  onPressed: () {
                    _searchController.text = "";
                    _vm.isSearch = !_vm.isSearch;
                    if (!_vm.isSearch) {
                      _vm.searchOrderCommand("");
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.add_circle,
                    color: Color(0xFF28A745),
                    size: 28,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AccountPaymentAddContactPage()),
                    ).then((value) async {
                      if (value != null) {
                        if (value) {
                          await _vm.getContactPartners();
                        }
                      }
                    });
                  },
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                        height: 1,
                        color: Color(0xFF929DAA),
                      ),
                  itemCount: _vm.partners.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        if (_vm.partners[index].id == null) {
                          Navigator.pop(context, null);
                        } else {
                          Navigator.pop(context, _vm.partners[index]);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 12),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2)),
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              child: Text(_vm.partners[index]?.name != null
                                  ? _vm.partners[index].name
                                      .substring(0, 1)
                                      .toUpperCase()
                                  : ""),
                              backgroundColor: const Color(0xFFE9F6EC),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    _vm.partners[index].name ?? "",
                                    style: const TextStyle(
                                        fontSize: 15, color: Color(0xFF2C333A)),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Visibility(
                                        visible: _vm.partners[index].phone !=
                                                null &&
                                            _vm.partners[index].phone.trim() !=
                                                "",
                                        child: const Icon(
                                          Icons.phone,
                                          size: 20,
                                          color: Color(0xFFA7B2BF),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        "  ${_vm.partners[index].phone ?? ""}",
                                        style: const TextStyle(
                                          color: Color(0xFF929DAA),
                                          fontSize: 15,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
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