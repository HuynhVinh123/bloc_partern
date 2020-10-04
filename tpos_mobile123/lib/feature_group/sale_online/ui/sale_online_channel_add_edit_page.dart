import 'package:flutter/material.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/sale_online_channel_add_edit_viewmodel.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';


import 'package:tpos_mobile/widgets/listview_data_error_info_widget.dart';
import 'package:tpos_mobile/widgets/view_base_widget.dart';

class SaleOnlineChannelAddEditPage extends StatefulWidget {
  const SaleOnlineChannelAddEditPage({this.crmTeam});
  static const routeName = "app/salechannel/list";
  final CRMTeam crmTeam;

  @override
  _SaleOnlineChannelAddEditPageState createState() =>
      _SaleOnlineChannelAddEditPageState(crmTeam: crmTeam);
}

class _SaleOnlineChannelAddEditPageState
    extends State<SaleOnlineChannelAddEditPage> {
  _SaleOnlineChannelAddEditPageState({CRMTeam crmTeam}) {
    _crmTeam = crmTeam;
  }
  final GlobalKey<FormState> _key = GlobalKey();
  bool _validate = false;
  CRMTeam _crmTeam;

  final SaleOnlineChannelAddEditViewModel _viewModel =
      SaleOnlineChannelAddEditViewModel();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController nameTextController = TextEditingController();
  TextEditingController shopIdTextController = TextEditingController();
  TextEditingController secretKeyTextController = TextEditingController();

  @override
  void initState() {
    _viewModel.initCommand(crmTeam: _crmTeam);
    super.initState();
    nameTextController.text = _crmTeam?.name;
    shopIdTextController.text = _crmTeam?.shopId;
    secretKeyTextController.text = _crmTeam?.zaloSecretKey;
  }

  @override
  void didChangeDependencies() {
    _viewModel.notifyPropertyChangedController.listen((name) {
      setState(() {});
    });

    _viewModel.dialogMessageController.listen((message) {
      registerDialogToView(context, message,
          scaffState: _scaffoldKey.currentState);
    });

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewBaseWidget(
      isBusyStream: _viewModel.isBusyController,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(_viewModel.channel.id == null
              ? "Tạo kênh bán hàng mới"
              : "Sửa kênh bán hàng"),
        ),
        body: _showBody(),
      ),
    );
  }

  Widget _showBody() {
    return StreamBuilder<CRMTeam>(
        stream: _viewModel.channelStream,
        initialData: _viewModel.channel,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ListViewDataErrorInfoWidget(
              errorMessage: snapshot.error,
            );
          }
          return _showItem(snapshot.data);
        });
  }

  Widget _showItem(CRMTeam item) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _key,
        autovalidate: _validate,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    value: _viewModel.channel.active ?? false,
                    title: const Text('Active'),
                    onChanged: (bool value) {
                      _viewModel.isCheckActive(value);
                    },
                  ),
                ),
                const Text(
                  "Loại: ",
                  style: TextStyle(fontSize: 16),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _viewModel.channel.type,
                    onChanged: (String newValue) {
                      setState(() {
                        switch (newValue) {
                          case "Zalo":
                            _viewModel.selectTypeCommand("Zalo");
                            break;
                          case "Facebook":
                            _viewModel.selectTypeCommand("Facebook");
                            break;
                          case "Lazada":
                            _viewModel.selectTypeCommand("Lazada");
                            break;
                          case "Shopee":
                            _viewModel.selectTypeCommand("Shopee");
                            break;
                        }
                      });
                    },
                    items: const [
                      DropdownMenuItem<String>(
                          value: "Zalo", child: Text("Zalo")),
                      DropdownMenuItem<String>(
                          value: "Facebook", child: Text("Facebook")),
                      DropdownMenuItem<String>(
                          value: "Lazada", child: Text("Lazada")),
                      DropdownMenuItem<String>(
                          value: "Shopee", child: Text("Shopee")),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(),
            TextFormField(
              validator: validateName,
              onEditingComplete: () {},
              controller: nameTextController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(5),
                icon: Icon(Icons.supervised_user_circle),
                labelText: 'Tên',
              ),
            ),
            const Divider(),
            TextFormField(
              onEditingComplete: () {},
              controller: shopIdTextController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(5),
                icon: Icon(Icons.dialpad),
                labelText: 'Shop ID',
              ),
            ),
            const Divider(),
            TextFormField(
              obscureText: true,
              onEditingComplete: () {},
              controller: secretKeyTextController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(5),
                icon: Icon(Icons.vpn_key),
                labelText: 'SecretKey',
              ),
            ),
            // Button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      padding: const EdgeInsets.all(10),
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        "LƯU",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        _sendToServer();
                        if (nameTextController.text != "") {
                          _viewModel.channel.name =
                              nameTextController.text.trim();
                          _viewModel.channel.shopId =
                              shopIdTextController.text.trim();
                          _viewModel.channel.zaloSecretKey =
                              secretKeyTextController.text.trim();

                          if (await _viewModel.saveInfo())
                            Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String validateName(String value) {
    if (value.isEmpty) {
      return "Tên không được bỏ trống";
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
}
