import 'package:breathe_drivers_club/core/utils/formatters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('formatCurrency', () {
    test('formata milhar com ponto e decimal com vírgula', () {
      expect(formatCurrency(1234.56), 'R\$ 1.234,56');
    });

    test('inteiro ganha duas casas decimais', () {
      expect(formatCurrency(120), 'R\$ 120,00');
    });

    test('zero', () {
      expect(formatCurrency(0), 'R\$ 0,00');
    });

    test('milhões com dois separadores de milhar', () {
      expect(formatCurrency(1234567.89), 'R\$ 1.234.567,89');
    });

    test('arredonda para centavos', () {
      expect(formatCurrency(9.999), 'R\$ 10,00');
    });

    test('valor negativo', () {
      expect(formatCurrency(-10), '-R\$ 10,00');
    });
  });

  group('formatDistance', () {
    test('abaixo de 1 km mostra metros', () {
      expect(formatDistance(250), '250 m');
    });

    test('exatamente 1 km', () {
      expect(formatDistance(1000), '1 km');
    });

    test('km com uma casa decimal', () {
      expect(formatDistance(1200), '1,2 km');
    });

    test('km exato omite o decimal zero', () {
      expect(formatDistance(2000), '2 km');
    });

    test('arredonda metros', () {
      expect(formatDistance(249.6), '250 m');
    });
  });

  group('formatDuration', () {
    test('horas e minutos', () {
      expect(formatDuration(const Duration(hours: 5, minutes: 20)), '5h20');
    });

    test('minutos com zero à esquerda', () {
      expect(formatDuration(const Duration(hours: 2, minutes: 5)), '2h05');
    });

    test('horas exatas omitem minutos', () {
      expect(formatDuration(const Duration(hours: 2)), '2h');
    });

    test('abaixo de uma hora', () {
      expect(formatDuration(const Duration(minutes: 45)), '45min');
    });
  });
}
