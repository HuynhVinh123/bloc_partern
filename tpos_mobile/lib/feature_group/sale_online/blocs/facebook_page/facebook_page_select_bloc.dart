import 'package:diacritic/diacritic.dart';
import 'package:facebook_api_client/facebook_api_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/facebook_page/facebook_page_select_event.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/facebook_page/facebook_page_select_state.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class FacebookPageSelectBloc
    extends Bloc<FacebookPageSelectEvent, FacebookPageSelectState> {
  FacebookPageSelectBloc({FacebookApi fbApi})
      : super(FacebookPageSelectLoading()) {
    _fbApi = fbApi ?? GetIt.instance<FacebookApi>();
  }
  FacebookApi _fbApi;
  String _keyWord = '';
  List<FacebookAccount> _fbPages = [];
  final Logger _logger = Logger();

  @override
  Stream<FacebookPageSelectState> mapEventToState(
      FacebookPageSelectEvent event) async* {
    if (event is FacebookPageSelectLoaded) {
      yield* _getFacebookPages(event.crmTeam);
    } else if (event is FacebookPageSelectSearch) {
      yield* _searchFacebookPages(event);
    }
  }

  Stream<FacebookPageSelectState> _getFacebookPages(CRMTeam crmTeam) async* {
    yield FacebookPageSelectLoading();
    try {
      _fbPages = await _fbApi.getFacebookAccount(
        accessToken: crmTeam.facebookUserToken,
      );
      yield FacebookPageSelectLoadSuccess(fbPages: _fbPages);
    } catch (e, s) {
      _logger.e("_getFacebookPages", e, s);

      final String errorString = e.toString();
      String errorHint;
      if (errorString.contains('Error validating')) {
        errorHint = S.current.pageState_SelectPageTokenValidateHint;
      }
      yield FacebookPageSelectLoadFailure(
        title: S.current.notification,
        content: errorString,
        hint: errorHint,
      );
    }
  }

  Stream<FacebookPageSelectState> _searchFacebookPages(event) async* {
    yield FacebookPageSelectLoading();
    List<FacebookAccount> fbPages = <FacebookAccount>[];
    try {
      _keyWord = event.search.trim().toLowerCase();
      fbPages = _fbPages
          .where(
            (FacebookAccount fbAccount) =>
                fbAccount.name.toLowerCase().contains(_keyWord) ||
                removeDiacritics(fbAccount.name.toLowerCase()).contains(
                  removeDiacritics(_keyWord),
                ),
          )
          .toList();
      yield FacebookPageSelectLoadSuccess(fbPages: fbPages);
    } catch (e, s) {
      _logger.e("_getFacebookPages", e, s);
      yield FacebookPageSelectLoadFailure(
          title: S.current.notification, content: e.toString());
    }
  }
}
