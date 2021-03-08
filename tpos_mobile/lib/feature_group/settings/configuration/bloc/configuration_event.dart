abstract class MobileConfigEvent {}

class MobileConfigLoaded extends MobileConfigEvent {}

/// Yêu cầu bloc kiểm tra cấu hình trên server để xác định xem làm gì tiếp theo
class MobileConfigValidated extends MobileConfigEvent {}

/// Yêu cầu bloc upload cấu hình lên server
class MobileConfigUpLoaded extends MobileConfigEvent {}
