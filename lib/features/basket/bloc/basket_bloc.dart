
import 'package:bloc/bloc.dart';
import 'package:contact/db/db.dart';
import 'package:contact/features/contact/models/contact_model.dart';
import 'package:meta/meta.dart';

part 'basket_event.dart';

part 'basket_state.dart';

class BasketBloc extends Bloc<BasketEvent, BasketState> {
  BasketBloc() : super(BasketInitial()) {


    on<GetAllContactEvent>((event, emit) async {
      List<ContactModelSql> sql;
      emit(BasketLoadingState());
      try {
        sql = await LocalDatabase.getAllContact();
        emit(BasketSuccessState(contactSql: sql));
      } catch (e) {
        emit(BasketErrorState(errorText: e.toString()));
      }
    });

    on<DeleteContactEvent>((event, emit) async {
      emit(BasketLoadingState());
      try {
        await LocalDatabase.deleteOldContact();
        emit(BasketSuccessState(contactSql: const []));
        print('Bloc Basket Delete event success');
      } catch (e) {
        emit(BasketErrorState(errorText: e.toString()));
      }
    });


    on<AddContactSqlEvent>((event, emit) async {
      emit(BasketLoadingState());
      try {
        await LocalDatabase.insertContact(event.contactModelSql);
        emit(BasketSuccessState(contactSql: const []));
        print('Bloc Basket Add event success');
      } catch (e) {
        emit(BasketErrorState(errorText: e.toString()));
      }
    });

  }
}
