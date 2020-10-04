import 'package:flutter/material.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/feature_group/reports/viewmodels/filter_search_viewmodel.dart';

class FilterSearchPage extends StatefulWidget {
  FilterSearchPage({this.nameSelect});
  String nameSelect;
  @override
  _FilterSearchPageState createState() => _FilterSearchPageState();
}

class _FilterSearchPageState extends State<FilterSearchPage> {
  var _vm = locator<FilterSearchViewModel>();

  @override
  void initState() {
    super.initState();
    if (widget.nameSelect == "groupPartner") {
      _vm.getPartnerCategorys();
    } else if (widget.nameSelect == "partner") {
      _vm.getListPartnerFPO();
    } else if (widget.nameSelect == "employee") {
      _vm.getApplicationUserSearchReport();
    } else if (widget.nameSelect == "company") {
      _vm.getCompanies();
    } else if (widget.nameSelect == "supplier") {
      _vm.getSuppliers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewBase<FilterSearchViewModel>(
        model: _vm,
        builder: (context, model, sizingInformation) {
          return Scaffold(
            appBar: AppBar(
              title: showTitleAppBar(),
            ),
            body: buildSearchWidget(),
          );
        });
  }

  Widget showTitleAppBar() {
    if (widget.nameSelect == "groupPartner") {
      return Text("Nhóm khách hàng");
    } else if (widget.nameSelect == "partner") {
      return Text("Khách hàng");
    } else if (widget.nameSelect == "employee") {
      return Text("Nhân viên");
    } else if (widget.nameSelect == "company") {
      return Text("Danh sách công ty");
    } else if (widget.nameSelect == "supplier") {
      return Text("Danh sách nhà cung cấp");
    }
    return Text("");
  }

  Widget buildSearchWidget() {
    if (widget.nameSelect == "groupPartner") {
      return buildPartnerCategories();
    } else if (widget.nameSelect == "partner") {
      return buildPartnerFPO();
    } else if (widget.nameSelect == "employee") {
      return buildApplicationUser();
    } else if (widget.nameSelect == "company") {
      return buildCompany();
    } else if (widget.nameSelect == "supplier") {
      return buildSupplier();
    } else {
      return const SizedBox();
    }
  }

  Widget buildPartnerCategories() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                offset: Offset(0, 3), blurRadius: 3, color: Colors.grey[400])
          ]),
          child: ListView.builder(
              itemCount: _vm.partnerCategory.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Navigator.pop(context, _vm.partnerCategory[index]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 12),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 1),
                                blurRadius: 1,
                                color: Colors.grey[300])
                          ],
                          borderRadius: BorderRadius.circular(2)),
                      child: Text(
                        "${_vm.partnerCategory[index].name}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                );
              }),
        ));
  }

  Widget buildPartnerFPO() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                offset: Offset(0, 3), blurRadius: 3, color: Colors.grey[400])
          ]),
          child: ListView.builder(
              itemCount: _vm.partnerFPOs.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Navigator.pop(context, _vm.partnerFPOs[index]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 12),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 1),
                                blurRadius: 1,
                                color: Colors.grey[300])
                          ],
                          borderRadius: BorderRadius.circular(2)),
                      child: Text(
                        "${_vm.partnerFPOs[index].displayName ?? ""}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                );
              }),
        ));
  }

  Widget buildApplicationUser() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                offset: Offset(0, 3), blurRadius: 3, color: Colors.grey[400])
          ]),
          child: ListView.builder(
              itemCount: _vm.applicationUserFPOs.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Navigator.pop(context, _vm.applicationUserFPOs[index]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 12),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 1),
                                blurRadius: 1,
                                color: Colors.grey[300])
                          ],
                          borderRadius: BorderRadius.circular(2)),
                      child: Text(
                        "${_vm.applicationUserFPOs[index].name ?? ""}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                );
              }),
        ));
  }

  Widget buildCompany() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                offset: Offset(0, 3), blurRadius: 3, color: Colors.grey[400])
          ]),
          child: ListView.builder(
              itemCount: _vm.companyOfUsers.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Navigator.pop(context, _vm.companyOfUsers[index]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 12),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 1),
                                blurRadius: 1,
                                color: Colors.grey[300])
                          ],
                          borderRadius: BorderRadius.circular(2)),
                      child: Text(
                        "${_vm.companyOfUsers[index].text ?? ""}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                );
              }),
        ));
  }

  Widget buildSupplier() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                offset: Offset(0, 3), blurRadius: 3, color: Colors.grey[400])
          ]),
          child: ListView.builder(
              itemCount: _vm.suppliers.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Navigator.pop(context, _vm.suppliers[index]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 12),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 1),
                                blurRadius: 1,
                                color: Colors.grey[300])
                          ],
                          borderRadius: BorderRadius.circular(2)),
                      child: Text(
                        "${_vm.suppliers[index].displayName}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                );
              }),
        ));
  }
}
