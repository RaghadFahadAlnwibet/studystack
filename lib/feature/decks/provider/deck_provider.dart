import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studystack/feature/decks/model/deck.dart';
import 'package:studystack/feature/state/view_state.dart';
import 'package:studystack/feature/decks/repository/i_decks_repository.dart';
import 'package:studystack/feature/decks/repository/decks_repository.dart';

final deckProvider = StateNotifierProvider<DeckStateNotifier, ViewState>((ref) {
  final decksRepository = DecksRepository();
  return DeckStateNotifier(decksRepository);
});

class DeckStateNotifier extends StateNotifier<ViewState> {
  final IDecksRepository decksRepository;

  DeckStateNotifier(this.decksRepository) : super(InitialViewState());
  // Done
  Future<int> insert({required String table, required Map<String, dynamic> data}) async {
    state = LoadingViewState();

    try {
      final deckId = await decksRepository.insert(table: table, data: data);
      state = LoadedViewState<int>(deckId);
      return deckId;
    } catch (e) {
      state = ErrorViewState(errorMessage: e.toString());
      rethrow;
    }
  }

  Future<int> delete(String table, int id) async {
  state = LoadingViewState();

  try {
    final dckId = await decksRepository.delete(table, id);
    state = LoadedViewState<int>(dckId);
    return dckId;
  } catch (e) {
    state = ErrorViewState(errorMessage: e.toString());
    rethrow;
  }
}


  Future<void> searchDecks(String keyword, int userId) async {
    state = LoadingViewState();

    try {
      final decks = await decksRepository.searchDecks(keyword, userId);
      state = LoadedViewState<List<Decks>>(decks);
    } catch (e) {
      state = ErrorViewState(errorMessage: e.toString());
    }
  }
  

  // Done 
  Future<void> getData(int userId)  async {
  state = LoadingViewState();

  try {
    final data = await decksRepository.getData(userId);
    final deckList = data.map((map) => Decks.fromJson(map)).toList();
    state = LoadedViewState<List<Decks>>(deckList);  // Changed to List<Decks>
     
  } catch (e) {
    state = ErrorViewState(errorMessage: e.toString());
  }
}



  Future<void> update(int id, Map<String, dynamic> data) async {
    state = LoadingViewState();

    try {
      await decksRepository.update(id, data);
      state = LoadedViewState<int>(id);
    } catch (e) {
      state = ErrorViewState(errorMessage: e.toString());
    }
  }
}
