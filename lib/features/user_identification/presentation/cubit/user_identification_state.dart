part of 'user_identification_cubit.dart';

abstract class UserIdentificationState extends Equatable {
  @override
  List<Object> get props => [];
}

class UserIdentificationInitial extends UserIdentificationState {}

class UserIdentificationLoading extends UserIdentificationState {}

class UserIdentificationLoaded extends UserIdentificationState {
  final String userId;
  UserIdentificationLoaded(this.userId);
}

class UserIdentificationError extends UserIdentificationState {
  final String message;
  UserIdentificationError(this.message);
}
