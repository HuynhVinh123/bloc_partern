import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_mobile/services/config_service/config_service.dart';

class LanguageEvent {}

class LanguageLoaded extends LanguageEvent {}

class LanguageChanged extends LanguageEvent {
  LanguageChanged(this.languageCode);
  final String languageCode;

  @override
  String toString() => '$runtimeType (languageCode: $languageCode)';
}

class LanguageState {
  LanguageState(this.locale);
  final Locale locale;

  @override
  String toString() => '$runtimeType (locale: $locale)';
}

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc({LanguageBloc initialState})
      : super(
          initialState ??
              LanguageState(
                const Locale('vi', 'VN'),
              ),
        ) {
    _logger.i('LanguageBloc Initialized');
  }
  final Logger _logger = Logger();
  @override
  Stream<LanguageState> mapEventToState(LanguageEvent event) async* {
    if (event is LanguageLoaded) {
      final Locale locale = Locale(GetIt.I<ConfigService>().languageCode);
      yield LanguageState(
        Locale(GetIt.instance<ConfigService>().languageCode),
      );
    } else if (event is LanguageChanged) {
      GetIt.instance<ConfigService>().setLanguageCode(event.languageCode);
      final Locale locale = Locale(GetIt.I<ConfigService>().languageCode);
      yield LanguageState(
        Locale(event.languageCode),
      );
    }
  }
}
