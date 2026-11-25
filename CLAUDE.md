# Breathe Drivers Club — contexto para o Claude Code

## O que é o produto
App de bem-estar, planejamento de vida e apoio ao trabalhador, oferecido **pela plataforma** (Uber, iFood etc.) a motoristas e entregadores, sem custo para eles. O objetivo é aumentar a **Percepção de Suporte Organizacional (PSO)** e a qualidade de vida no trabalho, reduzindo fadiga, jornadas exaustivas e acidentes.

O projeto nasceu de um trabalho da disciplina Gestão e Performance (Psicologia, IDP). As funcionalidades seguem três pilares:
- **Condições:** lembretes de pausa, alertas de jornada longa, pontos de apoio, acolhimento psicológico.
- **Tarefa:** metas de vida, meta diária de corridas, controle financeiro, cofrinho, assistente.
- **Vínculo:** benefícios e parcerias, pontos e "motorista destaque", comunidade.

Público: motoristas e entregadores, muitas vezes com escolaridade baixa, que usam o app **no celular, entre corridas, com pouco tempo**.

## Objetivo atual: PROTÓTIPO NAVEGÁVEL (só interface)
- **Não há backend.** Todos os dados são fictícios e ficam em memória.
- Nada de login real, API, banco de dados, Firebase, mapas reais ou IA real.
- O que importa: **todas as telas acessíveis, bonitas e funcionando com interações simuladas**, para apresentações.
- Mesmo assim, a arquitetura deve permitir trocar os dados fictícios por uma API depois (repositórios abstratos).

## Stack
- Flutter (versão estável mais recente) + Dart 3. Plataformas: **web** (principal, para a apresentação por link), Android e iOS.
- `go_router`: navegação, com `StatefulShellRoute.indexedStack` para as abas. Cada tela tem uma URL própria.
- `flutter_riverpod`: estado. **Sem code generation**; usar `Notifier`/`NotifierProvider`.
- `google_fonts`: fonte **Inter**.
- Evitar outros pacotes. Antes de adicionar qualquer dependência, justifique e pergunte.
- Adicionar pacotes sempre com `flutter pub add` (pega a versão atual).

## Estrutura de pastas
```
lib/
  main.dart
  app/
    app.dart              # MaterialApp.router + tema
    router.dart           # todas as rotas
    theme/                # app_colors.dart, app_typography.dart, app_theme.dart, app_spacing.dart
  core/
    widgets/              # componentes reutilizáveis (ver Design System)
    utils/                # formatadores (moeda BRL, datas, distância)
  data/
    models/               # classes imutáveis (final, const, copyWith)
    repositories/         # interfaces abstratas
    mock/                 # implementações fictícias + mock_data.dart
  features/
    onboarding/           # acesso, consentimento, perfil inicial
    home/                 # Início + pausa guiada
    plan/                 # Meu plano
    finance/              # Finanças
    benefits/             # Benefícios e parcerias
    support_points/       # Pontos de apoio e eventos
    assistant/            # Assistente roteirizado
    community/            # Comunidade
    survey/               # Questionário semestral
    help/                 # Ajuda / acolhimento
    more/                 # Mais, perfil, privacidade
    demo/                 # Modo apresentação e catálogo de telas
```
Cada feature tem `screens/`, `widgets/` e `providers.dart` (se precisar).

## Convenções de código
- Identificadores em inglês; **todo texto visível em português do Brasil**.
- Widgets pequenos e `const` sempre que possível. Arquivos de tela com mais de ~250 linhas devem ser quebrados em widgets da pasta `widgets/`.
- Nunca usar cores, tamanhos de fonte ou espaçamentos soltos. Usar sempre `AppColors`, o `TextTheme` e `AppSpacing`.
- Moeda sempre formatada como `R$ 1.234,56` (função em `core/utils`).
- `flutter analyze` sem avisos ao final de cada tarefa.
- Ao terminar cada fase: rodar `flutter analyze` e `flutter test`, e resumir o que foi feito. Não fazer commit sem eu pedir.

## Design System (extraído do protótipo, ver `docs/referencia/`)
Cores:
| Token | Hex | Uso |
|---|---|---|
| `primaryDark` | `#0B3B3B` | cabeçalho, tela de acesso, textos fortes |
| `primary` | `#127572` | barras de progresso, números de destaque, chip selecionado, aba ativa |
| `mint` | `#E2F5EF` | cards de dica, botões +/−, item selecionado |
| `mintTrack` | `#CFF3E7` | trilho das barras de progresso |
| `coral` | `#FE7A59` | botão principal (CTA), pins do mapa, indicador da aba ativa, logo |
| `coralSoft` | `#FFE9E1` | cards de alerta/pausa/ajuda, card de pontos |
| `background` | `#FBF6F0` | fundo das telas (bege claro) |
| `surface` | `#FFFFFF` | cards |
| `disabled` | `#D8D4C8` | botão desabilitado |
| `textPrimary` | `#1A1A1A` | texto |
| `textSecondary` | `#5F6368` | texto de apoio |
| `border` | `#ECE6DE` | contorno de cards e pílulas |

Formas e tipografia:
- Fonte Inter. Título de tela 22–24 semibold; título de card 16–17 semibold; corpo 14–15; números de destaque 32–40 bold em `primary`.
- Cards: fundo branco, raio 20, borda fina `border`, padding 16–20, sem sombra forte.
- Cabeçalho de tela: fundo `primaryDark`, cantos inferiores arredondados (raio 24). Linha 1: ícone de volante + "BREATHE DRIVERS CLUB" (caixa alta, espaçado). Linha 2: título. Linha 3: subtítulo curto.
- Botão principal: `coral`, texto escuro semibold, raio 14, altura ≥ 52.
- Botão secundário e chips: pílula branca com borda; chip selecionado = `primary` com texto branco.
- Logo: volante desenhado em código (círculo mint + 3 raios + centro coral). Sem imagem.
- Áreas de toque ≥ 48 px. O app é usado com pressa e às vezes com uma mão: botões grandes e telas escaneáveis em segundos.

Componentes base em `core/widgets/`: `BreatheHeader`, `BreatheCard`, `PrimaryButton`, `SecondaryButton`, `PillChip` / `ChipGroup`, `ProgressBarLabeled`, `StepperCounter` (− número +), `SectionTitle`, `TagBadge`, `BreatheLogo`, `EmptyState`, `DeviceFrame`.

## Navegação (decisão de arquitetura)
O protótipo original tinha 6 abas, e não havia espaço para Comunidade, Questionário e Ajuda. Decisão:
- **Barra inferior com 5 abas:** Início, Plano, Finanças, Apoio, Benefícios.
- **Assistente:** botão flutuante (FAB) nas telas das abas.
- **Ajuda (acolhimento):** ícone coral fixo no canto direito do cabeçalho, em todas as telas, levando a `/ajuda`.
- **Mais:** avatar no cabeçalho do Início, levando a `/mais` (Comunidade, Questionário, Privacidade e dados, Sobre o app).
- O Início tem atalhos para Comunidade, Questionário e Ajuda.
- **Sem bloqueio de rota:** qualquer tela abre direto pela URL (essencial para apresentações).
- Usar a estratégia de URL padrão com `#` (funciona no GitHub Pages).

Rotas:
`/acesso`, `/consentimento`, `/perfil-inicial`, `/inicio`, `/inicio/pausa`, `/plano`, `/financas`, `/beneficios`, `/apoio`, `/assistente`, `/comunidade`, `/questionario`, `/questionario/resultado`, `/ajuda`, `/mais`, `/privacidade`, `/telas` (catálogo de todas as telas, para apresentação).

## Web: moldura de celular
Na web, com largura maior que 600 px, o app aparece centralizado numa moldura de celular (~400×860, cantos arredondados, sombra), com fundo `primaryDark` em volta e uma legenda discreta: "Protótipo · dados fictícios". No celular, ocupa a tela toda. Implementar em `DeviceFrame`, sem pacote externo.

## Princípios do produto (respeitar em textos e interações)
1. **Nunca incentivar jornadas maiores.** Pontos e reconhecimento vêm de pausas, metas pessoais e questionário respondido, **nunca de fazer mais corridas**.
2. **Tom acolhedor e sem culpa.** Falar com "você", frases curtas, linguagem simples, sem jargão. Nada de "seja mais produtivo" ou "você consegue mais se se esforçar".
3. **Transparência.** Sempre deixar claro o que a empresa vê: apenas dados **agregados e anônimos**, usados para apoio e prevenção, **nunca para punição** (LGPD).
4. **Pausa é positiva.** Lembretes de pausa funcionam como reforço positivo e combatem a ideia de "não posso parar agora".
5. **Segurança no trânsito.** Textos de alerta pedem para parar em local seguro antes de usar o app.

## Dados fictícios
- Persona principal: **Carlos Souza**, 38 anos, motorista de carro há 6 anos em Brasília. Metas: concluir o ensino médio (40%), curso de especialização (20%), reserva de emergência (55%).
- Persona secundária: **Joana Lima**, 27 anos, entregadora de moto. Usada no modo apresentação para trocar de persona.
- Empresas parceiras são **fictícias** (AutoViva Peças e Serviços, Posto Aurora, SeguraMais Seguros…). Nunca usar marcas reais.
- Os limites de saúde são **provisórios** e ficam num único arquivo de configuração: alerta de jornada a partir de 10h online; lembrete de pausa a cada 2h; meta diária acima de 14 corridas mostra orientação.
- Os itens do questionário são **provisórios**; a equipe de Psicologia vai substituir pelos instrumentos validados. Deixá-los num único arquivo e marcar com comentário.

## Referência visual
As telas originais estão em `docs/referencia/` (01-acesso, 02-inicio, 03-meu-plano, 04-financas, 05-beneficios, 06-assistente, 07-pontos-de-apoio). **Antes de implementar uma tela, abra a imagem correspondente** e siga o layout, mas aplique as melhorias pedidas no prompt. Telas sem imagem (comunidade, questionário, ajuda, consentimento, mais) devem seguir o mesmo estilo.

O plano completo de fases está em `docs/PROMPTS.md`.
