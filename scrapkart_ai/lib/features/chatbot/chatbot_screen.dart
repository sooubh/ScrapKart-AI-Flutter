import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/text_styles.dart';
import '../../core/widgets/animated_blob_background.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Hi Karan! I am your ScrapKart AI assistant powered by Gemini. How can I help you today?',
      'isMe': false,
    }
  ];
  
  bool _isLoading = false;

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'text': text, 'isMe': true});
      _controller.clear();
      _isLoading = true;
    });
    
    _scrollToBottom();

    try {
      // Add timeout layer to represent robust backend communication
      await Future.delayed(const Duration(seconds: 1)).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw Exception('Connection timeout. Please try again.'),
      );
      
      // Dummy Response for Testing
      String aiReply = "I am a dummy AI. You said: '$text'";
      if (text.toLowerCase().contains('hi') || text.toLowerCase().contains('hello')) {
        aiReply = 'Hello! I am ready to help you with your scrap queries.';
      } else if (text.toLowerCase().contains('price') || text.toLowerCase().contains('much')) {
        aiReply = 'The price of scrap varies. Typically, plastic is around ₹15/kg, and metal is ₹40/kg.';
      }
      
      setState(() {
        _messages.add({'text': aiReply, 'isMe': false});
      });
    } catch (e) {
      setState(() {
        _messages.add({'text': 'Server connection failed! Please ensure you have an active internet connection. Details: $e', 'isMe': false});
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('AI Assistant', style: AppTextStyles.title),
        centerTitle: true,
        backgroundColor: Colors.white.withOpacity(0.5),
        elevation: 0,
      ),
      body: AnimatedBlobBackground(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + 60),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(24),
                itemCount: _messages.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length) {
                     return const Padding(
                       padding: EdgeInsets.only(top: 10),
                       child: Align(
                         alignment: Alignment.centerLeft,
                         child: CircularProgressIndicator(color: AppColors.primary)
                       ),
                     );
                  }
                  
                  final msg = _messages[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildChatBubble(
                      context,
                      text: msg['text'],
                      isMe: msg['isMe'],
                    ).animate().slideX(begin: msg['isMe'] ? 0.2 : -0.2).fadeIn(),
                  );
                },
              ),
            ),
            
            // Input Field
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.tertiary.withOpacity(0.3)),
                      ),
                      child: Semantics(
                        label: 'Chat message input',
                        child: TextField(
                          controller: _controller,
                          onSubmitted: (_) => _sendMessage(),
                          decoration: InputDecoration(
                            hintText: 'Type your message...',
                            hintStyle: AppTextStyles.body,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(BuildContext context, {required String text, required bool isMe}) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary : Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isMe ? 20 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Text(
          text,
          style: AppTextStyles.body.copyWith(
            color: isMe ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
