import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/account_payment/viewmodel/partner_search_contact_viewmodel.dart';
import 'package:tpos_mobile/widgets/page_state/page_state.dart';
import 'package:tpos_mobile/widgets/page_state/page_state_type.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import '../../../locator.dart';
import 'account_payment_add_contact_page.dart';

/// UI Danh sách người liên hệ
class PartnerSearchContactPage extends StatefulWidget {
  @override
  _PartnerSearchContactPageState createState() =>
      _PartnerSearchContactPageState();
}

class _PartnerSearchContactPageState extends State<PartnerSearchContactPage> {
  final _vm = locator<PartnerSearchContactViewModel>();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    setUpData();
  }

  Future setUpData() async {
    await _vm.getContactPartners();
    if (_vm.partners.length > 10) {
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
                        onChanged: (value) async {
                          if (value == "" || value.length == 1) {
                            setState(() {});
                          }
                          await _vm.searchOrderCommand(value);
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
    return ViewBase<PartnerSearchContactViewModel>(
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
                                    setUpData();
                                  },
                                  child: Text(
                                    S.current.reload,
                                    style: const TextStyle(color: Colors.white),
                                  )),
                            )
                          ],
                        )
                      : _vm.partners.isEmpty
                          ? const PageState()
                          : RefreshIndicator(
                              onRefresh: () async {
                                setUpData();
                                return true;
                              },
                              child: ListView.separated(
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          const Divider(
                                            height: 1,
                                            color: Color(0xFFF2F4F7),
                                          ),
                                  itemCount: _vm.partners.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: () {
                                        if (_vm.partners[index].id == null) {
                                          Navigator.pop(context, null);
                                        } else {
                                          Navigator.pop(
                                              context, _vm.partners[index]);
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 12),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(2)),
                                        child: Row(
                                          children: <Widget>[
                                            CircleAvatar(
                                              child: Text(
                                                  _vm.partners[index]?.name !=
                                                          null
                                                      ? _vm.partners[index].name
                                                          .substring(0, 1)
                                                          .toUpperCase()
                                                      : ""),
                                              backgroundColor:
                                                  const Color(0xFFE9F6EC),
                                            ),
                                            const SizedBox(
                                              width: 12,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    _vm.partners[index].name ??
                                                        "",
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        color:
                                                            Color(0xFF2C333A)),
                                                  ),
                                                  Wrap(
                                                    children: <Widget>[
                                                      Visibility(
                                                        visible: _vm
                                                                    .partners[
                                                                        index]
                                                                    .phone !=
                                                                null &&
                                                            _vm.partners[index]
                                                                    .phone
                                                                    .trim() !=
                                                                "",
                                                        child: const Icon(
                                                          Icons.phone,
                                                          size: 16,
                                                          color:
                                                              Color(0xFFA7B2BF),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 3,
                                                      ),
                                                      Text(
                                                        "  ${_vm.partners[index].phone ?? ""}",
                                                        style: const TextStyle(
                                                          color:
                                                              Color(0xFF929DAA),
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 8,
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Visibility(
                                                            visible: _vm
                                                                        .partners[
                                                                            index]
                                                                        .street !=
                                                                    null &&
                                                                _vm.partners[index]
                                                                        .street !=
                                                                    "",
                                                            child: const Icon(
                                                              FontAwesomeIcons
                                                                  .mapMarkerAlt,
                                                              size: 12,
                                                              color: Color(
                                                                  0xFF929DAA),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 4,
                                                          ),
                                                          Text(
                                                            _vm.partners[index]
                                                                    .street ??
                                                                '',
                                                            style:
                                                                const TextStyle(
                                                              color: Color(
                                                                  0xFF929DAA),
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                        ],
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
            ),
          );
        });
  }
}
