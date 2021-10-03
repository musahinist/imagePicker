import 'dart:io';

import 'package:advance_image_picker/advance_image_picker.dart';
import 'package:flutter/material.dart';

class ImagePickerPage extends StatelessWidget {
  // This widget is the root of your application.
  static const routeName = '/image_picker';

  const ImagePickerPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Setup image picker configs
    var configs = ImagePickerConfigs();
    // AppBar text color
    //   configs.bottomPanelColor = Colors.transparent;
    configs.appBarTextColor = Colors.white;
    configs.stickerFeatureEnabled = false;

    // Disable select images from album

    // Only use front camera for capturing
    // configs.cameraLensDirection = 0;
    // Translate function
    configs.translateFunc = (name, value) {
      switch (name) {
        case "image_picker_select_images_title":
          return 'Seçilen fotoğraf adedi.';
        case "image_picker_select_images_guide":
          return "Sürükleyerek fotoğrafları sıralayabilirsin";
        case "image_picker_camera_title":
          return "Kamera";
        case "image_picker_album_title":
          return "Albüm";
        case "image_picker_preview_title":
          return "Ön İzleme";
        case "image_picker_confirm":
          return "Onayla";
        case "image_picker_exit_without_selecting":
          return "Fotograf seçmeden çıkmak istiyor musun?";
        case "image_picker_confirm_delete":
          return "Fotoğrafı silmek istiyor musun?";
        case "image_picker_confirm_reset_changes":
          return "Fotograftaki bütün değişiklikleri silmek istiyor musun?";
        case "yes":
          return "Evet";
        case "no":
          return "Hayır";
        case "save":
          return "Kaydet";
        case "clear":
          return "Temizle";
        case "image_picker_edit_text":
          return "Metni Düzenle";
        case "image_picker_no_images":
          return "Fotograf yok...";
        case "image_picker_image_crop_title":
          return "Kırp";
        case "image_picker_image_filter_title":
          return "Filtrele";
        case "image_picker_image_edit_title":
          return "Düzenle";
        case "image_picker_image_sticker_title":
          return "Etiket";
        case "image_picker_image_addtext_title":
          return "Metin Ekle";
        case "image_picker_select_button_title":
          return "Seç";
        case "image_picker_image_sticker_guide":
          return "" /*"You can click on sticker icons to scale it or double click to remove it from image"*/;
        case "image_picker_exposure_title":
          return "Exposure";
        case "image_picker_exposure_locked_title":
          return "Kilitli";
        case "image_picker_exposure_auto_title":
          return "Otomatik";
        case "image_picker_image_edit_contrast":
          return "Zıtlık";
        case "image_picker_image_edit_brightness":
          return "Aydınlık";
        case "image_picker_image_edit_saturation":
          return "Doygunluk";
        default:
          return value;
      }
    };

    // /// Get localized text for label "image_picker_image_edit_saturation".
    // ///
    // /// Defaults to "saturation".
    // String get textSaturation =>
    //     getTranslatedString(, "saturation");
    //   };
    //   configs.getTranslatedString("image_picker_camera_title", "fggCamera");

    // Disable edit function, then add other edit control instead

    // configs.externalImageEditors['external_image_editor_1'] = EditorParams(
    //     title: 'external_image_editor_1',
    //     icon: Icons.edit_rounded,
    //     onEditorEvent: (
    //         {required BuildContext context,
    //         required File file,
    //         required String title,
    //         int maxWidth = 1080,
    //         int maxHeight = 1920,
    //         int compressQuality = 90,
    //         ImagePickerConfigs? configs}) async {
    //       return await Navigator.of(context).push(
    //         MaterialPageRoute<File>(
    //           fullscreenDialog: true,
    //           builder: (context) => ImageEdit(
    //               file: file,
    //               title: title,
    //               maxWidth: maxWidth,
    //               maxHeight: maxHeight,
    //               configs: configs),
    //         ),
    //       );
    //     });
    // configs.externalImageEditors['external_image_editor_2'] = EditorParams(
    //     title: 'external_image_editor_2',
    //     icon: Icons.edit_attributes,
    //     onEditorEvent: (
    //         {required BuildContext context,
    //         required File file,
    //         required String title,
    //         int maxWidth = 1080,
    //         int maxHeight = 1920,
    //         int compressQuality = 90,
    //         ImagePickerConfigs? configs}) async {
    //       return await Navigator.of(context).push(MaterialPageRoute<File>(
    //           fullscreenDialog: true,
    //           builder: (context) => ImageSticker(
    //               file: file,
    //               title: title,
    //               maxWidth: maxWidth,
    //               maxHeight: maxHeight,
    //               configs: configs)));
    //     });

    return const MyHomePage(title: 'advance_image_picker Demo');
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ImageObject> _imgObjs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            GridView.builder(
                shrinkWrap: true,
                itemCount: _imgObjs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    childAspectRatio: 1),
                itemBuilder: (BuildContext context, int index) {
                  var image = _imgObjs[index];
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Image.file(File(image.modifiedPath),
                        height: 80, fit: BoxFit.cover),
                  );
                })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Get max 5 images
          List<ImageObject>? objects = await Navigator.of(context)
              .push(PageRouteBuilder(pageBuilder: (context, animation, __) {
            return const ImagePicker(
              maxCount: 3,
              isCaptureFirst: true,
              isFullscreenImage: true,
            );
          }));

          if ((objects?.length ?? 0) > 0) {
            setState(() {
              _imgObjs = objects!;
            });
          }
        },
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
