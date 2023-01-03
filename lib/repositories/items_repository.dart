import 'package:cantwait28/models/item_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemsRepository {
  // get Items from Firebase
  Stream<List<ItemModel>> getItemsStream() {
    return FirebaseFirestore.instance
        .collection('items')
        .orderBy('release_date')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return ItemModel(
          id: doc.id,
          title: doc['title'],
          imageURL: doc['image_url'],
          releaseDate: (doc['release_date'] as Timestamp).toDate(),
        );
      }).toList();
    });
  }

  // Delete item with id
  Future<void> delete({required String id}) {
    return FirebaseFirestore.instance.collection('items').doc(id).delete();
  }

  // Add new item to items
  Future<void> add(
    String title,
    String imageURL,
    DateTime releaseDate,
  ) async {
    {
      await FirebaseFirestore.instance.collection('items').add(
        {
          'title': title,
          'image_url': imageURL,
          'release_date': releaseDate,
        },
      );
    }
  }
}
