import 'package:flutter/material.dart';

import 'file_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FileService _fileService = FileService();
  final TextEditingController _textController = TextEditingController(
    text: 'Flutter makes local file handling simple and reliable.',
  );

  late Future<String> _fileContent;
  late Future<String> _filePath;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _reloadFile();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _reloadFile() {
    setState(() {
      _fileContent = _fileService.readText();
      _filePath = _fileService.filePath;
    });
  }

  Future<void> _saveFile() async {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      _showMessage('Enter some text before saving.', isError: true);
      return;
    }

    setState(() => _isSaving = true);
    try {
      await _fileService.writeText(text);
      if (!mounted) return;
      _reloadFile();
      _showMessage('Text file saved successfully.');
    } catch (error) {
      if (!mounted) return;
      _showMessage(error.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red.shade700 : null,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Experiment 8'), centerTitle: true),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Local File Notebook',
              style: Theme.of(context).textTheme.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Write text to the application documents directory and read it asynchronously.',
            ),
            const SizedBox(height: 20),
            TextField(
              key: const Key('noteInput'),
              controller: _textController,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Text to store',
                hintText: 'Enter file content',
                prefixIcon: Icon(Icons.edit_note_rounded),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              key: const Key('saveButton'),
              onPressed: _isSaving ? null : _saveFile,
              icon: _isSaving
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_rounded),
              label: Text(_isSaving ? 'Saving...' : 'Write to text file'),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Saved File Content',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  key: const Key('refreshButton'),
                  tooltip: 'Read file again',
                  onPressed: _reloadFile,
                  icon: const Icon(Icons.refresh_rounded),
                ),
              ],
            ),
            FutureBuilder<String>(
              future: _fileContent,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(28),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Card(
                    color: Theme.of(context).colorScheme.errorContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Text(
                        'File error: ${snapshot.error}',
                        key: const Key('errorText'),
                      ),
                    ),
                  );
                }

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: SelectableText(
                      snapshot.data ?? 'The file is empty.',
                      key: const Key('fileContent'),
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            FutureBuilder<String>(
              future: _filePath,
              builder: (context, snapshot) {
                return Text(
                  snapshot.hasData
                      ? 'File path: ${snapshot.data}'
                      : 'Locating application documents directory...',
                  style: Theme.of(context).textTheme.bodySmall,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
