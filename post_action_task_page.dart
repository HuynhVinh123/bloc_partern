import 'package:fbpro_api/fbpro_api.dart';
import 'package:fbpro_web/helpers/dialog_helper.dart';
import 'package:fbpro_web/models/notify_message.dart';
import 'package:fbpro_web/pages/facebook_account/list/facebook_account_page.dart';
import 'package:fbpro_web/pages/facebook_group/list/facebook_groups_page.dart';
import 'package:fbpro_web/pages/facebook_tasks/facebook_task_helper.dart';
import 'package:fbpro_web/pages/facebook_tasks/post_action_task/type_reaction.dart';
import 'package:fbpro_web/services/notify_service/notify_service.dart';
import 'package:fbpro_web/widgets/widget_for_bloc/bloc_loading_screen.dart';
import 'package:fbpro_web/widgets/widget_for_bloc/bloc_ui_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tmt_flutter_untils/tmt_flutter_extensions.dart';

import 'package:tmt_flutter_ui/tmt_flutter_ui.dart';

import '../../../locator.dart';
import 'bloc/post_action_task_bloc.dart';
import 'bloc/post_action_task_event.dart';
import 'bloc/post_action_task_state.dart';

class PostActionTaskPage extends StatefulWidget {
  const PostActionTaskPage(
      {this.faceBookPostId, this.onRefresh, this.facebookAccount});
  final String faceBookPostId;
  final Function onRefresh;
  final FacebookAccount facebookAccount;
  @override
  _PostActionTaskPageState createState() => _PostActionTaskPageState();
}

class _PostActionTaskPageState extends State<PostActionTaskPage> {
  final PostActionTaskBloc _bloc = PostActionTaskBloc();

  final NotifyService _notify = locator<NotifyService>();

  bool isLike = false;
  bool isShare = false;
  bool onShowReaction = false;
  bool isShareGroup = false;
  bool isSharePerson = false;
  bool isShareFriend = false;
  bool isComment = false;
  bool isFirstLoad = true;
  bool isPost =
      false; // kiểm tra xem đã điền đúng link hoặc Id hay chưa. Hoặc nếu bỏ trống thì sẽ false
  FacebookAccount _facebookAccount;
  String linkFB = 'https://www.facebook.com/';
  DateTime _actionTime = DateTime.now();

  String typeShare = '';
  String titleShare = 'Chia sẻ đến';
  List<Map<String, dynamic>> _reactions = <Map<String, dynamic>>[];
  ReactionType _reactionType;
  Widget icon;
  ActionToPostTask _actionToPostTask;
  // FacebookGroup _facebookGroup;
  List<FacebookGroup> _faceBookGroups = <FacebookGroup>[];
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _postController = TextEditingController();
  final TextEditingController _groupController = TextEditingController();
  String idGroup;
  int checkNumber;

  @override
  void initState() {
    super.initState();
    if (widget.facebookAccount != null) {
      _facebookAccount = widget.facebookAccount;
    }
    if (widget.faceBookPostId != null) {
      isPost = true;
    }
    _reactions = reactions();
    _bloc.add(PostActionTaskLoaded(taskId: widget.faceBookPostId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocUiProvider<PostActionTaskBloc>(
      bloc: _bloc,
      listen: (dynamic state) {
        if (state is PostActionTaskSaveSuccess) {
          // ignore unnecessary_statements
          if (widget.onRefresh != null) {
            widget.onRefresh();
          }
          Navigator.pop(context);
          _notify.showNotify(
              NotifyMessage(title: state.title, message: state.message));
        } else if (state is PostActionTaskSaveFailure) {
          showError(context, state.message ?? 'Lỗi xử lý dữ liệu',
              title: state.title);
        }
      },
      // ignore: always_specify_types
      busyStates: const [PostActionTaskBusy],
      child: Scaffold(
        body: BlocLoadingScreen<PostActionTaskBloc>(
            busyStates: const <dynamic>[PostActionTaskInitial],
            child: BlocBuilder<PostActionTaskBloc, PostActionTaskState>(
                buildWhen: (PostActionTaskState prevState,
                    PostActionTaskState currState) {
              return currState is PostActionTaskLoadSuccess;
            }, builder: (BuildContext context, PostActionTaskState state) {
              if (state is PostActionTaskLoadSuccess) {
                return _buildBody(state);
              }
              return const SizedBox();
            })),
      ),
    );
  }

  Widget _buildBody(PostActionTaskLoadSuccess state) {
    if (state.actionToPostTask != null && isFirstLoad) {
      _actionToPostTask = state.actionToPostTask;
      final FacebookAccount facebookAccount = FacebookAccount();
      facebookAccount.id = state.actionToPostTask.facebookAccountId;
      facebookAccount.name = state.actionToPostTask.facebookName;
      facebookAccount.uid = state.actionToPostTask.facebookUid;
      facebookAccount.clientNodeId = state.actionToPostTask.clientId;
      _facebookAccount = facebookAccount;
      _postController.text = state.actionToPostTask.postUrl;
      // idGroup = state.actionToPostTask.postId;
      checkLinkPost( _postController.text );
      // _postController.text = checkNumber.toString();
      isLike = state.actionToPostTask.enableReaction;
      // Get type reacton
      final int positionReaction = _reactions.indexWhere(
          (Map<String, dynamic> element) =>
              (element['type'] as ReactionType).describe ==
              state.actionToPostTask.reaction.toLowerCase());

      _reactionType =
          isLike ? _reactions[positionReaction]['type'] : ReactionType.none;
      icon = isLike ? _reactions[positionReaction]['icon'] : null;
      isShare = state.actionToPostTask.enableShare;
      isShareGroup = state.actionToPostTask.enableShareGroup;
      _faceBookGroups = state.actionToPostTask.shareGroups;
      isSharePerson = state.actionToPostTask.enableShareWall;
      isShareFriend = state.actionToPostTask.enableShareFriendWall;
      isComment = state.actionToPostTask.enableComment;
      _commentController.text = state.actionToPostTask.commentMessage ?? '';
      _actionTime = state.actionToPostTask.actionTime;
      isFirstLoad = false;
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: _buildFacebookAccountButton(),
            ),
            Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              _buildDateButton(),
              _buildTimeButton(),
            ]),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 24),
              child: _buildActionOnPost(),
            )),
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
      if (_postController.text != '' && isPost) {
        ActionToPostTask actionToPostTask = ActionToPostTask();
        if (widget.faceBookPostId != null) {
          actionToPostTask = _actionToPostTask;
        }
        actionToPostTask.facebookAccountId = _facebookAccount.id;
        actionToPostTask.facebookUid = _facebookAccount.uid;
        actionToPostTask.facebookName = _facebookAccount.name;
        actionToPostTask.actionTime = _actionTime;
        actionToPostTask.clientId = _facebookAccount.clientNodeId;
        // dữ liệu thay đối đc trên UI
        actionToPostTask.postId =
            checkNumber != -1 ? checkNumber.toString() : idGroup;
        actionToPostTask.postUrl = checkNumber != -1
            ? linkFB + checkNumber.toString()
            : linkFB + idGroup;
        actionToPostTask.enableReaction = isLike;
        actionToPostTask.reaction =
            isLike ? _reactionType.describe : ReactionType.none.describe;
        actionToPostTask.enableShare = isShare;
        if (isShare) {
          actionToPostTask.enableShareGroup = isShareGroup;
        } else {
          actionToPostTask.enableShareGroup = false;
        }
        actionToPostTask.shareGroups =
            actionToPostTask.enableShareGroup ? _faceBookGroups : null;
        if (isShare) {
          actionToPostTask.enableShareWall = isSharePerson;
        } else {
          actionToPostTask.enableShareWall = false;
        }
        if (isShare) {
          actionToPostTask.enableShareFriendWall = isShareFriend;
        } else {
          actionToPostTask.enableShareFriendWall = false;
        }
        actionToPostTask.enableComment = isComment;
        actionToPostTask.commentMessage =
            isComment ? _commentController.text : '';
        actionToPostTask.lastUpdated = DateTime.now();
        actionToPostTask.clientNodeName = _facebookAccount.clientNodeName;
        if (widget.faceBookPostId != null) {
          _bloc.add(PostActionTaskUpdate(actionToPostTask: actionToPostTask));
        } else {
          _bloc.add(PostActionTaskSave(actionToPostTask: actionToPostTask));
        }
      } else {
        showInfo(context, '\'Bài viết\' không được để trống');
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
                  : checkNumber != -1
                      ? 'Link page:  $linkFB$checkNumber'
                      : 'Uid: $idGroup')
            ],
          ),
        ),
        // InkWell(
        //   onTap: () async {},
        //   child: Row(
        //     mainAxisSize: MainAxisSize.min,
        //     children: const [
        //       Text(
        //         'Chọn bài',
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

  /// Hoạt động like,commetn, on page
  Widget _buildActionOnPost() {
    return ListView(

      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Checkbox(
              value: isLike,
              onChanged: (bool value) {
                setState(() {
                  isLike = value;
                  onShowReaction = value;
                });
              },
            ),
            InkWell(
              child: Text(
                'Like',
                style: TextStyle(color: isLike ? Colors.blue : Colors.black),
              ),
              onTap: () {
                setState(() {
                  isLike = !isLike;
                  onShowReaction = !onShowReaction;
                });
              },
            ),
            Visibility(
                visible: isLike && icon != null, child: const Text('( ')),
            Visibility(
                visible: isLike && icon != null,
                child: icon ?? const SizedBox()),
            Visibility(
                visible: isLike && icon != null, child: const Text(' )')),
            const SizedBox(
              width: 24,
            ),
            Expanded(
              child: Visibility(
                visible: onShowReaction,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // ignore: always_specify_types
                  children: List.generate(
                      _reactions.length,
                      (int index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  onShowReaction = false;
                                  isLike = true;
                                  _reactionType = _reactions[index]['type'];
                                  icon = _reactions[index]['icon'];
                                });
                              },
                              child: _reactions[index]['icon'],
                            ),
                          )),
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        InkWell(
          onTap: () {
            setState(() {
              isShare = !isShare;
            });
          },
          child: Row(
            children: <Widget>[
              Checkbox(
                value: isShare,
                onChanged: (bool value) {
                  setState(() {
                    isShare = value;
                  });
                },
              ),
              const SizedBox(
                width: 8,
              ),
              const Text('Share'),
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Visibility(
            visible: isShare,
            child: Padding(
              padding: const EdgeInsets.only(left: 36),
              child: _buidlTypeShare(),
            )),
        Row(
          children: <Widget>[
            Checkbox(
              value: isComment,
              onChanged: (bool value) {
                setState(() {
                  isComment = value;
                });
              },
            ),
            const Text('Comment')
          ],
        ),
        Visibility(visible: isComment, child: _buildFormComment())
      ],
    );
  }

  Widget _buidlTypeShare() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Checkbox(
              value: isShareGroup,
              onChanged: (bool value) {
                setState(() {
                  isShareGroup = value;
                });
              },
            ),
            InkWell(
                onTap: () async {
                  isShareGroup = !isShareGroup;
                  if (isShareGroup) {
                    await selectGroup();
                  }

                  setState(() {});
                },
                child: const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Text('Share lên nhóm'),
                )),
            const SizedBox(
              width: 8,
            ),
            Visibility(
              visible: isShareGroup,
              child: const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Icon(Icons.arrow_right),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: Visibility(
              visible: isShareGroup,
              child: _faceBookGroups.isEmpty
                  ? _buildAddGroupById()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                          const SizedBox(
                            height: 4,
                          ),
                          // ignore: always_specify_types
                          ...List.generate(
                            _faceBookGroups.length,
                            (int index) => Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    '${_faceBookGroups[index].facebookId ?? ""} - ${_faceBookGroups[index].name ?? ''}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _faceBookGroups.removeAt(index);
                                    });
                                  },
                                  child: Container(
                                      width: 25,
                                      height: 25,
                                      child: const Center(
                                          child: Icon(
                                        Icons.close,
                                        size: 18,
                                      ))),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          _buildAddGroupById()
                        ]),
            )),
            Visibility(
              visible: isShareGroup,
              child: InkWell(
                onTap: () {
                  selectGroup();
                },
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    margin: const EdgeInsets.only(top: 6),
                    height: 25,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.grey[300]),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const <Widget>[
                        Icon(
                          Icons.add,
                          size: 18,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text('Thêm nhóm')
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        Row(
          children: <Widget>[
            Checkbox(
              value: isSharePerson,
              onChanged: (bool value) {
                setState(() {
                  isSharePerson = value;
                });
              },
            ),
            InkWell(
                onTap: () {
                  setState(() {
                    isSharePerson = !isSharePerson;
                  });
                },
                child: const Text('Share lên tường'))
          ],
        ),
        Row(
          children: <Widget>[
            Checkbox(
              value: isShareFriend,
              onChanged: (bool value) {
                setState(() {
                  isShareFriend = value;
                });
              },
            ),
            InkWell(
                onTap: () {
                  setState(() {
                    isShareFriend = !isShareFriend;
                  });
                },
                child: const Text('Chia sẻ lên trang cá nhân của bạn bè'))
          ],
        )
      ],
    );
  }

  Widget _buildAddGroupById() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(child: _buildFormAddGroup()),
        InkWell(
          onTap: () {
            if (_groupController.text != '') {
              final int check = int.parse(_groupController.text,
                  onError: (String value) => -1);
              if (check != -1) {
                final FacebookGroup group = FacebookGroup();
                group.facebookId = check.toString();
                _faceBookGroups.add(group);
                _groupController.clear();
                setState(() {});
              } else {
                final bool _validURL =
                    Uri.parse(_groupController.text).isAbsolute;
                if (_validURL) {
                  final List<String> spilits =
                      _groupController.text.trim().split('/');
                  if (spilits.isNotEmpty) {
                    if (spilits[spilits.length - 1] != '') {
                      idGroup = spilits[spilits.length - 1];
                    } else {
                      idGroup = spilits[spilits.length - 2];
                    }
                    final int checkId =
                        int.parse(idGroup, onError: (String source) => -1);
                    if (checkId != -1) {
                      final FacebookGroup group = FacebookGroup();
                      group.facebookId = checkId.toString();
                      _faceBookGroups.add(group);
                      _groupController.clear();
                      setState(() {});
                    } else {
                      showError(context, 'Đường link không chính xác!');
                    }
                  }
                } else {
                  showError(context, 'Đường link không chính xác!');
                }
              }
            }
          },
          child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              width: 25,
              height: 25,
              child: const Center(
                  child: Icon(
                Icons.add,
                color: Colors.green,
                size: 18,
              ))),
        ),
      ],
    );
  }

  Future<void> selectGroup() async {
    final FacebookGroup group = await Navigator.push(
      context,
      MaterialPageRoute<FacebookGroup>(
        builder: (BuildContext context) {
          return const FacebookGroupsPage(
            selectMode: true,
          );
        },
      ),
    );
    if (group != null)
      setState(() {
        final bool isExist = _faceBookGroups.any(
            (FacebookGroup element) => element.facebookId == group.facebookId);
        if (!isExist) {
          // PostActionTaskGroup actionTaskGroup = PostActionTaskGroup();
          // actionTaskGroup.id = group.facebookId;
          // actionTaskGroup.name = group.name;
          _faceBookGroups.add(group);
        }
      });
  }

  Widget _buildFormComment() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey)),
      child: TextField(
          controller: _commentController,
          maxLines: null,
          decoration: const InputDecoration.collapsed(
              hintText: 'Nhập nội dung comment')),
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
          onSubmitted: (String value) {
            checkLinkPost(value);
            setState(() {

            });
          },
          controller: _postController,
          maxLines: 1,
          decoration: const InputDecoration.collapsed(
              hintText: 'Nhập Id hoặc link bài viết')),
    );
  }


  void checkLinkPost(String value){
    if (value != '') {
      checkNumber = int.parse(value, onError: (String value) => -1);
      if (checkNumber != -1) {
        isPost = true;
      } else {
        final bool _validURL = Uri.parse(value).isAbsolute;
        if (_validURL) {
          final List<String> spilits = value.trim().split('/');
          if (spilits.isNotEmpty) {
            if (spilits[spilits.length - 1] != '') {
              idGroup = spilits[spilits.length - 1];
            } else {
              idGroup = spilits[spilits.length - 2];
            }
            final int checkId =
            int.parse(idGroup, onError: (String source) => -1);
            if (checkId != -1) {
              isPost = true;
            } else {
              isPost = false;
              showError(context, 'Đường link không chính xác!');
            }
          }
        } else {
          isPost = false;
          showError(context, 'Đường link không chính xác!');
        }
      }
    }
  }

  Widget _buildFormAddGroup() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(3),color: Colors.grey[100]),
      child: TextField(
          controller: _groupController,
          maxLines: null,
          decoration: const InputDecoration.collapsed(hintText: 'Nhập Id group hoặc link')),
    );
  }
}
