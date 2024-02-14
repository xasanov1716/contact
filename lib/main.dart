import 'package:contact/db/db.dart';
import 'package:contact/features/auth/bloc/auth_bloc.dart';
import 'package:contact/features/auth/repository/auth_repository.dart';
import 'package:contact/features/basket/bloc/basket_bloc.dart';
import 'package:contact/features/contact/repository/contact_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/app/pages.dart';
import 'features/contact/bloc/product_bloc.dart';

void showErrorMessage({
  required String message,
  required BuildContext context,
}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) => AlertDialog(
      backgroundColor: Colors.white,
      title: const Text(
        "Error",
        style: TextStyle(fontWeight: FontWeight.w800),
      ),
      content: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Text(
          message,
          style: const TextStyle(
              fontWeight: FontWeight.w500, color: Color(0xFF273032)),
        ),
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () {
            Navigator.of(context).pop();
          },
          isDefaultAction: true,
          child: const Text("ok"),
        )
      ],
    ),
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  LocalDatabase.getInstance;
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => ContactRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => AuthBloc(context.read<AuthRepository>())),
          BlocProvider(
              create: (context) =>
                  ContactBloc(context.read<ContactRepository>())),
          BlocProvider(create: (context) => BasketBloc()),
        ],
        child: const MaterialApp(
          home: App(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
