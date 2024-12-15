


import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../modules/map/presentation/bloc/map_bloc.dart';


class BlocManager<B extends BaseBloc> {
  final List<B> _blocs = [];

  void registerBloc(B bloc) {
    _blocs.add(bloc);
  }

  void clearAllBlocs() {
    for (final bloc in _blocs) {
      bloc.add(const ClearAllDataEvent());
    }
    _blocs.clear();
  }
}

// void clearAllBlocs() {
//   for (final bloc in _activeBlocs) {
//     bloc.close(); // Ensure all Bloc instances are closed
//   }
//   _activeBlocs.clear(); // Clear the list after disposing
// }
