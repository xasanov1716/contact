import 'package:contact/db/db.dart';
import 'package:contact/features/basket/bloc/basket_bloc.dart';
import 'package:contact/features/contact/models/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BasketPage extends StatefulWidget {
  const BasketPage({super.key});

  @override
  State<BasketPage> createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  @override
  void initState() {
    context.read<BasketBloc>().add(DeleteContactEvent());
    context.read<BasketBloc>().add(GetAllContactEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: BlocBuilder<BasketBloc, BasketState>(builder: (context, state) {
          if (state is BasketErrorState) {
            return Center(
              child: Text(state.errorText),
            );
          }
          if (state is BasketSuccessState) {
            return Column(
              children: [
                ...List.generate(
                    state.contactSql.length,
                    (index) => state.contactSql.isNotEmpty ? ListTile(
                      subtitle: Text(state.contactSql[index].phone),
                        trailing: Text(DateTime.fromMillisecondsSinceEpoch(state.contactSql[index].creationDate).toString()),
                        title: Text(state.contactSql[index].name)) : const Center(child: Text('EMPTY'),))
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }));
  }
}
