part of 'product_bloc.dart';

@immutable
abstract class ContactEvent {}


class AddContactEvent extends ContactEvent {
  final ContactModel contactModel;

  AddContactEvent({required this.contactModel});
}

class GetAllContact extends ContactEvent {}


class DeleteContactByIdEvent extends ContactEvent {
  final String id;

  DeleteContactByIdEvent({required this.id});
}