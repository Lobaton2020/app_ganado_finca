import 'package:app_ganado_finca/src/presentation/components/SimpleAppBar.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
Widget cachedNetworkImage(mediaUrl) {
  final bool isLocal = !RegExp(r'^https?://').hasMatch(mediaUrl);
  if(isLocal && mediaUrl != null){
    return Image.file(File(mediaUrl));
  }
  return CachedNetworkImage(
    imageUrl: mediaUrl,
    fit: BoxFit.fill,
    placeholder: (context, url) => Padding(
      padding: EdgeInsets.all(0),
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
      ),
    ),
    errorWidget: (context, url, error) => Icon(Icons.error),
  );
}

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final urlImage = ModalRoute.of(context)!.settings.arguments as String;
    final bool isLocal = !RegExp(r'^https?://').hasMatch(urlImage);
    return Scaffold(
      appBar: buildSimpleAppBar(context, 'Detalle imagen'),
      body: Center(
        child: isLocal && urlImage != null
          ? PhotoView(
            loadingBuilder: (context, event) {
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 0.5,
                ),
              );
            },
            imageProvider: FileImage(File(urlImage))
          )
          : PhotoView(
          loadingBuilder: (context, event) {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 0.5,
              ),
            );
          },
          imageProvider: CachedNetworkImageProvider(urlImage)
        ),
      ),
    );
  }
}
