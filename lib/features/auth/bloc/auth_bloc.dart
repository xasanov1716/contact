
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contact/common/models/universal_data.dart';
import 'package:flutter/cupertino.dart';

import '../repository/auth_repository.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<AuthLogInEvent>((event, emit) async {
      emit(AuthLoadingState());
        UniversalData data = await authRepository.loginUser(
            email: event.email, password: event.password);
        if(data.error.isEmpty){
          emit(AuthSuccessState());
        }else{
          emit(AuthErrorState(errorText: data.error));
        }
    });


    on<AuthSignUpEvent>((event, emit) async {
      emit(AuthLoadingState());
      UniversalData data = await authRepository.signUpUser(
          email: event.email, password: event.password);
      if(data.error.isEmpty){
        emit(AuthSuccessState());
      }else{
        emit(AuthErrorState(errorText: data.error));
      }
    });


    on<AuthGoogleSignInEvent>((event, emit) async {
      emit(AuthLoadingState());
      UniversalData data = await authRepository.signInWithGoogle();
      if(data.error.isEmpty){
        emit(AuthSuccessState());
      }else{
        emit(AuthErrorState(errorText: data.error));
      }
    });

  }
}
