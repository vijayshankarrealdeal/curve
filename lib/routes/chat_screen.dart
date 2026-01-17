import 'package:curve/services/chat_provider.dart';
import 'package:curve/services/colors_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ion.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer2<ChatProvider, ColorsProvider>(
      builder: (context, chat, color, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Row(
              children: [
                Iconify(Ion.sparkles, color: Colors.amber),
                SizedBox(width: 8),
                Text("Eve AI"),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(CupertinoIcons.refresh),
                onPressed: () => chat.clearChat(),
              )
            ],
          ),
          body: Column(
            children: [
              // Chat List
              Expanded(
                child: chat.messages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(CupertinoIcons.chat_bubble_2_fill,
                                size: 60, color: color.placeHolders()),
                            const SizedBox(height: 10),
                            Text(
                              "Ask Eve about intimacy,\nrelationships, or date ideas.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: color
                                      .navBarIconActiveColor()
                                      .withAlpha(128)),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: chat.scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: chat.messages.length,
                        itemBuilder: (context, index) {
                          final msg = chat.messages[index];
                          final isUser = msg['role'] == 'user';
                          return Align(
                            alignment: isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.all(12),
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.8,
                              ),
                              decoration: BoxDecoration(
                                color: isUser
                                    ? color.seedColorColor().withOpacity(0.2)
                                    : color.placeHolders(),
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(12),
                                  topRight: const Radius.circular(12),
                                  bottomLeft: isUser
                                      ? const Radius.circular(12)
                                      : Radius.zero,
                                  bottomRight: isUser
                                      ? Radius.zero
                                      : const Radius.circular(12),
                                ),
                              ),
                              child: isUser
                                  ? Text(msg['text']!,
                                      style: TextStyle(
                                          color: color.navBarIconActiveColor()))
                                  : MarkdownBody(
                                      data: msg['text']!,
                                      styleSheet: MarkdownStyleSheet(
                                        p: TextStyle(
                                            color:
                                                color.navBarIconActiveColor()),
                                        strong: TextStyle(
                                            color: color.seedColorColor(),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
              ),

              // Loading Indicator
              if (chat.isLoading)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: LinearProgressIndicator(minHeight: 2),
                ),

              // Input Area
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.getAppBarColor(),
                  border: Border(top: BorderSide(color: color.placeHolders())),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        style: TextStyle(color: color.navBarIconActiveColor()),
                        decoration: InputDecoration(
                          hintText: "Ask Eve...",
                          hintStyle: TextStyle(
                              color: color
                                  .navBarIconActiveColor()
                                  .withOpacity(0.5)),
                          filled: true,
                          fillColor: color.placeHolders(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                        onSubmitted: (val) {
                          chat.sendMessage(val);
                          _controller.clear();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: color.seedColorColor(),
                        shape: const CircleBorder(),
                      ),
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: () {
                        chat.sendMessage(_controller.text);
                        _controller.clear();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
