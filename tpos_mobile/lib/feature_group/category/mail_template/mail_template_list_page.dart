import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/template_ui/empty_data_widget.dart';
import 'package:tpos_mobile/app_core/template_ui/reload_list_page.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';
import 'mail_template_add_edit_page.dart';
import 'mail_template_list_viewmodel.dart';

class MailTemplateListPage extends StatefulWidget {
  const MailTemplateListPage({Key key}) : super(key: key);

  @override
  _MailTemplateListPageState createState() => _MailTemplateListPageState();
}

class _MailTemplateListPageState extends State<MailTemplateListPage> {
  final _viewModel = locator<MailTemplateListViewModel>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget buildAppBar() {
    return AppBar(
      title: const Padding(
        padding: EdgeInsets.only(left: 0, right: 0, top: 7, bottom: 7),
        child: Text("Mail Template"),
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MailTemplateAddEditPage()),
            ).then((value) {
              _viewModel.loadMailTemplates();
            });
          },
        ),
      ],
    );
  }

  Key refreshIndicatorKey = const Key("refreshIndicator");

  @override
  Widget build(BuildContext context) {
    return ViewBase<MailTemplateListViewModel>(
      model: _viewModel,
      builder: (context, model, sizingInformation) => Scaffold(
        backgroundColor: Colors.grey.shade200,
        key: _scaffoldKey,
        appBar: buildAppBar(),
        body: ReloadListPage(
          vm: _viewModel,
          onPressed: () {
            _viewModel.loadMailTemplates();
          },
          child: _viewModel.mailTemplates != null &&
                  _viewModel.mailTemplates.isNotEmpty
              ? _showListInvoice()
              : EmptyData(
                  onPressed: () {
                    _viewModel.loadMailTemplates();
                  },
                ),
        ),
      ),
    );
  }

  Widget _showListInvoice() {
    return Scrollbar(
      child: Container(
        child: RefreshIndicator(
          key: refreshIndicatorKey,
          onRefresh: () async {
            _viewModel.loadMailTemplates();
          },
          child: ListView.builder(
              itemCount: _viewModel.mailTemplates.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  background: Container(
                    margin: const EdgeInsets.only(
                        top: 2.5, bottom: 2.5, left: 5, right: 5),
                    padding: const EdgeInsets.only(top: 2.5, bottom: 2.5),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            S.current.deleteALine,
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Icon(
                          Icons.delete_forever,
                          color: Colors.white,
                          size: 30,
                        )
                      ],
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  key: Key("${_viewModel.mailTemplates}"),
                  confirmDismiss: (direction) async {
                    final dialogResult = await showQuestion(
                        context: context,
                        title: S.current.delete,
                        message:
                            "${S.current.mailTemplate_ConfirmDelete} ${_viewModel.mailTemplates[index].name ?? ""}");

                    if (dialogResult == DialogResultType.YES) {
                      final result = await _viewModel.deleteMailTemplate(
                          _viewModel.mailTemplates[index].id);
                      if (result) {
                        _viewModel.removeMailTemplate(index);
                      }
                      return result;
                    } else {
                      return false;
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                    child: _showItem(_viewModel.mailTemplates[index], index),
                  ),
                );
              }),
        ),
      ),
    );
  }

  Widget _showItem(MailTemplate item, int index) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(3.0)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey[300],
                offset: const Offset(0, 2),
                blurRadius: 3)
          ]),
      child: Column(
        children: <Widget>[
          ListTile(
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MailTemplateAddEditPage(
                          mailTemplate: item,
                          function: (value) {
                            setState(() {
                              _viewModel.mailTemplates[index] = value;
                            });
                          },
                        )),
              );
            },
            title: Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      item?.name ?? "",
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "${item?.typeId ?? 0 ?? ""}",
                      textAlign: TextAlign.end,
                    ),
                  ),
//                  InkWell(
//                    child: Container(
//                      child: Padding(
//                        padding: const EdgeInsets.only(left: 10),
//                        child: Icon(
//                          Icons.more_horiz,
//                          color: Colors.grey,
//                        ),
//                      ),
//                    ),
//                    onTap: () {},
//                  ),
                ],
              ),
            ),
            subtitle: Text(
              "${item?.model ?? ""}",
              style: const TextStyle(color: Colors.black),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    _viewModel.loadMailTemplates();
    super.initState();
  }
}
