import 'package:kingfishertom/core/services/base/base_cubit.dart';
import 'package:rxdart/rxdart.dart';



extension CubitStreamWithCurrentState<T> on BaseCubit<T> {
  Stream<T> get streamWithCurrentState => stream.startWith(state);
}
