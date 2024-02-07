import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AuthStates {}

abstract class AuthEvents {}

class LoginPressed extends AuthEvents {
  final String email;
  final String password;
  LoginPressed({required this.email, required this.password});
}

class SignUpPressed extends AuthEvents {
  final String email;
  final String password;
  SignUpPressed({required this.password,required this.email});
}

class AuthInitialised extends AuthStates {}

class AuthInProgress extends AuthStates {}

class AuthSuccessful extends AuthStates {}

class AuthFailed extends AuthStates {
  final String errorMessage;
  AuthFailed(this.errorMessage);
}

class AuthBloc extends Bloc<AuthEvents, AuthStates> {
  AuthBloc() : super(AuthInitialised()) {
    on<LoginPressed>((event, emit) async{
      try {
        emit(AuthInProgress());
        var response = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: event.email, password: event.password);
        if (response.user == null) {
          emit(AuthFailed("User not found"));
        } else {
          emit(AuthSuccessful());
        }
      }catch(error){
        emit(AuthFailed(error.toString()));
      }
    });

    on<SignUpPressed>((event,emit) async{
      try {
        emit(AuthInProgress());
        var response = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: event.email, password: event.password);
        if (response.user == null) {
          emit(AuthFailed("User not found"));
        } else {
          emit(AuthSuccessful());
        }
      }catch(error){
      emit(AuthFailed(error.toString()));
      }
    });
  }
}
