import 'package:app_ganado_finca/src/components/SimpleAppBar.dart';
import 'package:app_ganado_finca/src/models/Bovine.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

Widget cachedNetworkImage(mediaUrl) {
  return CachedNetworkImage(
    imageUrl: mediaUrl,
    fit: BoxFit.cover,
    placeholder: (context, url) => Padding(
      padding: EdgeInsets.all(20.0),
      child: CircularProgressIndicator(),
    ),
    errorWidget: (context, url, error) => Icon(Icons.error),
  );
}
class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final urlImage = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: buildSimpleAppBar(context, 'Detalle imagen'),
      body: Center(
        child: PhotoView(
          loadingBuilder: (context, event) {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 0.5,
              ),
            );
          },
          imageProvider: CachedNetworkImageProvider(urlImage),
        ),
      ),
    );
  }
}
