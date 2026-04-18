class SearchState {
  final List<String> allNames;
  final List<String> results;
  final String query;
  final List<String> searchHistory;

  const SearchState({
    required this.allNames,
    required this.results,
    required this.query,
    required this.searchHistory,
  });

  SearchState copyWith({
    List<String>? allNames,
    List<String>? results,
    String? query,
    List<String>? searchHistory,
  }) {
    return SearchState(
      allNames: allNames ?? this.allNames,
      results: results ?? this.results,
      query: query ?? this.query,
      searchHistory: searchHistory ?? this.searchHistory,
    );
  }
}