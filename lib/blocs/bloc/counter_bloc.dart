import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'counter_event.dart';
part 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterInitial()) {
    on<CounterIncrease>((event, emit) {
      emit(CounterChanged(counter: state.counter + 1));
    });
    on<CounterDecrease>((event, emit) {
      emit(CounterChanged(counter: state.counter - 1));
    });
  }
}
