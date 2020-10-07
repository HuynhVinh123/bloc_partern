import 'package:flutter/material.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/partner_add_edit_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/partner_info_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/partner_search_viewmodel.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';

import 'package:tpos_mobile/src/tpos_apis/tpos_models.dart';

import 'package:tpos_mobile/widgets/custom_widget.dart';
import 'package:tpos_mobile/widgets/listview_data_error_info_widget.dart';

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
                    backgroundColor: Colors.grey.shade200,
                    child: Text(snapshot.data[position].name.substring(0, 1)),
                  ),
                  title: Text(snapshot.data[position].name,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.orange, fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    children: <Widget>[
                      Text(
                        snapshot.data[position].phone ?? "<Chưa có sđt>",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ),
                      Text(snapshot.data[position].street ??
                          "<Chưa có địa chỉ>"),
                      Text(
                        snapshot.data[position].facebook != null &&
                                snapshot.data[position].facebook != ""
                            ? snapshot.data[position].facebook
                            : "<Chưa có Facebook>",
                        textAlign: TextAlign.start,
                        style: const TextStyle(),
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

  Widget buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          }),
      title: Padding(
        padding: const EdgeInsets.only(left: 0, right: 0, top: 8, bottom: 8),
        child: AppbarSearchWidget(
          keyword: partnerSearchViewModel.keyword,
          autoFocus: isSearchMode,
          onTextChange: (text) {
            partnerSearchViewModel.keywordChangedCommand(text);
          },
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => PartnerAddEditPage(
                  closeWhenDone: true,
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
