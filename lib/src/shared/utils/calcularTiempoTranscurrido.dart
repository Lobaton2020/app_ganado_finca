
String calcularTiempoTranscurrido(DateTime fechaInicial, DateTime fechaActual) {
  int diferenciaEnDias = fechaActual.difference(fechaInicial).inDays;
  if (diferenciaEnDias == 0) {
    return "${fechaActual.difference(fechaInicial).inHours}h";
  }
  if (diferenciaEnDias < 30) {
    return "${diferenciaEnDias}d";
  }
  final months = diferenciaEnDias ~/ 30;
  if(months < 12){
    return "${months.toInt()}m";
  }
  final years =  months / 12;
  return "${years.toInt()}a";
}