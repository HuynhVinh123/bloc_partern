abstract class HomeEvent {}

/// Khi Màn hình home được mở ra
class HomeLoaded extends HomeEvent {}

/// Khi đổi tab hiển thị
class HomePageChanged extends HomeEvent {
  HomePageChanged(this.index);
  final int index;
}
