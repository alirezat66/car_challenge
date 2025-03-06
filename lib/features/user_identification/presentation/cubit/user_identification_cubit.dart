import 'package:bloc/bloc.dart';
import 'package:car_challenge/core/usecase/usecase.dart';
import 'package:car_challenge/features/user_identification/domain/entities/user.dart';
import 'package:car_challenge/features/user_identification/domain/usecases/get_user_identification.dart';
import 'package:car_challenge/features/user_identification/domain/usecases/save_identification.dart';
import 'package:equatable/equatable.dart';
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
