/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/select_address_viewmodel.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class SelectAddressPage extends StatefulWidget {
  const SelectAddressPage({this.cityCode, this.districtCode});
  final String cityCode;
  final String districtCode;

  @override
  _SelectAddressPageState createState() =>
      _SelectAddressPageState(cityCode: cityCode, districtCode: districtCode);
}

class _SelectAddressPageState extends State<SelectAddressPage> {
  _SelectAddressPageState({this.cityCode, this.districtCode});
  String cityCode;
  String districtCode;

  SelectAddressViewModel viewModel = SelectAddressViewModel();

  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    viewModel.cityCode = cityCode;
    viewModel.districtCode = districtCode;
    viewModel.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<SelectAddressViewModel>(
      model: viewModel,
      child: Scaffold(
        appBar: buildAppBar(context),
        body: _showBody(),
      ),
    );
  }

  Widget _showBody() {
    return StreamBuilder(
        stream: viewModel.addressStream,
        initialData: viewModel.address,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasError) {
              // Đã xảy ra lỗi. Vui lòng tải lại
              return Center(
                child: Text(
                    "${S.current.dialog_errorOccur}. ${S.current.pleaseTryToReloadAgain}"),
              );
            }

            return ListView.builder(
//              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: viewModel.address?.length ?? 0,
              itemBuilder: (context, position) {
                return Column(
                  children: <Widget>[
                    const Divider(
                      height: 5.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: ListTile(
                        onTap: () {
                          Navigator.pop(context, viewModel.address[position]);
                        },
                        contentPadding: const EdgeInsets.all(5),
                        title: Text(
                          viewModel.address[position].name ?? '',
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        });
  }

  Widget buildAppBar(BuildContext context) {
    return AppBar(
      // Chọn địa chỉ
      title: TextField(
        autofocus: true,
        controller: _textController,
        style: const TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search, color: Colors.white),
            hintText: "${S.current.chooseAddress}...",
            hintStyle: const TextStyle(color: Colors.white)),
        onChanged: (text) {
          viewModel.searchAddress(text);
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.backspace),
          onPressed: () {
            _textController.clear();
            viewModel.searchAddress("");
          },
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    viewModel.dispose();
  }
}
