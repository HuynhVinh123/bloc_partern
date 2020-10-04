import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tpos_mobile/app_core/template_ui/empty_data_widget.dart';
import 'package:tpos_mobile/app_core/template_ui/reload_list_page.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/mail_template.dart';
import 'mail_template_add_edit_page.dart';
import 'mail_template_list_viewmodel.dart';

class MailTemplateListPage extends StatefulWidget {
  const MailTemplateListPage({Key key}) : super(key: key);

  @override
  _MailTemplateListPageState createState() => _MailTemplateListPageState();
}

class _MailTemplateListPageState extends State<MailTemplateListPage> {
  var _viewModel = locator<MailTemplateListViewModel>();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget buildAppBar() {
    return new AppBar(
      title: Padding(
        padding: const EdgeInsets.only(left: 0, right: 0, top: 7, bottom: 7),
        child: Text("Mail Template"),
      ),
      actions: <Widget>[
        new IconButton(
          icon: new Icon(Icons.add),
          onPressed: () async {
            Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new MailTemplateAddEditPage()),
            ).then((value) {
              _viewModel.loadMailTemplates();
            });
          },
        ),
      ],
    );
  }

  Key refreshIndicatorKey = new Key("refreshIndicator");

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
                    margin: EdgeInsets.only(
                        top: 2.5, bottom: 2.5, left: 5, right: 5),
                    padding: EdgeInsets.only(top: 2.5, bottom: 2.5),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "Xóa dòng này?",
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Icon(
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
                    var dialogResult = await showQuestion(
                        context: context,
                        title: "Xác nhận xóa",
                        message:
                            "Bạn có muốn xóa hóa đơn ${_viewModel.mailTemplates[index].name ?? ""}");

                    if (dialogResult == DialogResultType.YES) {
                      var result = await _viewModel.deleteMailTemplate(
                          _viewModel.mailTemplates[index].id);
                      if (result) _viewModel.removeMailTemplate(index);
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
          borderRadius: BorderRadius.all(Radius.circular(3.0)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey[300], offset: Offset(0, 2), blurRadius: 3)
          ]),
      child: new Column(
        children: <Widget>[
          new ListTile(
            onTap: () async {
              Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new MailTemplateAddEditPage(
                          mailTemplate: item,
                        )),
              );
            },
            title: Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 10),
              child: Row(
                children: <Widget>[
                  new Expanded(
                    child: new Text(
                      item?.name ?? "",
                      textAlign: TextAlign.start,
                    ),
                  ),
                  new Expanded(
                    child: new Text(
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
            subtitle: new Text(
              "${item?.model ?? ""}",
              style: TextStyle(color: Colors.black),
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
