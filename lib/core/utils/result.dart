abstract class Failure {
  final String message;
  const Failure(this.message);
}
class ServerFailure extends Failure { const ServerFailure(super.message); }
class AuthFailure extends Failure { const AuthFailure(super.message); }
class LocationFailure extends Failure { const LocationFailure(super.message); }
class StorageFailure extends Failure { const StorageFailure(super.message); }
class NetworkFailure extends Failure { const NetworkFailure(super.message); }
class CameraFailure extends Failure { const CameraFailure(super.message); }

class Result<T> {
  final T? data;
  final Failure? failure;
  const Result.success(this.data) : failure = null;
  const Result.error(this.failure) : data = null;
  bool get isSuccess => failure == null;
  bool get isError => failure != null;
}