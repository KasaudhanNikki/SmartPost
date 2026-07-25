import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraHelper {
  CameraHelper._();

  static final ImagePicker _picker = ImagePicker();

  static Future<bool> requestCameraAndGalleryPermissions() async {
    final cameraStatus = await Permission.camera.request();

    if (Platform.isIOS) {
      await Permission.photos.request();
    } else if (Platform.isAndroid) {
      final photosStatus = await Permission.photos.request();
      if (!photosStatus.isGranted) {
        await Permission.storage.request();
      }
    }

    return cameraStatus.isGranted;
  }

  static Future<XFile?> openCamera(BuildContext context) async {
    final hasCameraPermission = await requestCameraAndGalleryPermissions();

    if (!hasCameraPermission) {
      if (context.mounted) {
        _showPermissionDeniedSnackBar(context);
      }
      return null;
    }

    try {
      return await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open camera: $e')),
        );
      }
      return null;
    }
  }

  static void _showPermissionDeniedSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Camera permission is required to take photos'),
        action: SnackBarAction(
          label: 'Settings',
          onPressed: openAppSettings,
        ),
      ),
    );
  }
}
