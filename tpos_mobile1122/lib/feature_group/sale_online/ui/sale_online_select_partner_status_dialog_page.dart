/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'package:flutter/material.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/sale_online_select_partner_status_viewmodel.dart';


class SaleOnlineSelectPartnerStatusDialogPage extends StatefulWidget {
  @override
  _SaleOnlineSelectPartnerStatusDialogPageState createState() =>
      _SaleOnlineSelectPartnerStatusDialogPageState();
}

class _SaleOnlineSelectPartnerStatusDialogPageState
    extends State<SaleOnlineSelectPartnerStatusDialogPage> {
  SaleOnlineSelectPartnerStatusViewModel viewModel =
      SaleOnlineSelectPartnerStatusViewModel();
  @override
  void initState() {
    viewModel.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          color: Colors.white,
          child: StreamBuilder<List<PartnerStatus>>(
            stream: viewModel.statusStream,
            initialData: viewModel.statuss,
            builder: (ctx, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error),
                );
              }

              return ListView.separated(
                itemBuilder: (ctx, index) {
                  return ListTile(
                    title: Text(snapshot.data[index].text ?? ''),
                    onTap: () {
                      Navigator.pop(context, snapshot.data[index]);
                    },
                  );
                },
                separatorBuilder: (ctx, index) {
                  return const Divider();
                },
                itemCount: snapshot.data?.length ?? 0,
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    viewModel.dispose();
  }
}
