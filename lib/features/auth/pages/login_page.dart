import 'package:contact/common/global_button.dart';
import 'package:contact/features/auth/bloc/auth_bloc.dart';
import 'package:contact/features/auth/pages/sign_up_page.dart';
import 'package:contact/features/contact/pages/contact_page.dart';
import 'package:contact/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/global_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text("Login Screen"),
        ),
        body: BlocConsumer<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            return Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 10,
                  ),
                  const SizedBox(height: 24),
                  GlobalTextField(
                      hintText: "Email",
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onChanged: (v){
                        email = v;
                      }, caption: 'Email',
                  ),
                  const SizedBox(height: 16,),
                  GlobalTextField(
                    hintText: "Password",
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    onChanged: (v){
                      password = v;
                    }, caption: 'Password',
                  ),
                  const SizedBox(height: 18,),
                  GlobalButton(
                      title: ("Login"),
                      onTap: () {
                        if(email.isNotEmpty && password.isNotEmpty) {
                          context.read<AuthBloc>().add(AuthLogInEvent(email: email, password: password));
                        }
                      }),
                  const SizedBox(height: 12,),
                  GlobalButton(title: 'Google', onTap: (){
                    context.read<AuthBloc>().add(AuthGoogleSignInEvent());
                  }),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const RegisterScreen()));
                    },
                    child: const Text(
                      "Sign Up",
                      style:  TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.w800),
                    ),
                  ),

                ],
              ),
            );
          },
          listener: (context, state) {
            if (state is AuthSuccessState) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const ContactPage()));
            }
            if (state is AuthErrorState) {
              showErrorMessage(message: state.errorText, context: context);
            }
          },
        ),
      );
  }
}