import 'package:flutter/material.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/partners.dart';
import 'package:tpos_mobile/feature_group/pos_order/ui/pos_partner_add_edit_page.dart';
import 'package:tpos_mobile/feature_group/pos_order/viewmodels/pos_partner_list_viewmodel.dart';
import 'package:tpos_mobile/locator.dart';

import 'package:tpos_mobile/widgets/appbar_search_widget.dart';
import 'package:tpos_mobile_localization/generated/l10n.dart';

class PosPartnerListPage extends StatefulWidget {
  const PosPartnerListPage({this.partner});
  final Partners partner;
  @override
  _PosPartnerListPageState createState() => _PosPartnerListPageState();
}

class _PosPartnerListPageState extends State<PosPartnerListPage> {
  final _vm = locator<PosPartnerListViewModel>();
  bool _isSearchEnable = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    await _vm.getPartners();
    if (widget.partner?.name != null) {
      _vm.partner = widget.partner;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewBase<PosPartnerListViewModel>(
        model: _vm,
        builder: (context, model, _) {
          return Scaffold(
            backgroundColor: Colors.grey[300],
            appBar: buildAppBar(context),
            body: Stack(
              children: <Widget>[
                Visibility(
                  visible: _vm.partner != null,
                  child: Container(
                    height: 174,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Stack(
                      children: <Widget>[
                        SingleChildScrollView(
                          child: Row(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Container(
                                    child: CircleAvatar(
                                      child: Image.asset("images/no_image.png"),
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.white,
                                    ),
                                    margin: const EdgeInsets.all(0),
                                    width: 60,
                                    height: 60,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              _vm.partner?.name ?? "",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xFF28A745),
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
//                                          _buildDialogEditPartner(context);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PosPartnerAddEditPage(
                                                              _vm.partner))).then(
                                                  (value) {
                                                if (value != null) {}
                                              });
                                            },
                                            child: Row(
                                              children: <Widget>[
                                                const Icon(
                                                  Icons.edit,
                                                  color:
                                                      const Color(0xFF28A745),
                                                  size: 20,
                                                ),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                Text(
                                                  S.current.edit,
                                                  style: const TextStyle(
                                                      color: Color(0xFF28A745)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: RichText(
                                              text:
                                                  TextSpan(children: <TextSpan>[
                                                TextSpan(
                                                  text: "${S.current.phone}: ",
                                                  style: const TextStyle(
                                                      color: Color(0xFF2C333A),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                TextSpan(
                                                  text:
                                                      _vm.partner?.phone ?? "",
                                                  style: const TextStyle(
                                                      color: Color(0xFF484D54),
                                                      fontSize: 15),
                                                ),
                                              ]),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: RichText(
                                              text: TextSpan(
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text:
                                                        "${S.current.posOfSale_address}: ",
                                                    style: const TextStyle(
                                                        color:
                                                            Color(0xFF2C333A),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  TextSpan(
                                                    text: _vm.partner?.street ??
                                                        "",
                                                    style: const TextStyle(
                                                        color:
                                                            Color(0xFF484D54),
                                                        fontSize: 15),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: RichText(
                                              text:
                                                  TextSpan(children: <TextSpan>[
                                                const TextSpan(
                                                  text: "Email: ",
                                                  style: TextStyle(
                                                      color: const Color(
                                                          0xFF2C333A),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                TextSpan(
                                                  text:
                                                      _vm.partner?.email ?? "",
                                                  style: const TextStyle(
                                                      color: Color(0xFF484D54),
                                                      fontSize: 15),
                                                ),
                                              ]),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          RichText(
                                            text: TextSpan(children: <TextSpan>[
                                              TextSpan(
                                                text:
                                                    "${S.current.posOfSale_barCode}: ",
                                                style: TextStyle(
                                                    color:
                                                        const Color(0xFF2C333A),
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              TextSpan(
                                                text: _vm.partner?.barcode ??
                                                    "N/A",
                                                style: const TextStyle(
                                                    color: Color(0xFF484D54),
                                                    fontSize: 15),
                                              ),
                                            ]),
                                          ),
                                          SizedBox(
                                            width: 14,
                                            child: Center(
                                              child: Container(
                                                height: 10,
                                                width: 1,
                                                color: const Color(0xFF2C333A),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: RichText(
                                              text:
                                                  TextSpan(children: <TextSpan>[
                                                TextSpan(
                                                  text:
                                                      "${S.current.posOfSale_taxCode}: ",
                                                  style: const TextStyle(
                                                      color: Color(0xFF2C333A),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                TextSpan(
                                                  text: _vm.partner?.taxCode ??
                                                      "",
                                                  style: const TextStyle(
                                                      color: Color(0xFF484D54),
                                                      fontSize: 15),
                                                ),
                                              ]),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          right: 6,
                          bottom: 2,
                          child: Row(
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  if (widget.partner != _vm.partner &&
                                      widget.partner?.name != null) {
                                    _vm.partner = widget.partner;
                                  } else {
                                    _vm.partner = null;
                                  }
                                },
                                child: Container(
                                  width: 60,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFF0F1F3),
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Center(
                                    child: Text(
                                      S.current.close,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: _vm.partner == null ? 0 : 175),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    color: Colors.white,
                    child: ListView.separated(
                        separatorBuilder: (context, index) => const Divider(
                              color: Color(0xFFEBEDEF),
                              height: 2,
                            ),
                        padding: const EdgeInsets.only(top: 1),
                        itemCount: _vm.partners?.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          return _buildItemPartner(_vm.partners[index]);
                        }),
                  ),
                ),
              ],
            ),
//            floatingActionButton: Visibility(
//              visible: _vm.partner == null ? false : true,
//              child: FloatingActionButton(
//                backgroundColor: Color(0xFF28A745),
//                onPressed: () {
//                  _vm.partner = null;
//                },
//                child: Icon(Icons.arrow_upward),
//              ),
//            ),
          );
        });
  }

//  void _buildDialogEditPartner(
//    BuildContext context,
//  ) {
//    showDialog(
//      barrierDismissible: false,
//      context: context,
//      builder: (context) {
//        return AlertDialog(
//          titlePadding: const EdgeInsets.only(bottom: 12, top: 12),
//          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
//          shape: OutlineInputBorder(
//            borderRadius: BorderRadius.circular(8),
//            borderSide: const BorderSide(
//              width: 0,
//            ),
//          ),
//          title: Text(
//            "Chỉnh sửa sản phẩm",
//            style: TextStyle(color: Colors.red),
//            textAlign: TextAlign.center,
//          ),
//          content: PosPartnerAddEditPage(_vm.partner),
//          actions: <Widget>[
//            FlatButton(
//              child: const Text("HỦY BỎ"),
//              onPressed: () {
//                Navigator.pop(context);
//              },
//            ),
//            FlatButton(
//              child: const Text("XÁC NHẬN"),
//              onPressed: () {},
//            ),
//          ],
//        );
//      },
//    );
//  }

  Widget buildAppBar(BuildContext context) {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.only(left: 0, right: 0, top: 7, bottom: 7),
        child: _isSearchEnable
            ? AppbarSearchWidget(
                autoFocus: true,
                keyword: _vm.keyword,
                onTextChange: (text) async {
                  _vm.setKeyword(text);
                },
              )
            : Text(S.current.posOfSale_partners),
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () async {
            setState(() {
              _isSearchEnable = !_isSearchEnable;
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PosPartnerAddEditPage(null)),
            ).then((value) {
              _vm.getPartners();
            });
          },
        )
      ],
    );
  }

  Widget _buildItemPartner(Partners item) {
    const Widget sizedBox = SizedBox(
      height: 8,
    );
    return InkWell(
      onTap: () {
        _vm.partner = item;
//        Navigator.pop(context, item);
      },
      child: Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(1),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          item.name,
                          style: const TextStyle(
                              fontSize: 16,
                              color: const Color(0xFF484D54),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
//                        InkWell(
//                          onTap: () {
//                            Navigator.push(
//                                context,
//                                new MaterialPageRoute(
//                                    builder: (context) =>
//                                        new PosPartnerInfoPage(item)));
//                          },
//                          child: Row(
//                            children: <Widget>[
//                              Icon(
//                                Icons.info,
//                                color: Colors.green,
//                                size: 20,
//                              ),
//                              Text("Chi tiết")
//                            ],
//                          ),
//                        )
                    ],
                  ),
                  sizedBox,
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          item.street == null || item.street == ""
                              ? ""
                              : item.street,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(4)),
              child: item.id == widget.partner?.id
                  ? IconButton(
                      icon: const Icon(
                        Icons.check,
                        color: Color(0xFF28A745),
                      ),
                      onPressed: () {})
                  : IconButton(
                      icon: const Icon(
                        Icons.add,
                        color: Color(0xFF28A745),
                      ),
                      onPressed: () {
                        Navigator.pop(context, item);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
