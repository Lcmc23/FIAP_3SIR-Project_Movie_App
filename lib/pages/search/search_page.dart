import 'package:flutter/material.dart';
import 'package:movie_app/pages/search/widgets/movie_search.dart';
import 'package:movie_app/services/api_services.dart';
import 'package:movie_app/models/movie_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Movie> _filteredMovies = [];
  ApiServices apiServices = ApiServices();

  void _filterMovies(String query) async {
    if (query.isNotEmpty) {
      try {
        final result = await apiServices.searchMovies(query);
        setState(() {
          _filteredMovies = result.movies;
        });
      } catch (e) {
        print("Erro ao buscar filmes: $e");
      }
    } else {
      setState(() {
        _filteredMovies = [];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {}); // Atualiza o estado para refletir mudanças no sufixIcon
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _filterMovies('');
                            });
                          },
                        )
                      : null,
                  hintText: 'Search...',
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  _filterMovies(value);
                },
              ),
            ),
            Expanded(
              child: _filteredMovies.isEmpty
                  ? const Center(child: Text('Nenhum filme encontrado'))
                  : ListView.builder(
                      itemCount: _filteredMovies.length,
                      itemBuilder: (context, index) {
                        return MovieSearch(
                          movie: _filteredMovies[index],
                          onTap: () {
                            // Navegar para a página de detalhes do filme
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
