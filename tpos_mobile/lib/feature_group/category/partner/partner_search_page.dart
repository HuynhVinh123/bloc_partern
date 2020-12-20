import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';
import 'package:tpos_mobile/widgets/custom_widget.dart';
import 'package:tpos_mobile/widgets/listview_data_error_info_widget.dart';

import 'partner_page.dart';
import 'partner_info_page.dart';
import 'viewmodel/partner_search_viewmodel.dart';

class PartnerSearchPage extends StatefulWidget {
  const PartnerSearchPage(
      {this.closeWhenDone = true,
      this.isSearchMode = true,
      this.partnerCallBack,
      this.isCustomer = true,
      this.isSupplier = false,
      this.keyWord = ""});
  final bool isCustomer;
  final bool isSupplier;
  final bool closeWhenDone;
  final bool isSearchMode;
  final String keyWord;
  final Function(Partner) partnerCallBack;

  @override
  _PartnerSearchPageState createState() => _PartnerSearchPageState(
      closeWhenDone: closeWhenDone,
      isSearchMode: isSearchMode,
      partnerCallBack: partnerCallBack);
}

class _PartnerSearchPageState extends State<PartnerSearchPage> {
  _PartnerSearchPageState(
      {this.closeWhenDone = true,
      this.isSearchMode = true,
      this.partnerCallBack});
  bool closeWhenDone;
  bool isSearchMode;
  Function(Partner) partnerCallBack;

  PartnerSearchViewModel partnerSearchViewModel = PartnerSearchViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    partnerSearchViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(context),
      body: ViewBaseWidget(
        isBusyStream: partnerSearchViewModel.isBusyController,
        child: Column(
          children: <Widget>[
//            _showFilterPanel(),
            Expanded(child: _showListPartner()),
          ],
        ),
      ),
    );
  }

  Widget _showListPartner() {
    return StreamBuilder<List<Partner>>(
      stream: partnerSearchViewModel.partnersStream,
      builder: (ctx, snapshot) {
        if (snapshot.hasError) {
          return ListViewDataErrorInfoWidget(
            errorMessage: "Đã xảy ra lỗi!. \n" + snapshot.error.toString(),
          );
        }

        if (snapshot.data == null) {
          return const Center(
            child: Text(""),
          );
        }

        return Scrollbar(
          child: ListView.separated(
//              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            itemCount: snapshot.data.length ?? 0 + 1,
            separatorBuilder: (ctx, index) {
              return const Divider(
                height: 1,
              );
            },
            itemBuilder: (context, position) {
              return Dismissible(
                direction: DismissDirection.endToStart,
                key: ObjectKey("${snapshot.data[position]}"),
                background: Container(
                  color: Colors.green,
                  child: Row(
                    children: const <Widget>[
                      Expanded(
                        child: Text(
                          "Xóa dòng này?",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Icon(
                        Icons.delete_forever,
                        color: Colors.red,
                        size: 40,
                      )
                    ],
                  ),
                ),
                confirmDismiss: (direction) async {
                  final dialogResult = await showQuestion(
                      context: context,
                      title: "Xác nhận xóa",
                      message:
                          "Bạn có muốn xóa khách hàng ${snapshot.data[position].name ?? ""}");

                  if (dialogResult == OldDialogResult.Yes) {
                    final result = await partnerSearchViewModel
                        .deletePartner(snapshot.data[position].id);
                    if (result) {
                      snapshot.data.removeAt(position);
                    }
                    return result;
                  } else {
                    return false;
                  }
                },
                onDismissed: (direction) async {},
                child: ListTile(
                  contentPadding: const EdgeInsets.only(
                      left: 12, right: 12, top: 5, bottom: 5),
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFFE9F6EC),
                    child: Text(snapshot.data[position].name.substring(0, 1)),
                  ),
                  title: Text(snapshot.data[position].name,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          color: Color(0xFF2C333A),
                          fontWeight: FontWeight.w600)),
                  subtitle: Column(
                    children: <Widget>[
                      Row(
                        children: [
                          Text(
                            "[${snapshot.data[position].ref ?? ""}]",
                            style: const TextStyle(
                              color: Color(0xFF929DAA),
                            ),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          const Icon(
                            Icons.phone,
                            color: Color(0xFF929DAA),
                            size: 13,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Flexible(
                            child: Text(
                              snapshot.data[position].phone ?? "<Chưa có sđt>",
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                color: Color(0xFF929DAA),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            FontAwesomeIcons.mapMarkerAlt,
                            size: 13,
                            color: Color(0xFF929DAA),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Flexible(
                            child: Text(
                              snapshot.data[position].street ??
                                  "<Chưa có địa chỉ>",
                              style: const TextStyle(
                                color: Color(0xFF929DAA),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        snapshot.data[position].facebook != null &&
                                snapshot.data[position].facebook != ""
                            ? snapshot.data[position].facebook
                            : "<Chưa có Facebook>",
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          color: Color(0xFF929DAA),
                        ),
                      ),
//                        Text(snapshot.data[position].statusText ?? ""),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  onTap: () async {
                    if (isSearchMode) {
                      if (partnerCallBack != null)
                        partnerCallBack(snapshot.data[position]);
                      if (closeWhenDone) {
                        Navigator.pop<Partner>(
                            context, snapshot.data[position]);
                      }
                    } else {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PartnerInfoPage(
                                  partnerId: snapshot.data[position].id,
                                  onEditPartner: (value) {
                                    snapshot.data[position] = value;
                                  },
                                )),
                      );
                    }
                  },
                ),
              );
            },
          ),
        );
      },
    );
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
                          partnerSearchViewModel.keywordChangedCommand(value);
                        },
                        autofocus: isSearchMode,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(0),
                            isDense: true,
                            hintText: "Tìm kiếm",
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
                partnerSearchViewModel.keywordChangedCommand("");
              },
            ),
          )
        ],
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF858F9B),
          ),
          onPressed: () {
            Navigator.pop(context);
          }),
      title: Padding(
          padding: const EdgeInsets.only(left: 0, right: 0, top: 8, bottom: 8),
          child: _buildSearch()),
      actions: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.add_circle,
            color: Color(0xFF28A745),
            size: 28,
          ),
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => PartnerAddEditPage(
                  closeWhenSaved: true,
                  isSupplier: widget.isSupplier,
                  isCustomer: widget.isCustomer,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

//
  @override
  void initState() {
    partnerSearchViewModel.init(
        isCustomer: widget.isCustomer,
        isSupplier: widget.isSupplier,
        isSearchMode: widget.isSearchMode);
    partnerSearchViewModel.keywordChangedCommand(widget.keyWord);
    partnerSearchViewModel.dialogMessageController.listen((data) {
      registerDialogToView(context, data,
          scaffState: _scaffoldKey.currentState);
    });
    partnerSearchViewModel.notifyPropertyChangedController.listen((f) {
      setState(() {});
    });
    super.initState();
  }
}
