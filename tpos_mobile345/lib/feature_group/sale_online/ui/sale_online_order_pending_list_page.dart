import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_mobile/app_core/ui_base/ui_base.dart';

import 'package:tpos_mobile/feature_group/fast_sale_order/ui/fast_sale_order_add_edit_full_page.dart';
import 'package:tpos_mobile/feature_group/fast_sale_order/ui/fast_sale_order_quick_create_from_sale_online_order_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/sale_online_order_list_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/sale_online_order_list_viewmodel.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';

class SaleOnlineOrderPendingListPage extends StatelessWidget {
  const SaleOnlineOrderPendingListPage({this.saleOnlineOrderListViewModel});
  final SaleOnlineOrderListViewModel saleOnlineOrderListViewModel;

  @override
  Widget build(BuildContext context) {
    return UIViewModelBase(
      viewModel: saleOnlineOrderListViewModel,
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          title: const Text("Đang chờ xử lý"),
        ),
        body: ScopedModelDescendant<SaleOnlineOrderListViewModel>(
          builder: (context, _, __) => Column(
            children: <Widget>[
              _buildActionPanel(context),
              Expanded(
                child: _buildListPendingItem(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionPanel(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: <Widget>[
            Checkbox(
              value: saleOnlineOrderListViewModel.isPendingListSelectAll,
              onChanged: (value) {
                saleOnlineOrderListViewModel.handleCheckAllPendingList(value);
              },
            ),
            Text(
                "${saleOnlineOrderListViewModel.selectedManOrderCheckIds.length}"),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: ButtonTheme(
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.green),
                ),
                buttonColor: Colors.green,
                textTheme: ButtonTextTheme.primary,
                padding: const EdgeInsets.all(8),
                child: Wrap(
                  spacing: 10,
                  children: <Widget>[
                    RaisedButton(
                      child: const Text("Tạo HĐ với SP mặc định"),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                FastSaleOrderQuickCreateFromSaleOnlineOrderPage(
                              saleOnlineIds: saleOnlineOrderListViewModel
                                  .selectedManOrderCheckIds,
                            ),
                          ),
                        );
                      },
                    ),
                    RaisedButton(
                      child: const Text("Tạo HĐ bán"),
                      onPressed: () async {
                        if (saleOnlineOrderListViewModel
                                    .selectedManOrderCheckIds ==
                                null ||
                            saleOnlineOrderListViewModel
                                .selectedManOrderCheckIds.isEmpty) {
                          showWarning(
                              context: context,
                              title: "Chưa chọn đơn hàng nào!",
                              message:
                                  "Vui lòng chọn 1 hoặc nhiều đơn hàng có cùng tên facebook để tiếp tục");
                          return;
                        }

                        if (saleOnlineOrderListViewModel.selectedManyOrders.any(
                            (f) =>
                                f.facebookAsuid !=
                                saleOnlineOrderListViewModel
                                    .selectedManyOrders.first.facebookAsuid)) {
                          showWarning(
                              context: context,
                              title: "Các đơn đã chọn không cùng 1 facebook",
                              message:
                                  "Vui lòng chọn các đơn hàng có cùng tên facebook");
                          return;
                        }

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    FastSaleOrderAddEditFullPage(
                                      saleOnlineIds:
                                          saleOnlineOrderListViewModel
                                              .selectedManOrderCheckIds,
                                      partnerId: saleOnlineOrderListViewModel
                                          .selectedManyOrders?.first?.partnerId,
                                      onEditCompleted: (order) {
                                        if (order != null) {
                                          saleOnlineOrderListViewModel
                                              .updateAfterCreateInvoiceCommand();
                                        }
                                      },
                                    )));
                      },
                    ),
                    RaisedButton(
                      child: const Text("In"),
                      color: Colors.purple,
                      onPressed: () {
                        saleOnlineOrderListViewModel
                            .printSelectedItemsOnPendingList();
                      },
                    ),
                    RaisedButton(
                      child: const Text("Xóa khỏi danh sách"),
                      color: Colors.red,
                      onPressed: () {
                        saleOnlineOrderListViewModel
                            .removeAllSelectedPendingItem();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListPendingItem(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(left: 5, right: 5),
      itemBuilder: (context, index) => Slidable(
        actionExtentRatio: 0.25,
        actionPane: const SlidableBehindActionPane(),
        direction: Axis.horizontal,
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: "Xóa",
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {
              saleOnlineOrderListViewModel.removeSelectedPendingItem(
                  saleOnlineOrderListViewModel.selectedManyOrders[index]);
            },
          ),
        ],
        child: SaleOnlineOrderItem(
          item: saleOnlineOrderListViewModel.selectedManyOrders[index],
          isCheck: saleOnlineOrderListViewModel.selectedManOrderCheckIds.any(
              (f) =>
                  f ==
                  saleOnlineOrderListViewModel.selectedManyOrders[index].id),
          onSelect: (value) {
            saleOnlineOrderListViewModel.handleCheckOnPendingList(
                saleOnlineOrderListViewModel.selectedManyOrders[index]);
          },
        ),
      ),
      separatorBuilder: (context, index) => const SizedBox(
        height: 10,
      ),
      itemCount: saleOnlineOrderListViewModel.selectedManyOrders.length,
    );
  }
}
