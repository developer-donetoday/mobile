import 'package:done_today/datatypes/task.dart';
import 'package:done_today/reusables/circular_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

typedef MessageCallback = void Function(String message);

class MessageComposeBar extends StatefulWidget {
  final MessageCallback onMessageSend;

  MessageComposeBar({required this.onMessageSend});

  @override
  _MessageComposeBarState createState() => _MessageComposeBarState();
}

class _MessageComposeBarState extends State<MessageComposeBar> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool keyboardShowing = MediaQuery.of(context).viewInsets.bottom != 0;
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade200),
      padding: EdgeInsets.fromLTRB(20, 10, 15, keyboardShowing ? 10 : 20),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              onChanged: (value) {
                setState(() {});
                if (value.contains("\n")) {
                  _messageController.text = value.replaceAll("\n", "");
                  FocusScope.of(context).unfocus();
                }
              },
              style: GoogleFonts.roboto(fontSize: 16),
              maxLines: null,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Message',
              ),
            ),
          ),
          CircularButton(
              label: "SEND",
              icon: Icon(Icons.send),
              onTap: () async {
                if (_messageController.text.isEmpty) return;
                widget.onMessageSend(_messageController.text);
                // await widget.task.addMessage(_messageController.text);
                setState(() {
                  _messageController.clear();
                });
              },
              backgroundColor: _messageController.text.isEmpty
                  ? Colors.grey.shade300
                  : Colors.greenAccent.shade700,
              foregroundColor: Colors.white)
        ],
      ),
    );
  }
}
