import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact/features/contact/models/contact_model.dart';

import '../../../common/models/universal_data.dart';


class ContactRepository {
  Future<UniversalData> addContact({required ContactModel coffeeModel}) async {
    try {
      DocumentReference newProduct = await FirebaseFirestore.instance
          .collection("contacts")
          .add(coffeeModel.toJson());

      await FirebaseFirestore.instance
          .collection("contacts")
          .doc(newProduct.id)
          .update({
        "contactId": newProduct.id,
      });

      return UniversalData(data: "Contact added!");
    } on FirebaseException catch (e) {
      return UniversalData(error: e.code);
    } catch (error) {
      return UniversalData(error: error.toString());
    }
  }




  Future<UniversalData> updateProduct(
      {required ContactModel contactModel}) async {
    try {
      await FirebaseFirestore.instance
          .collection("contacts")
          .doc(contactModel.contactId)
          .update(
        contactModel.toJson(),
      );

      return UniversalData(data: "Contact updated!");
    } on FirebaseException catch (e) {
      return UniversalData(error: e.code);
    } catch (error) {
      return UniversalData(error: error.toString());
    }
  }


  

  Stream<List<ContactModel>> getContact(String categoryId) async* {
    if (categoryId.isEmpty) {
      yield* FirebaseFirestore.instance.collection("contacts").snapshots().map(
            (event1) => event1.docs
            .map((doc) => ContactModel.fromJson(doc.data()))
            .toList(),
      );
    }
  }

  Future<UniversalData> deleteContact({required String contactId}) async {
    try {
      await FirebaseFirestore.instance
          .collection("contacts")
          .doc(contactId)
          .delete();

      return UniversalData(data: "Contact deleted!");
    } on FirebaseException catch (e) {
      return UniversalData(error: e.code);
    } catch (error) {
      return UniversalData(error: error.toString());
    }
  }
}