import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Reusable image picker section for Create / Edit Event forms.
///
/// Shows:
///   - a dashed "Add Image" tap area when no image is selected or existing
///   - a preview of the locally picked file
///   - a preview of the existing remote image (via URL) if no local pick
///   - Remove / Change buttons
///
/// [existingImageUrl]  The relative path already stored on the server (nullable).
/// [pickedFile]        The locally picked XFile (nullable, from image_picker).
/// [onPicked]          Called when user picks a new image.
/// [onRemoved]         Called when user removes the image.
/// [staticBaseUrl]     The root HTTP URL to prefix existingImageUrl.
class ImagePickerWidget extends StatelessWidget {
  final String? existingImageUrl;
  final XFile? pickedFile;
  final ValueChanged<XFile> onPicked;
  final VoidCallback onRemoved;
  final String staticBaseUrl;

  const ImagePickerWidget({
    super.key,
    this.existingImageUrl,
    this.pickedFile,
    required this.onPicked,
    required this.onRemoved,
    required this.staticBaseUrl,
  });

  bool get _hasLocalPick => pickedFile != null;
  bool get _hasRemoteImage =>
      existingImageUrl != null && existingImageUrl!.isNotEmpty;
  bool get _hasAnyImage => _hasLocalPick || _hasRemoteImage;

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1920,
      maxHeight: 1080,
    );
    if (picked != null) {
      onPicked(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Image area ──────────────────────────────────────────────────
        GestureDetector(
          onTap: () => _pickImage(context),
          child: Container(
            height: 180,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _hasAnyImage
                    ? Colors.transparent
                    : Colors.grey.shade400,
                width: 1.5,
                // dashed effect via custom paint would be complex; use solid
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: _hasLocalPick
                ? _LocalPreview(filePath: pickedFile!.path)
                : _hasRemoteImage
                    ? _RemotePreview(
                        imageUrl: '$staticBaseUrl$existingImageUrl')
                    : const _AddImagePlaceholder(),
          ),
        ),

        // ── Action buttons ──────────────────────────────────────────────
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _pickImage(context),
                icon: const Icon(Icons.photo_library, size: 18),
                label: Text(_hasAnyImage ? 'Change Image' : 'Select Image'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
            if (_hasAnyImage) ...[
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: onRemoved,
                icon: const Icon(Icons.delete_outline, size: 18),
                label: const Text('Remove'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 12),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

// ── Private sub-widgets ───────────────────────────────────────────────────────

class _AddImagePlaceholder extends StatelessWidget {
  const _AddImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_photo_alternate_outlined,
            size: 52, color: Colors.grey.shade400),
        const SizedBox(height: 8),
        Text(
          'Tap to add image',
          style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(
          'JPEG · PNG · WEBP  •  Max 5 MB',
          style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
        ),
      ],
    );
  }
}

class _LocalPreview extends StatelessWidget {
  final String filePath;
  const _LocalPreview({required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.file(File(filePath), fit: BoxFit.cover),
        Positioned(
          bottom: 6,
          right: 6,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'New image selected',
              style: TextStyle(color: Colors.white, fontSize: 11),
            ),
          ),
        ),
      ],
    );
  }
}

class _RemotePreview extends StatelessWidget {
  final String imageUrl;
  const _RemotePreview({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey.shade200,
          child: const Center(
            child: Icon(Icons.broken_image_outlined,
                size: 48, color: Colors.grey),
          ),
        );
      },
    );
  }
}
