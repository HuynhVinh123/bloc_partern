import 'package:fbpro_api/fbpro_api.dart';
import 'package:fbpro_web/pages/facebook_command/facebook_command_bloc.dart';
import 'package:fbpro_web/pages/facebook_tasks/post_status_to_group/facebook_post_to_group_add_edit_page.dart';
import 'package:fbpro_web/pages/facebook_tasks/post_status_to_new_feed_task/facebook_task_add_select_type_page.dart';
import 'package:fbpro_web/widgets/window/window_wrapper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<void> showAddDeviceTaskSelect(BuildContext context,
    {FacebookAccount facebookAccount,
    FacebookGroup facebookGroup,
    Function onRefresh,
    String faceBookPostId}) async {
  await showDialog(
      context: context,
      builder: (BuildContext context) {
        return WindowWrapper(
          width: 999,
          title: const Text('Bạn muốn thêm nhiệm vụ nào?'),
          child: FacebookTaskAddSelectTypePage(
            facebookAccount: facebookAccount,
            facebookGroup: facebookGroup,
            onRefresh: onRefresh,
            faceBookPostId: faceBookPostId,
          ),
        );
      });
}

Future<void> showEditDeviceTask(BuildContext context,
    {FacebookAccount facebookAccount,
    FacebookGroup facebookGroup,
    Function onRefresh,
    String faceBookPostId,
    String type}) async {
  if (type == DeviceTaskType.POST_STATUS_TO_NEW_FEED.describe) {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return WindowWrapper(
            width: 700,
            title: const Text('Tạo bài viết và đăng lên tường'),
            child: FacebookPostToGroupAddEditPage(
              hideAppbar: true,
              facebookAccount: facebookAccount,
              isPostToGroup: false,
              onRefresh: onRefresh,
              faceBookPostId: faceBookPostId,
            ),
          );
        });
  } else if (type == DeviceTaskType.POST_STATUS_TO_GROUP.describe) {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return WindowWrapper(
            width: 700,
            title: const Text('Tạo bài viết và đăng lên nhóm'),
            child: FacebookPostToGroupAddEditPage(
              hideAppbar: true,
              facebookAccount: facebookAccount,
              onRefresh: onRefresh,
              faceBookPostId: faceBookPostId,
            ),
          );
        });
  }
}

List<String> getTypeFacebooks() {
  final List<String> typeFacebooks = [];
  typeFacebooks.add(DeviceTaskType.OPEN_FACEBOOK.describe);
  typeFacebooks.add(DeviceTaskType.CLOSE_FACEBOOK.describe);
  typeFacebooks.add(DeviceTaskType.OPEN_DEVICE.describe);
  typeFacebooks.add(DeviceTaskType.CLOSE_DEVICE.describe);
  typeFacebooks.add(DeviceTaskType.POST_STATUS_TO_NEW_FEED.describe);
  typeFacebooks.add(DeviceTaskType.POST_STATUS_TO_GROUP.describe);
  typeFacebooks.add(DeviceTaskType.COMMENT_TO_POST.describe);
  return typeFacebooks;
}

FacebookCommandType getTypeByKey(String type) {
  switch (type) {
    case 'OPEN_FACEBOOK':
      return FacebookCommandType.OPEN_FACEBOOK;
    case 'CLOSE_FACEBOOK':
      return FacebookCommandType.CLOSE_FACEBOOK;

    case 'OPEN_DEVICE':
      return FacebookCommandType.OPEN_DEVICE;
    case 'CLOSE_DEVICE':
      return FacebookCommandType.CLOSE_DEVICE;
    case 'POST_STATUS_TO_NEW_FEED':
      return FacebookCommandType.POST_STATUS_TO_NEW_FEED;
    case 'POST_STATUS_TO_GROUP':
      return FacebookCommandType.POST_STATUS_TO_GROUP;
    default:
      return FacebookCommandType.COMMENT_TO_POST;
  }
}



List<FacebookCommandStatus> getFacebookCommandStatuss(){
  List<FacebookCommandStatus> states = [];

  states.add(FacebookCommandStatus.IDLE);
  states.add(FacebookCommandStatus.RUNNING);
  // states.add(FacebookCommandStatus.RETRYING);
  states.add(FacebookCommandStatus.ERROR);
  states.add(FacebookCommandStatus.DONE);
  // states.add(FacebookCommandStatus.TIME_OUT);
  states.add(FacebookCommandStatus.EXPIRED);
  states.add(FacebookCommandStatus.CANCELED);
  return states;
}
