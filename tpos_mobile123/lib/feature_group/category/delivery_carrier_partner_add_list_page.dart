import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_mobile/app_core/ui_base/ui_base.dart';
import 'package:tpos_mobile/feature_group/category/viewmodel/delivery_carrier_partner_add_list_viewmodel.dart';

import 'delivery_carrier_partner_add_edit_page.dart';

class DeliveryCarrierAddListPage extends StatefulWidget {
  @override
  _DeliveryCarrierAddListPageState createState() =>
      _DeliveryCarrierAddListPageState();
}

class _DeliveryCarrierAddListPageState
    extends State<DeliveryCarrierAddListPage> {
  var _vm = DeliveryCarrierPartnerAddListViewModel();
  @override
  void initState() {
    _vm.init();
    _vm.initFirst();
    _vm.initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return UIViewModelBase(
      viewModel: _vm..onStateAdd(false),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Đối tác vận chuyển"),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return ScopedModelDescendant<DeliveryCarrierPartnerAddListViewModel>(
      builder: (context, _, __) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //Tiêu đề
            Container(
              color: Colors.grey.shade300,
              padding: EdgeInsets.all(8),
              child: Text(
                "Đối tác được hỗ trợ trên TPOS",
                style: const TextStyle(color: Colors.grey),
              ),
            ),

            Container(
              color: Colors.grey.shade300,
              padding: EdgeInsets.all(8),
              child: Text(
                "TPOS hỗ trợ nhiều đối tác vận chuyển phổ biến. Nhấn chọn để kết nối tới đối tác",
                style: const TextStyle(color: Colors.grey),
              ),
            ),

            // Danh sách đối tác

            ExpansionPanelList(
              expansionCallback: (index, isExpanded) {
                print(isExpanded);
                _vm.selectedSupportType =
                    _vm.notConnectDeliveryCarriers[index].code;

                setState(() {});
              },
              children: _vm.notConnectDeliveryCarriers
                  ?.map(
                    (f) => ExpansionPanel(
                      headerBuilder: (_, __) => ListTile(
                        leading: Image.asset(
                          f.iconAsset,
                          width: 50,
                          height: 50,
                        ),
                        title: Text(
                          "${f.name}",
                        ),
                        subtitle: Text("${f.description}"),
                        trailing: Text(
                          "${f.connectedCount == 0 ? "Chưa kết nối" : "${f.connectedCount} đã kết nối"}",
                          style: TextStyle(
                              color: f.connectedCount == 0
                                  ? Colors.grey
                                  : Colors.green),
                        ),
                        onTap: () {
                          if (_vm.selectedSupportType == f.code)
                            _vm.selectedSupportType = null;
                          else {
                            _vm.selectedSupportType = f.code;
                          }
                          setState(() {});
                        },
                      ),
                      body: Column(
                        children: <Widget>[
                          // Danh sách đối tác con

                          Divider(),
                          if (_vm.connectedDeliveryCarriers != null)
                            ..._vm.connectedDeliveryCarriers
                                .where((a) => a.deliveryType == f.code)
                                .map(
                                  (b) => ListTile(
                                    leading: Icon(
                                      Icons.check_circle,
                                      color: Colors.blue,
                                    ),
                                    title: Text(b.name),
                                    trailing: FlatButton(
                                      textColor: Colors.blue,
                                      child: Text("Sửa"),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DeliveryCarrierPartnerAddEditPage(
                                              editCarrier: b,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )
                                .toList(),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: RaisedButton(
                                color: Colors.blue,
                                child: Text(
                                    "${f.connectedCount == 0 ? "Kết nối ngay" : "Thêm kết nối ${f.name}"}"),
                                textColor: Colors.white,
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DeliveryCarrierPartnerAddEditPage(
                                        deliveryType: f.code,
                                        deliveryName: f.name,
                                      ),
                                    ),
                                  );
                                  _vm.initData();
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                      canTapOnHeader: true,
                      isExpanded: _vm.selectedSupportType == f.code &&
                          _vm.selectedSupportType != null,
                    ),
                  )
                  ?.toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SupportDeliveryCarrierItemView extends StatelessWidget {
  final SupportDeliveryCarrierModel supportCarrier;
  _SupportDeliveryCarrierItemView({this.supportCarrier});
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
