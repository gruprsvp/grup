import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:path_provider/path_provider.dart';

class ImageController extends ValueNotifier<XFile?> {
  ImageController() : super(null);
}

class ImageFormField extends FormField<XFile> {
  ImageFormField({
    super.key,
    super.validator,
    super.onSaved,
    this.controller,
    this.initialImage,
    this.icon,
    this.radius,
    this.color,
  }) : super(builder: (state) => (state as _ImageFormFieldState).builder());

  /// Controls the state of the image.
  ///
  /// If null, this image will create its own [ImageController]
  /// and initialize it with [initialValue].
  final ImageController? controller;

  /// The initial image to show.
  final ImageProvider? initialImage;

  /// The icon to show when there is no image.
  final IconData? icon;

  /// The radius of the image.
  final double? radius;

  /// The color of the icon.
  final Color? color;

  @override
  FormFieldState<XFile> createState() => _ImageFormFieldState();
}

class _ImageFormFieldState extends FormFieldState<XFile> {
  late final ImageController controller;

  final _imagePicker = ImagePicker();

  @override
  ImageFormField get widget => super.widget as ImageFormField;

  @override
  void initState() {
    super.initState();

    controller = widget.controller ?? ImageController();
    controller.addListener(_handleControllerChanged);
  }

  @override
  void dispose() {
    controller.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void didChange(XFile? value) {
    super.didChange(value);
    if (controller.value != value) {
      controller.value = value!;
    }
  }

  @override
  void reset() {
    controller.value = widget.initialValue;
    super.reset();
  }

  void _handleControllerChanged() {
    if (controller.value != value) {
      didChange(controller.value);
    }
  }

  Widget builder() {
    final radius = widget.radius ?? 20.0;
    final cameraIconDistance = radius / 5;

    final ImageProvider? image = value != null
        ? kIsWeb
            ? NetworkImage(value!.path) as ImageProvider
            : FileImage(File(value!.path)) as ImageProvider
        : widget.initialImage;

    return Stack(
      children: [
        ProfilePicture(
          onPressed: _changeImage,
          image: image,
          radius: widget.radius,
          icon: widget.icon,
          color: widget.color,
          // loadingValue: // TODO This should show a loading indicator when the image is being uploaded.
        ),
        Positioned.directional(
          textDirection: Directionality.of(context),
          end: cameraIconDistance,
          bottom: cameraIconDistance,
          child: IconButton.filledTonal(
            icon: const Icon(Icons.camera_alt_outlined),
            tooltip: AppLocalizations.of(context)!.chooseNewProfilePicture,
            onPressed: _changeImage,
          ),
        ),
      ],
    );
  }

  Future<void> _changeImage() async {
    final source = await _getImageSource();
    if (source == null) return;

    final image = await _getImage(source);
    if (image == null) return;

    final imageData = await image.readAsBytes();
    final croppedImage = await _getImageCropped(imageData);
    if (croppedImage == null) return;

    didChange(croppedImage);
  }

  /// Get an image from the camera or gallery.
  Future<XFile?> _getImage(ImageSource source) async {
    return await _imagePicker.pickImage(
      source: source,
      preferredCameraDevice: CameraDevice.front,
      maxWidth: 512,
      maxHeight: 512,
      requestFullMetadata: false,
    );
  }

  /// Show a dialog to crop the image.
  Future<XFile?> _getImageCropped(Uint8List imageData) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) => Dialog.fullscreen(
                child: ImageCrop(
              imageData: imageData,
              onCrop: (value) async {
                final savedImage =
                    value != null ? await _saveImage(value) : null;
                if (context.mounted) {
                  Navigator.pop(context, savedImage);
                }
              },
            )));
  }

  /// Save temporary image to a file.
  Future<XFile?> _saveImage(Uint8List imageData) async {
    if (kIsWeb) return XFile.fromData(imageData);

    final tempDir = await getTemporaryDirectory();
    final tempFile = File(
        '${tempDir.path}/temp_image_${DateTime.now().millisecondsSinceEpoch}.jpg');
    await tempFile.writeAsBytes(imageData);
    return XFile(tempFile.path);
  }

  /// Show a dialog to choose the image source.
  /// If the camera is not supported, the gallery will be the default source.
  Future<ImageSource?> _getImageSource() async {
    if (!_imagePicker.supportsImageSource(ImageSource.camera)) {
      return ImageSource.gallery;
    }

    return showDialog<ImageSource>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;

        return SimpleDialog(
          title: Text(l10n.chooseNewProfilePicture),
          children: [
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, ImageSource.camera),
              child: Row(
                children: [
                  const Icon(Icons.camera_alt),
                  const SizedBox(width: 8),
                  Text(l10n.camera),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, ImageSource.gallery),
              child: Row(
                children: [
                  const Icon(Icons.photo_library),
                  const SizedBox(width: 8),
                  Text(l10n.gallery),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
