import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/src/Model/chat_model.dart';
import 'package:chat_app/src/constant.dart';
import 'package:flutter/material.dart';

class RightMessage extends StatelessWidget {
  const RightMessage(
      {@required this.chatMessage,
      @required this.listMessage,
      @required this.id,
      @required this.index});
  final ChatMessage chatMessage;
  final List<ChatMessage> listMessage;
  final int index;
  final String id;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        chatMessage.type == MessageType.TEXT
            // Text
            ? ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 100,
                ),
                child: Container(
                  child: Text(
                    chatMessage.content,
                    style: TextStyle(color: Colors.white),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  decoration: BoxDecoration(
                    color: Variables.appColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  margin: EdgeInsets.only(
                    bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                    right: 10.0,
                  ),
                ),
              )
            : chatMessage.type == MessageType.IMAGE
                // Image
                ? Container(
                    child: FlatButton(
                      child: Material(
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Variables.appColor),
                            ),
                            width: 200.0,
                            height: 200.0,
                            padding: EdgeInsets.all(70.0),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Material(
                            child: Image.asset(
                              'assets/images/img_not_available.jpeg',
                              width: 200.0,
                              height: 200.0,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            clipBehavior: Clip.hardEdge,
                          ),
                          imageUrl: chatMessage.content,
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        clipBehavior: Clip.hardEdge,
                      ),
                      onPressed: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => FullPhoto(
                        //             url: document.data()['content'])));
                      },
                      padding: EdgeInsets.all(0),
                    ),
                    margin: EdgeInsets.only(
                        bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                        right: 10.0),
                  )
                // Sticker
                : Container(
                    child: Image.asset(
                      'assets/images/${chatMessage.content}.gif',
                      width: 100.0,
                      height: 100.0,
                      fit: BoxFit.cover,
                    ),
                    margin: EdgeInsets.only(
                        bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                        right: 10.0),
                  ),
      ],
      mainAxisAlignment: MainAxisAlignment.end,
    );
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1].idFrom != id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }
}
