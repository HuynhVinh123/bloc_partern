import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/feature_group/sale_order/sale_order_user_page.dart';
import 'package:tpos_mobile/feature_group/sale_order/viewmodels/sale_order_add_edit_viewmodel.dart';
import 'package:tpos_mobile/helpers/ui_help.dart';

class SaleOrderAddEditOtherInfoPage extends StatefulWidget {
  final SaleOrderAddEditViewModel editVm;
  SaleOrderAddEditOtherInfoPage({this.editVm});
  @override
  _SaleOrderAddEditOtherInfoPageState createState() =>
      _SaleOrderAddEditOtherInfoPageState();
}

class _SaleOrderAddEditOtherInfoPageState
    extends State<SaleOrderAddEditOtherInfoPage> {
  var _vm = new SaleOrderAddEditOtherInfoViewModel();
  var _noteTextController = new TextEditingController();

  bool isSale;

  @override
  void initState() {
    _vm.init(editVm: widget.editVm);
    _noteTextController.text = widget.editVm.note;
    isSale = widget.editVm.order.state != "sale";
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<SaleOrderAddEditOtherInfoViewModel>(
      model: _vm,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Thông tin khác"),
        ),
        body: _buildBody(),
        bottomNavigationBar: BottomBackButton(
          content: "QUAY LẠI ĐƠN HÀNG",
        ),
      ),
    );
  }

  Widget _buildBody() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context)?.requestFocus(new FocusNode());
      },
      child: ScopedModelDescendant<SaleOrderAddEditOtherInfoViewModel>(
        builder: (context, child, model) {
          return Container(
            color: Colors.grey.shade300,
            child: ListView(
              children: <Widget>[
                // Người bán
                Container(
                  color: Colors.white,
                  child: ListTile(
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.people,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Người bán",
                        )
                      ],
                    ),
                    title: ScopedModelDescendant<
                        SaleOrderAddEditOtherInfoViewModel>(
                      builder: (ctx, child, model) {
                        return Text(
                          "${widget.editVm.user.name ?? "Chọn người bán"}",
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.subtitle,
                        );
                      },
                    ),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () async {
                      var result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => SaleOrderUserPage(
                            isSearchMode: true,
                            closeWhenDone: true,
                          ),
                        ),
                      );
                      if (result != null) _vm.user = result;
                    },
                  ),
                ),

                // Ngày hóa đơn
                SizedBox(
                  height: 1,
                ),
                AbsorbPointer(
                  absorbing: !_vm._editVm.cantEditDateOrder,
                  child: Container(
                    color: _vm._editVm.cantEditDateOrder
                        ? Colors.white
                        : Colors.grey.shade300,
                    child: ListTile(
                      contentPadding: EdgeInsets.only(
                        right: 0,
                        left: 16,
                      ),
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.date_range,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Ngày hóa đơn:",
                          )
                        ],
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            DateFormat("dd/MM/yyyy HH:mm")
                                .format(model.dateOrder),
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: () async {
                              if (isSale) {
                                var selectedDate = await showDatePicker(
                                  context: context,
                                  initialDate: widget.editVm.order.dateOrder,
                                  firstDate: DateTime.now()
                                      .add(new Duration(days: -365)),
                                  lastDate: DateTime.now().add(
                                    new Duration(days: 1),
                                  ),
                                );

                                if (selectedDate != null) {
                                  _vm.setInvoiceDate(selectedDate, false);
                                }
                              }
                            },
                            icon: Icon(Icons.date_range),
                          ),
                          IconButton(
                            onPressed: () async {
                              if (isSale) {
                                var selectedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(
                                        hour: DateTime.now().hour,
                                        minute: DateTime.now().minute));

                                if (selectedTime != null) {
                                  model.setInvoiceTime(selectedTime);
                                }
                              }
                            },
                            icon: Icon(Icons.access_time),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 1,
                ),

                AbsorbPointer(
                  absorbing: !_vm._editVm.cantEditDateExpect,
                  child: Container(
                    color: _vm._editVm.cantEditDateExpect
                        ? Colors.white
                        : Colors.grey.shade300,
                    child: ListTile(
                      contentPadding: EdgeInsets.only(
                        right: 0,
                        left: 16,
                      ),
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.date_range,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Ngày cảnh báo:",
                          )
                        ],
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            model.dateExpected == null
                                ? "<Không cảnh báo>"
                                : DateFormat("dd/MM/yyyy HH:mm")
                                    .format(model.dateExpected),
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: () async {
                              if (isSale) {
                                var selectedDate = await showDatePicker(
                                  context: context,
                                  initialDate: widget.editVm.order.dateOrder,
                                  firstDate: DateTime.now()
                                      .add(new Duration(days: -365)),
                                  lastDate: DateTime.now().add(
                                    new Duration(days: 1),
                                  ),
                                );

                                if (selectedDate != null) {
                                  _vm.setDateExpected(selectedDate, false);
                                }
                              }
                            },
                            icon: Icon(Icons.date_range),
                          ),
                          IconButton(
                            onPressed: () async {
                              if (isSale) {
                                var selectedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(
                                        hour: DateTime.now().hour,
                                        minute: DateTime.now().minute));

                                if (selectedTime != null) {
                                  model.setDateExpectedTime(selectedTime);
                                }
                              }
                            },
                            icon: Icon(Icons.access_time),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 1,
                ),

                Container(
                  padding:
                      EdgeInsets.only(left: 17, right: 8, top: 5, bottom: 10),
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(Icons.note),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Ghi chú đơn hàng"),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _noteTextController,
                        maxLines: null,
                        onChanged: (text) {
                          widget.editVm.note = text;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              gapPadding: 10,
                              borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.grey,
                                  style: BorderStyle.solid),
                            ),
                            hintText: "Để lại ghi chú"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SaleOrderAddEditOtherInfoViewModel extends ViewModel {
  SaleOrderAddEditViewModel _editVm;
  SaleOrderAddEditOtherInfoViewModel({SaleOrderAddEditViewModel editVm}) {
    _editVm = editVm;
  }

  bool isSale;

  void init({SaleOrderAddEditViewModel editVm}) {
    _editVm = editVm;
  }

  DateTime get dateOrder => _editVm.order.dateOrder;
  DateTime get dateExpected => _editVm.order.dateExpected;

  void setInvoiceDate(DateTime value, bool isHour) {
    var temp = _editVm.order.dateOrder;

    _editVm.order.dateOrder = new DateTime(
        value.year,
        value.month,
        value.day,
        temp.hour,
        temp.minute,
        temp.second,
        temp.millisecond,
        temp.microsecond);

    notifyListeners();
  }

  void setDateExpected(DateTime value, bool isHour) {
    var temp = _editVm.order.dateExpected ?? DateTime.now();

    _editVm.order.dateExpected = new DateTime(
        value.year,
        value.month,
        value.day,
        temp.hour,
        temp.minute,
        temp.second,
        temp.millisecond,
        temp.microsecond);

    notifyListeners();
  }

  set user(ApplicationUser value) {
    _editVm.user = value;
    notifyListeners();
  }

  void setInvoiceTime(TimeOfDay value) {
    var temp = _editVm.order.dateOrder;
    _editVm.order.dateOrder =
        new DateTime(temp.year, temp.month, temp.day, value.hour, value.minute);
    notifyListeners();
  }

  void setDateExpectedTime(TimeOfDay value) {
    var temp = _editVm.order.dateExpected;
    _editVm.order.dateExpected =
        new DateTime(temp.year, temp.month, temp.day, value.hour, value.minute);
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
