import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:share_chairs/repository/user_repository.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupInitial());

  UserRepository userRepository = UserRepository();

  @override
  Stream<SignupState> mapEventToState(
    SignupEvent event,
  ) async* {
    if (event is SignupButtonPressed) {
      yield* _mapButtonPressedState(
        firstName: event.firstName,
        lastName: event.lastName,
        userName: event.userName,
        dateofbirth: event.dateofbirth,
        email: event.email,
        password: event.password,
      );
    }
  }

  Stream<SignupState> _mapButtonPressedState({
    required String firstName,
    required String lastName,
    required String userName,
    required String dateofbirth,
    required String email,
    required String password,
  }) async* {
    yield SignupLoading();

    var res = await userRepository.signUp(
      firstname: firstName,
      lastname: lastName,
      username: userName,
      dob: dateofbirth,
      email: email,
      password: password,
    );
    if (res['success'] == true) {
      yield SignupSuccess();
    } else {
      yield SignupFailure(error: res['message']);
    }
  }
}
