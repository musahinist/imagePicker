import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_app/src/sample_feature/advance_image_picker.dart';
import 'package:my_app/src/sample_feature/camera_page.dart';
import 'package:my_app/src/sample_feature/flutter_tts.dart';

import '../settings/settings_view.dart';
import 'sample_item.dart';
import 'sample_item_details_view.dart';

/// Displays a list of SampleItems.
class SampleItemListView extends StatelessWidget {
  const SampleItemListView(
      {Key? key,
      this.routeNameList = const [
        SampleItemDetailsView.routeName,
        //  TtsApp.routeName,
        ImagePickerPage.routeName,
      ]})
      : super(key: key);

  static const routeName = '/';

  final List<String> routeNameList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      body: Column(
        children: [
          ListTile(
            title: Text("myImagePicker"),
            leading: CameraPage(
              onSelect: (file) {},
            ),
          ),
          Expanded(
            child: ListView.builder(
              // Providing a restorationId allows the ListView to restore the
              // scroll position when a user leaves and returns to the app after it
              // has been killed while running in the background.
              restorationId: 'sampleItemListView',
              itemCount: routeNameList.length,
              itemBuilder: (BuildContext context, int index) {
                final item = routeNameList[index];

                return ListTile(
                    title: Text(item),
                    leading: const CircleAvatar(
                      // Display the Flutter Logo image asset.
                      foregroundImage:
                          AssetImage('assets/images/flutter_logo.png'),
                    ),
                    onTap: () {
                      // Navigate to the details page. If the user leaves and returns to
                      // the app after it has been killed while running in the
                      // background, the navigation stack is restored.

                      Navigator.restorablePushNamed(
                        context,
                        item,
                      );
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}
