import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';
import 'package:tpos_mobile/app_core/ui_base/ui_vm_base.dart';
import 'package:tpos_mobile/src/tpos_apis/models/partner_category.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import 'partner_category_page.dart';
import 'viewmodel/partner_category_add_edit_viewmodel.dart';

class PartnerCategoryAddEditPage extends StatefulWidget {
  const PartnerCategoryAddEditPage(
      {this.closeWhenDone, this.productCategoryId, this.onEdited});
  final int productCategoryId;
  final bool closeWhenDone;
  final Function(PartnerCategory) onEdited;

  @override
  _PartnerCategoryAddEditPageState createState() =>
      _PartnerCategoryAddEditPageState();
}

class _PartnerCategoryAddEditPageState
    extends State<PartnerCategoryAddEditPage> {
  _PartnerCategoryAddEditPageState();

  PartnerCategoryAddEditViewModel viewModel = PartnerCategoryAddEditViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _key = GlobalKey();
  bool _validate = false;

  final TextEditingController _nameTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return UIViewModelBase(
      viewModel: viewModel,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: widget.productCategoryId == null
              ? Text(
                  "${S.current.add} ${S.current.customerGroups.toLowerCase()}")
              : Text(
                  "${S.current.edit} ${S.current.customerGroups.toLowerCase()}"),
          actions: <Widget>[
            FlatButton.icon(
              label: Text(S.current.save),
              textColor: Colors.white,
              icon: const Icon(Icons.check),
              onPressed: () async {
                viewModel.partnerCategory.name =
                    _nameTextEditingController.text.trim();
                _sendToServer();
                if (_nameTextEditingController.text != "") {
                  await viewModel.save();
                  if (widget.closeWhenDone == true) {
                    Navigator.pop(context, viewModel.partnerCategory);
                  }
                }
                if (widget.onEdited != null)
                  widget.onEdited(viewModel.partnerCategory);
              },
            ),
          ],
        ),
        body: Container(color: Colors.grey.shade200, child: _showBody()),
      ),
    );
  }

  Widget _showBody() {
    return StreamBuilder<PartnerCategory>(
      stream: viewModel.partnerCategoryStream,
      initialData: viewModel.partnerCategory,
      builder: (context, snapshot) {
        return Form(
          key: _key,
          autovalidate: _validate,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _nameTextEditingController,
                  autofocus: false,
                  onEditingComplete: () {},
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(5),
                    icon: const Icon(Icons.supervised_user_circle),
                    labelText: S.current.groupName,
                  ),
                  validator: validateName,
                ),
                const Divider(),
                // Nhóm  cha
                ListTile(
                  title: Text(S.current.parentGroup),
                  subtitle: Text(viewModel.partnerCategory?.parent?.name ??
                      S.current.chooseParentGroup),
                  trailing: const Icon(Icons.keyboard_arrow_right),
                  onTap: () async {
                    final PartnerCategory result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const PartnerCategoryPage();
                        },
                      ),
                    );
                    if (result != null) {
                      viewModel.selectPartnerCategoryCommand(result);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  StreamSubscription notifySubcrible;
  @override
  void didChangeDependencies() {
    notifySubcrible = viewModel.notifyPropertyChangedController.listen((name) {
      setState(() {});
    });

    viewModel.dialogMessageController.listen((message) {
      registerDialogToView(context, message,
          scaffState: _scaffoldKey.currentState);
    });

    super.didChangeDependencies();
  }

  String validateName(String value) {
    if (value.isEmpty) {
      return S.current.mailTemplate_GroupNameCannotBeEmpty;
    }
    return null;
  }

  void _sendToServer() {
    if (_key.currentState.validate()) {
      // No any error in validation
      _key.currentState.save();
    } else {
      // validation error
      setState(() {
        _validate = true;
      });
    }
  }

  @override
  void initState() {
    viewModel.partnerCategory.id = widget.productCategoryId;
    viewModel.init();
    viewModel.partnerCategoryStream.listen((productCategory) {
      _nameTextEditingController.text = viewModel.partnerCategory.name;
    });

    super.initState();
  }

  @override
  void dispose() {
    viewModel.dispose();
    notifySubcrible.cancel();
    super.dispose();
  }
}
