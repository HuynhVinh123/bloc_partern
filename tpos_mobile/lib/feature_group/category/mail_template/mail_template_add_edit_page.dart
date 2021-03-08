import 'package:flutter/material.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import 'mail_template_add_edit_viewmodel.dart';

class MailTemplateAddEditPage extends StatefulWidget {
  const MailTemplateAddEditPage({this.mailTemplate, this.function});

  final MailTemplate mailTemplate;
  final Function function;

  @override
  _MailTemplateAddEditPageState createState() =>
      _MailTemplateAddEditPageState();
}

class _MailTemplateAddEditPageState extends State<MailTemplateAddEditPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      const GlobalObjectKey<ScaffoldState>('UserAddEditPage');
  final _formKey = GlobalKey<FormState>();
  final _vm = locator<MailTemplateAddEditViewModel>();

  FocusNode _typeFocusNode;
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
    return WillPopScope(
      onWillPop: () async {
        if (_vm.isReload) {
          widget.function(_vm.mailTemplate);
        }
        return true;
      },
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: widget.mailTemplate == null
                ? Text("${S.current.add} mail template")
                : Text("${S.current.edit} mail template"),
            actions: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.save,
                  color: Colors.white,
                ),
                onPressed: () {
                  _vm.mailTemplate?.name =
                      descriptionTextEditingController.text.trim();
                  _vm.mailTemplate?.subject =
                      titleTextEditingController.text.trim();

                  _vm.mailTemplate?.model =
                      modelTextEditingController.text.trim();
                  if (_vm.selectedMailType == "Mail") {
                    _vm.mailTemplate?.bodyHtml =
                        contentTextEditingController.text.trim();
                  } else {
                    _vm.mailTemplate?.bodyPlain =
                        contentTextEditingController.text.trim();
                  }
                  _save(context);
                },
              )
            ],
          ),
          body: ViewBase<MailTemplateAddEditViewModel>(
              model: _vm,
              builder: (context, model, _) {
                return _buildForm();
              })),
    );
  }

  Widget _buildForm() {
    const sizeBox = SizedBox(
      height: 10,
    );
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      child: Material(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4.0), topRight: Radius.circular(4.0)),
        shadowColor: Colors.grey[500],
        elevation: 4.0,
        child: Form(
          autovalidateMode: AutovalidateMode.always,
          key: _formKey,
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 10, right: 10),
                child: ListView(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        // Loại
                        Text(
                          "${S.current.type}: ",
                        ),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              style: const TextStyle(color: Colors.black),
                              value: _vm.selectedMailType,
                              onChanged: (value) {
                                if (value == "Mail") {
                                  contentTextEditingController?.text =
                                      _vm.mailTemplate.bodyHtml;
                                } else {
                                  contentTextEditingController?.text =
                                      _vm.mailTemplate.bodyPlain;
                                }
                                _vm.setCommandMailType(value);
                              },
                              items: _vm.mailTemplateTypes
                                  ?.map(
                                    (f) => DropdownMenuItem<String>(
                                      child: Text(
                                        f.text ?? "",
                                        style: const TextStyle(
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
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.all(10),
                        labelText: S.current.description,
                        suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              descriptionTextEditingController.clear();
                            }),
                      ),
                    ),
                    sizeBox,
                    TextFormField(
                      minLines: 2,
                      maxLines: null,
                      controller: titleTextEditingController,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_contentFocusNode);
                      },
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.all(10),
                        labelText: S.current.title,
                        suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
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
                                color: const Color(0xff23ad44),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                onPressed: () {
                                  print("on tap $f['name]");
                                  titleTextEditingController.text += f["value"];
                                },
                                child: Text(
                                  f["name"],
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal),
                                ));
                          }),
                        ]),
                    sizeBox,
                    TextFormField(
                      minLines: 7,
                      maxLines: null,
                      controller: contentTextEditingController,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_modelFocusNode);
                      },
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.all(10),
                        labelText: S.current.content,
                        suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
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
                                color: const Color(0xff23b7e5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                onPressed: () {
                                  print("on tap $f['name]");
                                  contentTextEditingController.text +=
                                      f["value"];
                                },
                                child: Text(
                                  f["name"],
                                  style: const TextStyle(
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
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.all(10),
                        labelText: 'Model',
                        suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
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

  Future<void> _save(BuildContext context) async {
    final result = await _vm.save();
    if (widget.mailTemplate?.id == null && result) {
      Navigator.pop(context);
    }
  }

  Future<void> loadData() async {
    if (widget.mailTemplate != null) {
      descriptionTextEditingController?.text = _vm.mailTemplate.name;
      titleTextEditingController?.text = _vm.mailTemplate.subject;
      modelTextEditingController?.text = _vm.mailTemplate.model;
      if (_vm.mailTemplate.typeId == "Mail") {
        contentTextEditingController?.text = _vm.mailTemplate.bodyHtml;
      } else {
        contentTextEditingController?.text = _vm.mailTemplate.bodyPlain;
      }
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
    typeTextEditingController = TextEditingController();
    descriptionTextEditingController = TextEditingController();
    titleTextEditingController = TextEditingController();
    contentTextEditingController = TextEditingController();
    modelTextEditingController = TextEditingController();

    _typeFocusNode = FocusNode();
    _titleFocusNode = FocusNode();
    _contentFocusNode = FocusNode();
    _modelFocusNode = FocusNode();

    loadData();
  }
}
