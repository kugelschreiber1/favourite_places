import 'dart:io';

import 'package:favourite_places/models/place_model.dart';
import 'package:favourite_places/providers/places_provider.dart';
import 'package:favourite_places/widgets/image_input.dart';
import 'package:favourite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';

class NewPlaceScreen extends ConsumerStatefulWidget {
  const NewPlaceScreen({super.key});

  @override
  ConsumerState<NewPlaceScreen> createState() => _NewPlaceScreenState();
}

class _NewPlaceScreenState extends ConsumerState<NewPlaceScreen> {
  final _titleController = TextEditingController();
  String? _errorMessage;
  File? _selectedImage;
  Location? _userLocation;

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Invalid Input"),
        content: Text(message),
        actions: [
          const Divider(height: 0.0),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "Ok",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _savePlace() {
    final value = _titleController.text.trim();

    if (value.isEmpty) {
      _errorMessage = "Name cannot be empty";
      _showError(_errorMessage!);
      return;
    }
    if (value.length <= 2) {
      _errorMessage = "Name is too short";
      _showError(_errorMessage!);
      return;
    }
    if (value.length > 50) {
      _errorMessage = "Name is too long";
      _showError(_errorMessage!);
      return;
    }
    if (_selectedImage == null) {
      _errorMessage = "The image cannot be empty";
      _showError(_errorMessage!);
      return;
    }
    if (_userLocation == null) {
      _errorMessage = "The location is not set";
      _showError(_errorMessage!);
      return;
    }
    if (_errorMessage == null) {
      ref.read(placesProvider.notifier).setPlace(
            Place(title: value, image: _selectedImage!),
          );
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Add New place"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                controller: _titleController,
                maxLength: 50,
                autofocus: true,
                decoration: const InputDecoration(
                  label: Text("Name"),
                  contentPadding: EdgeInsets.all(8.0),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 16.0),
              ImageInput(
                onPickImage: (image) {
                  _selectedImage = image;
                },
              ),
              const SizedBox(height: 16.0),
              const LocationInput(),
              const SizedBox(height: 16.0),
              ElevatedButton.icon(
                onPressed: _savePlace,
                icon: const Icon(Icons.add),
                label: const Text("Add Place"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
