import 'package:fbpro_api/fbpro_api.dart';
import 'package:fbpro_web/helpers/dialog_helper.dart';
import 'package:fbpro_web/models/notify_message.dart';
import 'package:fbpro_web/pages/facebook_account/list/facebook_account_page.dart';
import 'package:fbpro_web/pages/facebook_tasks/post_action_task/bloc/post_action_task_bloc.dart';
import 'package:fbpro_web/services/notify_service/notify_service.dart';
import 'package:fbpro_web/widgets/widget_for_bloc/bloc_loading_screen.dart';
import 'package:fbpro_web/widgets/widget_for_bloc/bloc_ui_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmt_flutter_untils/tmt_flutter_extensions.dart';

import '../../../locator.dart';
import 'bloc/add_new_friend_bloc.dart';
import 'bloc/add_new_friend_event.dart';
import 'bloc/add_new_friend_state.dart';

class AddNewFriendTaskPage extends StatefulWidget {
  const AddNewFriendTaskPage(
      {this.faceBookPostId, this.onRefresh, this.facebookAccount});
  final String faceBookPostId;
  final Function onRefresh;
  final FacebookAccount facebookAccount;
  @override
  _AddNewFriendTaskPageState createState() => _AddNewFriendTaskPageState();
}

class _AddNewFriendTaskPageState extends State<AddNewFriendTaskPage> {
  final AddNewFriendBloc _bloc = AddNewFriendBloc();

  final NotifyService _notify = locator<NotifyService>();

  FacebookAccount _facebookAccount;

  String linkFB = 'https://www.facebook.com/';
  DateTime _actionTime = DateTime.now();
  String _userName ;
  String _nameFacebook;
  bool isFriendName = false;
  AddNewFriend _addNewFriend;
  // FacebookGroup _facebookGroup;
  final TextEditingController _postController = TextEditingController();
  String idGroup;
  int checkNumber;
  bool isFirstLoad = true;
  String _uid;
  String titleLink = '';

  @override
  void initState() {
    super.initState();
    if (widget.facebookAccount != null) {
      _facebookAccount = widget.facebookAccount;
    }
    _bloc.add(AddNewFriendLoaded(taskId: widget.faceBookPostId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocUiProvider<AddNewFriendBloc>(
      bloc: _bloc,
      listen: (dynamic state) {
        if (state is AddNewFriendSaveSuccess) {
          // ignore unnecessary_statements
          if (widget.onRefresh != null) {
            widget.onRefresh();
          }
          Navigator.pop(context);
          _notify.showNotify(
              NotifyMessage(title: state.title, message: state.message));
        } else if (state is AddNewFriendSaveFailure) {
          showError(context, state.message ?? 'Lỗi xử lý dữ liệu',
              title: state.title);
        }
      },
      // ignore: always_specify_types
      busyStates: const [AddNewFriendBusy],
      child: Scaffold(
        body: BlocLoadingScreen<AddNewFriendBloc>(
            busyStates: const <dynamic>[AddNewFriendInitial],
            child: BlocBuilder<AddNewFriendBloc, AddNewFriendState>(buildWhen:
                (AddNewFriendState prevState, AddNewFriendState currState) {
              return currState is AddNewFriendLoadSuccess;
            }, builder: (BuildContext context, AddNewFriendState state) {
              if (state is AddNewFriendLoadSuccess) {
                return _buildBody(state);
              }
              return const SizedBox();
            })),
      ),
    );
  }

  Widget _buildBody(AddNewFriendLoadSuccess state) {
    if (widget.faceBookPostId != null) {
      if (state.addNewFriend != null && isFirstLoad) {
        _addNewFriend = state.addNewFriend;
        final FacebookAccount facebookAccount = FacebookAccount();
        facebookAccount.id = state.addNewFriend.facebookAccountId;
        facebookAccount.name = state.addNewFriend.facebookName;
        facebookAccount.uid = state.addNewFriend.facebookUid;
        facebookAccount.clientNodeId = state.addNewFriend.clientId;
        _facebookAccount = facebookAccount;
        // handleGetLinkFb(_postController.text);
        if(state.addNewFriend.username != null && state.addNewFriend.username != ''){
            _userName = state.addNewFriend.username;
            checkNumber = -1;
            titleLink = 'UserName: ';
        }else if(state.addNewFriend.friendUid != null && state.addNewFriend.friendUid != ''){
          _uid = state.addNewFriend.friendUid;
          checkNumber = -1;
          titleLink = 'Uid: ';
        }
        _postController.text = state.addNewFriend.url;
        _actionTime = state.addNewFriend.actionTime;
        isFirstLoad = false;
      }
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: _buildFacebookAccountButton(),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.topLeft,
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  _buildDateButton(),
                  _buildTimeButton(),
                ]),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  child: const Text('XÁC NHẬN'),
                  onPressed: () {
                    handleSave();
                  },
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void handleSave() {
    if (_facebookAccount == null) {
      showInfo(context, '\'Người dùng\' không được để trống');
    } else {
      if (_postController.text != '') {
        AddNewFriend addNewFriend = AddNewFriend();
        if (widget.faceBookPostId != null) {
          addNewFriend = _addNewFriend;
        }
        addNewFriend.facebookAccountId = _facebookAccount.id;
        addNewFriend.facebookUid = _facebookAccount.uid;
        addNewFriend.facebookName = _facebookAccount.name;
        addNewFriend.actionTime = _actionTime;
        addNewFriend.clientId = _facebookAccount.clientNodeId;
        addNewFriend.clientNodeName = _facebookAccount.clientNodeName;
        addNewFriend.lastUpdated = DateTime.now();
        //Facebook post
        addNewFriend.username = _userName;
        addNewFriend.friendUid = _uid;
        addNewFriend.url = '$linkFB${_uid ?? _userName ?? _nameFacebook}';

        if (widget.faceBookPostId != null) {
          _bloc.add(AddNewFriendUpdated(addNewFriend: addNewFriend));
        } else {
          _bloc.add(AddNewFriendSave(addNewFriend: addNewFriend));
        }
      } else {
        showInfo(context, '\'Tài khoản\' không được để trống');
      }
    }
  }

  Widget _buildFacebookAccountButton() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        InkWell(
          onTap: () async {
            final dynamic account = await Navigator.push(
              context,
              MaterialPageRoute<dynamic>(
                builder: (BuildContext context) {
                  return const FacebookAccountPage(
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                _facebookAccount != null
                    ? _facebookAccount.name
                    : 'Chọn tài khoản',
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
              // if (_facebookAccount != null)
              Visibility(
                visible: _facebookAccount != null,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Đổi',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Text(' | '),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: 8,
              ),
              _buildFormID(),
              Text(_postController.text == ''
                  ? ''
                  : '$titleLink ${checkNumber != -1 ? linkFB :''}${_uid ?? _userName ?? _nameFacebook ?? ''}')
            ],
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        // InkWell(
        //   onTap: () async {},
        //   child: Row(
        //     mainAxisSize: MainAxisSize.min,
        //     children: const <Widget>[
        //       Text(
        //         'Tìm kiếm',
        //         style:
        //             TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        //       ),
        //       SizedBox(
        //         width: 4,
        //       ),
        //       Icon(
        //         Icons.cloud_upload_outlined,
        //         size: 18,
        //       )
        //     ],
        //   ),
        // ),
      ],
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

  Widget _buildFormID() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.grey[200]),
      child: TextField(
          controller: _postController,
          maxLines: 1,
          decoration: const InputDecoration.collapsed(
              hintText: 'Nhập id, link hoặc username'),
          onSubmitted: (String value){
            handleGetLinkFb(value);
            setState(() {});
          },
      ),
    );
  }

  void handleGetLinkFb(String value) {
    isFriendName = false;
    _userName = null;
    _uid = null;
    _nameFacebook = null;
    if (value != '') {
      checkNumber = int.parse(value, onError: (String value) => -1);
      if (checkNumber != -1) {
        titleLink = 'Link: ';
        _uid = checkNumber.toString() ;
        // setState(() {});
      } else {
        final bool _validURL = Uri.parse(value).isAbsolute;
        if (_validURL) {
          if (value.contains('id=')) {
            titleLink = 'Uid: ';
            isFriendName = false;
            final List<String> spilits = value.trim().split('id=');
            if (spilits.isNotEmpty) {
              _uid = spilits[spilits.length - 1];
              // setState(() {});
            }
          } else {
            titleLink = 'Name: ';
            isFriendName = true;
            final List<String> spilits = value.trim().split('/');
            if (spilits.isNotEmpty) {
              if (spilits[spilits.length - 1] != '') {
                _nameFacebook = spilits[spilits.length - 1];
              } else {
                _nameFacebook = spilits[spilits.length - 2];
              }

              // setState(() {});
            }
          }
        } else {
          if (!value.contains('facebook')) {
            titleLink = 'Link: ';
            checkNumber = 0;
            isFriendName = true;
            _userName = value;
          } else {
            showError(context, 'Đường link không chính xác!');
          }
        }
      }
    }
  }
}
