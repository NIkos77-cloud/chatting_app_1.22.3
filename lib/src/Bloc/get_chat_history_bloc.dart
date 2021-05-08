import 'package:chat_app/src/Model/chat_model.dart';
import 'package:chat_app/src/Repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class GetChatHistoryBloc {
  final _repository = Repository();
  final _chatHistoryController = PublishSubject<ChatModel>();

  Stream<ChatModel> get chatHistoryStream => _chatHistoryController.stream;

  Future chatHistorySink(String groupId, int limit) async {
    ChatModel _chatHistory = await _repository.chatHistory(groupId, limit);
    _chatHistoryController.sink.add(_chatHistory);
  }

  void dispose() {
    _chatHistoryController.close();
  }
}
