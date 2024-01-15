
String calcularTiempoTranscurrido(DateTime fechaInicial, DateTime fechaActual) {
  int diferenciaEnDias = fechaActual.difference(fechaInicial).inDays;
  if (diferenciaEnDias < 30) {
    return "$diferenciaEnDias dias";
  }
  final months = diferenciaEnDias ~/ 30;
  if(months < 12){
    return "${months.toInt()} meses";
  }
  final years =  months / 12;
    return "${years.toInt()} años";
}