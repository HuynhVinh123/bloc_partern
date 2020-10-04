import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/template_ui/app_list_empty_notify.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/sale_online_channel_add_edit_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/sale_online_channel_list_viewmodel.dart';


import 'package:tpos_mobile/widgets/ModalWaitingWidget.dart';
import 'package:tpos_mobile/widgets/listview_data_error_info_widget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SaleOnlineChannelListPage extends StatefulWidget {
  const SaleOnlineChannelListPage({this.isSearchMode = false});
  final bool isSearchMode;

  @override
  _SaleOnlineChannelListPageState createState() =>
      _SaleOnlineChannelListPageState();
}

class _SaleOnlineChannelListPageState extends State<SaleOnlineChannelListPage> {
  final _viewModel = locator<SaleOnlineChannelListViewModel>();
  @override
  void initState() {
    _viewModel.viewModelStatusController = null;
    _viewModel.initCommand();

    super.initState();
  }

  Future _onAdd() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => SaleOnlineChannelAddEditPage(),
        ));
    _viewModel.initCommand();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalWaitingWidget(
      isBusyStream: _viewModel.isBusyController,
      initBusy: false,
      statusStream: _viewModel.viewModelStatusController,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Kênh bán hàng"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: _onAdd,
            )
          ],
        ),
        body: _showBody(),
      ),
    );
  }

  Widget _showBody() {
    return StreamBuilder<List<CRMTeam>>(
      stream: _viewModel.channelsStream,
      initialData: _viewModel.channels,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ListViewDataErrorInfoWidget(
            errorMessage: snapshot.error.toString(),
          );
        }
        if (snapshot.hasData == false) {
          return ListViewDataErrorInfoWidget(
            errorMessage: "Không có dữ liệu!",
            actions: <Widget>[
              RaisedButton(
                child: const Text("Tải lại"),
                onPressed: () {
                  _viewModel.initCommand();
                },
              ),
            ],
          );
        }
        return _showList(snapshot.data);
      },
    );
  }

  Widget _showList(List<CRMTeam> items) {
    return RefreshIndicator(
      onRefresh: () {
        return _viewModel.refreshCommand();
      },
      child: items.isEmpty
          ? AppListEmptyNotify(
              message: const Text("Nhấn + để thêm kênh bán hàng mới"),
              actions: <Widget>[
                OutlineButton.icon(
                  icon: Icon(Icons.refresh),
                  label: const Text("Tải lại"),
                  textColor: Colors.green,
                  onPressed: _viewModel.refreshCommand,
                ),
                RaisedButton.icon(
                  icon: Icon(Icons.add),
                  label: const Text("Thêm mới"),
                  textColor: Colors.white,
                  onPressed: _onAdd,
                ),
              ],
            )
          : ListView.separated(
              itemBuilder: (ctx, index) {
                return _showItem(items[index]);
              },
              separatorBuilder: (ctx, index) {
                return const Divider(
                  height: 2,
                );
              },
              itemCount: items.length),
    );
  }

  Widget _showItem(CRMTeam item) {
    return Slidable(
      actionPane: const SlidableStrechActionPane(),
      direction: Axis.horizontal,
      actionExtentRatio: 0.25,
      child: ListTile(
        onTap: () async {
          // Nếu là tìm kiếm thì chọn và trả về kết quả
          if (widget.isSearchMode) {
            Navigator.pop(context, item);
            return;
          }
          // Nếu là danh sách thì sửa
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => SaleOnlineChannelAddEditPage(
                crmTeam: item,
              ),
            ),
          );
        },
        leading: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            item.type ?? "",
          ),
        ),
        title: Row(
          children: <Widget>[
            Text(
              item.parentName ?? "",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
            Text(item.parentName != null ? " / " : ""),
            Expanded(
                child: Text(
              item.name ?? '',
              style: TextStyle(
                  color: item.parentName != null ? Colors.black : Colors.blue,
                  fontWeight: item.parentName == null
                      ? FontWeight.bold
                      : FontWeight.normal),
            )),
          ],
        ),
        subtitle:
            Text("Cho phép sử dụng: ${item.active == true ? "Có" : "Không"}"),
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Xóa',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            _viewModel.deleteChannel(item);
          },
        ),
      ],
    );
  }
}
