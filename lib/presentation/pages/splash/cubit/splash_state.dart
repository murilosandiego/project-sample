import 'package:equatable/equatable.dart';
import 'package:news_app/domain/entities/account.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object> get props => [];
}

class SplashInitial extends SplashState {}

class SplashToHome extends SplashState {
  SplashToHome({required this.account});

  final Account account;

  @override
  List<Object> get props => [account];
}

class SplashToLogin extends SplashState {}
