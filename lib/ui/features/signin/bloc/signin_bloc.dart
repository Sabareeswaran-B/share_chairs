import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:share_chairs/repository/user_repository.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  SigninBloc() : super(SigninInitial());

  UserRepository userRepository = UserRepository();

  @override
  Stream<SigninState> mapEventToState(
    SigninEvent event,
  ) async* {
    if (event is SigninButtonPressed) {
      yield* _mapButtonPressedState(
          email: event.email, password: event.password);
    }
  }

  Stream<SigninState> _mapButtonPressedState(
      {String? email, String? password}) async* {
    yield SigninLoading();

    var res = await userRepository.signIn(email: email, password: password);
    if (res['success'] == true) {
      yield SigninSuccess();
    } else {
      yield SigninFailure(error: res['message']);
    }
  }
}
