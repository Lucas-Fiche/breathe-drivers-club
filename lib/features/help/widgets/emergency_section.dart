import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';

/// Contato de emergência (número curto, público e gratuito).
class _EmergencyContact {
  const _EmergencyContact({
    required this.name,
    required this.number,
    required this.description,
    required this.icon,
  });

  final String name;
  final String number;
  final String description;
  final IconData icon;
}

const List<_EmergencyContact> _contacts = <_EmergencyContact>[
  _EmergencyContact(
    name: 'CVV',
    number: '188',
    description: 'Apoio emocional · 24h · gratuito',
    icon: Icons.favorite_border_rounded,
  ),
  _EmergencyContact(
    name: 'SAMU',
    number: '192',
    description: 'Urgência médica · 24h · gratuito',
    icon: Icons.medical_services_outlined,
  ),
];

/// Seção "Em situação de emergência": CVV 188 e SAMU 192, com o número em
/// destaque. No protótipo, tocar mostra o número; não liga de verdade.
class EmergencySection extends StatelessWidget {
  const EmergencySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SectionTitle(title: 'Em situação de emergência'),
        const SizedBox(height: AppSpacing.md),
        for (final _EmergencyContact c in _contacts) ...<Widget>[
          _EmergencyTile(contact: c),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _EmergencyTile extends StatelessWidget {
  const _EmergencyTile({required this.contact});

  final _EmergencyContact contact;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Semantics(
      button: true,
      label: '${contact.name}, ${contact.number}. ${contact.description}',
      excludeSemantics: true,
      child: BreatheCard(
        padding: const EdgeInsets.all(AppSpacing.lg),
        onTap: () => _showNumber(context),
        child: Row(
          children: <Widget>[
            Icon(contact.icon, color: AppColors.primary),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(contact.name, style: textTheme.titleMedium),
                  Text(contact.description, style: textTheme.bodySmall),
                ],
              ),
            ),
            Text(contact.number, style: textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }

  Future<void> _showNumber(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Ligar para o ${contact.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(contact.number, style: textTheme.displaySmall),
            const SizedBox(height: AppSpacing.sm),
            Text(contact.description, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Protótipo: a ligação não é feita. Na versão real, este botão '
              'abriria o telefone já com o número.',
              textAlign: TextAlign.center,
              style: textTheme.bodySmall,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendi'),
          ),
        ],
      ),
    );
  }
}
