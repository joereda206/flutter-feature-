import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  Timer? _debounce;

  SearchCubit()
      : super(
          const SearchState(
            allNames: ['Ahmed', 'Ali', 'Mona', 'Sara', 'Mahmoud', 'Salma'],
            results: ['Ahmed', 'Ali', 'Mona', 'Sara', 'Mahmoud', 'Salma'],
            query: '',
            searchHistory: [],
          ),
        );

  void onQueryChanged(String value) {
    emit(state.copyWith(query: value));
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final trimmed = value.trim();

      if (trimmed.isNotEmpty && !state.searchHistory.contains(trimmed)) {
        final updatedHistory = [trimmed, ...state.searchHistory];
        emit(state.copyWith(searchHistory: updatedHistory));
      }

      final filtered = state.allNames
          .where((name) => name.toLowerCase().contains(trimmed.toLowerCase()))
          .toList();
      emit(state.copyWith(results: filtered));
    });
  }

  void removeFromHistory(String item) {
    final updatedHistory =
        state.searchHistory.where((h) => h != item).toList();
    emit(state.copyWith(searchHistory: updatedHistory));
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}