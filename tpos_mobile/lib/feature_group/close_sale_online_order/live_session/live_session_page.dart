import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as time_ago;
import 'package:tpos_mobile/feature_group/close_sale_online_order/live_session/live_session_list_bloc.dart';
import 'package:tpos_mobile/feature_group/close_sale_online_order/live_session/live_sesssion_setting_page.dart';
import 'package:tpos_mobile/feature_group/close_sale_online_order/models/facebook_post_with_channel.dart';
import 'package:tpos_mobile/feature_group/close_sale_online_order/viewmodel/comment_viewmodel.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/sale_online_facebook_channel_list_page.dart';
import 'package:tpos_mobile/helpers/svg_icon.dart';
import 'package:tpos_mobile/widgets/animation.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_ui_provider.dart';

/// UI phiên bán hàng
/// Hiện thông tin chưa có phiên bán nào và nút có thêm phiên mới nếu chưa có phiên nào đăng hoạt đông
/// Hiện danh sách phiên bán đang hoạt động và các hoạt động trên danh sách
///
/// UI Event:
/// + CreateNewSession
/// + ContinueWithSession
/// + Show Sesion setting
/// + Close session
class LiveSessionPage extends StatefulWidget {
  @override
  _LiveSessionPageState createState() => _LiveSessionPageState();
}

class _LiveSessionPageState extends State<LiveSessionPage> {
  final LiveSessionBloc _bloc = LiveSessionBloc();

  Future<void> _handleAddNewSession(BuildContext context) async {
    // Mở bài viết để chọn
    final FacebookPostWithChannel result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const SaleOnlineFacebookChannelListPage(
            selectMode: false,
            selectPostMode: true,
          );
        },
      ),
    );

    // Thêm vào bloc
    if (result != null) {
      _bloc.add(LiveSessionListAdded(
          crmTeam: result.crmTeam, facebookPost: result.post));
    }
  }

  @override
  void initState() {
    _bloc.add(LiveSessionListLoaded());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocUiProvider<LiveSessionBloc>(
      bloc: _bloc,
      busyStates: const [LiveSessionListLoaded],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Phiên chốt đơn'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {},
            ),
          ],
        ),
        body: _buildBody(),
        backgroundColor: const Color(0xffEBEDEF),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<LiveSessionBloc, LiveSessionListState>(
        builder: (context, state) {
      if (state is LiveSessionListLoadSuccess) {
        return _buildList(state.sessions);
      }
      return const SizedBox();
    });
  }

  Widget _buildList(List<CommentViewModel> items) {
    if (items.isEmpty) {
      return _EmptySessionWidget(
        onAddPressed: () => _handleAddNewSession(context),
      );
    } else {
      return _ListSessionWidget(
        onAddPressed: () => _handleAddNewSession(context),
        items: items,
      );
    }
  }
}

/// UI Khi chưa có phiên nào được tạo
class _EmptySessionWidget extends StatelessWidget {
  const _EmptySessionWidget({Key key, this.onAddPressed}) : super(key: key);
  static const Color _backgroundColor = Color(0xffEBEDEF);
  static const Color _buttonColor = Color(0xff28A745);
  static const Color _titleColor = Color(0xff484D54);
  static const double _titleFontSize = 18.0;

  final VoidCallback onAddPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _backgroundColor,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(
            height: 64,
          ),
          const SvgIcon(
            SvgIcon.liveStreamSession,
          ),
          const Text(
            'Chưa có phiên chốt đơn nào',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _titleColor,
              fontSize: _titleFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            'Tạo phiên chốt đơn mới để bán hàng livestream hiệu quả hơn với tự động tạo đơn, tối ưu hóa và thoát phiên bất cứ lúc nào mà vẫn quay trở lại bán hàng nhanh chóng',
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            'Lưu ý: Các phiên chỉ hoạt động khi app đang mở và sẽ bị reset sau khi thoát ứng dụng',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.orangeAccent),
          ),
          const Spacer(),
          RaisedButton(
            color: _buttonColor,
            textColor: Colors.white,
            onPressed: onAddPressed,
            child: const Text('Thêm phiên mới'),
          ),
        ],
      ),
    );
  }
}

/// UI khi đã có phiên được tạo và đang hoạt động
/// UI bao gồm danh sách các phiên
class _ListSessionWidget extends StatelessWidget {
  const _ListSessionWidget({Key key, this.onAddPressed, @required this.items})
      : assert(items != null),
        super(key: key);
  final VoidCallback onAddPressed;
  final List<CommentViewModel> items;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ...items
            .map(
              (e) => _ListSessionItem(
                item: e,
              ),
            )
            .toList(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RaisedButton(
            color: Colors.green,
            textColor: Colors.white,
            onPressed: onAddPressed,
            child: const Text('Thêm phiên khác'),
          ),
        ),
      ],
    );
  }
}

/// UI 1 phiên trong danh sách phiên đang hoạt động
class _ListSessionItem extends StatelessWidget {
  const _ListSessionItem({Key key, @required this.item})
      : assert(item != null),
        super(key: key);

  static const Color _backgroundColor = Colors.white;
  static const Color _titleColor = Color(0xff28A745);

  final CommentViewModel item;

  @override
  Widget build(BuildContext context) {
    return Provider<CommentViewModel>(
      create: (context) => item,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: _backgroundColor,
          border: Border.all(color: _backgroundColor),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildHeader(),
            _buildSummary(),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Expanded(
          child: Text(
            'Phiên ngày 19/09/2020 lúc 8h50',
            style: TextStyle(fontSize: 16, color: _titleColor),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.more_horiz),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Consumer<CommentViewModel>(
      builder: (context, vm, widget) {
        return Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color(0xffF5F6F7),
              ),
              padding: const EdgeInsets.only(right: 12),
              child: Row(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(
                              item.commentSetting.crmTeam.facebookUserAvatar ??
                                  '',
                            ),
                          ),
                          color: Colors.white,
                          border: Border.all(color: Colors.red, width: 5),
                        ),
                        height: 50,
                        width: 50,
                      ),
                      const Positioned(
                          bottom: 0,
                          right: 0,
                          child: SvgIcon(
                            SvgIcon.camera,
                            size: 15,
                          ))
                    ],
                  ),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Shop thời trang mùa hè 2020'),
                    ),
                  ),
                  const BlinkWidget(
                    interval: 1000,
                    children: <Widget>[
                      SvgIcon(
                        SvgIcon.liveStream,
                      ),
                      SvgIcon(
                        SvgIcon.liveStream,
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    vm.facebookPost.message ?? '',
                  ),
                ),
                SizedBox(
                  width: 120,
                  height: 80,
                  child: Image.network(vm.facebookPost.picture ?? ''),
                ),
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            Row(
              children: <Widget>[
                const SvgIcon(SvgIcon.message),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(vm.commentCount?.toString() ?? ''),
                ),
                const SizedBox(
                  width: 10,
                ),
                const SvgIcon(SvgIcon.share),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(vm.shareCount.toString()),
                ),
                const SizedBox(
                  width: 10,
                ),
                const SvgIcon(SvgIcon.order),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(vm.orderCount.toString()),
                ),
                const Spacer(),
                Text(
                  time_ago.format(vm.facebookPost.createdTime, locale: 'vi'),
                ),
              ],
            ),
            ButtonTheme(
              height: 35,
              child: Row(
                children: <Widget>[
                  const Spacer(),
                  RaisedButton(
                    color: const Color(0xffEBEDEF),
                    onPressed: () {},
                    child: const Text('Đóng phiên'),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  RaisedButton(
                    color: const Color(0xffEBEDEF),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return LiveSessionConfigPage(
                          commentSetting: vm.commentSetting,
                        );
                      }));
                    },
                    child: const Text('Cài đặt'),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  RaisedButton(
                    color: _titleColor,
                    textColor: Colors.white,
                    onPressed: () {},
                    child: const Text('Vào chốt đơn'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummary() {
    const TextStyle operateStyle = TextStyle(fontSize: 12, color: Colors.white);
    return Consumer<CommentViewModel>(builder: (context, vm, child) {
      return Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Row(
          children: <Widget>[
            if (vm.isLive)
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: const Color(0xff3B7AD9).withOpacity(0.7),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Expanded(
                    child: Text(
                      'Trực tiếp',
                      style: operateStyle,
                    ),
                  ),
                ),
              ),
            const SizedBox(
              width: 10,
            ),
            if (vm.commentSetting.autoCreateOrderConfig.enable)
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: const Color(0xff3B7AD9).withOpacity(0.7),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Expanded(
                    child: Text(
                      'Đơn tự động',
                      style: operateStyle,
                    ),
                  ),
                ),
              ),
            const SizedBox(
              width: 10,
            ),
            if (vm
                .commentSetting.hideCommentOnFacebookSetting.enableHideComment)
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: const Color(0xff3B7AD9).withOpacity(0.7),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Expanded(
                    child: Text(
                      'Tự ẩn comment',
                      style: operateStyle,
                    ),
                  ),
                ),
              ),
            // Tự động ẩn
          ],
        ),
      );
    });
  }
}
