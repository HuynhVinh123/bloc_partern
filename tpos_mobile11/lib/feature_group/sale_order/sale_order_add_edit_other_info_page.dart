import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/feature_group/sale_order/sale_order_user_page.dart';
import 'package:tpos_mobile/feature_group/sale_order/viewmodels/sale_order_add_edit_viewmodel.dart';
import 'package:tpos_mobile/helpers/ui_help.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class SaleOrderAddEditOtherInfoPage extends StatefulWidget {
  const SaleOrderAddEditOtherInfoPage({this.editVm});
  final SaleOrderAddEditViewModel editVm;
  @override
  _SaleOrderAddEditOtherInfoPageState createState() =>
      _SaleOrderAddEditOtherInfoPageState();
}

class _SaleOrderAddEditOtherInfoPageState
    extends State<SaleOrderAddEditOtherInfoPage> {
  final _vm = SaleOrderAddEditOtherInfoViewModel();
  final _noteTextController = TextEditingController();

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
          /// Thông tin khác
          title: Text(S.current.otherInformation),
        ),
        body: _buildBody(),
        bottomNavigationBar: BottomBackButton(
          content: S.current.backToOrder.toUpperCase(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context)?.requestFocus(FocusNode());
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
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          S.current.purchaseOrder_employee,
                        )
                      ],
                    ),
                    title: ScopedModelDescendant<
                        SaleOrderAddEditOtherInfoViewModel>(
                      builder: (ctx, child, model) {
                        return Text(
                          widget.editVm.user.name ??
                              S.current.purchaseOrder_chooseEmployee,
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.subtitle,
                        );
                      },
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => const SaleOrderUserPage(
                            isSearchMode: true,
                            closeWhenDone: true,
                          ),
                        ),
                      );
                      if (result != null) {
                        _vm.user = result;
                      }
                    },
                  ),
                ),

                // Ngày hóa đơn
                const SizedBox(
                  height: 1,
                ),
                AbsorbPointer(
                  absorbing: !_vm._editVm.cantEditDateOrder,
                  child: Container(
                    color: _vm._editVm.cantEditDateOrder
                        ? Colors.white
                        : Colors.grey.shade300,
                    child: ListTile(
                      contentPadding: const EdgeInsets.only(
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
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "${S.current.invoiceDate}:",
                          )
                        ],
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            DateFormat("dd/MM/yyyy HH:mm")
                                .format(model.dateOrder),
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: () async {
                              if (isSale) {
                                final selectedDate = await showDatePicker(
                                  context: context,
                                  initialDate: widget.editVm.order.dateOrder,
                                  firstDate: DateTime.now()
                                      .add(const Duration(days: -365)),
                                  lastDate: DateTime.now().add(
                                    const Duration(days: 1),
                                  ),
                                );

                                if (selectedDate != null) {
                                  _vm.setInvoiceDate(selectedDate, false);
                                }
                              }
                            },
                            icon: const Icon(Icons.date_range),
                          ),
                          IconButton(
                            onPressed: () async {
                              if (isSale) {
                                final selectedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(
                                        hour: DateTime.now().hour,
                                        minute: DateTime.now().minute));

                                if (selectedTime != null) {
                                  model.setInvoiceTime(selectedTime);
                                }
                              }
                            },
                            icon: const Icon(Icons.access_time),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 1,
                ),

                AbsorbPointer(
                  absorbing: !_vm._editVm.cantEditDateExpect,
                  child: Container(
                    color: _vm._editVm.cantEditDateExpect
                        ? Colors.white
                        : Colors.grey.shade300,
                    child: ListTile(
                      contentPadding: const EdgeInsets.only(
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
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "${S.current.purchaseOrder_dateWarning}:",
                          )
                        ],
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            model.dateExpected == null
                                ? "<${S.current.noWarnings}>"
                                : DateFormat("dd/MM/yyyy HH:mm")
                                    .format(model.dateExpected),
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: () async {
                              if (isSale) {
                                final selectedDate = await showDatePicker(
                                  context: context,
                                  initialDate: widget.editVm.order.dateOrder,
                                  firstDate: DateTime.now()
                                      .add(const Duration(days: -365)),
                                  lastDate: DateTime.now().add(
                                    const Duration(days: 1),
                                  ),
                                );

                                if (selectedDate != null) {
                                  _vm.setDateExpected(selectedDate, false);
                                }
                              }
                            },
                            icon: const Icon(Icons.date_range),
                          ),
                          IconButton(
                            onPressed: () async {
                              if (isSale) {
                                final selectedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(
                                        hour: DateTime.now().hour,
                                        minute: DateTime.now().minute));

                                if (selectedTime != null) {
                                  model.setDateExpectedTime(selectedTime);
                                }
                              }
                            },
                            icon: const Icon(Icons.access_time),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),

                Container(
                  padding: const EdgeInsets.only(
                      left: 17, right: 8, top: 5, bottom: 10),
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          const Icon(Icons.note),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(S.current.note),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _noteTextController,
                        maxLines: null,
                        onChanged: (text) {
                          widget.editVm.note = text;
                        },
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              gapPadding: 10,
                              borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.grey,
                                  style: BorderStyle.solid),
                            ),
                            hintText: S.current.note),
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
  SaleOrderAddEditOtherInfoViewModel({SaleOrderAddEditViewModel editVm}) {
    _editVm = editVm;
  }
  SaleOrderAddEditViewModel _editVm;

  bool isSale;

  void init({SaleOrderAddEditViewModel editVm}) {
    _editVm = editVm;
  }

  DateTime get dateOrder => _editVm.order.dateOrder;
  DateTime get dateExpected => _editVm.order.dateExpected;

  void setInvoiceDate(DateTime value, bool isHour) {
    final temp = _editVm.order.dateOrder;

    _editVm.order.dateOrder = DateTime(
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
    final temp = _editVm.order.dateExpected ?? DateTime.now();

    _editVm.order.dateExpected = DateTime(
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
    final temp = _editVm.order.dateOrder;
    _editVm.order.dateOrder =
        DateTime(temp.year, temp.month, temp.day, value.hour, value.minute);
    notifyListeners();
  }

  void setDateExpectedTime(TimeOfDay value) {
    final temp = _editVm.order.dateExpected;
    _editVm.order.dateExpected =
        DateTime(temp.year, temp.month, temp.day, value.hour, value.minute);
    notifyListeners();
  }
}
