import 'package:cantwait28/features/add/cubit/add_cubit.dart';
import 'package:cantwait28/repositories/items_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

// AddPage Widget
class AddPage extends StatefulWidget {
  const AddPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  String? _imageURL;
  String? _title;
  DateTime? _releaseDate;

  @override
  Widget build(BuildContext context) {
    // Bloc Provider AddCubit
    return BlocProvider(
      create: (context) => AddCubit(ItemsRepository()),
      // BlocListener if saved pop window
      child: BlocListener<AddCubit, AddState>(
        listener: (context, state) {
          if (state.saved) {
            Navigator.of(context).pop();
          }
          if (state.errorMessage.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ));
          }
        },
        // BlocBuilder AddCubit
        child: BlocBuilder<AddCubit, AddState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Add new upcoming title'),
                // AppBar actions
                actions: [
                  IconButton(
                    // Validate form
                    onPressed: _imageURL == null ||
                            _title == null ||
                            _releaseDate == null
                        ? null
                        : () {
                            context.read<AddCubit>().add(
                                  _title!,
                                  _imageURL!,
                                  _releaseDate!,
                                );
                          },
                    icon: const Icon(Icons.check),
                  ),
                ],
              ),
              // AddPageBody widget
              body: _AddPageBody(
                onTitleChanged: (newValue) {
                  setState(() {
                    _title = newValue;
                  });
                },
                onImageUrlChanged: (newValue) {
                  setState(() {
                    _imageURL = newValue;
                  });
                },
                onDateChanged: (newValue) {
                  setState(() {
                    _releaseDate = newValue;
                  });
                },
                selectedDateFormatted: _releaseDate == null
                    ? null
                    : DateFormat.yMMMMEEEEd().format(_releaseDate!),
              ),
            );
          },
        ),
      ),
    );
  }
}

// AddPageBody
class _AddPageBody extends StatelessWidget {
  const _AddPageBody({
    Key? key,
    required this.onTitleChanged,
    required this.onImageUrlChanged,
    required this.onDateChanged,
    this.selectedDateFormatted,
  }) : super(key: key);

  final Function(String) onTitleChanged;
  final Function(String) onImageUrlChanged;
  final Function(DateTime?) onDateChanged;
  final String? selectedDateFormatted;

  @override
  Widget build(BuildContext context) {
    // AddPage body ListView
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 20,
      ),
      children: [
        // Field Title
        TextField(
          onChanged: onTitleChanged,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Matrix 5',
            label: Text('Title'),
          ),
        ),
        const SizedBox(height: 20),
        // Field Image URL
        TextField(
          onChanged: onImageUrlChanged,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'http:// ... .jpg',
            label: Text('Image URL'),
          ),
        ),
        const SizedBox(height: 20),
        // Button with DatePicker
        ElevatedButton(
          onPressed: () async {
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(
                const Duration(days: 365 * 10),
              ),
            );
            onDateChanged(selectedDate);
          },
          child: Text(selectedDateFormatted ?? 'Choose release date'),
        ),
      ],
    );
  }
}
