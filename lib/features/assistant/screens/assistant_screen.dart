import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../assistant_script.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input_area.dart';
import '../widgets/help_now_card.dart';
import '../widgets/typing_indicator.dart';

/// Mensagem do chat (roteirizada).
class _Msg {
  const _Msg.user(this.text)
      : isUser = true,
        suggestions = const <String>[],
        action = null;

  const _Msg.assistant(
    this.text, {
    this.suggestions = const <String>[],
    this.action,
  }) : isUser = false;

  final bool isUser;
  final String text;
  final List<String> suggestions;
  final AssistantAction? action;
}

/// Tela Assistente (`/assistente`): chat roteirizado, sem IA real.
class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  final List<_Msg> _messages = <_Msg>[
    const _Msg.assistant(kAssistantGreeting),
  ];
  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();
  bool _typing = false;
  bool _showHelp = true;

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _leave() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/inicio');
    }
  }

  void _navigate(String route) {
    if (route.startsWith('/beneficios') || route.startsWith('/financas')) {
      context.go(route);
    } else {
      context.push(route);
    }
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendTopic(String topicId) {
    final AssistantTopic? topic = kAssistantTopics[topicId];
    if (topic == null) return;
    _handleUser(topic.chipLabel, topicId: topicId);
  }

  void _sendText() {
    final String text = _input.text.trim();
    if (text.isEmpty) return;
    _handleUser(text, rawText: text);
  }

  void _handleUser(String displayText, {String? topicId, String? rawText}) {
    final bool distress = rawText != null && isDistressText(rawText);
    setState(() {
      _messages.add(_Msg.user(displayText));
      _input.clear();
      _typing = true;
      _showHelp = distress;
    });
    _scrollToEnd();

    Future<void>.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() {
        _typing = false;
        if (topicId != null) {
          _addTopic(topicId);
        } else if (distress) {
          _messages.add(
            const _Msg.assistant(
              kAssistantDistress,
              action: AssistantAction(
                label: 'Pedir acolhimento',
                route: '/ajuda',
              ),
            ),
          );
        } else {
          final String? id = matchTopicId(rawText!);
          if (id != null) {
            _addTopic(id);
          } else {
            _messages.add(
              const _Msg.assistant(
                kAssistantFallback,
                suggestions: kEntryTopics,
              ),
            );
          }
        }
      });
      _scrollToEnd();
    });
  }

  void _addTopic(String id) {
    final AssistantTopic topic = kAssistantTopics[id]!;
    _messages.add(
      _Msg.assistant(
        topic.response,
        suggestions: topic.suggestions,
        action: topic.action,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BreatheScaffold(
      title: 'Assistente',
      subtitle: 'Tire dúvidas e organize seu plano',
      showHelp: false,
      onBack: _leave,
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              controller: _scroll,
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: <Widget>[
                for (final _Msg m in _messages)
                  ChatBubble(
                    isUser: m.isUser,
                    text: m.text,
                    suggestions: m.suggestions,
                    action: m.action,
                    onSuggestion: _sendTopic,
                    onAction: (AssistantAction a) => _navigate(a.route),
                  ),
                if (_typing) const TypingIndicator(),
              ],
            ),
          ),
          if (_showHelp)
            const Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: HelpNowCard(),
            ),
          ChatInputArea(
            controller: _input,
            onSendTopic: _sendTopic,
            onSendText: _sendText,
          ),
        ],
      ),
    );
  }
}
