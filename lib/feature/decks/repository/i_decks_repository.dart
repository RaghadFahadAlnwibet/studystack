import 'package:studystack/feature/decks/model/deck.dart';
abstract class IDecksRepository {

Future<int> insert({required String table, required Map<String, dynamic> data});

Future<int> delete(String table, int id);

Future<List<Decks>> searchDecks(String keyword, int userId);

Future<List<Map<String, dynamic>>> getData(int id);

Future<int> update(int id, data);

}