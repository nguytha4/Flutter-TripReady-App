
import 'package:flutter/material.dart';

class ImageService
{
    static ImageProvider buildAssetImage(String imageUrl) { 
    if (imageUrl.startsWith('http')) {
      return NetworkImage(imageUrl);
    } else {
      return AssetImage(imageUrl);
    }
  }
}