import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';

/// "Seus direitos": baixar e apagar os dados, simulados com confirmação.
class DataRightsSection extends StatelessWidget {
  const DataRightsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SectionTitle(title: 'Seus direitos'),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Você pode ver, corrigir, baixar ou apagar seus dados, e mudar o '
          'consentimento quando quiser.',
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.md),
        SecondaryButton(
          label: 'Baixar meus dados',
          icon: Icons.download_rounded,
          onPressed: () => _download(context),
        ),
        const SizedBox(height: AppSpacing.sm),
        SecondaryButton(
          label: 'Apagar meus dados',
          icon: Icons.delete_outline_rounded,
          onPressed: () => _erase(context),
        ),
      ],
    );
  }

  Future<void> _download(BuildContext context) async {
    final bool ok = await _confirm(
      context,
      title: 'Baixar meus dados?',
      body:
          'Vamos juntar num arquivo tudo o que o app guarda sobre você: '
          'perfil, metas, finanças, humores e respostas do questionário.',
      confirmLabel: 'Pedir arquivo',
    );
    if (!ok || !context.mounted) return;
    await _done(
      context,
      title: 'Pedido registrado',
      body:
          'Protótipo: nenhum arquivo é gerado. Na versão real, o arquivo '
          'ficaria disponível aqui no app em até 15 dias.',
    );
  }

  Future<void> _erase(BuildContext context) async {
    final bool ok = await _confirm(
      context,
      title: 'Apagar meus dados?',
      body:
          'Seus pontos, metas, finanças e histórico serão apagados e não '
          'dá para desfazer. Seu acesso ao app continua, se você quiser '
          'voltar.',
      confirmLabel: 'Apagar',
    );
    if (!ok || !context.mounted) return;
    await _done(
      context,
      title: 'Pedido registrado',
      body:
          'Protótipo: nada foi apagado. Na versão real, seus dados seriam '
          'apagados em até 15 dias, exceto o que a lei obriga a guardar.',
    );
  }

  Future<bool> _confirm(
    BuildContext context, {
    required String title,
    required String body,
    required String confirmLabel,
  }) async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(title),
        content: Text(body),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _done(
    BuildContext context, {
    required String title,
    required String body,
  }) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: AppColors.surface,
        icon: const Icon(Icons.check_circle_rounded, color: AppColors.primary),
        title: Text(title),
        content: Text(body),
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
