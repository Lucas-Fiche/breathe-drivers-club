import 'package:breathe_drivers_club/data/models/models.dart';
import 'package:breathe_drivers_club/data/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Cria um container isolado por teste e garante o descarte.
ProviderContainer makeContainer() {
  final ProviderContainer container = ProviderContainer();
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('persona', () {
    test('começa em Carlos e troca recarrega todos os dados', () {
      final ProviderContainer c = makeContainer();

      expect(c.read(personaProvider), Persona.carlos);
      expect(c.read(profileProvider).profile.name, 'Carlos Souza');
      final double carlosIncome = c.read(financeProvider).income;
      expect(carlosIncome, 4860);

      c.read(personaProvider.notifier).select(Persona.joana);

      expect(c.read(profileProvider).profile.name, 'Joana Lima');
      expect(c.read(financeProvider).income, 3200);
    });

    test('trocar de persona descarta mutações da anterior', () {
      final ProviderContainer c = makeContainer();

      c.read(financeProvider.notifier).addToPiggyBank(100);
      expect(c.read(financeProvider).piggyBank.balance, 220);

      c.read(personaProvider.notifier).select(Persona.joana);
      expect(c.read(financeProvider).piggyBank.balance, 60);

      // Voltar para Carlos recarrega a semente (mutação não persistiu).
      c.read(personaProvider.notifier).select(Persona.carlos);
      expect(c.read(financeProvider).piggyBank.balance, 120);
    });
  });

  group('benefícios — resgate', () {
    test('resgatar sem pontos suficientes falha e não debita', () {
      final ProviderContainer c = makeContainer();

      // Zera os pontos para forçar a falha.
      final int points = c.read(profileProvider).profile.points;
      expect(c.read(profileProvider.notifier).spendPoints(points), isTrue);
      expect(c.read(profileProvider).profile.points, 0);

      // SeguraMais custa 500 pontos.
      final RedeemResult result =
          c.read(benefitsProvider.notifier).redeem('b-seguramais');

      expect(result, RedeemResult.notEnoughPoints);
      expect(c.read(profileProvider).profile.points, 0);
      expect(c.read(benefitsProvider).isRedeemed('b-seguramais'), isFalse);
    });

    test('resgatar com saldo debita os pontos e marca como resgatado', () {
      final ProviderContainer c = makeContainer();

      final int before = c.read(profileProvider).profile.points; // 1250
      final RedeemResult result =
          c.read(benefitsProvider.notifier).redeem('b-seguramais'); // 500

      expect(result, RedeemResult.success);
      expect(c.read(profileProvider).profile.points, before - 500);
      expect(c.read(benefitsProvider).isRedeemed('b-seguramais'), isTrue);
    });

    test('resgatar duas vezes o mesmo benefício falha na segunda', () {
      final ProviderContainer c = makeContainer();

      expect(
        c.read(benefitsProvider.notifier).redeem('b-conta-leve'),
        RedeemResult.success,
      );
      final int afterFirst = c.read(profileProvider).profile.points;

      expect(
        c.read(benefitsProvider.notifier).redeem('b-conta-leve'),
        RedeemResult.alreadyRedeemed,
      );
      // Não debita de novo.
      expect(c.read(profileProvider).profile.points, afterFirst);
    });

    test('benefício inexistente devolve notFound', () {
      final ProviderContainer c = makeContainer();
      expect(
        c.read(benefitsProvider.notifier).redeem('nao-existe'),
        RedeemResult.notFound,
      );
    });
  });

  group('plano — metas e meta diária', () {
    test('avançar etapa não passa de 100%', () {
      final ProviderContainer c = makeContainer();

      // Meta com 5 etapas; avança além do total.
      for (int i = 0; i < 10; i++) {
        c.read(planProvider.notifier).advanceGoal('g-ensino-medio');
      }

      final LifeGoal goal = c
          .read(planProvider)
          .goals
          .firstWhere((LifeGoal g) => g.id == 'g-ensino-medio');

      expect(goal.completedSteps, goal.totalSteps);
      expect(goal.progress, 1.0);
    });

    test('avançar etapa credita pontos; meta concluída não credita mais', () {
      final ProviderContainer c = makeContainer();

      final int start = c.read(profileProvider).profile.points;
      c.read(planProvider.notifier).advanceGoal('g-ensino-medio'); // 2 -> 3
      expect(
        c.read(profileProvider).profile.points,
        start + PointRewards.perGoalStep,
      );

      // Leva a meta ao fim e tenta avançar além: sem novos pontos.
      c.read(planProvider.notifier).advanceGoal('g-ensino-medio'); // 4
      c.read(planProvider.notifier).advanceGoal('g-ensino-medio'); // 5
      final int maxed = c.read(profileProvider).profile.points;
      c.read(planProvider.notifier).advanceGoal('g-ensino-medio'); // no-op
      expect(c.read(profileProvider).profile.points, maxed);
    });

    test('adicionar meta entra na lista ativa e ignora título vazio', () {
      final ProviderContainer c = makeContainer();
      final int before = c.read(planProvider).goals.length;

      c.read(planProvider.notifier).addGoal(
            title: '  Tirar a CNH tipo D  ',
            category: GoalCategory.outro,
            totalSteps: 4,
          );
      expect(c.read(planProvider).goals.length, before + 1);
      final LifeGoal added = c.read(planProvider).goals.last;
      expect(added.title, 'Tirar a CNH tipo D');
      expect(added.completedSteps, 0);
      expect(added.isComplete, isFalse);

      // Título vazio não adiciona.
      c.read(planProvider.notifier).addGoal(
            title: '   ',
            category: GoalCategory.outro,
            totalSteps: 3,
          );
      expect(c.read(planProvider).goals.length, before + 1);
    });

    test('meta diária respeita os limites', () {
      final ProviderContainer c = makeContainer();
      final PlanNotifier plan = c.read(planProvider.notifier);

      plan.setDailyTarget(100);
      expect(c.read(planProvider).dailyGoal.targetRides, DailyGoalLimits.max);

      plan.setDailyTarget(0);
      expect(c.read(planProvider).dailyGoal.targetRides, DailyGoalLimits.min);

      plan.setDailyTarget(8);
      expect(c.read(planProvider).dailyGoal.targetRides, 8);
    });

    test('registrar pausa incrementa pausas, marca horário e dá pontos', () {
      final ProviderContainer c = makeContainer();

      final int breaks = c.read(planProvider).workDay.breaksTaken;
      final int points = c.read(profileProvider).profile.points;

      c.read(planProvider.notifier).registerBreak();

      expect(c.read(planProvider).workDay.breaksTaken, breaks + 1);
      expect(c.read(planProvider).workDay.lastBreak, isNotNull);
      expect(
        c.read(profileProvider).profile.points,
        points + PointRewards.perBreak,
      );
    });
  });

  group('finanças — cofrinho', () {
    test('adicionar ao cofrinho aumenta o saldo', () {
      final ProviderContainer c = makeContainer();
      c.read(financeProvider.notifier).addToPiggyBank(50);
      expect(c.read(financeProvider).piggyBank.balance, 170);
    });

    test('valor não positivo no cofrinho é ignorado', () {
      final ProviderContainer c = makeContainer();
      c.read(financeProvider.notifier).addToPiggyBank(-10);
      c.read(financeProvider.notifier).addToPiggyBank(0);
      expect(c.read(financeProvider).piggyBank.balance, 120);
    });

    test('resumo do mês soma ganhos, gastos e sobra', () {
      final ProviderContainer c = makeContainer();
      final FinanceState f = c.read(financeProvider);
      expect(f.income, 4860);
      expect(f.expenses, 2140);
      expect(f.saved, 2720);
      expect(f.expensesByCategory['Combustível'], 700);
    });

    test('registrar gasto atualiza total e categorias na hora', () {
      final ProviderContainer c = makeContainer();
      c.read(financeProvider.notifier).registerTransaction(
            type: TransactionType.expense,
            category: 'Combustível',
            amount: 100,
            description: 'teste',
          );
      final FinanceState f = c.read(financeProvider);
      expect(f.expenses, 2240);
      expect(f.expensesByCategory['Combustível'], 800);
      expect(f.transactions.first.description, 'teste');
    });

    test('registrar ganho entra no total de ganhos', () {
      final ProviderContainer c = makeContainer();
      c.read(financeProvider.notifier).registerTransaction(
            type: TransactionType.income,
            category: 'Gorjeta',
            amount: 40,
          );
      expect(c.read(financeProvider).income, 4900);
    });

    test('editar meta do cofrinho muda o alvo; valor inválido é ignorado', () {
      final ProviderContainer c = makeContainer();
      c.read(financeProvider.notifier).setPiggyGoal(800);
      expect(c.read(financeProvider).piggyBank.goal, 800);

      c.read(financeProvider.notifier).setPiggyGoal(0);
      expect(c.read(financeProvider).piggyBank.goal, 800);
    });
  });

  group('comunidade', () {
    test('publicar adiciona post assinado pela pessoa ativa', () {
      final ProviderContainer c = makeContainer();
      final int before = c.read(communityProvider).posts.length;

      c
          .read(communityProvider.notifier)
          .publish(text: 'Primeiro dia de folga!', category: 'Conquista');

      final CommunityState s = c.read(communityProvider);
      expect(s.posts.length, before + 1);
      expect(s.posts.first.author, 'Carlos Souza');
      expect(s.posts.first.text, 'Primeiro dia de folga!');
    });

    test('post vazio é ignorado', () {
      final ProviderContainer c = makeContainer();
      final int before = c.read(communityProvider).posts.length;
      c.read(communityProvider.notifier).publish(text: '   ', category: 'Dica');
      expect(c.read(communityProvider).posts.length, before);
    });

    test('curtir alterna o estado e o total', () {
      final ProviderContainer c = makeContainer();
      final CommunityPost post = c.read(communityProvider).posts.first;
      final int likes = post.likes;

      c.read(communityProvider.notifier).toggleLike(post.id);
      CommunityPost updated =
          c.read(communityProvider).posts.firstWhere((p) => p.id == post.id);
      expect(updated.liked, isTrue);
      expect(updated.likes, likes + 1);

      c.read(communityProvider.notifier).toggleLike(post.id);
      updated =
          c.read(communityProvider).posts.firstWhere((p) => p.id == post.id);
      expect(updated.liked, isFalse);
      expect(updated.likes, likes);
    });
  });

  group('questionário', () {
    test('não envia enquanto houver perguntas sem resposta', () {
      final ProviderContainer c = makeContainer();
      final SurveyState s = c.read(surveyProvider);

      // Responde todas menos a última.
      for (int i = 0; i < s.questions.length - 1; i++) {
        c.read(surveyProvider.notifier).answer(s.questions[i].id, 2);
      }
      expect(c.read(surveyProvider.notifier).submit(), isFalse);
      expect(c.read(surveyProvider).submitted, isFalse);
    });

    test('responder tudo permite enviar e credita pontos uma vez', () {
      final ProviderContainer c = makeContainer();
      final SurveyState s = c.read(surveyProvider);
      final int points = c.read(profileProvider).profile.points;

      for (final SurveyQuestion q in s.questions) {
        c.read(surveyProvider.notifier).answer(q.id, 3);
      }

      expect(c.read(surveyProvider).isComplete, isTrue);
      expect(c.read(surveyProvider.notifier).submit(), isTrue);
      expect(
        c.read(profileProvider).profile.points,
        points + PointRewards.perSurvey,
      );

      // Enviar de novo não credita mais.
      expect(c.read(surveyProvider.notifier).submit(), isFalse);
      expect(
        c.read(profileProvider).profile.points,
        points + PointRewards.perSurvey,
      );
    });

    test('trocar resposta não duplica a entrada', () {
      final ProviderContainer c = makeContainer();
      final String qId = c.read(surveyProvider).questions.first.id;

      c.read(surveyProvider.notifier).answer(qId, 1);
      c.read(surveyProvider.notifier).answer(qId, 4);

      expect(c.read(surveyProvider).answeredCount, 1);
      expect(c.read(surveyProvider).answerFor(qId), 4);
    });
  });

  group('apoio', () {
    test('interesse em evento alterna e soma/retira pontos simbólicos', () {
      final ProviderContainer c = makeContainer();
      final String eventId = c.read(supportProvider).events.first.id;
      final int points = c.read(profileProvider).profile.points;

      c.read(supportProvider.notifier).toggleEventInterest(eventId);
      expect(c.read(supportProvider).isInterested(eventId), isTrue);
      expect(
        c.read(profileProvider).profile.points,
        points + PointRewards.perEventInterest,
      );

      c.read(supportProvider.notifier).toggleEventInterest(eventId);
      expect(c.read(supportProvider).isInterested(eventId), isFalse);
      expect(c.read(profileProvider).profile.points, points);
    });

    test('iniciar rota marca o ponto ativo', () {
      final ProviderContainer c = makeContainer();
      final String id = c.read(supportProvider).supportPoints.first.id;
      c.read(supportProvider.notifier).startRoute(id);
      expect(c.read(supportProvider).activePointId, id);
    });

    test('avaliar ponto grava estrelas; fora de 1–5 é ignorado', () {
      final ProviderContainer c = makeContainer();
      final String id = c.read(supportProvider).supportPoints.first.id;

      c.read(supportProvider.notifier).rateSupportPoint(id, 4);
      expect(c.read(supportProvider).ratingFor(id), 4);

      c.read(supportProvider.notifier).rateSupportPoint(id, 9);
      expect(c.read(supportProvider).ratingFor(id), 4);
    });
  });

  group('benefícios — filtro por slug da rota', () {
    test('slug válido vira categoria; inválido/nulo vira nulo', () {
      expect(BenefitCategoryX.fromSlug('estudos'), BenefitCategory.estudos);
      expect(BenefitCategoryX.fromSlug('financas'), BenefitCategory.financas);
      expect(BenefitCategoryX.fromSlug('xpto'), isNull);
      expect(BenefitCategoryX.fromSlug(null), isNull);
    });

    test('rótulos em português', () {
      expect(BenefitCategory.saude.label, 'Saúde');
      expect(BenefitCategory.financas.label, 'Finanças');
    });
  });
}
