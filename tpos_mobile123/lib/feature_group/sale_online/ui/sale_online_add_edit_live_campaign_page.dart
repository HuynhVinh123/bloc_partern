/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'package:flutter/material.dart';
import 'package:tpos_mobile/app_core/ui_base/ui_vm_base.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/sale_online_live_campaign_select_product_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/sale_online_add_edit_live_campaign_viewmodel.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_models.dart';

import 'package:tpos_mobile/helpers/messenger_helper.dart';

class SaleOnlineAddEditLiveCampaignPage extends StatefulWidget {
  const SaleOnlineAddEditLiveCampaignPage(
      {this.liveCampaign, this.onEditCompleted});
  final LiveCampaign liveCampaign;
  final Function(LiveCampaign) onEditCompleted;

  @override
  _SaleOnlineAddEditLiveCampaignPageState createState() =>
      _SaleOnlineAddEditLiveCampaignPageState(liveCampaign: liveCampaign);
}

class _SaleOnlineAddEditLiveCampaignPageState
    extends State<SaleOnlineAddEditLiveCampaignPage> {
  _SaleOnlineAddEditLiveCampaignPageState({LiveCampaign liveCampaign}) {
    _liveCampaign = liveCampaign;
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  LiveCampaign _liveCampaign;

  SaleOnlineAddEditLiveCampaignViewModel viewModel =
      SaleOnlineAddEditLiveCampaignViewModel();

  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _noteTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return UIViewModelBase(
      viewModel: viewModel,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(viewModel.liveCampaign.id == null
              ? "Chiến dịch mới"
              : "Sửa chiến dịch"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () async {
                viewModel.liveCampaign.name = _nameTextController.text;
                viewModel.liveCampaign.note = _noteTextController.text;
                if (await viewModel.save()) {
                  if (widget.onEditCompleted != null) {
                    widget.onEditCompleted(viewModel.liveCampaign);
                  }
//                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
        body: _showLiveCampaignDetail(),
      ),
    );
  }

  Widget _showLiveCampaignDetail() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _nameTextController,
            decoration: const InputDecoration(
              hintText: "Ngày 13/2 sang...",
              labelText: "Tên chiến dịch",
            ),
          ),
          TextField(
            controller: _noteTextController,
            decoration: const InputDecoration(
                hintText: "ghi chú...", labelText: "Ghi chú"),
          ),
          ListTile(
            title: const Text("Cho phép hoạt động: "),
            trailing: Switch(
                value: viewModel.liveCampaign.isActive ?? false,
                onChanged: (value) {
                  viewModel.liveCampaign.isActive = value;
                  viewModel.changeStatus(value);

                  setState(() {});

                  //TODO bỏ setState cho trạng thái
                }),
          ),
          ListTile(
            title: Text(
                "Danh sách sản phẩm (${viewModel.liveCampaign.details?.length ?? 0})"),
            trailing: Icon(Icons.chevron_right),
            onTap: () async {
              viewModel.liveCampaign.details ??= <LiveCampaignDetail>[];
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  final SaleOnlineLiveCampaignSelectProductPage
                      saleOnlineLiveCampaignSelectProductPage =
                      SaleOnlineLiveCampaignSelectProductPage(
                    details: viewModel.liveCampaign.details,
                  );
                  return saleOnlineLiveCampaignSelectProductPage;
                }),
              );
            },
          ),
/*          if (!viewModel.isEditMode)
            Row(
              children: <Widget>[
                 Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child:  RaisedButton.icon(
                      shape: OutlineInputBorder(
                        borderSide:
                        BorderSide(width: 1, color: Colors.green),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: Colors.white,
                      textColor: Theme.of(context).primaryColor,
                      icon: Icon(Icons.close),
                      label: Text(
                        "Hủy bỏ",
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                 Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child:  RaisedButton.icon(
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      icon: Icon(Icons.check),
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide:
                        BorderSide(width: 1, color: Theme.of(context).primaryColor),
                      ),
                      label: Text(
                        "Lưu",
                      ),
                      onPressed: () async {
                        viewModel.liveCampaign.name =
                            _nameTextController.text;
                        viewModel.liveCampaign.note =
                            _noteTextController.text;
                        if (await viewModel.save()) {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),*/
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    viewModel.dispose();
  }

  @override
  void initState() {
    viewModel.initViewModel(editLiveCampaign: _liveCampaign);
    viewModel.dialogMessageController.listen((f) {
      registerDialogToView(context, f, scaffState: _scaffoldKey.currentState);
    });

    _noteTextController.text = viewModel.liveCampaign.note;
    _nameTextController.text = viewModel.liveCampaign.name;
    super.initState();
  }
}
