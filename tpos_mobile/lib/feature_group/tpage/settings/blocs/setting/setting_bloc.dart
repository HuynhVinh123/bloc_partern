import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tpos_mobile/feature_group/tpage/settings/blocs/setting/setting_event.dart';
import 'package:tpos_mobile/feature_group/tpage/settings/blocs/setting/setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc() : super(SettingLoading());

  @override
  Stream<SettingState> mapEventToState(SettingEvent event) async* {}
}
