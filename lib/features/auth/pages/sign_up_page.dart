
import 'dart:io';

import 'package:contact/common/global_button.dart';
import 'package:contact/common/loading_dialog.dart';
import 'package:contact/features/auth/pages/login_page.dart';
import 'package:contact/features/contact/pages/contact_page.dart';
import 'package:contact/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../common/global_input.dart';
import '../../../common/models/universal_data.dart';
import '../bloc/auth_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {


  final TextEditingController phoneController = TextEditingController();


  String email = '';


  String password = '';

  FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: const Text("Sign Up Page"),
          elevation: 0,
        ),
        body: BlocConsumer<AuthBloc, AuthState>(builder: (context, state) {
          if (state is AuthLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height / 12),
                GlobalTextField(
                  hintText: "Email",
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  caption: 'Email',
                  onChanged: (v){
                    email = v;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                GlobalTextField(
                  hintText: "Password",
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  caption: 'Password',
                  onChanged: (v){
                    password = v;
                  },
                ),
                const SizedBox(height: 20),
                GlobalButton(
                    title: "Register",
                    onTap: () {
                      if (email.isNotEmpty && password.isNotEmpty) {
                        context.read<AuthBloc>().add(AuthSignUpEvent(password: password, email: email));
                      }else{
                        showErrorMessage(message: "Maydonlar to'liq emas", context: context);
                      }
                    }),
                const SizedBox(height: 12,),
                GlobalButton(title: 'Google', onTap: (){
                  context.read<AuthBloc>().add(AuthGoogleSignInEvent());
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
                      },
                      child: const Text(
                        "Log In",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }, listener: (context, state) {
          if (state is AuthSuccessState) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const ContactPage()));
          }

          if (state is AuthErrorState) {
            showErrorMessage(message: state.errorText, context: context);
          }
        }),
      );
  }
}