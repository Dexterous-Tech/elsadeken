import 'package:bloc/bloc.dart';
import 'package:elsadeken/features/home/notification/data/model/Notification_count_response_model.dart';
import 'package:elsadeken/features/home/notification/data/repo/notification_repo.dart';
import 'package:meta/meta.dart';

part 'notification_count_state.dart';

class NotificationCountCubit extends Cubit<NotificationCountState> {
  NotificationCountCubit(this.notificationRepoInterface) : super(NotificationCountInitial());       

  final NotificationRepoInterface notificationRepoInterface;

  void countNotification() async {
    emit(NotificationCountLoading());
  
      final response = await notificationRepoInterface.countNotification();

      response.fold(
        (failure) => emit(NotificationCountFailure(failure.displayMessage)),
        (data) {
            emit(NotificationCountSuccess(data));
          
        },
      );
      
  }
}   
