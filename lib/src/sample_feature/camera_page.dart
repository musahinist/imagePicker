import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/src/sample_feature/crop_page.dart';

import 'gallery_page.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key, required this.onSelect, this.child})
      : super(key: key);
  final ValueSetter<XFile?> onSelect;
  final Widget? child;
  static const routeName = '/camera_page';

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  XFile? file;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
            onTap: () async {
              List<CameraDescription> cameraList = await availableCameras();
              Navigator.of(context)
                  .push(
                MaterialPageRoute<XFile>(
                  builder: (context) => TakePictureScreen(
                    cameraList: cameraList,
                  ),
                ),
              )
                  .then((file) {
                widget.onSelect(file);

                this.file = file;
                setState(() {});
              });
            },
            child: SizedBox(
              height: 50,
              child: widget.child ??
                  CircleAvatar(
                    backgroundImage:
                        file != null ? FileImage(File(file!.path)) : null,
                  ),
            ))
        // FutureBuilder<List<CameraDescription>>(
        //     future: availableCameras(),
        //     builder: (context, snapshot) {
        //       if (snapshot.connectionState == ConnectionState.done) {
        //         return TakePictureScreen(
        //             cameraList: snapshot.data!, onSelect: onSelect);
        //       } else {
        //         return Center(
        //           child: const CircularProgressIndicator.adaptive(),
        //         );
        //       }
        //     }),
        ;
  }
}

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    Key? key,
    required this.cameraList,
  }) : super(key: key);

  final List<CameraDescription> cameraList;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen>
    with TickerProviderStateMixin {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late TabController _tabController;
  List<double> exposureList = [];
  XFile? image;
  IconData flashIcon = Icons.flash_auto;
  bool isCamera = true;

  double exposure = 0;
  int segmentedControlValue = 0;
  double _currentSliderValue = 20;
  double maxZoom = 1;
  double minZoom = 1;
  double curZoom = 1;
  bool isZooming = false;
  @override
  void initState() {
    super.initState();
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle
    //     .dark); // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.cameraList.first,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      isCamera = _tabController.index == 0 ? true : false;
      segmentedControlValue = _tabController.index;
      setState(() {});
    });
    // _tabController.addListener(() async {
    //   if (_tabController.index == 1) {
    //     _controller = CameraController(
    //       // Get a specific camera from the list of available cameras.
    //       widget.cameraList.first,
    //       // Define the resolution to use.
    //       ResolutionPreset.high,
    //     );
    //     _initializeControllerFuture = _controller.initialize();
    //     setState(() {});
    //   }
    // });
  }

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _initializeControllerFuture = _controller.initialize();
    await _initializeControllerFuture;
    minZoom = await _controller.getMinZoomLevel();
    maxZoom = await _controller.getMaxZoomLevel();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black38,
        elevation: 0,
        actions: isCamera
            ? [
                AnimatedOpacity(
                  duration: Duration(milliseconds: 300),
                  opacity: isZooming ? 1 : 0,
                  child: CircleAvatar(
                      backgroundColor: Colors.black38,
                      child: Text(curZoom.toStringAsFixed(1))),
                ),
                IconButton(
                  icon: Icon(Icons.exposure),
                  onPressed: () async {
                    exposureList = [
                      await _controller.getMinExposureOffset(),
                      await _controller.getMaxExposureOffset(),
                      await _controller.getExposureOffsetStepSize()
                    ];
                    showMenu(
                      shape: StadiumBorder(),
                      position: RelativeRect.fromSize(
                          Rect.fromLTWH(0, 30, 20, 30), Size.zero),
                      context: context,
                      items: <PopupMenuEntry<double>>[
                        PopupMenuItem<double>(
                          enabled: false,
                          child: StatefulBuilder(
                            builder: (context, state) => Row(
                              children: [
                                SizedBox(
                                  width: 24,
                                  child: Center(
                                    child: Text(
                                      exposure.round().toString(),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 150,
                                  child: CupertinoSlider(
                                    activeColor: Colors.amber,
                                    min: exposureList[0],
                                    max: exposureList[1],
                                    divisions: exposureList[2].round() != 0
                                        ? exposureList[2].round()
                                        : null,
                                    value: exposure,
                                    onChanged: (val) {
                                      state(() {
                                        exposure = val;
                                        _controller.setExposureOffset(val);
                                        print(val);
                                        // _controller.setExposureMode(
                                        //     ExposureMode.auto);
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                IconButton(
                  icon: Icon(flashIcon),
                  onPressed: () {
                    showMenu(
                      shape: StadiumBorder(),
                      position: RelativeRect.fromSize(
                          Rect.fromLTWH(0, 30, 20, 30), Size.zero),
                      context: context,
                      items: <PopupMenuEntry<double>>[
                        PopupMenuItem<double>(
                          enabled: false,
                          onTap: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  _controller.setFlashMode(FlashMode.off);

                                  flashIcon = Icons.flash_off;
                                  Navigator.of(context).pop();
                                  setState(() {});
                                },
                                icon: Icon(Icons.flash_off),
                              ),
                              IconButton(
                                onPressed: () {
                                  _controller.setFlashMode(FlashMode.auto);
                                  flashIcon = Icons.flash_auto;
                                  Navigator.of(context).pop();
                                  setState(() {});
                                },
                                icon: Icon(Icons.flash_auto),
                              ),
                              IconButton(
                                onPressed: () {
                                  _controller.setFlashMode(FlashMode.always);
                                  flashIcon = Icons.flash_on;
                                  Navigator.of(context).pop();
                                  setState(() {});
                                },
                                icon: Icon(Icons.flash_on),
                              ),
                              IconButton(
                                onPressed: () {
                                  _controller.setFlashMode(FlashMode.torch);
                                  flashIcon = Icons.flashlight_on;
                                  Navigator.of(context).pop();
                                  setState(() {});
                                },
                                icon: Icon(Icons.flashlight_on),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                // IconButton(
                //   onPressed: () {
                //     _controller.setZoomLevel(2);
                //     setState(() {});
                //   },
                //   icon: Icon(Icons.zoom_out),
                // ),

                IconButton(
                  onPressed: () {
                    _controller = CameraController(
                      // Get a specific camera from the list of available cameras.
                      _controller.description.lensDirection ==
                              CameraLensDirection.back
                          ? widget.cameraList.last
                          : widget.cameraList.first,
                      // Define the resolution to use.
                      ResolutionPreset.high,
                    );
                    _initializeControllerFuture = _controller.initialize();
                    setState(() {});
                  },
                  icon: Icon(Icons.switch_camera_outlined, color: Colors.white),
                ),
                //  VerticalDivider(color: Colors.white),
              ]
            : [],
        // title: const Text('Take a picture'),
      ),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: TabBarView(
        controller: _tabController,
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the Future is complete, display the preview.
                return InteractiveViewer(
                  panEnabled: false,
                  minScale: minZoom,
                  maxScale: maxZoom,
                  onInteractionUpdate: (details) {
                    if (details.scale >= minZoom && details.scale <= maxZoom) {
                      isZooming = true;
                      curZoom = details.scale;
                      _controller.setZoomLevel(details.scale);
                      setState(() {});
                    }
                  },
                  onInteractionEnd: (details) {
                    isZooming = false;

                    setState(() {});
                  },
                  child: CameraPreview(
                    _controller,
                  ),
                );
              } else {
                // Otherwise, display a loading indicator.
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          // image != null ? CropSample(image: image!) : SizedBox(),
          GalleryPage(
            onSelect: (file) {
              image = file;
              setState(() {});
            },
          )
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: isCamera
          ? FloatingActionButton(
              //  elevation: 0,
              backgroundColor: Colors.white,
              // foregroundColor: Colors.transparent,
              // Provide an onPressed callback.
              onPressed: () async {
                // Take the Picture in a try / catch block. If anything goes wrong,
                // catch the error.
                try {
                  // Ensure that the camera is initialized.
                  await _initializeControllerFuture;

                  // Attempt to take a picture and get the file `image`
                  // where it was saved.
                  image = await _controller.takePicture();
                  setState(() {});

                  // If the picture was taken, display it on a new screen.
                  // await Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => DisplayPictureScreen(
                  //       // Pass the automatically generated path to
                  //       // the DisplayPictureScreen widget.
                  //       imagePath: image!.path,
                  //     ),
                  //   ),
                  // );
                } catch (e) {
                  // If an error occurs, log the error to the console.
                  print(e);
                }
              },
              child: Icon(isCamera ? Icons.camera : Icons.photo_library,
                  color: Colors.amber))
          : null,
      bottomNavigationBar: BottomAppBar(
        color: Colors.black38,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              if (image != null)
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            enableDrag: true,
                            context: context,
                            builder: (context) => DisplayPictureScreen(
                                  imagePath: image!.path,
                                  onDelete: () {
                                    image = null;
                                    Navigator.of(context).pop();
                                    setState(() {});
                                  },
                                ));
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.amber,
                        backgroundImage:
                            image != null ? FileImage(File(image!.path)) : null,
                      ),
                    ),
                    SizedBox(width: 12),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop(image);
                      },
                      icon: Icon(Icons.check, color: Colors.white),
                    ),
                  ],
                ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CupertinoSlidingSegmentedControl(
                    groupValue: segmentedControlValue,
                    backgroundColor: Colors.black38,
                    thumbColor: Colors.amber,
                    children: const <int, Widget>{
                      0: Icon(Icons.camera, color: Colors.white),
                      1: Icon(Icons.photo_library, color: Colors.white),
                    },
                    onValueChanged: (value) {
                      setState(() {
                        segmentedControlValue = value as int;
                        _tabController.animateTo(segmentedControlValue);
                      });
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final VoidCallback onDelete;

  const DisplayPictureScreen(
      {Key? key, required this.imagePath, required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Image.file(
            File(imagePath),
            fit: BoxFit.contain,
          ),
        ),
        IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        )
      ],
    );
  }
}
