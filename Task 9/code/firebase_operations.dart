// Excerpts from the report; methods depend on the original widget state.
// The full campus_connect app and firebase_options.dart were not supplied.
import 'package:firebase_core/firebase_core.dart';
 import 'package:firebase_auth/firebase_auth.dart';
 import 'package:firebase_database/firebase_database.dart';
 import 'firebase_options.dart';

 Future<DatabaseReference> connect() async {
     final app = Firebase.apps.isEmpty
         ? await Firebase.initializeApp(
             options: DefaultFirebaseOptions.currentPlatform)
         : Firebase.app();
     const url = String.fromEnvironment('DATABASE_URL');
     final db = url.isEmpty
         ? FirebaseDatabase.instance
         : FirebaseDatabase.instanceFor(app: app, databaseURL: url);
     final auth = FirebaseAuth.instance;
     final user = auth.currentUser ?? (await auth.signInAnonymously()).user;
     if (user == null) {
       throw StateError('Sign-in did not complete. Please retry.');
     }
     return db.ref('users/${user.uid}/students');
   }

 Future<void> submit() async {
     if (!form.currentState!.validate()) return;
     FocusScope.of(context).unfocus();
     setState(() => saving = true);
     try {
       await widget.ref.push().set({
         'name': name.text.trim(),
         'email': email.text.trim(),
         'department': department,
         'note': note.text.trim(),
         'createdAt': ServerValue.timestamp
       });
       if (!mounted) return;
       name.clear();
       email.clear();
       note.clear();
       form.currentState!.reset();
       message('Student saved to Firebase.');
     } catch (e) {
       message('Could not save: $e');
     } finally {
       if (mounted) setState(() => saving = false);
     }
   }








 Future<void> readRecords() async {
     setState(() => reading = true);
     try {
       final snapshot = await widget.ref.get();
       message(
           'Read ${snapshot.children.length} student records from Firebase.');
     } catch (e) {
       message('Could not read records: $e');
     } finally {
       if (mounted) setState(() => reading = false);
     }
   }

 Future<void> remove(String id) async {
     final confirmed = await showDialog<bool>(
         context: context,
         builder: (context) => AlertDialog(
                 title: const Text('Delete this student?'),
                 content:
                     const Text('This removes the record from your database.'),
                 actions: [
                   TextButton(
                       onPressed: () => Navigator.pop(context, false),
                       child: const Text('Cancel')),
                   FilledButton(
                       onPressed: () => Navigator.pop(context, true),
                       child: const Text('Delete'))
                 ]));
     if (confirmed != true || !mounted) return;
     try {
       await widget.ref.child(id).remove();
       message('Student deleted.');
     } catch (e) {
       message('Could not delete: $e');
     }
   }
