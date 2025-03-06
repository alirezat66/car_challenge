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
      : super(UserIdentificationInitial());

  Future<void> saveUserId(String userId) async {
    emit(UserIdentificationLoading());
    final result = await saveUser(User(userId));
    result.fold(
      (failure) => emit(UserIdentificationError(failure.message)),
      (_) => emit(UserIdentificationLoaded(userId)),
    );
  }

  Future<void> loadUser() async {
    emit(UserIdentificationLoading());
    final result = await getUser(const NoParams());
    result.fold(
      (failure) => emit(UserIdentificationInitial()), // No user, show input
      (user) => emit(UserIdentificationLoaded(user.id)),
    );
  }
}
