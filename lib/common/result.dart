class Result<T> {
  final T? data;
  final String? error;

  Result.success(this.data) : error = null;

  Result.error(this.error) : data = null;

  bool get isSuccess => data != null;
}
