import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/navigation.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../../../data/providers/providers.dart';
import '../widgets/survey_done_view.dart';
import '../widgets/survey_intro.dart';
import '../widgets/survey_question_view.dart';

/// Questionário semestral (`/questionario`): introdução, uma afirmação por
/// tela com avanço automático e, ao final, envio e devolutiva. Se já foi
/// respondido, mostra quando será o próximo.
class SurveyScreen extends ConsumerStatefulWidget {
  const SurveyScreen({super.key});

  /// Pausa curta após tocar, para a pessoa ver a opção marcada.
  static const Duration advanceDelay = Duration(milliseconds: 350);

  @override
  ConsumerState<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends ConsumerState<SurveyScreen> {
  /// -1 = introdução; 0..n-1 = afirmação atual.
  int _step = -1;
  Timer? _advance;

  @override
  void dispose() {
    _advance?.cancel();
    super.dispose();
  }

  void _onSelect(SurveyQuestion question, int option, int total) {
    ref.read(surveyProvider.notifier).answer(question.id, option);
    _advance?.cancel();
    _advance = Timer(SurveyScreen.advanceDelay, () {
      if (!mounted) return;
      if (_step < total - 1) {
        setState(() => _step++);
      } else {
        // A devolutiva abre por cima do questionário (rota filha); ao voltar,
        // esta tela já mostra o estado "já respondido".
        ref.read(surveyProvider.notifier).submit();
        context.go('/questionario/resultado');
      }
    });
  }

  void _back() {
    _advance?.cancel();
    if (_step >= 0) {
      setState(() => _step--);
    } else {
      popOrGo(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final SurveyState survey = ref.watch(surveyProvider);
    final List<SurveyQuestion> questions = survey.questions;

    final Widget body;
    if (survey.submitted) {
      body = const SurveyDoneView();
    } else if (_step < 0) {
      body = SurveyIntro(
        questionCount: questions.length,
        onStart: () => setState(() => _step = 0),
      );
    } else {
      final SurveyQuestion q = questions[_step];
      body = SurveyQuestionView(
        key: ValueKey<String>(q.id),
        question: q,
        index: _step,
        total: questions.length,
        selected: survey.answerFor(q.id),
        onSelect: (int option) => _onSelect(q, option, questions.length),
      );
    }

    // No meio do questionário, o voltar do sistema volta uma afirmação.
    return PopScope(
      canPop: _step < 0 || survey.submitted,
      onPopInvokedWithResult: (bool didPop, Object? _) {
        if (!didPop) _back();
      },
      child: BreatheScaffold(
        title: 'Questionário',
        subtitle: 'Como tem sido o seu trabalho',
        onBack: survey.submitted ? () => popOrGo(context) : _back,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: body,
        ),
      ),
    );
  }
}
