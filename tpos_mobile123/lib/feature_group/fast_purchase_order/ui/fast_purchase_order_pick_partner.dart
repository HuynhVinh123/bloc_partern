import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/helper/widget_helper.dart';

import 'package:tpos_mobile/feature_group/fast_purchase_order/view_model/fast_purchase_order_addedit_viewmodel.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_purchase_order_partner.dart';

class PagePickPartnerFPO extends StatefulWidget {
  final FastPurchaseOrderAddEditViewModel vm;

  PagePickPartnerFPO({@required this.vm});

  @override
  _PagePickPartnerFPOState createState() => _PagePickPartnerFPOState();
}

class _PagePickPartnerFPOState extends State<PagePickPartnerFPO> {
  TextEditingController searchController = new TextEditingController();
  FastPurchaseOrderAddEditViewModel _viewModel;
  @override
  void initState() {
    _viewModel = widget.vm;
    _viewModel.getPartner();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<FastPurchaseOrderAddEditViewModel>(
      model: _viewModel,
      child: ScopedModelDescendant<FastPurchaseOrderAddEditViewModel>(
          builder: (context, child, model) {
        return Scaffold(
          appBar: _buildAppBar(),
          body: !model.isLoadingListPartner ? _buildBody() : loadingScreen(),
        );
      }),
    );
  }

  Widget _buildAppBar() {
    Timer debounce;
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: Container(
          padding: EdgeInsets.only(left: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          child: TextField(
            controller: searchController,
            autofocus: true,
            style: TextStyle(fontSize: 20),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    searchController.text = "";
                  }),
              hintText: "Tìm kiếm...",
              fillColor: Colors.white,
              enabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                  borderSide: BorderSide(color: Colors.white)),
            ),
            onChanged: (text) {
              debounce = Timer(const Duration(milliseconds: 500), () {
                _viewModel.getPartnerByKeyWord(text);
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return ScopedModelDescendant<FastPurchaseOrderAddEditViewModel>(
      builder: (context, child, model) {
        return ListView.builder(
            itemCount: model.partners.length,
            itemBuilder: (context, index) {
              PartnerFPO item = model.partners[index];
              return _showListItem(item);
            });
      },
    );
  }

  Widget _showListItem(PartnerFPO item) {
    return InkWell(
      onTap: () {
        _viewModel.onPickPartner(item).then((result) {
          Navigator.pop(context, true);
        });
      },
      child: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "${item.name ?? "<Chưa có tên>"}",
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "${item.phone ?? "<Chưa có số điện thoại>"}",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              "${item.street ?? "<Chưa có địa chỉ>"}",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w300,
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
