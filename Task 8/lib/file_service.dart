import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileService {
  static const String fileName = 'experiment_8_notes.txt';

  Future<Directory> get documentsDirectory async {
    final directory = await getApplicationDocumentsDirectory();
    print('Application documents directory: ${directory.path}');
    return directory;
  }

  Future<File> get localFile async {
    final directory = await documentsDirectory;
    return File('${directory.path}${Platform.pathSeparator}$fileName');
  }

  Future<String> get filePath async => (await localFile).path;

  Future<File> writeText(String text) async {
    try {
      final file = await localFile;
      return await file.writeAsString(text, flush: true);
    } on FileSystemException catch (error) {
      throw Exception('Unable to write the file: ${error.message}');
    } catch (error) {
      throw Exception('Unexpected write error: $error');
    }
  }

  Future<String> readText() async {
    try {
      final file = await localFile;
      if (!await file.exists()) {
        await writeText(
          'Welcome to Experiment 8!\n'
          'This text was created and stored in the app documents folder.',
        );
      }
      return await file.readAsString();
    } on FileSystemException catch (error) {
      throw Exception('Unable to read the file: ${error.message}');
    } catch (error) {
      throw Exception('Unexpected read error: $error');
    }
  }
}
