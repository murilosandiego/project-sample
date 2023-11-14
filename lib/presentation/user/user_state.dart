part of 'user_cubit.dart';

class UserState extends Equatable {
  const UserState({this.user});

  final User? user;

  @override
  List<Object?> get props => [user];
}
