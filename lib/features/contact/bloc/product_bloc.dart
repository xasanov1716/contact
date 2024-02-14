
import 'package:bloc/bloc.dart';
import 'package:contact/common/models/universal_data.dart';
import 'package:meta/meta.dart';

import '../models/contact_model.dart';
import '../repository/contact_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final ContactRepository contactRepository;
  ContactBloc(this.contactRepository) : super(ProductInitial()) {

    on<AddContactEvent>((event, emit) async{
      emit(ContactLoadingState());
      UniversalData data = await contactRepository.addContact(coffeeModel: event.contactModel);
      
        print('Data ${data.data}');
      if(data.error.isEmpty){
        print('Data ${data.data}');
        emit(ContactSuccessState(contact: const[]));
      }else{
        emit(ContactErrorState(errorText: data.error));
      }
    });


    on<DeleteContactByIdEvent>((event, emit) async{
      emit(ContactLoadingState());
      UniversalData data = await contactRepository.deleteContact(contactId: event.id);
      print('Data ${data.data}');
      if(data.error.isEmpty){
        print('Data ${data.data}');
        emit(ContactSuccessState(contact: const[]));
      }else{
        emit(ContactErrorState(errorText: data.error));
      }
    });


    on<GetAllContact>((event, emit) async{
      List<ContactModel>? contact;
      emit(ContactLoadingState());
       contact = contactRepository.getContact('') as List<ContactModel>?;
      if(contact != null){
        print('Bloc ishladi');
        emit(ContactSuccessState(contact: contact!));
      }else{
        print('Bloc error');
        emit(ContactErrorState(errorText: 'Error'));
      }
    });
  }
}
