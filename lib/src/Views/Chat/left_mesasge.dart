import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/src/Model/chat_model.dart';
import 'package:chat_app/src/constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LeftMessage extends StatelessWidget {
  const LeftMessage(
      {@required this.chatMessage,
      @required this.listMessage,
      @required this.id,
      this.peerAvatar,
      @required this.index});
  final ChatMessage chatMessage;
  final List<ChatMessage> listMessage;
  final int index;
  final String id;
  final String peerAvatar;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              isLastMessageLeft(index)
                  ? Material(
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          color: Colors.grey[200],
                          child: CircularProgressIndicator(
                            strokeWidth: 1.0,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Variables.appColor),
                          ),
                          width: 35.0,
                          height: 35.0,
                          padding: EdgeInsets.all(10.0),
                        ),
                        imageUrl: peerAvatar,
                        width: 35.0,
                        height: 35.0,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(18.0),
                      ),
                      clipBehavior: Clip.hardEdge,
                    )
                  : Container(width: 35.0),
              chatMessage.type == MessageType.TEXT
                  ? ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width - 100),
                      child: Container(
                        child: Text(
                          chatMessage.content,
                          style: TextStyle(color: Colors.black87),
                        ),
                        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0)),
                        margin: EdgeInsets.only(left: 10.0),
                      ),
                    )
                  : chatMessage.type == MessageType.IMAGE
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
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
                          margin: EdgeInsets.only(left: 10.0),
                        )
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
          ),

          // Time
          isLastMessageLeft(index)
              ? Container(
                  child: Text(
                    DateFormat('dd MMM kk:mm').format(
                        DateTime.fromMillisecondsSinceEpoch(
                            int.parse(chatMessage.timestamp))),
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.0,
                        fontStyle: FontStyle.italic),
                  ),
                  margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
                )
              : Container()
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      margin: EdgeInsets.only(bottom: 10.0),
    );
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1].idFrom == id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
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
