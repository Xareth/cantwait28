import 'package:cantwait28/features/details/cubit/details_cubit.dart';
import 'package:cantwait28/models/item_model.dart';
import 'package:cantwait28/repositories/items_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// DetailsPage widget
class DetailsPage extends StatelessWidget {
  const DetailsPage({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Can\'t Wait 🤩'),
      ),
      // DetailsPageBody widget
      body: BlocProvider(
        create: (context) => DetailsCubit(ItemsRepository())..getItemWithID(id),
        child: BlocBuilder<DetailsCubit, DetailsState>(
          builder: (context, state) {
            final itemModel = state.itemModel;
            // if itemModel is empty
            if (itemModel == null) {
              return const Center(child: CircularProgressIndicator());
            }
            // Display ListView with items
            return ListView(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
              ),
              children: [
                // ListViewItem details
                _ListViewItem(
                  itemModel: itemModel,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ListViewItem items
class _ListViewItem extends StatelessWidget {
  const _ListViewItem({
    Key? key,
    required this.itemModel,
  }) : super(key: key);

  final ItemModel itemModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 30,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black12,
        ),
        child: Column(
          children: [
            // Container with image
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.black12,
                image: DecorationImage(
                  image: NetworkImage(
                    itemModel.imageURL,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Below image container
            Row(
              children: [
                // Title and Release date fields
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          itemModel.title,
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(itemModel.releaseDateFormatted()),
                      ],
                    ),
                  ),
                ),
                // Box with days left
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white70,
                  ),
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                        itemModel.daysleft(),
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text('days left'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
