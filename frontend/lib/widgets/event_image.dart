import 'package:flutter/material.dart';
import '../services/api_client.dart';

/// Displays a remote event image from the backend, or a placeholder when
/// there is no image or when loading fails.
///
/// Usage:
///   EventImageWidget(imageUrl: event.imageUrl, height: 200)
class EventImageWidget extends StatelessWidget {
  final String? imageUrl; // relative path: /uploads/events/xyz.jpg
  final double height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const EventImageWidget({
    super.key,
    required this.imageUrl,
    this.height = 200,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  /// Build the full HTTP URL from the relative path returned by the backend.
  String? _buildFullUrl() {
    if (imageUrl == null || imageUrl!.isEmpty) return null;
    // imageUrl is like "/uploads/events/abc.jpg"
    // staticBaseUrl is like "http://10.0.2.2:8080" (no /api suffix)
    return '${ApiClient.staticBaseUrl}$imageUrl';
  }

  @override
  Widget build(BuildContext context) {
    final fullUrl = _buildFullUrl();

    Widget imageWidget;

    if (fullUrl == null) {
      imageWidget = _Placeholder(height: height);
    } else {
      imageWidget = Image.network(
        fullUrl,
        height: height,
        width: double.infinity,
        fit: fit,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return SizedBox(
            height: height,
            child: const Center(child: CircularProgressIndicator()),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _Placeholder(height: height);
        },
      );
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }
    return imageWidget;
  }
}

class _Placeholder extends StatelessWidget {
  final double height;
  const _Placeholder({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      color: Colors.grey.shade200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_outlined, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 8),
          Text(
            'No image',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
