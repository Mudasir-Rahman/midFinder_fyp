import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(String message) : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}

class AuthFailure extends Failure {
  const AuthFailure(String message) : super(message);
}
class NotFoundFailure extends Failure{
  const NotFoundFailure(String message) : super(message);
}
class UploadFailure extends Failure{
  const UploadFailure(String message) : super(message);
}
class DatabaseFailure extends Failure{
  const DatabaseFailure(String message) : super(message);
}
class GeocodingFailure extends Failure{
  const GeocodingFailure(String message) : super(message);

}