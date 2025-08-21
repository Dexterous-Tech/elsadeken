import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/features/members/data/models/members.dart';

abstract class MembersListState<T> {}
class MembersListInitial<T> extends MembersListState<T> {}
class MembersListLoading<T> extends MembersListState<T> {}
class MembersListEmpty<T> extends MembersListState<T> {
  final String message;
  MembersListEmpty(this.message);
}
class MembersListLoaded<T> extends MembersListState<T> {
  final List<T> items;
  MembersListLoaded(this.items);
}
class MembersListError<T> extends MembersListState<T> {
  final String message;
  MembersListError(this.message);
}

class MembersListCubit<T> extends Cubit<MembersListState<T>> {
  MembersListCubit(this.loader) : super(MembersListInitial<T>());

  /// loader لازم ترجع ApiResponse<T> فيه data + message
  final Future<dynamic> Function() loader;

  Future<void> fetch() async {
    emit(MembersListLoading<T>());
    try {
      final response = await loader(); // ApiResponse<T>
      final List<T> items = response.data as List<T>;
      if (items.isEmpty) {
        emit(MembersListEmpty<T>(response.message));
      } else {
        emit(MembersListLoaded<T>(items));
      }
    } catch (e) {
      emit(MembersListError<T>(e.toString()));
    }
  }
}
