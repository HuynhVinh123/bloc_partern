import 'package:flutter/foundation.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_command.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/services/log_services/log_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/facebook_share_info.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_api.dart';

class FacebookPostShareListViewModel extends ViewModel {
  FacebookPostShareListViewModel(
      {ITposApiService tposApi, LogService logService})
      : super(logService: logService) {
    _tposApi = tposApi ?? locator<ITposApiService>();
  }

  ITposApiService _tposApi;
  String _facebookPostId;
  String _facebookUserOrPageId;

  bool isAutoClose = false;
  CRMTeam _crmTeam;

  void init(
      {@required String postId,
      String pageId,
      bool isAutoClose,
      @required CRMTeam crmTeam}) {
    assert(postId != null);
    _facebookPostId = postId;
    _facebookUserOrPageId = pageId;
    this.isAutoClose = isAutoClose;
    _crmTeam = crmTeam;

    _initCommand = ViewModelCommand(
        name: "Init", executeFunction: (param) => _initCommandAction());

    _refreshCommand = ViewModelCommand(
        name: "Refresh", executeFunction: (param) => _initCommandAction());
  }

  ViewModelCommand _initCommand;
  ViewModelCommand _refreshCommand;
  List<FacebookShareInfo> _facebookShares;
  List<FacebookShareCount> _facebookShareCounts;

  ViewModelCommand get initCommand => _initCommand;

  ViewModelCommand get refreshCommand => _refreshCommand;

  List<FacebookShareCount> get facebookShareCounts => _facebookShareCounts;

  int get shareCount => _facebookShares?.length ?? 0;

  int get userCount => _facebookShareCounts?.length ?? 0;

  int postCount = 0;

  int groupCount = 0;

  Future<void> _initCommandAction() async {
    onStateAdd(true, message: "Đang tải dữ liệu...");
    try {
      await _loadShares();
    } catch (e, s) {
      logger.error("", e, s);
      onDialogMessageAdd(OldDialogMessage.error("", "", error: e));
    }
    notifyListeners();
    onStateAdd(false);
  }

  Future<void> _loadShares() async {
    groupCount = 0;
    postCount = 0;
    _facebookShares = await _tposApi.getSharedFacebook(
        _facebookPostId, _facebookUserOrPageId,
        mapUid: true, teamId: _crmTeam?.id);

    _facebookShareCounts = <FacebookShareCount>[];
    // ignore: avoid_function_literals_in_foreach_calls
    _facebookShares.forEach(
      (value) {
        final FacebookShareCount existUser = _facebookShareCounts.firstWhere(
            (f) => f.facebookUid == value.from.id,
            orElse: () => null);

        if (existUser != null) {
          if (value.permalinkUrl != null) {
            if (value.permalinkUrl.contains("/groups/")) {
              groupCount += 1;
              existUser.countGroup += 1;
            } else if (value.permalinkUrl.contains("/posts/")) {
              postCount += 1;
              existUser.count += 1;
            }
          }
          existUser.details.add(value);
        } else {
          final FacebookShareCount facebookShareCount = FacebookShareCount(
              count: 0,
              countGroup: 0,
              avatarLink: value.from.pictureLink,
              name: value.from.name,
              facebookUid: value.from.id,
              permalinkUrl: value.permalinkUrl,
              details: <FacebookShareInfo>[value]);
          if (value.permalinkUrl != null) {
            if (value.permalinkUrl.contains("/groups/")) {
              groupCount += 1;
              facebookShareCount.countGroup = 1;
              facebookShareCount.count = 0;
            } else if (value.permalinkUrl.contains("/posts/")) {
              postCount += 1;
              facebookShareCount.count = 1;
              facebookShareCount.countGroup = 0;
            }

            _facebookShareCounts.add(facebookShareCount);
          }
        }
      },
    );

    _facebookShareCounts.sort((a, b) => a.count.compareTo(b.count));
    _facebookShareCounts = _facebookShareCounts.reversed.toList();
  }

  void sortListByTotal() {
    _facebookShareCounts.sort((a, b) {
      final sort1 = b.totalCount.compareTo(a.totalCount);
      final sort2 = b.countGroup.compareTo(a.countGroup);
      if (sort1 != 0) {
        return sort1;
      }

      return sort2;
    });

    notifyListeners();
  }

  void sortListByGroup() {
    _facebookShareCounts.sort((a, b) {
      var sort1 = b.countGroup.compareTo(a.countGroup);
      return sort1;
    });

    notifyListeners();
  }

  void sortListByPersonal() {
    _facebookShareCounts.sort((a, b) {
      var sort1 = b.count.compareTo(a.count);
      return sort1;
    });

    notifyListeners();
  }
}

class FacebookShareCount {
  FacebookShareCount(
      {this.avatarLink,
      this.name,
      this.facebookUid,
      this.count,
      this.details,
      this.countGroup,
      this.permalinkUrl});

  String avatarLink;
  String name;
  String facebookUid;
  String permalinkUrl;
  int count;
  int countGroup;
  int get totalCount => (count ?? 0) + (countGroup ?? 0);

  List<FacebookShareInfo> details;
}
