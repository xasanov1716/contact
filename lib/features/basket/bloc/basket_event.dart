part of 'basket_bloc.dart';

@immutable
abstract class BasketEvent {}


class GetAllContactEvent extends BasketEvent {}

class DeleteContactEvent extends BasketEvent {}

class AddContactSqlEvent extends BasketEvent {
  final ContactModelSql contactModelSql;

  AddContactSqlEvent({required this.contactModelSql});
}