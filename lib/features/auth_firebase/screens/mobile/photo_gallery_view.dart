import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../blocs/bloc.dart';
import '../screen.dart';

class PhotoGalleryView extends HookWidget {
  const PhotoGalleryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homepage'),
        actions: [
          const MainPopupMenuButton(),
        ],
      ),
      body: Container(),
    );
  }
}
