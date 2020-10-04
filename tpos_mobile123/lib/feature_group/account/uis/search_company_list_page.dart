import 'package:flutter/material.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/account/viewmodels/search_company_list_viewmodel.dart';
import 'package:tpos_mobile/locator.dart';

class SearchCompanyListPage extends StatefulWidget {
  @override
  _SearchCompanyListPageState createState() => _SearchCompanyListPageState();
}

class _SearchCompanyListPageState extends State<SearchCompanyListPage> {
  TextEditingController _searchController = TextEditingController();
  var _vm = locator<SearchCompanyListViewModel>();

  Widget _buildSearch() {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(24)),
      height: 40,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 12,
          ),
          Icon(
            Icons.search,
            color: Color(0xFF28A745),
          ),
          Expanded(
            child: Center(
              child: Container(
                  height: 35,
                  margin: EdgeInsets.only(left: 4),
                  child: Center(
                    child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          if (value == "" || value.length == 1) {
                            setState(() {});
                          }
                          _vm.searchOrderCommand(value);
                        },
                        autofocus: true,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(0),
                            isDense: true,
                            hintText: "Tìm kiếm",
                            border: InputBorder.none)),
                  )),
            ),
          ),
          Visibility(
            visible: _searchController.text != "",
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.grey,
                size: 18,
              ),
              onPressed: () {
                setState(() {
                  _searchController.text = "";
                });
                _vm.searchOrderCommand("");
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewBase<SearchCompanyListViewModel>(
        model: _vm,
        builder: (context, model, _) {
          return Scaffold(
            appBar: AppBar(
              title: _vm.isSearch ? _buildSearch() : Text("Danh sách công ty"),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _searchController.text = "";
                    _vm.isSearch = !_vm.isSearch;
                    if (!_vm.isSearch) {
                      _vm.searchOrderCommand("");
                    }
                  },
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 4),
                        child: Divider(
                          height: 1,
                          color: Colors.grey[400],
                        ),
                      ),
                  itemCount: _vm.companies.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        if (_vm.companies[index].id == null) {
                          Navigator.pop(context, null);
                        } else {
                          Navigator.pop(context, _vm.companies[index]);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 12),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2)),
                        child: Text(
                          "${_vm.companies[index].name}",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  }),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _vm.getCompanies();
  }
}
