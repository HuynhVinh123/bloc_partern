import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/helper/widget_helper.dart';

import 'package:tpos_mobile/feature_group/fast_purchase_order/view_model/fast_purchase_order_addedit_viewmodel.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_purchase_order_partner.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class PagePickPartnerFPO extends StatefulWidget {
  const PagePickPartnerFPO({@required this.vm});
  final FastPurchaseOrderAddEditViewModel vm;

  @override
  _PagePickPartnerFPOState createState() => _PagePickPartnerFPOState();
}

class _PagePickPartnerFPOState extends State<PagePickPartnerFPO> {
  TextEditingController searchController = TextEditingController();
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
          padding: const EdgeInsets.only(left: 8),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          child: TextField(
            controller: searchController,
            autofocus: true,
            style: const TextStyle(fontSize: 20),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.cancel,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    searchController.text = "";
                  }),
              // Tìm kiếm
              hintText: "${S.current.search}...",
              fillColor: Colors.white,
              enabledBorder: const UnderlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: const UnderlineInputBorder(
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
              final PartnerFPO item = model.partners[index];
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
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //Chưa có tên
            Text(
              item.name ?? "<${S.current.noName}>",
              style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              item.phone ?? "<${S.current.noPhoneNumber}>",
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              item.street ?? "<${S.current.noAddress}>",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w300,
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
