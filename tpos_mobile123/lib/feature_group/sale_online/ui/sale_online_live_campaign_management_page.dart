/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_mobile/app_core/ui_base/app_bar_button.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/sale_online_add_edit_live_campaign_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/sale_online_live_campaign_management_viewmodel.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_models.dart';

import 'package:tpos_mobile/widgets/listview_data_error_info_widget.dart';

class SaleOnlineLiveCampaignManagementPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<SaleOnlineLiveCampaignManagementPage> {
  SaleOnlineLiveCampaignManagementViewModel viewModel =
      SaleOnlineLiveCampaignManagementViewModel();

  Key refreshIndicatorKey = const Key("refreshIndicator");

  @override
  void dispose() {
    super.dispose();
    viewModel.dispose();
  }

  @override
  void initState() {
    viewModel.refreshLiveCampaign();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<SaleOnlineLiveCampaignManagementViewModel>(
      model: viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Danh sách chiến dịch"),
          actions: <Widget>[
            AppbarIconButton(
              onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                  return SaleOnlineAddEditLiveCampaignPage();
                }));

                viewModel.refreshLiveCampaign();
              },
              icon: Icon(Icons.add),
              isEnable: viewModel.permissionAdd,
            ),
          ],
        ),
        body: StreamBuilder<bool>(
            stream: viewModel.isExportExcelStream,
            initialData: false,
            builder: (context, snapshot) {
              return Stack(
                children: <Widget>[
                  _showBody(),
                  if (snapshot.data)
                    Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.green.withOpacity(0.3),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ))
                  else
                    const SizedBox()
                ],
              );
            }),
      ),
    );
  }

  Widget _showBody() {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            children: <Widget>[
              const Text("Chiến dịch còn hoạt động"),
              StreamBuilder<bool>(
                  stream: viewModel.isOnlyShowAvaiableCampaignStream,
                  initialData: viewModel.isOnlyShowAvaiableCampaign,
                  builder: (context, snapshot) {
                    return Checkbox(
                      onChanged: (value) {
                        viewModel.isOnlyShowAvaiableCampaign = value;
                        viewModel.refreshLiveCampaign();
                      },
                      value: viewModel.isOnlyShowAvaiableCampaign,
                    );
                  }),
            ],
          ),
        ),
        const Divider(),
        Expanded(
          child: RefreshIndicator(
            key: refreshIndicatorKey,
            onRefresh: () {
              return viewModel.refreshLiveCampaign();
            },
            child: StreamBuilder<List<LiveCampaign>>(
              stream: viewModel.liveCampaignsStream,
              builder: (ctx, data) {
                if (data.hasError) {
                  return ListViewDataErrorInfoWidget(
                    errorMessage: "Đã xảy ra lỗi!\n" + data.error.toString(),
                  );
                }

                if (data.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (data.data == null) {
                    return Column(
                      children: const <Widget>[Text("Không có chiến dịch nào")],
                    );
                  }

                  return ListView.separated(
                      separatorBuilder: (_, __) {
                        return const Divider();
                      },
                      itemCount: data.data.length,
                      itemBuilder: (ctx, index) {
                        return ListTile(
                          onTap: !viewModel.permissionEdit
                              ? null
                              : () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      final SaleOnlineAddEditLiveCampaignPage
                                          saleOnlineAddEditLiveCampaignPage =
                                          SaleOnlineAddEditLiveCampaignPage(
                                        liveCampaign: data.data[index],
                                        onEditCompleted: (value) {
                                          data.data[index] = value;
                                        },
                                      );
                                      return saleOnlineAddEditLiveCampaignPage;
                                    }),
                                  );
                                  viewModel.refreshLiveCampaign();
                                },
                          title: Text(
                            data.data[index].name ?? '',
                            style: TextStyle(color: Colors.blue),
                          ),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(
                                height: 10,
                              ),
                              Text(data.data[index].note ??
                                  "Không có ghi chú.."),
                              if (data.data[index].facebookUserName != null)
                                Text(
                                    "Đã live bởi ${data.data[index].facebookUserName}")
                              else
                                const Text(""),
                            ],
                          ),
                          trailing: Column(
                            children: <Widget>[
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(DateFormat("dd/MM/yyyy  HH:mm")
                                      .format(data.data[index].dateCreated)),
                                  Container(
                                    width: 45,
                                    height: 35,
                                    child: Center(
                                      child: FlatButton(
                                        child: Center(
                                            child: Icon(
                                          Icons.more_vert,
                                          color: Colors.grey[600],
                                          size: 20,
                                        )),
                                        onPressed: () {
                                          _showBottomSheet(
                                              context, data.data[index]);
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ),
//                              InkWell(
//                                onTap: () async {
//                                  _showBottomSheet(context, data.data[index]);
//                                },
//                                child: Container(
//                                  margin: EdgeInsets.only(top: 4),
//                                  decoration: BoxDecoration(
//                                      color: Colors.green,
//                                      borderRadius: BorderRadius.circular(2)),
//                                  height: 32,
//                                  width: 90,
//                                  child: Center(
//                                    child: Row(
//                                      mainAxisAlignment:
//                                          MainAxisAlignment.center,
//                                      children: <Widget>[
//                                        Text(
//                                          "Tải Excel ",
//                                          style: TextStyle(color: Colors.white),
//                                        ),
//                                        viewModel.isDownloadExcel
//                                            ? CircularProgressIndicator()
//                                            : Icon(
//                                                Icons.file_download,
//                                                size: 18,
//                                                color: Colors.white,
//                                              )
//                                      ],
//                                    ),
//                                  ),
//                                ),
//                              ),
                            ],
                          ),
                          contentPadding: const EdgeInsets.only(left: 16),
                          isThreeLine: false,
                        );
                      });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  void _showBottomSheet(context, LiveCampaign item) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12),
                    topLeft: Radius.circular(12))),
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(
                      Icons.file_download,
                      color: Colors.green,
                    ),
                    title: const Text('Tải file Excel'),
                    onTap: () async {
                      Navigator.pop(context);
                      await viewModel.downloadExcel(item, context);
                    }),
                ListTile(
                  leading: Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                  ),
                  title: const Text('Xóa chiến dịch'),
                  onTap: () => {},
                ),
              ],
            ),
          );
        });
  }
}
