import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'vehicle_selection_state.dart';

class VehicleSelectionCubit extends Cubit<VehicleSelectionState> {
  VehicleSelectionCubit() : super(VehicleSelectionInitial());
}
