part of 'signin_bloc.dart';

abstract class SigninEvent extends Equatable {
  const SigninEvent();

  @override
  List<Object> get props => [];
}

class SigninButtonPressed extends SigninEvent {
  final String email;
  final String password;

  const SigninButtonPressed({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
