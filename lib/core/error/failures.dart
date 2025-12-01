

import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable{

  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [];
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = "Failed to access local storage"]);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure([super.message = "Database operation failed"]);
}

class ValidationFailure extends Failure {
  const ValidationFailure([super.message = "Invalid input"]);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found']);
}