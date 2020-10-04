import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/close_sale_online_order/models/comment_setting.dart';
import 'package:tpos_mobile/feature_group/close_sale_online_order/viewmodel/comment_viewmodel.dart';
import 'package:tpos_mobile/src/facebook_apis/src/models/facebook_post.dart';

abstract class LiveSessionListEvent {}

class LiveSessionListLoaded extends LiveSessionListEvent {}

class LiveSessionListClosed extends LiveSessionListEvent {}

class LiveSessionListAdded extends LiveSessionListEvent {
  final FacebookPost facebookPost;
  final CRMTeam CrmTeam;

  LiveSessionListAdded({this.facebookPost, this.CrmTeam});
}

abstract class LiveSessionListState {}

class LiveSessionListUnInitial extends LiveSessionListState {}

class LiveSessionListLoading extends LiveSessionListState {}

class LiveSessionListBusy extends LiveSessionListState {}

class LiveSessionListLoadSuccess extends LiveSessionListState {
  LiveSessionListLoadSuccess(this.sessions);
  final List<CommentViewModel> sessions;
}

class LiveSessionListLoadFailure extends LiveSessionListState {}

class LiveSessionBloc extends Bloc<LiveSessionListEvent, LiveSessionListState> {
  LiveSessionBloc({LiveSessionListState initialState}) : super(initialState);

  /// Cache active session on List
  final List<CommentViewModel> _sessions = <CommentViewModel>[];

  @override
  Stream<LiveSessionListState> mapEventToState(
      LiveSessionListEvent event) async* {
    if (event is LiveSessionListLoaded) {
      yield LiveSessionListLoadSuccess(_sessions);
    } else if (event is LiveSessionListAdded) {
      // Tạo mới CommentViewModel
      final CommentSetting newSetting = CommentSetting();
      newSetting.crmTeam = event.CrmTeam;
      newSetting.facebookPost = event.facebookPost;

      // Tạo mới CommentViewModel

      final CommentViewModel commentViewModel =
          CommentViewModel(commentSetting: newSetting);

      _sessions.add(commentViewModel);

      yield LiveSessionListLoadSuccess(_sessions);
    }
  }
}
