// lib/core/data/result.dart
import '../error/failures.dart';

class Result<T> {
  final T? data;
  final Failure? error;

  const Result.success(this.data) : error = null;
  const Result.failure(this.error) : data = null;

  bool get isSuccess => error == null;
  bool get isFailure => error != null;
}