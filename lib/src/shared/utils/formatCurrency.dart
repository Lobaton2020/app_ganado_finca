import 'package:intl/intl.dart';

String formatearMonedaCOP(double valor) {
  final format = NumberFormat.currency(
    locale: "es_CO",
    symbol: "COP",
    decimalDigits: 1,
  );

  return format.format(valor);
}
