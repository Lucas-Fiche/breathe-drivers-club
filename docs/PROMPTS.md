# Breathe Drivers Club — sequência de prompts para o Claude Code

## Como usar
1. Crie a pasta do projeto e coloque nela o `CLAUDE.md` e a pasta `docs/` (com `PROMPTS.md` e `referencia/`). Depois abra o Claude Code nessa pasta.
2. Rode **uma fase por vez**, na ordem. Copie o bloco de código da fase e cole no Claude Code.
3. Nas fases 0, 1 e 2, use o **modo de planejamento** (Shift+Tab até aparecer "plan mode"). Revise o plano antes de aprovar.
4. Ao fim de cada fase: rode o app (`flutter run -d chrome`), confira e faça o commit (`git add . && git commit -m "fase X"`). Se algo quebrar numa fase seguinte, você volta para o commit anterior.
5. Para ajustes visuais, **tire um print da tela e cole no Claude Code** junto com o que quer mudar (veja os prompts de ajuste no fim).
6. Se a conversa ficar longa, use `/clear` entre as fases. O CLAUDE.md garante que o contexto do projeto não se perca.

---

## Fase 0 — Criar o projeto
```
Leia o CLAUDE.md. Vamos criar o projeto Flutter do Breathe Drivers Club.

1. Rode `flutter create --org br.com.breathedrivers --project-name breathe_drivers_club --platforms=web,android,ios .` na pasta atual, sem apagar CLAUDE.md nem docs/.
2. Adicione as dependências: go_router, flutter_riverpod, google_fonts. Para formatação de moeda e data, avalie se precisa do pacote intl ou se uma função simples resolve. Me diga o que escolheu.
3. Crie toda a estrutura de pastas descrita no CLAUDE.md (com arquivos vazios ou placeholders onde fizer sentido).
4. Configure analysis_options.yaml com flutter_lints e regras extras úteis (prefer_const_constructors, prefer_final_locals, require_trailing_commas).
5. Remova o app contador de exemplo e o teste padrão. Deixe um main.dart mínimo que abre uma tela "Breathe" vazia.
6. Crie um .gitignore adequado e rode `git init`.
7. Rode `flutter analyze` e `flutter run -d chrome` para confirmar que funciona.

Ao final, me mostre a árvore de pastas criada.
```

## Fase 1 — Design system e componentes base
```
Leia o CLAUDE.md, seção "Design System", e veja as imagens em docs/referencia/ para entender o estilo.

1. Em lib/app/theme/, crie:
   - app_colors.dart com todos os tokens da tabela;
   - app_spacing.dart (4, 8, 12, 16, 20, 24, 32) e raios (14, 20, 24);
   - app_typography.dart com TextTheme em Inter (google_fonts);
   - app_theme.dart com o ThemeData (Material 3) usando tudo isso. Inclua os temas de ElevatedButton, OutlinedButton, Chip, InputDecoration, Card, NavigationBar e Checkbox, para que os widgets padrão já saiam no estilo do app.
2. Em lib/core/widgets/, crie os componentes listados no CLAUDE.md:
   - BreatheLogo: volante desenhado com CustomPainter, com parâmetro de tamanho;
   - BreatheHeader: título, subtítulo, ação opcional à direita e o ícone de Ajuda;
   - BreatheCard, PrimaryButton, SecondaryButton, PillChip e ChipGroup (seleção única);
   - ProgressBarLabeled (rótulo, % e barra);
   - StepperCounter (− número +, com mínimo e máximo);
   - SectionTitle, TagBadge, EmptyState;
   - DeviceFrame (moldura de celular na web, regra dos 600 px).
3. Crie lib/core/utils/formatters.dart com formatCurrency (R$ 1.234,56), formatDistance (250 m / 1,2 km) e formatDuration (5h20).
4. Crie uma tela temporária /componentes que mostra todos os componentes, para eu conferir o visual.
5. Escreva testes simples para os formatadores.

Compare os componentes com as imagens de referência (cabeçalho, cards, chips, barras de progresso, botões +/−) e mantenha-se fiel a elas.
```

## Fase 2 — Navegação, shell e moldura web
```
Leia o CLAUDE.md, seções "Navegação" e "Web: moldura de celular".

1. Em lib/app/router.dart, configure o go_router com:
   - StatefulShellRoute.indexedStack para as 5 abas (Início, Plano, Finanças, Apoio, Benefícios). O estado de cada aba deve ser preservado ao trocar;
   - todas as demais rotas listadas no CLAUDE.md como rotas de tela cheia (sem barra inferior);
   - rota inicial /acesso;
   - nenhum redirect ou bloqueio: qualquer URL abre direto.
2. Crie o shell (ScaffoldWithNavBar):
   - barra inferior com as 5 abas, ícones outline/filled, aba ativa em `primary` e um traço coral acima do item ativo, como no protótipo;
   - FAB do Assistente (ícone de balão de conversa, fundo primaryDark, ícone mint) que leva a /assistente.
3. Todas as telas usam o BreatheHeader. O ícone de Ajuda (coração ou boia, coral) aparece em todas e leva a /ajuda.
4. Crie telas placeholder para todas as rotas, cada uma com o cabeçalho correto (título e subtítulo do protótipo quando houver) e um EmptyState "Em construção".
5. Aplique o DeviceFrame em volta do app inteiro (no builder do MaterialApp.router).
6. Crie a tela /telas (catálogo para apresentação): lista agrupada (Onboarding, Abas principais, Outras telas, Estados especiais) com o nome e a descrição de uma linha de cada tela. Um toque abre a tela. Ela será usada para navegar rapidamente durante a apresentação.
7. Remova a rota /componentes da navegação principal, mas mantenha-a acessível pela URL.

Teste: rode no Chrome, navegue por todas as abas e abra algumas URLs direto (ex.: /#/financas).
```

## Fase 3 — Modelos e dados fictícios
```
Leia o CLAUDE.md, seção "Dados fictícios". Agora vamos criar a camada de dados, ainda sem telas.

1. Em lib/data/models/, crie modelos imutáveis (final, const, copyWith):
   - UserProfile (nome, tipo: motorista/entregador, veículo, anos de app, cidade, pontos);
   - LifeGoal (título, categoria, progresso 0–1, etapas totais e concluídas);
   - DailyGoal (meta de corridas, corridas feitas);
   - WorkDay (horas online hoje, pausas feitas, última pausa);
   - Transaction (tipo ganho/gasto, categoria, valor, data, descrição);
   - PiggyBank (saldo, meta);
   - Partner/Benefit (nome, categoria Trabalho/Saúde/Estudos/Finanças, descrição, custo em pontos, desconto);
   - StudyProgram;
   - SupportPoint (nome, comodidades, distância, minutos, posição x/y no mapa ilustrado, avaliação, horário);
   - Event (título, data, local, descrição);
   - CommunityPost (autor, categoria, texto, curtidas, comentários, data);
   - SurveyQuestion e SurveyAnswer;
   - ConsentSettings (um bool por tipo de dado);
   - MoodEntry (Bem, Cansado, Estressado, Sobrecarregado).
2. Em lib/data/repositories/, crie interfaces abstratas por domínio (ProfileRepository, PlanRepository, FinanceRepository, BenefitsRepository, SupportRepository, CommunityRepository, SurveyRepository).
3. Em lib/data/mock/, crie as implementações Mock* e um mock_data.dart com dados realistas para as duas personas (Carlos e Joana), incluindo:
   - Finanças de Carlos no mês: ganhos ~R$ 4.860; gastos ~R$ 2.140 divididos em Combustível, Manutenção, Alimentação, Celular/internet e Outros; cofrinho R$ 120 de meta R$ 500; ~15 transações recentes;
   - 8 a 10 parceiros fictícios distribuídos nas 4 categorias, com descontos reais em vez de "[x]%";
   - 4 programas de estudo (conclusão do ensino médio, apoio à graduação, cursos técnicos e de especialização, educação financeira);
   - 5 pontos de apoio e 4 eventos em Brasília (nomes fictícios no estilo "Ponto Respiro Centro");
   - 8 posts de comunidade com tom real e respeitoso.
4. Crie lib/app/health_limits.dart com os limites provisórios (10h, 2h, 14 corridas) e um comentário dizendo que são provisórios.
5. Crie providers Riverpod (Notifier) para cada domínio, expondo os dados e as ações simuladas (avançar etapa, mudar meta diária, adicionar ao cofrinho, resgatar benefício, registrar humor, registrar pausa, publicar post, responder questionário).
6. Crie um provider de persona ativa. Trocar a persona recarrega todos os dados.
7. Escreva testes unitários para as ações principais (resgatar sem pontos suficientes falha; avançar etapa não passa de 100%; etc.).
```

## Fase 4 — Acesso, consentimento e perfil inicial
```
Implemente o fluxo de onboarding. Veja docs/referencia/01-acesso.png.

1. /acesso: fiel ao protótipo. Metade de cima em primaryDark com o BreatheLogo grande, "Breathe", "DRIVERS CLUB" e "Respire. Planeje. Siga em frente.". Embaixo, um painel bege com cantos superiores arredondados contendo:
   - campo "Número de acesso da sua empresa" (numérico, exemplo 123456);
   - checkbox "Li e aceito como meus dados são usados. Você escolhe o que compartilha." O trecho "como meus dados são usados" é um link que abre /consentimento;
   - botão Entrar, desabilitado até ter 4+ caracteres e o aceite;
   - texto de ajuda embaixo.
   Entrar leva a /perfil-inicial.
2. /consentimento (melhoria em relação ao protótipo, importante para a LGPD). Tela clara e simples com:
   - bloco "O que a empresa vê": apenas números agregados e anônimos de todos os trabalhadores, nunca seus dados individuais, e nunca usados para punição;
   - lista de tipos de dados com um interruptor cada e explicação de uma linha: Metas e finanças (ficam só com você), Dados de trabalho da plataforma (horas, ganhos, aceitação), Questionário de bem-estar (dados de saúde, com proteção reforçada), Uso do app;
   - nota: "Você pode mudar isso quando quiser em Mais > Privacidade";
   - botão "Salvar minhas escolhas".
3. /perfil-inicial: questionário curto de perfil, uma pergunta por vez, com barra de progresso no topo e respostas em chips grandes:
   - Você trabalha como? (Motorista de carro / Entregador de moto / Entregador de bike / Outro)
   - Há quanto tempo? (<1 ano / 1–3 / 3–6 / 6+)
   - Quantas horas por dia, em média? (até 6 / 6–8 / 8–10 / mais de 10)
   - O que você mais quer agora? (múltipla escolha: Terminar os estudos / Organizar dinheiro / Descansar melhor / Ter benefícios / Conhecer outros trabalhadores)
   - Ao final: tela "Tudo pronto, [Nome]!" com um resumo e o botão "Começar", que leva a /inicio.
   Se a pessoa responder "mais de 10 horas", mostre uma mensagem acolhedora (sem julgamento) sobre o app ajudar com pausas.
4. As respostas atualizam o provider de perfil, mas nada é obrigatório para as outras telas funcionarem.
```

## Fase 5 — Início e pausa guiada
```
Implemente a aba Início (/inicio). Veja docs/referencia/02-inicio.png e mantenha o layout, com estas adições da Tabela 1 do projeto:

1. Cabeçalho: "Bom dia, Carlos" (saudação conforme o horário: Bom dia/Boa tarde/Boa noite), subtítulo "Vamos fazer um dia equilibrado", avatar à direita (leva a /mais) e o ícone de Ajuda.
2. Card "Seu dia" (novo): tempo online hoje (ex.: 5h20), pausas feitas e tempo desde a última pausa. Uma barra mostra o tempo online até o limite saudável de 10h. Cor neutra até 8h, coral depois.
3. Card "Sua meta de hoje": "6 de 10 corridas" com botões −/+, barra de progresso e uma frase que muda conforme o progresso. Ao bater a meta, mostre uma mensagem de reconhecimento que sugere encerrar o dia ou descansar, nunca "faça mais".
4. Card "Como você está hoje?": chips Bem / Cansado / Estressado / Sobrecarregado. Ao tocar, mostre uma resposta curta e acolhedora diferente para cada um. Em Estressado e Sobrecarregado, inclua um link para /ajuda. Texto "Toque para registrar. É só para você."
5. Card "Hora de respirar" (fundo coralSoft) com o botão coral "Iniciar pausa de 1 minuto", que leva a /inicio/pausa.
6. Card de reconhecimento (novo), por exemplo "Você fez 3 pausas hoje. Cuidar de você também é trabalho. +20 pontos".
7. Atalhos (novo): 3 botões em linha para Comunidade, Questionário (com selo "novo") e Pontos de apoio.

/inicio/pausa (tela cheia, fundo primaryDark):
- Círculo animado de respiração: expande por 4s ("Inspire"), segura por 2s ("Segure"), contrai por 4s ("Solte"). Contagem regressiva de 60s.
- Botão "Encerrar" discreto.
- Ao terminar: "Pausa concluída. +10 pontos" com animação suave. Registra a pausa no provider, soma os pontos e volta ao Início.
- Use apenas AnimationController do Flutter, sem pacotes.
```

## Fase 6 — Meu plano
```
Implemente a aba Plano (/plano). Veja docs/referencia/03-meu-plano.png.

1. Cabeçalho "Meu plano" / "Seus objetivos, no seu ritmo".
2. Card "Metas de vida": cada meta com ProgressBarLabeled e o botão "Avançar uma etapa". Ao avançar, anime a barra. Ao chegar a 100%, mostre uma celebração discreta e a meta passa para "Conquistadas".
3. Botão "+ Nova meta": bottom sheet com nome, categoria em chips (Estudos, Dinheiro, Saúde, Família, Outro) e número de etapas (StepperCounter). A meta é adicionada à lista.
4. Card "Meta diária de corridas" com StepperCounter grande e o texto "Você define o ritmo. O app lembra das pausas.". Acima do limite de health_limits (14), mostre uma orientação gentil em coralSoft sobre limites saudáveis, sem bloquear.
5. Card "Dica do assistente" (fundo mint): texto contextual conforme as metas (ex.: se há meta de Estudos: "Seu plano inclui estudos. A empresa tem programas de apoio à escola e à graduação."). O botão coral "Ver programas" leva a /beneficios com o filtro Estudos pré-selecionado (passe o filtro pela rota, como query parameter).
6. Seção "Conquistadas" (recolhível), mostrada só se houver metas concluídas.
```

## Fase 7 — Finanças
```
Implemente a aba Finanças (/financas). Veja docs/referencia/04-financas.png.

1. Cabeçalho "Finanças" / "Quanto entra, sai e sobra".
2. Card "Este mês": Ganhos, Gastos e Lucro (ganhos − gastos), com valores reais do mock em vez de "[0.000]". O lucro aparece em destaque em `primary`.
3. Card "Para onde foi o dinheiro" (novo): barras horizontais simples por categoria de gasto, com valor e %. Feito com widgets do Flutter, sem pacote de gráficos.
4. Card "Meu cofrinho": valor grande, barra até a meta e "24% da meta de R$ 500". Botões + R$ 10 / + R$ 50 / + R$ 100 com animação no número. Toque em "Editar meta" para mudar o valor da meta.
5. Botão "+ Registrar" (ganho ou gasto): bottom sheet com tipo (chips), valor (teclado numérico com formatação BRL), categoria e descrição opcional. Atualiza tudo na hora.
6. Lista "Últimas movimentações" (as 5 mais recentes) e "Ver todas" (lista completa agrupada por dia).
7. Card expansível "Investimento, recebimento e lucro" (educação financeira): explicação simples dos três conceitos com um exemplo usando números do Carlos (ex.: recebeu R$ 4.860, mas o combustível e a manutenção são o custo de trabalhar; o que sobra é o lucro). Inclua uma dica sobre separar o dinheiro da reserva. Linguagem bem simples.
```

## Fase 8 — Benefícios e parcerias
```
Implemente a aba Benefícios (/beneficios). Veja docs/referencia/05-beneficios.png.

1. Cabeçalho "Benefícios e parcerias" / "Vantagens para você e para o seu trabalho".
2. Card de pontos (coralSoft): "Seus pontos 1250" e "Complete metas e troque os pontos por vantagens". Toque em "Como ganhar pontos" abre um bottom sheet: pausas, metas concluídas, questionário respondido, participação em eventos. Deixe claro que pontos NÃO vêm de fazer mais corridas.
3. Filtros em ChipGroup: Todos, Trabalho, Saúde, Estudos, Finanças. Aceitar o filtro vindo da rota (?filtro=estudos).
4. Lista de parceiros como no protótipo (nome, TagBadge da categoria, descrição, custo em pontos, botão Resgatar). Resgatar abre uma confirmação. Se houver pontos, desconta e mostra um "cupom" com código fictício. Se não houver, o botão fica desabilitado com "Faltam X pontos".
5. Seção "Programas de estudo" (aparece em Todos e Estudos): cards maiores dos programas com "Quero participar", que mostra uma confirmação de inscrição simulada.
6. Seção "Motorista destaque" (novo): card com selo, explicação de como funciona (baseado em metas e cuidado consigo, não em volume de corridas) e o progresso do Carlos rumo ao selo do mês.
```

## Fase 9 — Pontos de apoio e eventos
```
Implemente a aba Apoio (/apoio). Veja docs/referencia/07-pontos-de-apoio.png.

1. Cabeçalho "Pontos de apoio" / "Descanso, convivência e eventos perto de você".
2. Mapa ILUSTRADO (sem pacote de mapas): CustomPainter com fundo bege, quarteirões arredondados, ruas brancas, uma área verde e água no canto, como no protótipo.
   - Pins coral para pontos de apoio, losangos teal para eventos e um ponto azul pulsante para "Você".
   - Legenda embaixo.
   - Tocar num pin seleciona o item na lista. Ao selecionar, desenhe a rota em coral (linha em L do "Você" até o ponto) com animação de desenho, e uma etiqueta escura no topo: "Rota: Ponto Respiro Centro · 2 min".
3. Alternância Pontos de apoio / Eventos (ChipGroup), trocando a lista e os pins visíveis.
4. Lista de pontos: nome, distância e tempo, comodidades com ícones pequenos (banheiro, água, descanso, recarga). Item selecionado com fundo mint e borda primary, "Rota ativa no mapa" e "Toque para iniciar".
5. Tocar em "Toque para iniciar" ou num item abre um bottom sheet de detalhes: horário, avaliação (estrelas), comodidades, endereço fictício, botões "Iniciar rota" (simulado) e "Avaliar este ponto" (1–5 estrelas + comentário).
6. Lista de eventos: data em destaque (dia/mês), título, local e "Tenho interesse" (alterna o estado e soma pontos simbólicos).
```

## Fase 10 — Assistente roteirizado
```
Implemente /assistente. Veja docs/referencia/06-assistente.png. NÃO há IA real: as respostas são roteirizadas.

1. Cabeçalho "Assistente" / "Tire dúvidas e organize seu plano", com botão voltar.
2. Interface de chat: mensagem inicial "Oi, Carlos! Posso ajudar com benefícios, estudos e pausas.". Balões do assistente em branco à esquerda e os do usuário em primary com texto branco à direita.
3. Chips de sugestão acima do campo de texto: Benefícios, Estudos, Pausas, Finanças, "O que a empresa oferece?".
4. Crie lib/features/assistant/assistant_script.dart com um roteiro em árvore: cada tópico tem uma resposta curta (2–4 frases simples), 2–3 sugestões de continuação e, quando fizer sentido, um botão de ação que navega para a tela certa (ex.: "Ver programas de estudo" leva a /beneficios?filtro=estudos).
5. O tópico "O que a empresa oferece?" deve ser TRANSPARENTE: listar o que existe e também as limitações (ex.: o app não muda o valor das corridas; os benefícios dependem dos parceiros).
6. Texto livre: correspondência simples por palavras-chave (estudo, escola, dinheiro, cansado, pausa, seguro…). Sem correspondência, mostre uma resposta padrão com as sugestões.
7. Indicador "digitando…" (três pontos animados) por ~800 ms antes de cada resposta.
8. Card fixo "Precisa de ajuda agora?" (coralSoft) com o botão "Pedir acolhimento", que leva a /ajuda. Ele aparece no início da conversa e também automaticamente se o usuário digitar palavras como "estressado", "não aguento", "ansioso".
9. Rodapé discreto: "O assistente não substitui um profissional."
```

## Fase 11 — Ajuda (acolhimento) e Comunidade
```
Implemente /ajuda e /comunidade.

/ajuda (tela de tom calmo; nada de vermelho alarmante):
1. Cabeçalho "Ajuda" / "Você não está sozinho".
2. Card principal: "Falar com um psicólogo agora" (atendimento oferecido pela plataforma) com o botão coral. Simule com uma tela "Conectando você a um profissional…" e depois "Na versão real, você seria atendido por chat ou ligação. Tempo médio: 5 min.".
3. Opção "Agendar conversa" com 3 horários fictícios para escolher e confirmação.
4. Exercício rápido: atalho para a pausa guiada (/inicio/pausa).
5. "Em situação de emergência": CVV 188 (apoio emocional, 24h, gratuito) e SAMU 192. No protótipo, mostrar o número em destaque, sem ligar de verdade.
6. Nota de privacidade: "Seu pedido de ajuda é sigiloso. A empresa não sabe quem pediu."

/comunidade:
1. Cabeçalho "Comunidade" / "Troque experiências com outros trabalhadores".
2. Banner recolhível "Regras de convivência" (respeito, sem dados pessoais, sem discurso de ódio, conteúdo moderado).
3. Filtros: Todos, Dicas, Pontos de apoio, Conquistas, Desabafo.
4. Feed de posts: avatar com iniciais, nome, tipo (motorista/entregador), tempo, categoria, texto, curtir (com contador) e comentários (contador, abre lista simples). Menu "⋯" com "Denunciar", que mostra a confirmação "Nossa moderação vai analisar".
5. Botão "+ Publicar": bottom sheet com categoria e texto (limite de 500 caracteres) e o aviso "Não compartilhe dados pessoais". O post entra no topo do feed.
```

## Fase 12 — Questionário semestral
```
Implemente /questionario e /questionario/resultado.

1. Crie lib/features/survey/survey_items.dart com itens PROVISÓRIOS (comentário no topo: "itens provisórios — substituir pelos instrumentos validados escolhidos pela equipe de Psicologia"). Use 4 dimensões com 2–3 afirmações cada: Bem-estar, Fadiga, Sono e Suporte da empresa (PSO). Escala de 1 a 5 (Discordo totalmente → Concordo totalmente), com rótulos e emojis neutros.
2. Tela de introdução: para que serve, tempo estimado (~3 min), "suas respostas individuais não são vistas pela empresa; ela vê só médias de todos", +50 pontos ao concluir. Botão "Começar".
3. Uma afirmação por tela, com barra de progresso, escala em botões grandes, avanço automático ao responder e botão voltar.
4. /questionario/resultado (devolutiva ao trabalhador): resumo por dimensão com barras e uma frase acolhedora (sem diagnóstico, sem rótulos clínicos), 2–3 sugestões práticas ligadas ao app (ex.: fadiga alta leva a pausas e pontos de apoio; suporte baixo leva a benefícios e ao assistente) e "+50 pontos" somados.
5. Inclua um estado "Questionário já respondido. O próximo será em maio de 2027", mostrado se o usuário entrar de novo.
```

## Fase 13 — Mais, Privacidade e Modo apresentação
```
Implemente /mais, /privacidade e o modo apresentação.

/mais:
- Card do perfil (avatar com iniciais, nome, tipo, cidade, pontos, selo se tiver).
- Itens: Comunidade, Questionário semestral, Privacidade e dados, Ajuda, Sobre o Breathe (explica a proposta: oferecido pela plataforma, gratuito, dados para apoio e nunca para punição) e Sair (volta para /acesso).

/privacidade:
- Os mesmos interruptores da tela de consentimento, ligados ao mesmo provider.
- "Baixar meus dados" e "Apagar meus dados" (simulados, com confirmação), conforme os direitos previstos na LGPD.

Modo apresentação (lib/features/demo/):
1. Ativação escondida: toque longo no logo do cabeçalho OU 5 toques rápidos no avatar. Abre um bottom sheet "Modo apresentação".
2. Ações:
   - "Simular 10h de jornada": muda as horas online e, ao voltar ao Início, aparece um alerta em tela cheia (fundo coralSoft) "Você está há 10h online. Que tal encerrar ou fazer uma pausa longa? Pare em local seguro.", com "Fazer pausa agora" e "Lembrar em 30 min";
   - "Disparar lembrete de pausa": banner no topo, estilo notificação, "Já são 2h sem pausa. Uma parada de 5 minutos ajuda a manter a atenção.";
   - "Mostrar reconhecimento": snackbar ou animação "+20 pontos — você cuidou de você hoje";
   - "Trocar persona (Carlos/Joana)";
   - "Abrir catálogo de telas" (/telas);
   - "Resetar dados".
3. O banner de lembrete e o alerta de jornada são widgets reutilizáveis num overlay global. Os providers que os acionam também servirão para a lógica real no futuro.
4. Adicione na tela /telas a seção "Estados especiais", com links que já disparam esses estados.
```

## Fase 14 — Polimento e revisão
```
Faça uma revisão completa do app antes da apresentação:

1. Overflow: escreva um teste de widget que abre CADA rota em 360×740 e 430×932 e falha se houver overflow ou exceção. Corrija tudo.
2. Texto ampliado: teste com textScaler 1.3 nas telas principais e corrija o que quebrar.
3. Acessibilidade: Semantics nos ícones e botões só com ícone, contraste dos textos sobre coral e mint, áreas de toque ≥ 48.
4. Consistência: todas as telas usam BreatheHeader, AppColors e espaçamentos do tema. Procure cores hardcoded (grep por "Color(0x" e "Colors.") fora do tema e corrija.
5. Transições: fade e slide suaves entre telas de tela cheia; animações de números (pontos, cofrinho) com TweenAnimationBuilder.
6. Textos: revise todos os textos da interface (ortografia, tom acolhedor, nada que culpe o trabalhador ou incentive jornadas maiores) e me mostre a lista do que mudou.
7. Web: título da aba "Breathe Drivers Club", favicon com o volante, cor de tema primaryDark no manifest e tela de carregamento (splash) do web com o fundo primaryDark e o logo.
8. Rode `flutter analyze` e `flutter test` e me entregue um resumo com o que foi corrigido.
```

## Fase 15 — Publicação (link para qualquer pessoa abrir)
```
Quero que qualquer pessoa abra o protótipo por um link.

1. Crie .github/workflows/deploy-web.yml que, a cada push na main, faz `flutter build web --release --base-href /<NOME_DO_REPO>/` e publica no GitHub Pages (actions/upload-pages-artifact + actions/deploy-pages). Use o nome real do repositório.
2. Me passe o passo a passo para: criar o repositório no GitHub, dar push e ativar o GitHub Pages (Settings > Pages > Source: GitHub Actions).
3. Gere também o APK: `flutter build apk --release` e me diga onde ficou o arquivo, para eu instalar num Android.
4. Adicione ao README.md: o que é o projeto, o link do protótipo, a lista de rotas (para abrir telas direto pela URL), como ativar o modo apresentação e como rodar localmente.
```

---

## Prompts de ajuste (use sempre que precisar)

**Ajuste visual com print**
```
[cole o print da tela]
Esta é a tela X rodando agora. Compare com docs/referencia/0N-xxx.png e ajuste: [o que está diferente]. Mantenha os componentes do design system.
```

**Corrigir erro**
```
Deu este erro ao [ação]:
[cole o erro completo]
Encontre a causa, explique em 2 linhas e corrija. Depois rode flutter analyze.
```

**Mudar texto ou dado**
```
Na tela X, troque [texto/dado atual] por [novo]. Se o dado vier do mock, altere em lib/data/mock/mock_data.dart.
```

**Nova tela no futuro**
```
Leia o CLAUDE.md. Crie a tela [nome] na rota /[rota], dentro de features/[feature]. Ela deve [descrição]. Use os componentes de core/widgets, adicione a rota no router e inclua a tela no catálogo /telas.
```
