import 'package:flutter/material.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/pos_order/viewmodels/pos_method_payment_list_viewmodel.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class PosMethodPaymentListPage extends StatefulWidget {
  @override
  _PosMethodPaymentListPageState createState() =>
      _PosMethodPaymentListPageState();
}

class _PosMethodPaymentListPageState extends State<PosMethodPaymentListPage> {
  final _vm = locator<PosMethodPaymentListViewModel>();

  @override
  void initState() {
    super.initState();
    _vm.getAccountJournalsPointSale();
  }

  @override
  Widget build(BuildContext context) {
    return ViewBase<PosMethodPaymentListViewModel>(
        model: _vm,
        builder: (context, model, _) {
          return Scaffold(
            appBar: AppBar(
              /// Phương thức thanh toán
              title:  Text(S.current.posSession_paymentType),
            ),
            body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, 3),
                        blurRadius: 3,
                        color: Colors.grey[400])
                  ]),
                  child: ListView.builder(
                      itemCount: _vm.accountJournals.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Navigator.pop(context, _vm.accountJournals[index]);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 12),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      offset: const Offset(0, 2),
                                      blurRadius: 2,
                                      color: Colors.grey[400])
                                ],
                                borderRadius: BorderRadius.circular(2)),
                            child: Text(
                              _vm.accountJournals[index]?.name ?? "",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      }),
                )),
          );
        });
  }
}
