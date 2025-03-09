
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_identification/user_identification.dart';
part 'user_identification_state.dart';

class UserIdentificationCubit extends Cubit<UserIdentificationState> {
  final SaveUserIdentification saveUser;
  final GetUserIdentification getUser;

  UserIdentificationCubit(this.saveUser, this.getUser)
      : super(const UserIdentificationState());

  Future<void> saveUserId(String userId) async {
    emit(state.copyWith(status: IdentificationStatus.loading));
    final result = await saveUser(User(userId));
    result.fold(
      (failure) => emit(state.copyWith(
        status: IdentificationStatus.error,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(
        status: IdentificationStatus.loaded,
        userId: userId,
      )),
    );
  }

  Future<void> loadUser() async {
    emit(state.copyWith(status: IdentificationStatus.loading));
    final result = await getUser(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: IdentificationStatus.initial,
        ),
      ), // No user, show input
      (user) => emit(state.copyWith(
        status: IdentificationStatus.loaded,
        userId: user.id,
      )),
    );
  }
}
