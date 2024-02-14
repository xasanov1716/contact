import 'package:contact/features/contact/bloc/product_bloc.dart';
import 'package:contact/features/contact/models/contact_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  String name = '';
  String phone = '';


  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<ContactBloc, ContactState>(
        listener: (context, state) {
          if (state is ContactSuccessState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is ContactLoadingState) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                TextField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(hintText: 'Enter Name',
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),

                  ),
                  onChanged: (v) {
                    name = v;
                  },
                ),
               const  SizedBox(height: 16,),
                TextField(
                  focusNode: focusNode,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    MaskTextInputFormatter(
                        mask: '(##) ### ## ##',
                        filter: {"#": RegExp(r'[0-9]')},
                        type: MaskAutoCompletionType.lazy)
                  ],
                  decoration:  InputDecoration(hintText: 'Phone Number',
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),

                  ),
                  onChanged: (v) {
                    if(v.length == 14){
                      focusNode.unfocus();
                    }
                    phone = v;
                  },
                ),
                TextButton(
                    onPressed: () {
                      context.read<ContactBloc>().add(AddContactEvent(
                          contactModel: ContactModel(
                              phone: phone,
                              name: name,
                              contactId: '',
                              creationDate:
                                  DateTime.now().millisecondsSinceEpoch)));
                    },
                    child: const Center(child: Text('Add')))
              ],
            ),
          );
        },
      ),
    );
  }
}
