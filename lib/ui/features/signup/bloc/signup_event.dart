part of 'signup_bloc.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class SignupButtonPressed extends SignupEvent {
  final String firstName;
  final String lastName;
  final String userName;
  final String dateofbirth;
  final String email;
  final String password;

  const SignupButtonPressed(
      {
      required this.firstName,
      required this.lastName,
      required this.userName,
      required this.dateofbirth,
      required this.email,
      required this.password,
      });

  @override
  List<Object> get props => [
        firstName,
        lastName,
        userName,
        dateofbirth,
        email,
        password,
      ];
}
