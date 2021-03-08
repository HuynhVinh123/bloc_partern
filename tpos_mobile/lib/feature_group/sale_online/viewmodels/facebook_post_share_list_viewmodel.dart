import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_command.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service/new_dialog_service.dart';
import 'package:tpos_mobile/services/log_services/log_service.dart';
import 'package:tpos_mobile/services/print_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/facebook_share_info.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_api.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import '../../../app.dart';

class FacebookPostShareListViewModel extends ScopedViewModel {
  FacebookPostShareListViewModel({
    ITposApiService tposApi,
    LogService logService,
    PrintService print,
    NewDialogService dialog,
  }) : super(logService: logService) {
    _tposApi = tposApi ?? locator<ITposApiService>();
    _print = print ?? locator<PrintService>();
    _dialog = dialog ?? GetIt.I<NewDialogService>();
  }

  NewDialogService _dialog;
  PrintService _print;

  ITposApiService _tposApi;
  String _facebookPostId;
  String _facebookUserOrPageId;

  bool isAutoClose = false;
  CRMTeam _crmTeam;

  bool _isSelectEnable = false;

  bool get isSelectEnable => _isSelectEnable;

  set isSelectEnable(bool value) {
    _isSelectEnable = value;
    notifyListeners();
  }

  bool get isSelectAll {
    return !_facebookShareCounts.any((f) => f.isSelected == false);
  }

  set isSelectAll(bool value) {
    if (value) {
      for (final value in _facebookShareCounts) {
        value.isSelected = true;
      }
    } else {
      for (final value in _facebookShareCounts) {
        value.isSelected = false;
      }
    }
    notifyListeners();
  }

  int get selectedCount =>
      _facebookShareCounts?.where((f) => f.isSelected)?.length ?? 0;

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
    setBusy(true, message: "Đang tải dữ liệu...");
    try {
      await _loadShares();
    } catch (e, s) {
      logger.error("", e, s);
      onDialogMessageAdd(OldDialogMessage.error("", "", error: e));
    }
    notifyListeners();
    setBusy(false);
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
            } else if (!value.permalinkUrl.contains("/groups/")) {
              postCount += 1;
              existUser.count += 1;
            }
          }
          existUser.isSelected = false;
          existUser.details.add(value);
        } else {
          final FacebookShareCount facebookShareCount = FacebookShareCount(
              count: 0,
              countGroup: 0,
              avatarLink: value.from.pictureLink,
              name: value.from.name,
              facebookUid: value.from.id,
              permalinkUrl: value.permalinkUrl,
              isSelected: false,
              details: <FacebookShareInfo>[value]);
          if (value.permalinkUrl != null) {
            if (value.permalinkUrl.contains("/groups/")) {
              groupCount += 1;
              facebookShareCount.countGroup = 1;
              facebookShareCount.count = 0;
            } else if (!value.permalinkUrl.contains("/groups/")) {
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

  Future<void> printShare({List<FacebookShareCount> selectedItems}) async {
    final List<FacebookShareCount> _printFailItems = [];
    selectedItems ??= _facebookShareCounts.where((f) => f.isSelected).toList();

    if (selectedItems.isEmpty) {
      _dialog.showDialog(
        title: S.current.notification,
        content: S.current.chooseFacebookAccountToPrint,
        type: AlertDialogType.warning,
      );
      return;
    }

    for (final itm in selectedItems) {
      try {
        setBusy(true, message: "${S.current.printing} ${itm.name ?? "N/A"}");
        await _print.printFacebookShared(itm);
        await Future.delayed(const Duration(seconds: 1));
      } catch (e, s) {
        _printFailItems.add(itm);
        logger.error("printFacebookShared", e, s);
      }
    }
    setBusy(false);
    if (_printFailItems.isNotEmpty) {
      final bool result = await App.showConfirm(
          title: S.current.notification,
          content:
              "Có (${_printFailItems.length}) phiếu in không thành công. Bạn có muốn in lại những phiếu bị lỗi không?");

      if (result != null && result) {
        printShare(selectedItems: _printFailItems);
      }
    }
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
      final sort1 = b.countGroup.compareTo(a.countGroup);
      return sort1;
    });

    notifyListeners();
  }

  void sortListByPersonal() {
    _facebookShareCounts.sort((a, b) {
      final sort1 = b.count.compareTo(a.count);
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
      this.permalinkUrl,
      this.isSelected = false});

  String avatarLink;
  String name;
  String facebookUid;
  String permalinkUrl;
  int count;
  int countGroup;

  int get totalCount => (count ?? 0) + (countGroup ?? 0);
  bool isSelected;

  List<FacebookShareInfo> details;
}
