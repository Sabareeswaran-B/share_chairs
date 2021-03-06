part of 'signin_bloc.dart';

abstract class SigninState extends Equatable {
  const SigninState();

  @override
  List<Object> get props => [];
}

class SigninInitial extends SigninState {}

class SigninLoading extends SigninState {}

class EmailVerify extends SigninState {}

class SigninSuccess extends SigninState {}

class SigninFailure extends SigninState {
  final String error;

  const SigninFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'SigninFailure { error : $error}';
}
