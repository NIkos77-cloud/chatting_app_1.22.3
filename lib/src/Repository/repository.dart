import 'package:chat_app/src/Database/database_service.dart';
import 'package:chat_app/src/Model/chat_model.dart';

class Repository {
  final _database = DatabaseService();

  Future<ChatModel> chatHistory(String groupId, int limit) async {
    return _database.getChatHistory(groupId, limit);
  }
}
