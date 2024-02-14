part of 'product_bloc.dart';

@immutable
abstract class ContactState {}

class ProductInitial extends ContactState {}

class ContactLoadingState extends ContactState {}

class ContactSuccessState extends ContactState {
  final List<ContactModel> contact;

  ContactSuccessState({required this.contact});
}

class ContactErrorState extends ContactState {
  final String errorText;

  ContactErrorState({required this.errorText});
}