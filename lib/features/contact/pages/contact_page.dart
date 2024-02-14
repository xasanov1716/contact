import 'package:contact/features/basket/bloc/basket_bloc.dart';
import 'package:contact/features/basket/pages/basket_page.dart';
import 'package:contact/features/contact/bloc/product_bloc.dart';
import 'package:contact/features/contact/models/contact_model.dart';
import 'package:contact/features/contact/pages/add_contact.dart';
import 'package:contact/features/contact/repository/contact_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  void initState() {
    super.initState();
  }

  final ContactRepository contactRepository = ContactRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BasketPage()));
                },
                icon: const Icon(Icons.shopping_basket)),
            SizedBox(
              width: 14,
            ),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddContactPage()));
                },
                icon: const Icon(Icons.add))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder(
                  stream: contactRepository.getContact(''),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ContactModel>> snapshot) {
                    if (snapshot.hasData) {
                      print('Successga tushdi');
                      return snapshot.data!.isNotEmpty
                          ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ...List.generate(
                                    snapshot.data!.length,
                                    (index) => Slidable(

                                      // The start action pane is the one at the left or the top side.
                                      startActionPane: ActionPane(
                                        // A motion is a widget used to control how the pane animates.
                                        motion: const ScrollMotion(),

                                        // A pane can dismiss the Slidable.
                                        dismissible: DismissiblePane(onDismissed: () {}),

                                        // All actions are defined in the children parameter.
                                        children: []
                                      ),

                                      // The end action pane is the one at the right or the bottom side.
                                      endActionPane:  ActionPane(
                                        motion: ScrollMotion(),
                                        children: [
                                          SlidableAction(
                                            flex: 1,
                                            foregroundColor: Colors.green,
                                            icon: Icons.call,
                                            onPressed: (BuildContext context) {
                                              callUser(snapshot.data![index].phone);
                                            },
                                          ),
                                          SlidableAction(
                                            flex: 1,
                                            foregroundColor: Colors.red,
                                            icon: Icons.delete,
                                            onPressed: (BuildContext context) {
                                              context.read<BasketBloc>().add(
                                                  AddContactSqlEvent(
                                                      contactModelSql: ContactModelSql(
                                                          name: snapshot
                                                              .data![index].name,
                                                          phone: snapshot
                                                              .data![index].phone,
                                                          creationDate: DateTime
                                                              .now()
                                                              .millisecondsSinceEpoch)));
                                              context.read<ContactBloc>().add(DeleteContactByIdEvent(id: snapshot.data![index].contactId));
                                            },
                                          ),
                                          SlidableAction(
                                            flex: 1,
                                            foregroundColor: Colors.blue,
                                            icon: Icons.message,
                                              onPressed: (BuildContext context){
                                                messageUser(snapshot.data![index].phone);
                                              }
                                          ),
                                        ],
                                      ),
                                      child: ListTile(
                                        title:
                                            Text(snapshot.data![index].name),
                                        subtitle:
                                            Text(snapshot.data![index].phone),
                                      ),
                                    )),
                              ],
                            )
                          : const Center(child: Text('EMPTY'));
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  }),
            ],
          ),
        ));
  }


  Future<void> messageUser(String number) async {
    await launchUrl(Uri.parse('sms:+998$number?body='));
  }

  Future<void> callUser(String number) async {
    await launchUrl(Uri.parse('tel:+998$number'));
  }

}
