import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:fbpro_api/fbpro_api.dart';
import 'package:fbpro_web/helpers/dialog_helper.dart';
import 'package:fbpro_web/pages/facebook_account/list/facebook_account_page.dart';
import 'package:fbpro_web/pages/facebook_tasks/post_status_to_new_feed_task/post_status_to_new_feed_task_add_edit_bloc.dart';
import 'package:fbpro_web/widgets/widget_for_bloc/bloc_ui_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tmt_flutter_untils/tmt_flutter_extensions.dart';
import 'package:tmt_flutter_ui/tmt_flutter_ui.dart';
import 'package:fbpro_web/extensions/status_privacy_extensions.dart';

class PostStatusToNewFeedTaskAddEditPage extends StatefulWidget {
  const PostStatusToNewFeedTaskAddEditPage(
      {Key key, this.hideAppbar = false, this.facebookAccount})
      : super(key: key);
  final bool hideAppbar;
  final FacebookAccount facebookAccount;

  @override
  _PostStatusToNewFeedTaskAddEditPageState createState() =>
      _PostStatusToNewFeedTaskAddEditPageState();
}

class _PostStatusToNewFeedTaskAddEditPageState
    extends State<PostStatusToNewFeedTaskAddEditPage> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  StatusPrivacyType _statusPrivacyType = StatusPrivacyType.none;
  FacebookAccount _facebookAccount;
  DateTime _actionTime = DateTime.now();
  final List<String> _photos = <String>[];
  final PostSatusToNewFeedAddEditBloc _bloc = PostSatusToNewFeedAddEditBloc();
  List<String> imageLinks = ["https://tse1.mm.bing.net/th?id=OIP.wx64GmJDu2nd32eO_tieDgHaEK&pid=Api&P=0&w=326&h=184","https://tse1.mm.bing.net/th?id=OIP.wx64GmJDu2nd32eO_tieDgHaEK&pid=Api&P=0&w=326&h=184","https://tse1.mm.bing.net/th?id=OIP.wx64GmJDu2nd32eO_tieDgHaEK&pid=Api&P=0&w=326&h=184"];
  @override
  void initState() {
    _facebookAccount = widget.facebookAccount;
    super.initState();
  }

  void _handleSave() {
    _bloc.add(
      PostStatusToNewFeedSave(
          facebookAccount: _facebookAccount,
          actionTime: _actionTime,
          statusPrivacyType: _statusPrivacyType,
          message: _messageController.text.trim(),
          link: _linkController.text.trim(),
          photos: _photos),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocUiProvider<PostSatusToNewFeedAddEditBloc>(
      bloc: _bloc,
      busyStates: const [PostStatusToNewFeedBusy],
      child: Scaffold(
        appBar: widget.hideAppbar
            ? null
            : AppBar(title: const Text('Tạo bài viết & Đăng lên tường')),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildPrivacySelectButton() {
    return PopupMenuButton(
      child: PopupMenuButtonContent(
        title: Text(_statusPrivacyType.title),
        icon: _statusPrivacyType.icon,
      ),
      onSelected: (value) {
        setState(() {
          _statusPrivacyType = value;
        });
      },
      itemBuilder: (BuildContext context) {
        return StatusPrivacyType.values
            .map(
              (StatusPrivacyType e) => PopupMenuItem<StatusPrivacyType>(
                child: PopupMenuItemContent(
                  title: Text(e.title),
                  icon: e.icon,
                  isSelected: _statusPrivacyType == e,
                ),
                value: e,
              ),
            )
            .toList();
      },
    );
  }

  Widget _buildDateButton() {
    return FlatButton.icon(
      icon: const Icon(Icons.date_range),
      label: Text(_actionTime.toStringFormat('dd/MM/yyyy')),
      onPressed: () async {
        final DateTime selectedDate = await showDatePicker(
          context: context,
          firstDate: DateTime.now(),
          currentDate: _actionTime,
          lastDate: DateTime.now().add(
            const Duration(days: 99),
          ),
          initialDate: _actionTime,
        );
        if (selectedDate != null) {
          setState(() {
            _actionTime = _actionTime.changeDate(selectedDate);
          });
        }
      },
    );
  }

  Widget _buildTimeButton() {
    return FlatButton.icon(
      icon: const Icon(Icons.timelapse),
      label: Text(_actionTime.toStringFormat('HH:mm')),
      onPressed: () async {
        final TimeOfDay selectedTime = await showTimePicker(
          initialTime: TimeOfDay.fromDateTime(_actionTime),
          context: context,
        );

        if (selectedTime != null) {
          setState(() {
            _actionTime = _actionTime.changeTime(selectedTime);
          });
        }
      },
    );
  }

  Widget _buildFacebookAccountButton() {
    return InkWell(
      child: Row(
        children: [
          Text(
            _facebookAccount?.name ?? 'Chọn tài khoản',
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
          if (_facebookAccount != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Đổi",
                style: TextStyle(color: Colors.blue),
              ),
            ),
        ],
      ),
      onTap: () async {
        final account = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return FacebookAccountPage(
                onlyActive: true,
                selectMode: true,
              );
            },
          ),
        );

        if (account != null) {
          setState(() {
            _facebookAccount = account;
          });
        }
      },
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                child: Text(_facebookAccount?.name?.substring(0, 1) ?? "F"),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFacebookAccountButton(),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    _buildPrivacySelectButton(),
                    const SizedBox(
                      width: 10,
                    ),
                    _buildDateButton(),
                    _buildTimeButton(),
                  ]),
                ],
              )
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: LayoutBuilder(
                builder:(layout,setStatte)=> Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeTextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: "Bạn muốn đăng cái gì nào?",
                        border: InputBorder.none,
                      ),
                      maxFontSize: 32,
                      minFontSize: 12,
                      stepGranularity: 4,
                      style: const TextStyle(fontSize: 16),
                      //presetFontSizes: [30, 20, 12],
                      maxLines: null,
                    ),
                    Wrap(
                      children: List.generate(imageLinks.length, (index) => Container(
                        width: constraints.maxWidth/(imageLinks.length==1 ?1:2),
                        height: constraints.maxWidth/(imageLinks.length==1 ?1:2),
                        child: Stack(
                          alignment: AlignmentDirectional.bottomStart,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey)),
                              width: constraints.maxWidth/(imageLinks.length==1 ?1:2),
                              height: constraints.maxWidth/(imageLinks.length==1 ?1:2),
                              child: Center(
                                  child: Image.network(
                                    constraints,
                                    width: constraints.maxWidth/(imageLinks.length==1 ?1:2),
                                    height: constraints.maxWidth/(imageLinks.length==1 ?1:2),
                                    fit: BoxFit.fill,
                                  )
                              ),
                            ),
                            if(imageLinks.length >4 && index>=4)
                                Container(
                                 width:  constraints.maxWidth/(imageLinks.length==1 ?1:2),
                                 color: Colors.white24,
                               )
                              ,
                              Visibility(
                                visible:true,
                                child: Positioned(
                                  top: -10,
                                  right: -8,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      size: 20,
                                    ),
                                    onPressed: () {

                                    },
                                  ),
                                ),
                              )
                          ],
                        ),
                      );)
                    )
                  ],
                ),
              ),
            ),
          ),

          // Link trong bài viết

          if (_linkController.text.isNotEmpty)
            _Link(
              link: _linkController.text.trim(),
              onDeleted: () {
                setState(() {
                  _linkController.clear();
                });
              },
            ),

          _AddToPostContent(
            onLinkPressed: () async {
              await showInputStringDialog(
                context: context,
                controller: _linkController,
              );
              setState(() {});
            },
          ),

          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            child: RaisedButton(
              child: const Text("ĐĂNG"),
              onPressed: () => _handleSave(),
              color: Colors.blue,
              textColor: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}

class _PrivacyButton extends StatelessWidget {
  const _PrivacyButton({Key key, this.onPressed, this.title, this.icon})
      : super(key: key);
  final VoidCallback onPressed;
  final String title;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Row(
            children: [
              IconTheme(
                child: icon,
                data: const IconThemeData(size: 14),
              ),
              const SizedBox(
                width: 5,
              ),
              DefaultTextStyle(
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                child: Text(title),
              ),
              const SizedBox(
                width: 5,
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddToPostContent extends StatelessWidget {
  const _AddToPostContent({Key key, this.onLinkPressed}) : super(key: key);
  final VoidCallback onLinkPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade400),
      ),
      padding: EdgeInsets.all(5),
      child: Row(
        children: [
          const Text(
            "Thêm vào bài viết",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          const IconButton(
            icon: Icon(FontAwesomeIcons.smile),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.image),
            color: Colors.white,
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Chọn từ thư viện'),
              ),
              PopupMenuItem(
                child: Text('Từ link'),
              ),
              PopupMenuItem(
                child: Text('Tải lên từ máy tính'),
              )
            ],
          ),
          IconButton(
            icon: const Icon(Icons.link),
            color: Colors.green,
            onPressed: onLinkPressed,
          )
        ],
      ),
    );
  }
}

class _Link extends StatelessWidget {
  const _Link({Key key, this.link = '', this.onDeleted}) : super(key: key);
  final String link;
  final VoidCallback onDeleted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey,
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Chip(
          onDeleted: onDeleted,
          label: Text(link),
        ),
      ),
    );
  }
}

class _ImageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(),
    );
  }
}
