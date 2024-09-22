import 'package:cloud_firestore/cloud_firestore.dart';

class LostFoundItem {
  final String userId;
  final String name;
  final String address;
  final String duration;
  final String description;
  final String category;
  final String color;
  final String imageUrl;

  LostFoundItem({
    required this.userId,
    required this.name,
    required this.address,
    required this.duration,
    required this.description,
    required this.category,
    required this.color,
    required this.imageUrl,
  });

  // Factory constructor to create LostModel from Firestore document
  factory LostFoundItem.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return LostFoundItem(
      imageUrl: data['imageUrl'] ?? '',
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      address: data['address'] ?? '',
      duration: data['duration'] ?? '',
      color: data['color'] ?? '',
      description: data['description'] ?? '',
      userId: data['user id'] ?? '',
    );
  }
}