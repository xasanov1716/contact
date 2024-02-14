part of 'basket_bloc.dart';

@immutable
abstract class BasketState {}

class BasketInitial extends BasketState {}


class BasketLoadingState extends BasketState {}

class BasketErrorState extends BasketState {
  final String errorText;

  BasketErrorState({required this.errorText});
}

class BasketSuccessState extends BasketState {
  final List<ContactModelSql> contactSql;

  BasketSuccessState({required this.contactSql});
}