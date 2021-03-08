import 'package:facebook_api_client/facebook_api_client.dart';
import 'package:tpos_mobile/extensions.dart';
import 'package:tpos_mobile/feature_group/close_sale_online_order/models/comment_setting.dart';

bool checkHideComment(
    FacebookComment comment, List<HideCommentCondition> conditions) {
  assert(conditions != null);
  bool isHideThisComment = false;
  final String message = comment.message;
  if (conditions.isNotEmpty) {
    for (final condition in conditions) {
      if (condition.field == 'message') {
        isHideThisComment = checkHideCommentMessageField(message, condition);
        if (isHideThisComment) {
          break;
        }
      } else if (condition.field == 'messageLength') {
        isHideThisComment = checkHideCommentMesssageLength(message, condition);
        if (isHideThisComment) {
          break;
        }
      }
    }
  }

  return isHideThisComment;
}

/// Xác định [comment.message] có khớp với điều kiện ẩn hay không

bool checkHideCommentMessageField(
    String message, HideCommentCondition condition) {
  bool isHideThisComment = false;
  switch (condition.operator) {
    case HideCommentOperator.contain:
      if (condition.value == '@phone') {
        isHideThisComment = message.isContainPhone();
        break;
      } else if (condition.value == '@email') {
        isHideThisComment = message.isContainEmail();
        break;
      }
      isHideThisComment = message.contains(condition.value);
      break;
    case HideCommentOperator.doesNotContain:
      if (condition.value == '@phone') {
        isHideThisComment = !message.isContainPhone();
        break;
      } else if (condition.value == '@email') {
        isHideThisComment = !message.isContainEmail();
        break;
      }

      isHideThisComment = !message.contains(condition.value);
      break;
    case HideCommentOperator.equal:
      if (condition.value == '@phone' || condition.value == '@email') {
        throw Exception('Not support hide comment equal @phone or @email');
      }

      isHideThisComment = message == condition.value;
      break;
    default:
      throw Exception('Not support hide comment for this condition');
  }

  return isHideThisComment;
}

// Xác định [message] có độ dài khớp với [condition] hay không

bool checkHideCommentMesssageLength(
    String message, HideCommentCondition condition) {
  assert(condition.field == 'messageLength');
  assert(condition.operator == HideCommentOperator.less ||
      condition.operator == HideCommentOperator.lessOrEqual ||
      condition.operator == HideCommentOperator.greater ||
      condition.operator == HideCommentOperator.greaterOrEqual);
  bool isHideThisComment = false;
  switch (condition.operator) {
    case HideCommentOperator.greater:
      isHideThisComment = message.length > condition.value;
      break;
    case HideCommentOperator.greaterOrEqual:
      isHideThisComment = message.length >= condition.value;
      break;
    case HideCommentOperator.less:
      isHideThisComment = message.length < condition.value;
      break;
    case HideCommentOperator.lessOrEqual:
      isHideThisComment = message.length <= condition.value;
      break;
    default:
      throw Exception('not support hide comment for this operation');
  }
  return isHideThisComment;
}
