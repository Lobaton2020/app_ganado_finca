# app_ganado_finca

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
`flutter doctor`
`dart pub cache repair`
`dart pub cache clean`
`flutter pub get`
`flutter run --hot`
`flutter config --android-sdk "path"`
`flutter build apk --release`


# Anotaciones sincronizacion:

Cada cuanto acualizo mi BD local, cad vez que haga una mutacion sobre cad componente en especifico, al crear en modo online etc.

  Escenario cuando no hay internet:
  No por ahora:
  * Crear salida animal
  * Eliminar salida animal
  * Editar registro animal, foto
 Llama funcion de sincronizacion, en secuencia:
 Primero sincroniza la tabla bovines

 Debe existir una opcion de Eliminar caché para que borré lo local y traiga toda la data del server. Solo si hay internet.
