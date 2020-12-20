/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/product_unit_viewmodel.dart';

class ProductUnitPage extends StatefulWidget {
  const ProductUnitPage({this.uomCateogoryId});
  final int uomCateogoryId;

  @override
  _ProductUnitPageState createState() =>
      _ProductUnitPageState(uomCateogoryId: uomCateogoryId);
}

class _ProductUnitPageState extends State<ProductUnitPage> {
  _ProductUnitPageState({this.uomCateogoryId});
  int uomCateogoryId;

  ProductUOMViewModel viewModel = ProductUOMViewModel();

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    viewModel.uomCateogoryId = uomCateogoryId;
    viewModel.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ProductUOMViewModel>(
      model: viewModel,
      child: Scaffold(
        appBar: buildAppBar(context),
        body: _showBody(),
      ),
    );
  }

  Widget _showBody() {
    return StreamBuilder(
        stream: viewModel.productUOMStream,
        initialData: viewModel.productUOM,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Đã xảy ra lỗi. Vui lòng tải lại"),
              );
            }

            return ListView.builder(
//              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: viewModel.productUOM?.length ?? 0,
              itemBuilder: (context, position) {
                return Column(
                  children: <Widget>[
                    const Divider(
                      height: 2.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: ListTile(
                        onTap: () {
                          Navigator.pop(
                              context, viewModel.productUOM[position]);
                        },
                        contentPadding: const EdgeInsets.all(5),
                        title: Text(
                          viewModel.productUOM[position].name ?? '',
                          textAlign: TextAlign.start,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: RandomColor().randomColor(),
                          child: Text(viewModel.productUOM[position].name
                              .substring(0, 1)),
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
      title: TextField(
        autofocus: true,
        controller: _searchController,
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.search, color: Colors.white),
            hintText: "Chọn đơn vị sản phẩm",
            hintStyle: TextStyle(color: Colors.white)),
        onChanged: (text) {
          viewModel.searchProductUOM(text);
        },
      ),
      leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          }),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.cancel),
          onPressed: () {
            _searchController.clear();
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    viewModel.dispose();
  }
}
