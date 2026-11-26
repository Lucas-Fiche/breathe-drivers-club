import '../models/models.dart';
import 'survey_questions.dart';

/// Fonte única de dados fictícios do protótipo.
///
/// [PersonaData] agrupa todos os dados de uma persona; [mockDataFor] devolve o
/// pacote da persona pedida. Tudo é fictício e fica em memória. Empresas e
/// pessoas citadas são inventadas.

/// Data de referência do protótipo (bate com a data atual do projeto).
final DateTime _today = DateTime(2026, 11, 25);

DateTime _dAgo(int days) => _today.subtract(Duration(days: days));

/// Horas atrás em relação ao relógio real. Usado só nos posts, para o feed
/// sempre mostrar "há 3h", "ontem" etc. no dia da apresentação.
DateTime _hAgo(int hours) => DateTime.now().subtract(Duration(hours: hours));
DateTime _dAhead(int days) => _today.add(Duration(days: days));

/// Pacote completo de dados de uma persona.
class PersonaData {
  const PersonaData({
    required this.profile,
    required this.consent,
    required this.goals,
    required this.dailyGoal,
    required this.workDay,
    required this.moods,
    required this.transactions,
    required this.piggyBank,
    required this.benefits,
    required this.studyPrograms,
    required this.supportPoints,
    required this.events,
    required this.posts,
    required this.surveyQuestions,
  });

  final UserProfile profile;
  final ConsentSettings consent;
  final List<LifeGoal> goals;
  final DailyGoal dailyGoal;
  final WorkDay workDay;
  final List<MoodEntry> moods;
  final List<Transaction> transactions;
  final PiggyBank piggyBank;
  final List<Benefit> benefits;
  final List<StudyProgram> studyPrograms;
  final List<SupportPoint> supportPoints;
  final List<Event> events;
  final List<CommunityPost> posts;
  final List<SurveyQuestion> surveyQuestions;
}

/// Devolve os dados da persona pedida.
PersonaData mockDataFor(Persona persona) {
  switch (persona) {
    case Persona.carlos:
      return _carlos;
    case Persona.joana:
      return _joana;
  }
}

// ---------------------------------------------------------------------------
// Dados compartilhados entre as personas (ofertas do clube, pontos, comunidade)
// ---------------------------------------------------------------------------

/// 10 parceiros fictícios distribuídos nas 4 categorias, com descontos reais.
final List<Benefit> _benefits = <Benefit>[
  const Benefit(
    id: 'b-autoviva',
    partnerName: 'AutoViva Peças e Serviços',
    category: BenefitCategory.trabalho,
    description: 'Revisão, peças e troca de óleo com preço de parceiro.',
    pointsCost: 300,
    discount: '15% de desconto',
  ),
  const Benefit(
    id: 'b-posto-aurora',
    partnerName: 'Posto Aurora',
    category: BenefitCategory.trabalho,
    description: 'Abastecimento mais barato na rede credenciada.',
    pointsCost: 200,
    discount: 'R\$ 0,15 por litro',
  ),
  const Benefit(
    id: 'b-seguramais',
    partnerName: 'SeguraMais Seguros',
    category: BenefitCategory.trabalho,
    description: 'Seguro do veículo e de acidentes pessoais.',
    pointsCost: 500,
    discount: '20% de desconto',
  ),
  const Benefit(
    id: 'b-bem-viver',
    partnerName: 'Clínica Bem Viver',
    category: BenefitCategory.saude,
    description: 'Consultas e exames de rotina para você e a família.',
    pointsCost: 350,
    discount: '30% de desconto',
  ),
  const Benefit(
    id: 'b-farmavida',
    partnerName: 'FarmaVida',
    category: BenefitCategory.saude,
    description: 'Medicamentos e vacinas na rede de farmácias parceira.',
    pointsCost: 150,
    discount: '12% de desconto',
  ),
  const Benefit(
    id: 'b-sorriso-claro',
    partnerName: 'Sorriso Claro Odontologia',
    category: BenefitCategory.saude,
    description: 'Limpeza e tratamentos odontológicos.',
    pointsCost: 250,
    discount: '25% de desconto',
  ),
  const Benefit(
    id: 'b-avancar',
    partnerName: 'Escola Avançar EAD',
    category: BenefitCategory.estudos,
    description: 'Ensino médio e cursos técnicos no seu ritmo.',
    pointsCost: 400,
    discount: '40% na mensalidade',
  ),
  const Benefit(
    id: 'b-prosseguir',
    partnerName: 'Instituto Prosseguir',
    category: BenefitCategory.estudos,
    description: 'Cursos de especialização e graduação.',
    pointsCost: 600,
    discount: 'Bolsa de 50%',
  ),
  const Benefit(
    id: 'b-conta-leve',
    partnerName: 'Conta Leve Finanças',
    category: BenefitCategory.financas,
    description: 'Conta digital sem tarifa, com cashback em pagamentos.',
    pointsCost: 100,
    discount: '10% de cashback',
  ),
  const Benefit(
    id: 'b-previdencia-simples',
    partnerName: 'Previdência Simples',
    category: BenefitCategory.financas,
    description: 'Plano de previdência para guardar aos poucos.',
    pointsCost: 450,
    discount: '3 meses sem taxa',
  ),
];

/// 4 programas de estudo.
final List<StudyProgram> _studyPrograms = <StudyProgram>[
  const StudyProgram(
    id: 'sp-ensino-medio',
    title: 'Conclua o ensino médio',
    description:
        'Termine o ensino médio em até 18 meses, estudando no seu ritmo.',
    provider: 'Escola Avançar EAD',
  ),
  const StudyProgram(
    id: 'sp-graduacao',
    title: 'Apoio à graduação',
    description:
        'Bolsas parciais e orientação para entrar e se manter na faculdade.',
    provider: 'Instituto Prosseguir',
  ),
  const StudyProgram(
    id: 'sp-tecnicos',
    title: 'Cursos técnicos e de especialização',
    description: 'Trilhas curtas de qualificação com certificado reconhecido.',
    provider: 'Rede Qualifica',
  ),
  const StudyProgram(
    id: 'sp-financeira',
    title: 'Educação financeira na prática',
    description:
        'Oficinas gratuitas sobre orçamento, dívidas e reserva de emergência.',
    provider: 'Conta Leve Finanças',
  ),
];

/// 5 pontos de apoio fictícios em Brasília.
final List<SupportPoint> _supportPoints = <SupportPoint>[
  const SupportPoint(
    id: 'pt-centro',
    name: 'Ponto Respiro Centro',
    amenities: <String>['Banheiro', 'Água', 'Descanso', 'Recarga'],
    distanceMeters: 250,
    minutes: 2,
    mapX: 0.55,
    mapY: 0.35,
    rating: 4.7,
    hours: '06h–22h',
  ),
  const SupportPoint(
    id: 'pt-rodoviaria',
    name: 'Ponto Respiro Rodoviária',
    amenities: <String>['Banheiro', 'Água'],
    distanceMeters: 550,
    minutes: 4,
    mapX: 0.30,
    mapY: 0.55,
    rating: 4.4,
    hours: '24h',
  ),
  const SupportPoint(
    id: 'pt-posto-aurora',
    name: 'Ponto Respiro Posto Aurora',
    amenities: <String>['Água', 'Recarga'],
    distanceMeters: 900,
    minutes: 6,
    mapX: 0.72,
    mapY: 0.50,
    rating: 4.2,
    hours: '05h–23h',
  ),
  const SupportPoint(
    id: 'pt-asa-sul',
    name: 'Ponto Respiro Asa Sul',
    amenities: <String>['Banheiro', 'Água', 'Descanso', 'Café'],
    distanceMeters: 1500,
    minutes: 8,
    mapX: 0.40,
    mapY: 0.72,
    rating: 4.6,
    hours: '07h–21h',
  ),
  const SupportPoint(
    id: 'pt-taguatinga',
    name: 'Ponto Respiro Taguatinga',
    amenities: <String>['Banheiro', 'Água', 'Recarga', 'Estacionamento'],
    distanceMeters: 2300,
    minutes: 12,
    mapX: 0.20,
    mapY: 0.25,
    rating: 4.5,
    hours: '06h–23h',
  ),
];

/// 4 eventos fictícios em Brasília.
final List<Event> _events = <Event>[
  Event(
    id: 'ev-cafe',
    title: 'Café da manhã do motorista',
    date: _dAhead(3),
    location: 'Ponto Respiro Centro',
    description:
        'Encontro para tomar um café e trocar ideia, por conta do clube.',
  ),
  Event(
    id: 'ev-roda',
    title: 'Roda de conversa: estresse e estrada',
    date: _dAhead(6),
    location: 'Ponto Respiro Asa Sul',
    description:
        'Bate-papo com psicólogo sobre lidar com a pressão do dia a dia.',
  ),
  Event(
    id: 'ev-checkup',
    title: 'Mutirão de check-up',
    date: _dAhead(10),
    location: 'Clínica Bem Viver',
    description:
        'Aferição de pressão, glicemia e orientação de saúde, gratuitas.',
  ),
  Event(
    id: 'ev-financas',
    title: 'Oficina de finanças',
    date: _dAhead(14),
    location: 'Ponto Respiro Taguatinga',
    description: 'Como organizar o orçamento e começar uma reserva.',
  ),
];

/// 8 posts de comunidade, com tom real e respeitoso.
///
final List<CommunityPost> _posts = <CommunityPost>[
  CommunityPost(
    id: 'p1',
    author: 'Marcos A.',
    authorType: DriverType.motorista,
    category: PostCategory.conquista,
    text:
        'Consegui tirar meu primeiro domingo de folga em meses. O mundo não '
        'acabou e voltei melhor na segunda.',
    likes: 42,
    date: _hAgo(3),
    comments: <PostComment>[
      PostComment(
        author: 'Rita S.',
        text: 'Que bom! Descanso também é trabalho bem feito.',
        date: _hAgo(2),
      ),
      PostComment(
        author: 'Pedro H.',
        text: 'Vou tentar fazer isso no próximo domingo.',
        date: _hAgo(1),
      ),
    ],
  ),
  CommunityPost(
    id: 'p2',
    author: 'Rita S.',
    authorType: DriverType.motorista,
    category: PostCategory.dica,
    text:
        'Deixo uma garrafa de água gelada e uma fruta sempre no carro. Ajuda a '
        'não parar em qualquer lanchonete.',
    likes: 31,
    date: _hAgo(9),
    comments: <PostComment>[
      PostComment(
        author: 'Sandra R.',
        text: 'Faço igual! Uma bolsa térmica pequena resolve.',
        date: _hAgo(8),
      ),
    ],
  ),
  CommunityPost(
    id: 'p3',
    author: 'João P.',
    authorType: DriverType.entregador,
    category: PostCategory.pontoDeApoio,
    text:
        'Alguém conhece um ponto de apoio com banheiro aberto de madrugada na '
        'Asa Norte?',
    likes: 12,
    date: _hAgo(26),
    comments: <PostComment>[
      PostComment(
        author: 'Marcos A.',
        text: 'O Posto Aurora da 710 Norte fica aberto 24h.',
        date: _hAgo(26),
      ),
      PostComment(
        author: 'Aline M.',
        text: 'No app, a aba Apoio mostra os pontos abertos agora.',
        date: _hAgo(26),
      ),
      PostComment(author: 'João P.', text: 'Valeu, pessoal!', date: _hAgo(26)),
    ],
  ),
  CommunityPost(
    id: 'p4',
    author: 'Fernanda L.',
    authorType: DriverType.entregador,
    category: PostCategory.desabafo,
    text:
        'Dia difícil, muita chuva e pouca corrida. Bom saber que tem gente '
        'passando pelo mesmo e se apoiando por aqui.',
    likes: 55,
    date: _hAgo(50),
    comments: <PostComment>[
      PostComment(
        author: 'Rita S.',
        text: 'Força! Amanhã é outro dia.',
        date: _hAgo(50),
      ),
      PostComment(
        author: 'Carlos S.',
        text: 'Passei pelo mesmo. Respira e se cuida.',
        date: _hAgo(50),
      ),
    ],
  ),
  CommunityPost(
    id: 'p5',
    author: 'Carlos S.',
    authorType: DriverType.motorista,
    category: PostCategory.dica,
    text:
        'Faço uma pausa de 5 minutos a cada 2 horas. Parece pouco, mas minha '
        'coluna agradece no fim do dia.',
    likes: 38,
    date: _hAgo(74),
    comments: <PostComment>[
      PostComment(
        author: 'Fernanda L.',
        text: 'Comecei a fazer e senti diferença já na primeira semana.',
        date: _hAgo(74),
      ),
    ],
  ),
  CommunityPost(
    id: 'p6',
    author: 'Aline M.',
    authorType: DriverType.motorista,
    category: PostCategory.conquista,
    text:
        'Terminei mais um módulo do ensino médio pelo programa do clube. '
        'Faltam dois!',
    likes: 61,
    date: _hAgo(98),
    comments: <PostComment>[
      PostComment(
        author: 'Marcos A.',
        text: 'Parabéns! Isso inspira a gente.',
        date: _hAgo(98),
      ),
      PostComment(
        author: 'Sandra R.',
        text: 'Que orgulho! Falta pouco.',
        date: _hAgo(98),
      ),
    ],
  ),
  CommunityPost(
    id: 'p7',
    author: 'Pedro H.',
    authorType: DriverType.entregador,
    category: PostCategory.dica,
    text:
        'Separo 10 reais por dia no cofrinho. Em um mês já deu pra fazer a '
        'revisão da moto.',
    likes: 27,
    date: _hAgo(122),
  ),
  CommunityPost(
    id: 'p8',
    author: 'Sandra R.',
    authorType: DriverType.entregador,
    category: PostCategory.desabafo,
    text:
        'Às vezes a gente esquece de cuidar da gente. Esse app me lembrou de '
        'respirar hoje. Obrigada.',
    likes: 49,
    date: _hAgo(146),
    comments: <PostComment>[
      PostComment(
        author: 'Aline M.',
        text: 'Obrigada por compartilhar. Cuidar de si vem primeiro.',
        date: _hAgo(146),
      ),
    ],
  ),
];

// ---------------------------------------------------------------------------
// Persona principal: Carlos Souza
// ---------------------------------------------------------------------------

final PersonaData _carlos = PersonaData(
  profile: const UserProfile(
    name: 'Carlos Souza',
    type: DriverType.motorista,
    vehicle: 'Carro',
    yearsOnApp: 6,
    city: 'Brasília',
    points: 1250,
  ),
  consent: const ConsentSettings(
    shareLocation: true,
    shareWorkHours: true,
    shareFinances: false,
    shareMood: true,
    shareSurvey: true,
  ),
  goals: const <LifeGoal>[
    LifeGoal(
      id: 'g-ensino-medio',
      title: 'Concluir o ensino médio',
      category: GoalCategory.estudos,
      totalSteps: 5,
      completedSteps: 2, // 40%
    ),
    LifeGoal(
      id: 'g-especializacao',
      title: 'Curso de especialização',
      category: GoalCategory.estudos,
      totalSteps: 5,
      completedSteps: 1, // 20%
    ),
    LifeGoal(
      id: 'g-reserva',
      title: 'Reserva de emergência',
      category: GoalCategory.financas,
      totalSteps: 20,
      completedSteps: 11, // 55%
    ),
  ],
  dailyGoal: const DailyGoal(targetRides: 10, completedRides: 6),
  workDay: WorkDay(
    onlineHours: 7.5,
    breaksTaken: 2,
    lastBreak: _today.subtract(const Duration(hours: 1, minutes: 20)),
  ),
  moods: <MoodEntry>[
    MoodEntry(mood: Mood.bem, date: _today),
    MoodEntry(mood: Mood.cansado, date: _dAgo(1)),
  ],
  transactions: <Transaction>[
    // Ganhos (Corridas) — total R$ 4.860.
    Transaction(
      id: 'c-i1',
      type: TransactionType.income,
      category: 'Corridas',
      amount: 980,
      date: _dAgo(2),
      description: 'Repasse de corridas',
    ),
    Transaction(
      id: 'c-i2',
      type: TransactionType.income,
      category: 'Corridas',
      amount: 1120,
      date: _dAgo(6),
      description: 'Repasse de corridas',
    ),
    Transaction(
      id: 'c-i3',
      type: TransactionType.income,
      category: 'Corridas',
      amount: 890,
      date: _dAgo(10),
      description: 'Repasse de corridas',
    ),
    Transaction(
      id: 'c-i4',
      type: TransactionType.income,
      category: 'Corridas',
      amount: 1040,
      date: _dAgo(14),
      description: 'Repasse de corridas',
    ),
    Transaction(
      id: 'c-i5',
      type: TransactionType.income,
      category: 'Corridas',
      amount: 830,
      date: _dAgo(18),
      description: 'Repasse de corridas',
    ),
    // Gastos — total R$ 2.140.
    Transaction(
      id: 'c-e1',
      type: TransactionType.expense,
      category: 'Combustível',
      amount: 200,
      date: _dAgo(1),
      description: 'Abastecimento',
    ),
    Transaction(
      id: 'c-e2',
      type: TransactionType.expense,
      category: 'Combustível',
      amount: 260,
      date: _dAgo(8),
      description: 'Abastecimento',
    ),
    Transaction(
      id: 'c-e3',
      type: TransactionType.expense,
      category: 'Combustível',
      amount: 240,
      date: _dAgo(15),
      description: 'Abastecimento',
    ),
    Transaction(
      id: 'c-e4',
      type: TransactionType.expense,
      category: 'Manutenção',
      amount: 350,
      date: _dAgo(9),
      description: 'Troca de óleo e revisão',
    ),
    Transaction(
      id: 'c-e5',
      type: TransactionType.expense,
      category: 'Alimentação',
      amount: 180,
      date: _dAgo(3),
      description: 'Feira da semana',
    ),
    Transaction(
      id: 'c-e6',
      type: TransactionType.expense,
      category: 'Alimentação',
      amount: 160,
      date: _dAgo(11),
      description: 'Refeições na rua',
    ),
    Transaction(
      id: 'c-e7',
      type: TransactionType.expense,
      category: 'Alimentação',
      amount: 180,
      date: _dAgo(17),
      description: 'Feira da semana',
    ),
    Transaction(
      id: 'c-e8',
      type: TransactionType.expense,
      category: 'Celular/internet',
      amount: 170,
      date: _dAgo(5),
      description: 'Plano de celular',
    ),
    Transaction(
      id: 'c-e9',
      type: TransactionType.expense,
      category: 'Outros',
      amount: 250,
      date: _dAgo(7),
      description: 'Farmácia',
    ),
    Transaction(
      id: 'c-e10',
      type: TransactionType.expense,
      category: 'Outros',
      amount: 150,
      date: _dAgo(12),
      description: 'Presente para a filha',
    ),
  ],
  piggyBank: const PiggyBank(balance: 120, goal: 500),
  benefits: _benefits,
  studyPrograms: _studyPrograms,
  supportPoints: _supportPoints,
  events: _events,
  posts: _posts,
  surveyQuestions: kSurveyQuestions,
);

// ---------------------------------------------------------------------------
// Persona secundária: Joana Lima
// ---------------------------------------------------------------------------

final PersonaData _joana = PersonaData(
  profile: const UserProfile(
    name: 'Joana Lima',
    type: DriverType.entregador,
    vehicle: 'Moto',
    yearsOnApp: 3,
    city: 'Brasília',
    points: 640,
  ),
  consent: const ConsentSettings(
    shareLocation: true,
    shareWorkHours: true,
    shareFinances: true,
    shareMood: true,
    shareSurvey: false,
  ),
  goals: const <LifeGoal>[
    LifeGoal(
      id: 'g-faculdade',
      title: 'Juntar para a faculdade',
      category: GoalCategory.estudos,
      totalSteps: 10,
      completedSteps: 3, // 30%
    ),
    LifeGoal(
      id: 'g-moto',
      title: 'Trocar de moto',
      category: GoalCategory.financas,
      totalSteps: 8,
      completedSteps: 2, // 25%
    ),
    LifeGoal(
      id: 'g-saude',
      title: 'Fazer um check-up de saúde',
      category: GoalCategory.saude,
      totalSteps: 4,
      completedSteps: 1, // 25%
    ),
  ],
  dailyGoal: const DailyGoal(targetRides: 12, completedRides: 8),
  workDay: WorkDay(
    onlineHours: 5,
    breaksTaken: 1,
    lastBreak: _today.subtract(const Duration(hours: 2, minutes: 10)),
  ),
  moods: <MoodEntry>[MoodEntry(mood: Mood.bem, date: _today)],
  transactions: <Transaction>[
    // Ganhos (Entregas) — total R$ 3.200.
    Transaction(
      id: 'j-i1',
      type: TransactionType.income,
      category: 'Entregas',
      amount: 820,
      date: _dAgo(2),
      description: 'Repasse de entregas',
    ),
    Transaction(
      id: 'j-i2',
      type: TransactionType.income,
      category: 'Entregas',
      amount: 760,
      date: _dAgo(6),
      description: 'Repasse de entregas',
    ),
    Transaction(
      id: 'j-i3',
      type: TransactionType.income,
      category: 'Entregas',
      amount: 900,
      date: _dAgo(11),
      description: 'Repasse de entregas',
    ),
    Transaction(
      id: 'j-i4',
      type: TransactionType.income,
      category: 'Entregas',
      amount: 720,
      date: _dAgo(16),
      description: 'Repasse de entregas',
    ),
    // Gastos — total R$ 1.500.
    Transaction(
      id: 'j-e1',
      type: TransactionType.expense,
      category: 'Combustível',
      amount: 160,
      date: _dAgo(1),
      description: 'Abastecimento',
    ),
    Transaction(
      id: 'j-e2',
      type: TransactionType.expense,
      category: 'Combustível',
      amount: 140,
      date: _dAgo(10),
      description: 'Abastecimento',
    ),
    Transaction(
      id: 'j-e3',
      type: TransactionType.expense,
      category: 'Manutenção',
      amount: 200,
      date: _dAgo(13),
      description: 'Revisão da moto',
    ),
    Transaction(
      id: 'j-e4',
      type: TransactionType.expense,
      category: 'Alimentação',
      amount: 260,
      date: _dAgo(4),
      description: 'Mercado',
    ),
    Transaction(
      id: 'j-e5',
      type: TransactionType.expense,
      category: 'Alimentação',
      amount: 240,
      date: _dAgo(12),
      description: 'Refeições na rua',
    ),
    Transaction(
      id: 'j-e6',
      type: TransactionType.expense,
      category: 'Celular/internet',
      amount: 120,
      date: _dAgo(5),
      description: 'Plano de celular',
    ),
    Transaction(
      id: 'j-e7',
      type: TransactionType.expense,
      category: 'Outros',
      amount: 200,
      date: _dAgo(8),
      description: 'Capacete novo',
    ),
    Transaction(
      id: 'j-e8',
      type: TransactionType.expense,
      category: 'Outros',
      amount: 180,
      date: _dAgo(14),
      description: 'Farmácia',
    ),
  ],
  piggyBank: const PiggyBank(balance: 60, goal: 300),
  benefits: _benefits,
  studyPrograms: _studyPrograms,
  supportPoints: _supportPoints,
  events: _events,
  posts: _posts,
  surveyQuestions: kSurveyQuestions,
);
