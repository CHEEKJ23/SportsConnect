part of 'chat_bloc.dart';

@freezed
class ChatEvent with _$ChatEvent {
  const factory ChatEvent.started() = ChatStarted;
  const factory ChatEvent.reset({bool? shouldResetChat}) = ChatReset;
  const factory ChatEvent.userSelected(UserEntity user) = UserSelected;
  const factory ChatEvent.getChatMessage() = GetChatMessage;
  const factory ChatEvent.loadMoreChatMessage() = LoadMoreChatMessage;
  const factory ChatEvent.sendMessage(
    int chatId,
    ChatMessage message, 
  //   {
  //   required String socketId,
  // }
  ) = SendMessage;
  const factory ChatEvent.chatSelected(ChatEntity chat) = ChatSelected;
  const factory ChatEvent.addNewMessage(ChatMessageEntity message) =
      AddNewMessage;
  const factory ChatEvent.chatNotificationOpened(int chatId) =
      ChatNotificationOpened;
       // New event for sending item details
       // New event for sending item details
       // New event for sending item details
       // New event for sending item details
       // New event for sending item details
  // const factory ChatEvent.sendMessageWithItemDetails({
  //   required String chatId,
  //   required String message,
  // }) = SendMessageWithItemDetails;
}