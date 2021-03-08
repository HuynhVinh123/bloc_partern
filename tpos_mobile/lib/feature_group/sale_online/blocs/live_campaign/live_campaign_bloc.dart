import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/live_campaign/live_campaign_state.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import '../../../../locator.dart';
import 'live_campaign_event.dart';

class LiveCampaignBloc extends Bloc<LiveCampaignEvent, LiveCampaignState> {
  LiveCampaignBloc({
    ITposApiService tposApi,
  }) : super(LiveCampaignLoading()) {
    _campaignApi = GetIt.I<LiveCampaignApi>();
    _tposApi = tposApi ?? locator<ITposApiService>();
  }

  LiveCampaignApi _campaignApi;
  ITposApiService _tposApi;
  List<LiveCampaign> _liveCampaign = [];

  final log = Logger("SaleOnlineLiveCampaignManagementViewModel");

  @override
  Stream<LiveCampaignState> mapEventToState(LiveCampaignEvent event) async* {
    if (event is LiveCampaignLoaded) {
      /// Load danh sách chiến dịch live
      yield LiveCampaignLoading();
      yield* getLiveCampaigns(event);
    } else if (event is LiveCampaignExportExcel) {
      /// Thực hiện load excel
      yield LiveCampaignLoading();
      yield* downLoadExcel(event);
    } else if (event is LiveCampaignLoadedMore) {
      /// Thực hiện load more danh sách chiến dịch live
      yield LiveCampaignLoadingMore();
      yield* getLiveCampaignsLoadMore(event);
    } else if (event is LiveCampaignDeleted) {
      /// Thực hiện xóa chiến dịch
      yield LiveCampaignLoading();
      yield* deleteCampaign(event);
    } else if (event is LiveCampaignDeleteLocal) {
      yield LiveCampaignLoading();
      yield* deleteLiveCampaignLocals(event);
    }
  }

  Stream<LiveCampaignState> deleteLiveCampaignLocals(
      LiveCampaignDeleteLocal event) async* {
    yield LiveCampaignLoadSuccess(liveCampaigns: _liveCampaign);
  }

  Stream<LiveCampaignState> getLiveCampaigns(LiveCampaignLoaded event) async* {
    try {
      List<LiveCampaign> liveCampaigns = [];
      if (event.isActive) {
        liveCampaigns = await _campaignApi.getAvaibleLiveCampaigns(
            keyWord: event.keyWord, top: event.top, skip: event.skip);
      } else {
        liveCampaigns = await _campaignApi.getLiveCampaigns(
            keyWord: event.keyWord, top: event.top, skip: event.skip);
      }

      if (liveCampaigns.length == event.top) {
        liveCampaigns.add(tempLiveCampaign);
      }
      _liveCampaign = liveCampaigns;
      yield LiveCampaignLoadSuccess(liveCampaigns: liveCampaigns);
    } catch (e) {
      yield LiveCampaignLoadFailure(
          title: S.current.error, content: e.toString());
    }
  }

  Stream<LiveCampaignState> getLiveCampaignsLoadMore(
      LiveCampaignLoadedMore event) async* {
    event.liveCampaigns.removeWhere((element) => element.name == 'temp');
    try {
      List<LiveCampaign> liveCampaignMores = [];
      if (event.isActive) {
        liveCampaignMores = await _campaignApi.getAvaibleLiveCampaigns(
            keyWord: event.keyWord, top: event.top, skip: event.skip);
      } else {
        liveCampaignMores = await _campaignApi.getLiveCampaigns(
            keyWord: event.keyWord, top: event.top, skip: event.skip);
      }
      if (liveCampaignMores.length == event.top) {
        liveCampaignMores.add(tempLiveCampaign);
      }

      event.liveCampaigns.addAll(liveCampaignMores);
      _liveCampaign = event.liveCampaigns;
      yield LiveCampaignLoadSuccess(liveCampaigns: event.liveCampaigns);
    } catch (e) {
      yield LiveCampaignLoadFailure(
          title: S.current.error, content: e.toString());
    }
  }

  Stream<LiveCampaignState> downLoadExcel(
      LiveCampaignExportExcel event) async* {
    try {
      final result = await _tposApi.exportExcelLiveCampaign(
          event.liveCampaignId, event.liveCampaignName);
      if (result != null) {
        yield LiveCampaignActionSuccess(path: result);
      }
    } catch (e) {
      yield LiveCampaignActionFailure(
          title: S.current.error, content: e.toString());
    }
  }

  Stream<LiveCampaignState> deleteCampaign(LiveCampaignDeleted event) async* {
    try {
      await _campaignApi.deleteCampaign(event.id);
      _liveCampaign.removeAt(event.index);
      yield LiveCampaignActionSuccess(
          title: S.current.notification, content: S.current.deleteSuccessful);
    } catch (e) {
      yield LiveCampaignActionFailure(
          title: S.current.error, content: e.toString());
    }
  }
}

var tempLiveCampaign = LiveCampaign(name: 'temp');
