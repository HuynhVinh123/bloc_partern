import 'package:flutter/material.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/src/tpos_apis/models/mail_template.dart';

import 'mail_template_add_edit_viewmodel.dart';

class MailTemplateAddEditPage extends StatefulWidget {
  MailTemplateAddEditPage({this.mailTemplate});

  final MailTemplate mailTemplate;

  @override
  _MailTemplateAddEditPageState createState() =>
      _MailTemplateAddEditPageState();
}

class _MailTemplateAddEditPageState extends State<MailTemplateAddEditPage> {
  GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalObjectKey<ScaffoldState>('UserAddEditPage');
  final _formKey = GlobalKey<FormState>();
  var _vm = locator<MailTemplateAddEditViewModel>();

  FocusNode _typeFocusNode;
  FocusNode _descriptionFocusNode;
  FocusNode _titleFocusNode;
  FocusNode _contentFocusNode;
  FocusNode _modelFocusNode;

  TextEditingController typeTextEditingController;
  TextEditingController descriptionTextEditingController;
  TextEditingController titleTextEditingController;
  TextEditingController contentTextEditingController;
  TextEditingController modelTextEditingController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: widget.mailTemplate == null
              ? Text("Thêm mail template")
              : Text("Sửa mail template"),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.save,
                color: Colors.white,
              ),
              onPressed: () {
                _vm.mailTemplate?.name =
                    descriptionTextEditingController.text.trim();
                _vm.mailTemplate?.bodyPlain =
                    titleTextEditingController.text.trim();
                _vm.mailTemplate?.subject =
                    contentTextEditingController.text.trim();
                _vm.mailTemplate?.model =
                    modelTextEditingController.text.trim();
                _save(context);
              },
            )
          ],
        ),
        body: ViewBase<MailTemplateAddEditViewModel>(
            model: _vm,
            builder: (context, model, _) {
              return _buildForm();
            }));
  }

  Widget _buildForm() {
    var sizeBox = SizedBox(
      height: 10,
    );
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4.0), topRight: Radius.circular(4.0)),
        shadowColor: Colors.grey[500],
        elevation: 4.0,
        child: Form(
          autovalidate: _validate,
          key: _formKey,
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 10, right: 10),
                child: ListView(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "Loại: ",
                        ),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: new DropdownButton<String>(
                              style: TextStyle(color: Colors.black),
                              value: _vm.selectedMailType,
                              onChanged: (value) {
                                _vm.setCommandMailType(value);
                              },
                              items: _vm.mailTemplateTypes
                                  ?.map(
                                    (f) => DropdownMenuItem<String>(
                                      child: Text(
                                        "${f.text}",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.blue),
                                      ),
                                      value: f.value,
                                    ),
                                  )
                                  ?.toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    sizeBox,
                    TextFormField(
                      controller: descriptionTextEditingController,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_titleFocusNode);
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(10),
                        labelText: 'Mô tả',
                        suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              descriptionTextEditingController.clear();
                            }),
                      ),
                    ),
                    sizeBox,
                    TextFormField(
                      maxLines: 2,
                      controller: titleTextEditingController,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_contentFocusNode);
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(10),
                        labelText: 'Tiêu đề',
                        suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              titleTextEditingController.clear();
                            }),
                      ),
                    ),
                    sizeBox,
                    Wrap(
                        alignment: WrapAlignment.end,
                        spacing: 5.0,
                        runSpacing: 0,
                        runAlignment: WrapAlignment.start,
                        children: [
                          ..._vm.headers.map((f) {
                            return MaterialButton(
                                color: Color(0xff23ad44),
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(18.0),
                                ),
                                onPressed: () {
                                  print("on tap $f['name]");
                                  titleTextEditingController.text += f["value"];
                                },
                                child: Text(
                                  f["name"],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal),
                                ));
                          }),
                        ]),
                    sizeBox,
                    TextFormField(
                      maxLines: 7,
                      controller: contentTextEditingController,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_modelFocusNode);
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(10),
                        labelText: 'Nội dung',
                        suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              contentTextEditingController.clear();
                            }),
                      ),
                    ),
                    sizeBox,
                    Wrap(
                        spacing: 5.0,
                        runSpacing: 0,
                        runAlignment: WrapAlignment.start,
                        children: [
                          ..._vm.contents.map((f) {
                            return MaterialButton(
                                color: Color(0xff23b7e5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(18.0),
                                ),
                                onPressed: () {
                                  print("on tap $f['name]");
                                  contentTextEditingController.text +=
                                      f["value"];
                                },
                                child: Text(
                                  f["name"],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal),
                                ));
                          }),
                        ]),
                    sizeBox,
                    TextFormField(
                      controller: modelTextEditingController,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_typeFocusNode);
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(10),
                        labelText: 'Model',
                        suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              modelTextEditingController.clear();
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save(BuildContext context) async {
    var result = await _vm.save();
    if (widget.mailTemplate?.id == null && result) {
      Navigator.pop(context);
    }
  }

  bool _validate = false;

  Future<void> loadData() async {
    if (widget.mailTemplate != null) {
      descriptionTextEditingController?.text = _vm.mailTemplate.name;
      contentTextEditingController?.text = _vm.mailTemplate.subject;
      titleTextEditingController?.text = _vm.mailTemplate.bodyPlain;
      modelTextEditingController?.text = _vm.mailTemplate.model;
    }
  }

  @override
  void initState() {
    super.initState();
    _vm.initCommand();

    if (widget.mailTemplate != null) {
      _vm.mailTemplate = widget.mailTemplate;
    }

    _vm.selectedMailType = _vm.mailTemplate.typeId;
    typeTextEditingController = new TextEditingController();
    descriptionTextEditingController = new TextEditingController();
    titleTextEditingController = new TextEditingController();
    contentTextEditingController = new TextEditingController();
    modelTextEditingController = new TextEditingController();

    _typeFocusNode = new FocusNode();
    _descriptionFocusNode = new FocusNode();
    _titleFocusNode = new FocusNode();
    _contentFocusNode = new FocusNode();
    _modelFocusNode = new FocusNode();

    loadData();
  }
}
