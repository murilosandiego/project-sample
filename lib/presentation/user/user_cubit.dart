import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news_app/domain/entities/account.dart';
import 'package:news_app/domain/entities/user.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserState());

  void addUser({required Account? account}) {
    if (account == null) {
      emit(UserState());
      return;
    }

    emit(
      UserState(
        user: User(
          id: account.id,
          name: account.username,
          email: account.email,
        ),
      ),
    );
  }
}
