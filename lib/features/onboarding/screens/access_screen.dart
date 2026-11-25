import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';

/// Tela de acesso (`/acesso`).
///
/// Metade de cima em [AppColors.primaryDark] com o logo e a marca; embaixo, um
/// painel bege com o número de acesso, o aceite e o botão Entrar.
class AccessScreen extends StatefulWidget {
  const AccessScreen({super.key});

  @override
  State<AccessScreen> createState() => _AccessScreenState();
}

class _AccessScreenState extends State<AccessScreen> {
  final TextEditingController _controller = TextEditingController();
  late final TapGestureRecognizer _consentLinkRecognizer;
  bool _accepted = false;

  @override
  void initState() {
    super.initState();
    _consentLinkRecognizer = TapGestureRecognizer()
      ..onTap = () => context.push('/consentimento');
  }

  @override
  void dispose() {
    _controller.dispose();
    _consentLinkRecognizer.dispose();
    super.dispose();
  }

  bool get _canEnter => _controller.text.trim().length >= 4 && _accepted;

  void _enter() {
    if (!_canEnter) return;
    context.go('/perfil-inicial');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          const Expanded(child: _AccessHero()),
          _AccessPanel(
            controller: _controller,
            accepted: _accepted,
            canEnter: _canEnter,
            consentLinkRecognizer: _consentLinkRecognizer,
            onNumberChanged: (_) => setState(() {}),
            onAcceptChanged: (bool v) => setState(() => _accepted = v),
            onEnter: _enter,
          ),
        ],
      ),
    );
  }
}

/// Parte de cima: logo + marca + frase.
class _AccessHero extends StatelessWidget {
  const _AccessHero();

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const BreatheLogo(size: 120),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Breathe',
            style: textTheme.displaySmall?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'DRIVERS CLUB',
            style: textTheme.titleSmall?.copyWith(
              color: AppColors.mintTrack,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Respire. Planeje. Siga em frente.',
            style: textTheme.bodyLarge?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

/// Painel bege com o formulário de acesso.
class _AccessPanel extends StatelessWidget {
  const _AccessPanel({
    required this.controller,
    required this.accepted,
    required this.canEnter,
    required this.consentLinkRecognizer,
    required this.onNumberChanged,
    required this.onAcceptChanged,
    required this.onEnter,
  });

  final TextEditingController controller;
  final bool accepted;
  final bool canEnter;
  final TapGestureRecognizer consentLinkRecognizer;
  final ValueChanged<String> onNumberChanged;
  final ValueChanged<bool> onAcceptChanged;
  final VoidCallback onEnter;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.header)),
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.xl,
        right: AppSpacing.xl,
        top: AppSpacing.xxl,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Número de acesso da sua empresa', style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: controller,
            onChanged: onNumberChanged,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            decoration: const InputDecoration(hintText: 'Ex.: 123456'),
          ),
          const SizedBox(height: AppSpacing.lg),
          _ConsentCheck(
            accepted: accepted,
            onChanged: onAcceptChanged,
            linkRecognizer: consentLinkRecognizer,
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: 'Entrar',
            onPressed: canEnter ? onEnter : null,
          ),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: Text(
              'Digite o número (4 ou mais caracteres) e aceite para entrar.',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

/// Checkbox de aceite com o trecho "como meus dados são usados" como link.
class _ConsentCheck extends StatelessWidget {
  const _ConsentCheck({
    required this.accepted,
    required this.onChanged,
    required this.linkRecognizer,
  });

  final bool accepted;
  final ValueChanged<bool> onChanged;
  final TapGestureRecognizer linkRecognizer;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final TextStyle bodyStyle =
        textTheme.bodyLarge ?? const TextStyle();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 28,
          height: 28,
          child: Checkbox(
            value: accepted,
            onChanged: (bool? v) => onChanged(v ?? false),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text.rich(
              TextSpan(
                style: bodyStyle,
                children: <InlineSpan>[
                  const TextSpan(text: 'Li e aceito '),
                  TextSpan(
                    text: 'como meus dados são usados',
                    style: bodyStyle.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: linkRecognizer,
                  ),
                  const TextSpan(
                    text: '. Você escolhe o que compartilha.',
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
