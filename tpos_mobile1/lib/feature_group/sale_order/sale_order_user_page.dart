/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'package:flutter/material.dart';
import 'package:tpos_mobile/feature_group/sale_order/sale_order_user_viewmodel.dart.dart';
import 'package:tpos_mobile/helpers/helpers.dart';

import 'package:tpos_mobile/widgets/custom_widget.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class SaleOrderUserPage extends StatefulWidget {
  const SaleOrderUserPage(
      {this.closeWhenDone = true, this.isSearchMode = true, this.keyWord = ""});
  final bool isSearchMode;
  final bool closeWhenDone;
  final String keyWord;

  @override
  _SaleOrderUserPageState createState() => _SaleOrderUserPageState();
}

class _SaleOrderUserPageState extends State<SaleOrderUserPage> {
  _SaleOrderUserPageState();
  SaleOrderUserViewModel viewModel = SaleOrderUserViewModel();

  @override
  void initState() {
    viewModel.init();
    viewModel.keyword = widget.keyWord;

    super.initState();
    viewModel.dialogMessageController.listen((message) {
      registerDialogToView(context, message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: _showListProductCategories(),
    );
  }

  Widget _showListProductCategories() {
    return StreamBuilder(
      stream: viewModel.usersStream,
      initialData: viewModel.users,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.hasError) {
            return  Center(
              child: Text("${S.current.error}.${S.current.pleaseTryToAgain}"),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.only(left: 12),
            separatorBuilder: (context, index) {
              return const Divider(
                height: 1,
              );
            },
            shrinkWrap: true,
            itemCount: viewModel.users?.length ?? 0,
            itemBuilder: (context, position) {
              return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: ListTile(
                      onTap: () async {
                        if (widget.isSearchMode) {
                          if (widget.closeWhenDone)
                            Navigator.pop(context, viewModel.users[position]);
                        }
                      },
                      contentPadding: const EdgeInsets.all(0),
                      title: Text(
                        viewModel.users[position]?.name ?? "",
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }

  Widget buildAppBar(BuildContext context) {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: AppbarSearchWidget(
          onTextChange: (text) {
            viewModel.searchOrderCommand(text);
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }
}
