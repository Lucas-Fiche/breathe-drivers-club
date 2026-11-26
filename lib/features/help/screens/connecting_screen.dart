import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/utils/navigation.dart';
import '../../../core/widgets/widgets.dart';

/// Simulação do atendimento (`/ajuda/psicologo`): mostra "Conectando você a
/// um profissional…" por alguns segundos e depois explica como seria na
/// versão real. Não há atendimento de verdade no protótipo.
class ConnectingScreen extends StatefulWidget {
  const ConnectingScreen({super.key});

  /// Tempo da simulação de conexão.
  static const Duration connectDelay = Duration(milliseconds: 2500);

  @override
  State<ConnectingScreen> createState() => _ConnectingScreenState();
}

class _ConnectingScreenState extends State<ConnectingScreen> {
  bool _connected = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(ConnectingScreen.connectDelay, () {
      if (mounted) setState(() => _connected = true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BreatheScaffold(
      title: 'Atendimento',
      subtitle: 'Psicólogo oferecido pela plataforma',
      showHelp: false,
      onBack: () => popOrGo(context, fallback: '/ajuda'),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _connected ? const _Result() : const _Connecting(),
        ),
      ),
    );
  }
}

class _Connecting extends StatelessWidget {
  const _Connecting();

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox.square(
            dimension: 56,
            child: CircularProgressIndicator(
              color: AppColors.primary,
              backgroundColor: AppColors.mintTrack,
              strokeWidth: 5,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Conectando você a um profissional…',
            textAlign: TextAlign.center,
            style: textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Se estiver dirigindo, pare em local seguro antes de continuar.',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _Result extends StatelessWidget {
  const _Result();

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            BreatheCard(
              color: AppColors.mint,
              borderColor: AppColors.mint,
              child: Column(
                children: <Widget>[
                  const Icon(
                    Icons.support_agent_rounded,
                    size: 48,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Na versão real, você seria atendido por chat ou ligação.',
                    textAlign: TextAlign.center,
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text('Tempo médio', style: textTheme.bodyMedium),
                  Text('5 min', style: textTheme.headlineMedium),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'É sigiloso: a empresa não sabe quem pediu ajuda.',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              label: 'Respirar enquanto espera',
              icon: Icons.air_rounded,
              onPressed: () => context.push('/inicio/pausa'),
            ),
            const SizedBox(height: AppSpacing.md),
            SecondaryButton(
              label: 'Voltar para a Ajuda',
              onPressed: () => popOrGo(context, fallback: '/ajuda'),
            ),
          ],
        ),
      ),
    );
  }
}
