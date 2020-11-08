extension MapExtensions on Map<String, dynamic> {
  T toObject<T>(T Function(Map<String, dynamic> json) convert) {
    return convert(this);
  }
}

extension FutureExtensions on Future<Map<String, dynamic>> {
  Future<T> toObject<T>(T Function(Map<String, dynamic> json) convert) async {
    final Map<String, dynamic> json = await Future.value(this);
    return convert(json);
  }
}
