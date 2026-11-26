import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../assistant_script.dart';

/// Área inferior do chat: chips de sugestão, campo de texto, botão enviar e
/// rodapé "O assistente não substitui um profissional."
class ChatInputArea extends StatelessWidget {
  const ChatInputArea({
    super.key,
    required this.controller,
    required this.onSendTopic,
    required this.onSendText,
  });

  final TextEditingController controller;
  final ValueChanged<String> onSendTopic;
  final VoidCallback onSendText;

  /// Altura da faixa de chips (pílulas com área de toque confortável).
  static const double _chipsHeight = 40;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        MediaQuery.of(context).padding.bottom + AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: _chipsHeight,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                for (final String id in kEntryTopics) ...<Widget>[
                  PillChip(
                    label: kAssistantTopics[id]!.chipLabel,
                    onTap: () => onSendTopic(id),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: controller,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => onSendText(),
                  decoration: const InputDecoration(
                    hintText: 'Escreva sua dúvida…',
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _SendButton(onPressed: onSendText),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'O assistente não substitui um profissional.',
            textAlign: TextAlign.center,
            style: textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({required this.onPressed});

  final VoidCallback onPressed;

  /// Área de toque ≥ 48 px.
  static const double _size = 52;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Enviar',
      child: Material(
        color: AppColors.coral,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: const SizedBox.square(
            dimension: _size,
            child: Icon(Icons.send_rounded, color: AppColors.textPrimary),
          ),
        ),
      ),
    );
  }
}
