// Formatadores de texto para exibição em pt-BR.
//
// Escritos à mão (sem o pacote `intl`) porque o protótipo usa dados fictícios
// e só precisa do locale pt-BR. Se um dia houver API/internacionalização,
// trocar por `intl` aqui, de forma centralizada.

/// Formata um valor em reais como `R$ 1.234,56`.
///
/// Separador de milhar: ponto. Separador decimal: vírgula. Sempre 2 casas.
/// Aceita valores negativos: `-R$ 10,00`.
String formatCurrency(num value) {
  final bool negative = value < 0;
  final double abs = value.abs().toDouble();

  // Arredonda para centavos e separa parte inteira e decimal.
  final int cents = (abs * 100).round();
  final int whole = cents ~/ 100;
  final int fraction = cents % 100;

  final String digits = whole.toString();
  final StringBuffer grouped = StringBuffer();
  for (int i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) {
      grouped.write('.');
    }
    grouped.write(digits[i]);
  }

  final String fractionText = fraction.toString().padLeft(2, '0');
  final String sign = negative ? '-' : '';
  return '${sign}R\$ $grouped,$fractionText';
}

/// Formata uma distância em metros como `250 m` ou `1,2 km`.
///
/// Abaixo de 1 km mostra metros inteiros; a partir de 1 km mostra km com uma
/// casa decimal (vírgula), omitindo o `,0` quando for exato (`2 km`).
String formatDistance(num meters) {
  if (meters < 1000) {
    return '${meters.round()} m';
  }
  final double km = meters / 1000;
  final int tenths = (km * 10).round();
  final int whole = tenths ~/ 10;
  final int decimal = tenths % 10;
  if (decimal == 0) {
    return '$whole km';
  }
  return '$whole,$decimal km';
}

const List<String> _monthsShort = <String>[
  'jan', 'fev', 'mar', 'abr', 'mai', 'jun',
  'jul', 'ago', 'set', 'out', 'nov', 'dez',
];

/// Formata uma data como `25/11`.
String formatShortDate(DateTime date) {
  final String day = date.day.toString().padLeft(2, '0');
  final String month = date.month.toString().padLeft(2, '0');
  return '$day/$month';
}

/// Cabeçalho de dia relativo: `Hoje`, `Ontem` ou `25 de nov`.
String formatDayHeader(DateTime date, {DateTime? now}) {
  final DateTime reference = now ?? DateTime.now();
  final DateTime today = DateTime(reference.year, reference.month, reference.day);
  final DateTime day = DateTime(date.year, date.month, date.day);
  final int diff = today.difference(day).inDays;
  if (diff == 0) return 'Hoje';
  if (diff == 1) return 'Ontem';
  return '${date.day} de ${_monthsShort[date.month - 1]}';
}

/// Formata uma duração como `5h20`, `45min` ou `2h`.
///
/// A partir de 1 hora usa o formato `<h>h<mm>`, omitindo os minutos quando
/// forem zero. Abaixo de 1 hora usa `<n>min`.
String formatDuration(Duration duration) {
  final int totalMinutes = duration.inMinutes;
  final int hours = totalMinutes ~/ 60;
  final int minutes = totalMinutes % 60;

  if (hours == 0) {
    return '${minutes}min';
  }
  if (minutes == 0) {
    return '${hours}h';
  }
  return '${hours}h${minutes.toString().padLeft(2, '0')}';
}

/// Tempo relativo curto para feeds: `agora`, `há 5 min`, `há 3h`, `ontem`,
/// `há 4 dias` ou, a partir de uma semana, `25 de nov`.
String formatTimeAgo(DateTime date, {DateTime? now}) {
  final DateTime reference = now ?? DateTime.now();
  final Duration diff = reference.difference(date);
  if (diff.inMinutes < 1) return 'agora';
  if (diff.inMinutes < 60) return 'há ${diff.inMinutes} min';
  if (diff.inHours < 24) return 'há ${diff.inHours}h';
  final DateTime today =
      DateTime(reference.year, reference.month, reference.day);
  final DateTime day = DateTime(date.year, date.month, date.day);
  final int days = today.difference(day).inDays;
  if (days <= 1) return 'ontem';
  if (days < 7) return 'há $days dias';
  return '${date.day} de ${_monthsShort[date.month - 1]}';
}

/// Iniciais de um nome para avatares: `Carlos Souza` → `CS`, `Rita` → `R`.
String initialsOf(String name) {
  final List<String> parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((String p) => p.isNotEmpty)
      .toList();
  if (parts.isEmpty) return '?';
  if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
  return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
      .toUpperCase();
}
