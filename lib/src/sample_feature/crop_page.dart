import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';

class CropSample extends StatefulWidget {
  final XFile image;
  const CropSample({
    Key? key,
    required this.image,
  }) : super(key: key);
  @override
  _CropSampleState createState() => _CropSampleState();
}

class _CropSampleState extends State<CropSample> {
  // static const _images = const [];

  final _cropController = CropController();
  final _imageDataList = <Uint8List>[];

  var _loadingImage = false;
  var _currentImage = 0;
  set currentImage(int value) {
    setState(() {
      _currentImage = value;
    });

    //_imageDataList[_currentImage];
  }

  var _isSumbnail = false;
  var _isCropping = false;
  var _isCircleUi = false;
  Uint8List? _croppedData;
  var _statusText = '';

  @override
  void initState() {
    _loadAllImages();
    super.initState();
  }

  Future<void> _loadAllImages() async {
    setState(() {
      _loadingImage = true;
    });

    Uint8List temp = await widget.image.readAsBytes();
    // _cropController.image = temp;
    _imageDataList.add(temp);

    // for (final assetName in _images) {
    //   _imageDataList.add(await _load(assetName));
    // }
    setState(() {
      _loadingImage = false;
    });
  }

  // Future<Uint8List> _load(String assetName) async {
  //   final assetData = await rootBundle.load(assetName);
  //   return assetData.buffer.asUint8List();
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Visibility(
        visible: !_loadingImage && !_isCropping,
        child: Stack(
          children: [
            // if (_imageDataList.length >= 4)
            //   Padding(
            //     padding: const EdgeInsets.all(16),
            //     child: Row(
            //       children: [
            //         _buildSumbnail(_imageDataList[0]),
            //         // const SizedBox(width: 16),
            //         // _buildSumbnail(_imageDataList[1]),
            //         // const SizedBox(width: 16),
            //         // _buildSumbnail(_imageDataList[2]),
            //         // const SizedBox(width: 16),
            //         // _buildSumbnail(_imageDataList[3]),
            //       ],
            //     ),
            //   ),
            Expanded(
              child: Visibility(
                visible: _croppedData == null,
                child: Stack(
                  children: [
                    if (_imageDataList.isNotEmpty)
                      Crop(
                        controller: _cropController,
                        image: _imageDataList[_currentImage],
                        onCropped: (croppedData) {
                          setState(() {
                            _croppedData = croppedData;
                            _isCropping = false;
                          });
                        },
                        withCircleUi: _isCircleUi,
                        onStatusChanged: (status) => setState(() {
                          _statusText = <CropStatus, String>{
                                CropStatus.nothing: 'Crop has no image data',
                                CropStatus.loading:
                                    'Crop is now loading given image',
                                CropStatus.ready: 'Crop is now ready!',
                                CropStatus.cropping:
                                    'Crop is now cropping image',
                              }[status] ??
                              '';
                        }),
                        initialSize: 0.5,
                        maskColor: _isSumbnail ? Colors.white : null,
                        cornerDotBuilder: (size, edgeAlignment) => _isSumbnail
                            ? const SizedBox.shrink()
                            : const DotControl(),
                      ),
                    Positioned(
                      right: 16,
                      bottom: 16,
                      child: GestureDetector(
                        onTapDown: (_) => setState(() => _isSumbnail = true),
                        onTapUp: (_) => setState(() => _isSumbnail = false),
                        child: CircleAvatar(
                          backgroundColor:
                              _isSumbnail ? Colors.blue.shade50 : Colors.blue,
                          child: Center(
                            child: Icon(Icons.crop_free_rounded),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                replacement: Center(
                  child: _croppedData == null
                      ? SizedBox.shrink()
                      : Image.memory(_croppedData!),
                ),
              ),
            ),
            if (_croppedData == null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.crop_7_5, color: Colors.white),
                          onPressed: () {
                            _isCircleUi = false;
                            _cropController.aspectRatio = 16 / 4;
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.crop_16_9, color: Colors.white),
                          onPressed: () {
                            _isCircleUi = false;
                            _cropController.aspectRatio = 16 / 9;
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.crop_5_4, color: Colors.white),
                          onPressed: () {
                            _isCircleUi = false;
                            _cropController.aspectRatio = 4 / 3;
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.crop_square, color: Colors.white),
                          onPressed: () {
                            _isCircleUi = false;
                            _cropController
                              ..withCircleUi = false
                              ..aspectRatio = 1;
                          },
                        ),
                        IconButton(
                            icon: Icon(Icons.circle, color: Colors.white),
                            onPressed: () {
                              _isCircleUi = true;
                              _cropController.withCircleUi = true;
                            }),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isCropping = true;
                          });
                          _isCircleUi
                              ? _cropController.cropCircle()
                              : _cropController.crop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text('CROP IT!'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            Text(_statusText, style: TextStyle(color: Colors.white)),
            const SizedBox(height: 16),
          ],
        ),
        replacement: Center(child: const CircularProgressIndicator()),
      ),
    );
  }

  Expanded _buildSumbnail(Uint8List data) {
    final index = _imageDataList.indexOf(data);
    return Expanded(
      child: InkWell(
        onTap: () {
          _croppedData = null;
          currentImage = index;
        },
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            border: index == _currentImage
                ? Border.all(
                    width: 8,
                    color: Colors.blue,
                  )
                : null,
          ),
          child: Image.memory(
            data,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
