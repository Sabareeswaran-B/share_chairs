part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  List<Object> get props => [];
}

class Authenticated extends AuthenticationState {}

class Unauthenticated extends AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}
