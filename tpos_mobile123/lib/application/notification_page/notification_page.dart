import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tmt_flutter_untils/sources/string_utils/string_utils.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/show_webview_page.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';
import 'package:tpos_mobile/helpers/helpers.dart';

import 'package:timeago/timeago.dart' as time_ago;
import 'package:tpos_mobile/widgets/bloc_widget/bloc_loading_screen.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_ui_provider.dart';
import '../notification_popup_dialog_page.dart';
import 'notification_bloc.dart';
import 'notification_html_view_page.dart';
import 'notification_state.dart';
import 'notification_event.dart';

import 'package:tmt_flutter_untils/tmt_flutter_utils.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage();

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final _notReadTilteStyle = TextStyle(fontWeight: FontWeight.bold);
  final _readTitleStyle = TextStyle(fontWeight: FontWeight.normal);

  NotificationBloc _bloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_bloc == null) {
      _bloc = context.bloc<NotificationBloc>();
      _bloc.add(NotificationLoaded());
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    //_bloc.close();
    print("notification page disposed");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).notification),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return BlocLoadingScreen<NotificationBloc>(
      busyStates: const [NotificationLoading],
      child: RefreshIndicator(
        onRefresh: () async {
          context.bloc<NotificationBloc>().add(NotificationLoaded());
          await Future.delayed(const Duration(seconds: 1));
        },
        child: BlocConsumer<NotificationBloc, NotificationState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is NotificationLoadSuccess) {
              return _buildList(state.notificationResult.items);
            } else if (state is NotificationLoadFailure) {
              return _buildListError(state.message);
            } else if (state is NotificationUnInitial) {
              return const Center(
                child: Text('Phải gọi sự kiện loaded'),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }

  /// UI danh sách thông báo
  Widget _buildList(List<TPosNotification> items) {
    assert(items != null);
    if (items.isEmpty) {
      return _buildListEmpty();
    }
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) => _buildItem(items[index]),
      separatorBuilder: (context, index) => const Divider(),
      itemCount: items.length,
    );
  }

  /// UI từng dòng thông báo. UI này được gọi trong UI danh sách [_buildList]
  Widget _buildItem(TPosNotification item) {
    return ListTile(
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: Colors.green.shade300,
        child: Icon(
          Icons.mail,
          color: Colors.white,
        ),
      ),
      title: Row(children: <Widget>[
        Expanded(
          child: Text(
            "${item.title}",
            style: item.dateRead == null ? _notReadTilteStyle : _readTitleStyle,
          ),
        ),
      ]),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(StringUtils.trimUnicode(item.description ?? '', 100)),
          if (item.dateRead != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "${DateFormat("dd/MM/yyyy HH:mm").format(item.dateCreated)}",
                  style: TextStyle(color: Colors.blue),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text("${time_ago.format(item.dateCreated, locale: "vi_VN")}"),
              ],
            ),
        ],
      ),
      onTap: () async {
        // await Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => NotificationViewPage(
        //       notification: item,
        //       title: item.title,
        //       htmlString: item.content,
        //     ),
        //   ),
        // );

        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotificationHtmlViewPage(
              notification: item,
            ),
          ),
        );
      },
    );
  }

  /// UI khi danh sách rỗng. không có phần tử
  Widget _buildListEmpty() {
    return Center(
      child: Column(
        children: <Widget>[
          Icon(
            Icons.notifications,
            color: Colors.grey.shade300,
            size: 70,
          ),
          const Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text(
              "Chưa có thông báo",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Text(
            "Các thông báo từ TPOS sẽ hiển thị ở đây",
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
        ],
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }

  /// UI khi quá trình tải danh sách bị lỗi
  Widget _buildListError(String message) {
    assert(message != null);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.error,
            size: 70,
            color: Colors.grey.shade300,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(message),
        ],
      ),
    );
  }
}
