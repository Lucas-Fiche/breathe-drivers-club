# Breathe Drivers Club

**Protótipo navegável** de um app de bem-estar, planejamento de vida e apoio ao trabalhador, oferecido **pela plataforma** (aplicativos de corrida e entrega) a motoristas e entregadores, sem custo para eles.

O objetivo é aumentar a **Percepção de Suporte Organizacional (PSO)** e a qualidade de vida no trabalho, reduzindo fadiga, jornadas exaustivas e acidentes. O projeto nasceu de um trabalho da disciplina Gestão e Performance (Psicologia, IDP).

**Abrir o protótipo:** https://lucas-fiche.github.io/breathe-drivers-club/

> É só interface: **todos os dados são fictícios** e ficam na memória do navegador. Não há login real, servidor, mapas reais nem IA. Recarregar a página volta tudo ao início. Empresas parceiras e pessoas citadas são inventadas.

## O que tem no app

As funcionalidades seguem três pilares:

- **Condições:** lembretes de pausa, alerta de jornada longa, pontos de apoio, acolhimento psicológico.
- **Tarefa:** metas de vida, meta diária de corridas, controle financeiro, cofrinho, assistente.
- **Vínculo:** benefícios e parcerias, pontos e "destaque do mês", comunidade.

Princípios que o app respeita: **nunca incentivar jornadas maiores** (os pontos vêm de pausas, metas e questionário, nunca de fazer mais corridas), **tom acolhedor e sem culpa**, **transparência** (a empresa vê só dados agregados e anônimos, nunca para punição, conforme a LGPD), **pausa é positiva** e **segurança no trânsito**.

## Telas (abrem direto pela URL)

Qualquer tela abre direto pelo link, sem passar pelo login. Use o endereço do protótipo + `#` + a rota. Exemplo: `https://lucas-fiche.github.io/breathe-drivers-club/#/inicio`

| Rota | Tela |
|---|---|
| `/#/acesso` | Acesso (número da empresa e aceite) |
| `/#/consentimento` | Consentimento: o que você compartilha |
| `/#/perfil-inicial` | Perfil inicial (4 perguntas rápidas) |
| `/#/inicio` | Início: dia, meta, humor, pausa e atalhos |
| `/#/inicio/pausa` | Pausa guiada de 1 minuto |
| `/#/plano` | Meu plano: metas de vida e meta diária |
| `/#/financas` | Finanças: ganhos, gastos, lucro e cofrinho |
| `/#/beneficios` | Benefícios e parcerias |
| `/#/beneficios?filtro=estudos` | Benefícios já filtrados (também `trabalho`, `saude`, `financas`) |
| `/#/apoio` | Pontos de apoio e eventos (mapa ilustrado) |
| `/#/assistente` | Assistente com respostas roteirizadas |
| `/#/comunidade` | Comunidade: feed, filtros e publicação |
| `/#/questionario` | Questionário semestral |
| `/#/questionario/resultado` | Devolutiva do questionário (exemplo, se ainda não respondeu) |
| `/#/ajuda` | Ajuda e acolhimento (CVV 188, SAMU 192) |
| `/#/ajuda/psicologo` | Simulação de atendimento com psicólogo |
| `/#/mais` | Mais: perfil e outros recursos |
| `/#/privacidade` | Privacidade e dados (LGPD) |
| `/#/telas` | **Catálogo de todas as telas e estados especiais** |
| `/#/componentes` | Catálogo de componentes do design system |

## Modo apresentação

Um menu escondido para demonstrar o protótipo. Para abrir:

- **toque longo no logo** (o volante) no cabeçalho de qualquer tela; ou
- **5 toques rápidos no avatar** (as iniciais) no canto do Início.

Ações disponíveis:

- **Simular 10h de jornada:** ao abrir o Início, aparece o alerta de jornada longa em tela cheia.
- **Disparar lembrete de pausa:** um banner desce do topo, em qualquer tela.
- **Mostrar reconhecimento:** "+20 pontos — você cuidou de você hoje".
- **Trocar persona:** alterna entre **Carlos Souza** (motorista de carro) e **Joana Lima** (entregadora de moto).
- **Abrir catálogo de telas** (`/telas`).
- **Resetar dados:** volta tudo ao início, com o Carlos.

Os mesmos estados também abrem pelo catálogo `/#/telas`, na seção **Estados especiais**.

## Rodar localmente

Requisitos: [Flutter](https://docs.flutter.dev/get-started/install) estável (testado com 3.41) e Chrome.

```bash
flutter pub get
flutter run -d chrome          # web
flutter run                    # Android/iOS com um aparelho ou emulador conectado
```

Verificações:

```bash
flutter analyze
flutter test                   # inclui a revisão de layout em 360×740 e 430×932
```

Gerar o APK para Android:

```bash
flutter build apk --release    # arquivo em build/app/outputs/flutter-apk/app-release.apk
```

Regenerar o favicon e os ícones da web a partir do logo:

```bash
flutter test tool/generate_web_icons.dart
```

## Publicação

A cada push na `main`, o GitHub Actions (`.github/workflows/deploy-web.yml`) roda `flutter analyze` e `flutter test`, gera o site e publica no GitHub Pages. Se algum teste falhar, o link continua com a última versão boa.

## Estrutura

```
lib/
  app/        rotas, tema, moldura de celular, transições
  core/       componentes reutilizáveis, alertas globais, formatadores
  data/       modelos, repositórios (interfaces) e dados fictícios
  features/   uma pasta por área do app (inicio, plano, financas…)
```

Os dados fictícios ficam atrás de repositórios abstratos, para serem trocados por uma API depois. Os **limites de saúde** (`lib/app/health_limits.dart`) e os **itens do questionário** (`lib/features/survey/survey_items.dart`) são **provisórios**: a equipe de Psicologia vai substituí-los pelos valores e instrumentos validados.
