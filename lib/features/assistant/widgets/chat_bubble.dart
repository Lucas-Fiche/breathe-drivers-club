import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../assistant_script.dart';

/// Balão de mensagem. Assistente em branco à esquerda; usuário em [primary]
/// com texto branco à direita. Mensagens do assistente podem trazer chips de
/// continuação e um botão de ação.
class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.isUser,
    required this.text,
    this.suggestions = const <String>[],
    this.action,
    this.onSuggestion,
    this.onAction,
  });

  final bool isUser;
  final String text;
  final List<String> suggestions;
  final AssistantAction? action;
  final ValueChanged<String>? onSuggestion;
  final ValueChanged<AssistantAction>? onAction;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final BorderRadius radius = BorderRadius.only(
      topLeft: const Radius.circular(AppRadius.card),
      topRight: const Radius.circular(AppRadius.card),
      bottomLeft: Radius.circular(isUser ? AppRadius.card : AppSpacing.xs),
      bottomRight: Radius.circular(isUser ? AppSpacing.xs : AppRadius.card),
    );

    final Widget bubble = Container(
      decoration: BoxDecoration(
        color: isUser ? AppColors.primary : AppColors.surface,
        borderRadius: radius,
        border: isUser ? null : Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Text(
        text,
        style: textTheme.bodyLarge?.copyWith(
          color: isUser ? Colors.white : AppColors.textPrimary,
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: <Widget>[
                bubble,
                if (!isUser && suggestions.isNotEmpty) ...<Widget>[
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: <Widget>[
                      for (final String id in suggestions)
                        if (kAssistantTopics[id] != null)
                          PillChip(
                            label: kAssistantTopics[id]!.chipLabel,
                            onTap: () => onSuggestion?.call(id),
                          ),
                    ],
                  ),
                ],
                if (!isUser && action != null) ...<Widget>[
                  const SizedBox(height: AppSpacing.sm),
                  SecondaryButton(
                    label: action!.label,
                    icon: Icons.arrow_forward_rounded,
                    expand: false,
                    onPressed: () => onAction?.call(action!),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
