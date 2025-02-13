class Result<T> {
  final T? data;
  final String? error;

  const Result._({this.data, this.error});

  factory Result.success(T data) => Result._(data: data);

  factory Result.error(String error) => Result._(error: error);

  bool get isSuccess => data != null;
  bool get isError => error != null;
}
