part of 'user_identification_cubit.dart';

class UserIdentificationState extends Equatable {
  final String userId;
  final IdentificationStatus status;
  final String errorMessage;

  const UserIdentificationState({
    this.userId = '',
    this.status = IdentificationStatus.initial,
    this.errorMessage = '',
  });

  @override
  List<Object?> get props => [userId, status, errorMessage];

  UserIdentificationState copyWith({
    String? userId,
    IdentificationStatus? status,
    String? errorMessage,
  }) {
    return UserIdentificationState(
      userId: userId ?? this.userId,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

enum IdentificationStatus { initial, loading, loaded, error }
