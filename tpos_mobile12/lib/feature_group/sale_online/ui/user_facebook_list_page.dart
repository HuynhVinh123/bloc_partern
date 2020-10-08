import 'package:flutter/material.dart';
import 'package:tpos_mobile/app_core/template_ui/empty_data_widget.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/user_facebook_info_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/user_facebook_list_viewmodel.dart';
import 'package:tpos_mobile/locator.dart';

class UserFaceBookListPage extends StatefulWidget {
  const UserFaceBookListPage({this.postId, this.teamId});
  final String postId;
  final int teamId;
  @override
  _UserFaceBookListPageState createState() => _UserFaceBookListPageState();
}

class _UserFaceBookListPageState extends State<UserFaceBookListPage> {
  final _vm = locator<UserFaceBookListViewModel>();

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() {
    _vm.getUserFacebooks(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    return ViewBase<UserFaceBookListViewModel>(
        model: _vm,
        builder: (context, model, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Danh sách người dùng "),
            ),
            body: _vm.userFacebooks.isEmpty
                ? EmptyData(
                    onPressed: () async {
                      _vm.getUserFacebooks(widget.postId);
                    },
                  )
                : ListView.separated(
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                          height: 1,
                        ),
                    itemCount: _vm.userFacebooks.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserFacebookInfoPage(
                                  id: _vm.userFacebooks[index].id,
                                  teamId: widget.teamId,
                                  userName: _vm.userFacebooks[index].from?.name,
                                  postId: widget.postId,
                                ),
                              ));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 10, left: 10),
                                child: GestureDetector(
                                  child: SizedBox(
                                    width: 45,
                                    height: 45,
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(_vm
                                              .userFacebooks[index]
                                              .from
                                              .pictureLink ??
                                          ""),
                                    ),
                                  ),
                                  onTap: () {},
                                ),
                              ),
                              Text(
                                _vm.userFacebooks[index].from?.name,
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
          );
        });
  }
}
