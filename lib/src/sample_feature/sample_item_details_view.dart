import 'package:flutter/material.dart';
import 'package:my_app/src/app.dart';

/// Displays detailed information about a SampleItem.
class SampleItemDetailsView extends StatelessWidget {
  const SampleItemDetailsView({Key? key}) : super(key: key);

  static const routeName = '/sample_item';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              rootScaffoldMessengerKey.currentState!
                  .showMaterialBanner(MaterialBanner(
                content: Text("asdd"),
                actions: [
                  TextButton(
                    onPressed: () {
                      rootScaffoldMessengerKey.currentState!
                          .clearMaterialBanners();
                    },
                    child: Text("asdsd"),
                  )
                ],
              ));
              // rootScaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
              //   content: Text("sdfsdfdsffd"),
              // ));
            },
            child: Text('More Information Here')),
      ),
    );
  }
}
