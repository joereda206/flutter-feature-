import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_cubit.dart';
import 'search_state.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Cubit')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              onChanged: (value) {
                context.read<SearchCubit>().onQueryChanged(value);
              },
              decoration: const InputDecoration(
                hintText: 'Search name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // History Section
            BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                if (state.searchHistory.isEmpty) return const SizedBox();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recent Searches',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: state.searchHistory.map((item) {
                        return InputChip(
                          label: Text(item),
                          onPressed: () {
                            _controller.text = item;
                            context.read<SearchCubit>().onQueryChanged(item);
                          },
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () {
                            context.read<SearchCubit>().removeFromHistory(item);
                          },
                        );
                      }).toList(),
                    ),
                    const Divider(height: 20),
                  ],
                );
              },
            ),

            // Results Section
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (state.query.isEmpty) {
                    return const Center(child: Text('Search for a name'));
                  }
                  if (state.results.isEmpty) {
                    return const Center(child: Text('No results found'));
                  }
                  return ListView.builder(
                    itemCount: state.results.length,
                    itemBuilder: (context, index) {
                      return ListTile(title: Text(state.results[index]));
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
