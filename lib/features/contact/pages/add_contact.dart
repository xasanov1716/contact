import 'dart:io';

import 'package:contact/common/loading_dialog.dart';
import 'package:contact/features/contact/bloc/product_bloc.dart';
import 'package:contact/features/contact/models/contact_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../common/models/universal_data.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  String name = '';
  String phone = '';


  final ImagePicker picker = ImagePicker();
  String image = '';

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
                Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey
                  ),
                  child: image.isNotEmpty ? Image.network(
                    image,fit: BoxFit.cover,
                    height: 60,
                    width: 60,
                  ) : const SizedBox(),
                ),
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
                TextButton(onPressed: (){
                  showBottomSheetDialog();
                }, child: Text('Select Image')),
                TextButton(
                    onPressed: () {
                      context.read<ContactBloc>().add(AddContactEvent(
                          contactModel: ContactModel(
                              phone: phone,
                              name: name,
                              contactId: '',
                              creationDate:
                                  DateTime.now().millisecondsSinceEpoch, image: image)));
                    },
                    child: const Center(child: Text('Add')))
              ],
            ),
          );
        },
      ),
    );
  }

  Future<UniversalData> imageUploader(XFile xFile) async {
    String downloadUrl = "";
    try {
      final storageRef = FirebaseStorage.instance.ref();
      var imageRef = storageRef.child("images/${xFile.name}");
      await imageRef.putFile(File(xFile.path));
      downloadUrl = await imageRef.getDownloadURL();
      debugPrint('STORAGE ISHLADI');
      return UniversalData(data: downloadUrl);
    } catch (error) {
      debugPrint('STORAGE ISHLAMADI');
      return UniversalData(error: error.toString());
    }}




  void showBottomSheetDialog() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Color(0xFF674D3F),
            borderRadius:  BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  _getFromGallery();
                  Navigator.pop(context);
                },
                leading:  const Icon(Icons.photo,color: Colors.white,),
                title:  const Text("Select from Gallery",style: TextStyle(color: Colors.white,fontSize: 16,fontFamily: 'Urbanist'),),
              ),
              ListTile(
                onTap: () {
                  _getFromCamera();
                  Navigator.pop(context);
                },
                leading:  const Icon(Icons.camera_alt,color: Colors.white,),
                title:  const Text("Select from Camera",style: TextStyle(color: Colors.white,fontSize: 16,fontFamily: 'Urbanist'),),
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _getFromGallery() async {
    XFile? xFiles = await picker.pickImage(
      maxHeight: 512,
      maxWidth: 512,
      source: ImageSource.gallery,
    );
    if (xFiles != null && context.mounted) {
      showLoading(context: context);
      UniversalData data = await imageUploader(xFiles);
      image = data.data;
      setState(() {

      });
      if (context.mounted) {
        hideLoading(context: context);
      }
    } else if (context.mounted) {
      hideLoading(context: context);
    }
  }

  Future<void> _getFromCamera() async {
    XFile? xFiles = await picker.pickImage(
      maxHeight: 512,
      maxWidth: 512,
      source: ImageSource.camera,
    );
    if (xFiles != null && context.mounted) {
      showLoading(context: context);
      UniversalData data = await imageUploader(xFiles);
      image = data.data;
      setState(() {

      });
      if (context.mounted) {
        hideLoading(context: context);
      }
    } else if (context.mounted) {
      hideLoading(context: context);
    }
  }

}
