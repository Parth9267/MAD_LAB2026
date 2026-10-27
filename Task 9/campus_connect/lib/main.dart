import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';

const teal = Color(0xFF087F8C);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CampusApp());
}

class CampusApp extends StatelessWidget {
  const CampusApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Campus Connect',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: teal),
            scaffoldBackgroundColor: const Color(0xFFF3F6FA),
            inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: const Color(0xFFF3F6FA),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none))),
        home: const Startup(),
      );
}

class Startup extends StatefulWidget {
  const Startup({super.key});
  @override
  State<Startup> createState() => _StartupState();
}

class _StartupState extends State<Startup> {
  late Future<DatabaseReference> startup;
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
    if (user == null)
      throw StateError('Sign-in did not complete. Please retry.');
    return db.ref('users/${user.uid}/students');
  }

  @override
  void initState() {
    super.initState();
    startup = connect();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<DatabaseReference>(
      future: startup,
      builder: (context, snapshot) {
        if (snapshot.hasData) return Directory(ref: snapshot.data!);
        return Scaffold(
            body: Center(
                child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: snapshot.hasError
                        ? Column(mainAxisSize: MainAxisSize.min, children: [
                            const Icon(Icons.cloud_off_rounded,
                                size: 56, color: teal),
                            const SizedBox(height: 20),
                            const Text('Let’s connect your campus',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 12),
                            Text('${snapshot.error}',
                                textAlign: TextAlign.center),
                            const SizedBox(height: 16),
                            const Text(
                                'Check Firebase configuration, database URL and Anonymous sign-in.'),
                            const SizedBox(height: 16),
                            FilledButton(
                                onPressed: () => setState(() {
                                      startup = connect();
                                    }),
                                child: const Text('Retry connection')),
                          ])
                        : const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 18),
                                Text('Connecting to your campus…')
                              ]))));
      });
}

class Directory extends StatefulWidget {
  final DatabaseReference ref;
  const Directory({super.key, required this.ref});
  @override
  State<Directory> createState() => _DirectoryState();
}

class _DirectoryState extends State<Directory> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController();
  final note = TextEditingController();
  String department = 'Information Technology', search = '';
  bool saving = false;
  late Stream<DatabaseEvent> records;
  final departments = [
    'Information Technology',
    'Computer Engineering',
    'Electronics',
    'Mechanical',
    'Other'
  ];
  @override
  void initState() {
    super.initState();
    records = widget.ref.onValue;
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    note.dispose();
    super.dispose();
  }

  void message(String text) {
    if (mounted)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
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

  Widget panel(Widget child) => Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: child);
  Widget inputForm() => panel(Form(
      key: form,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Icon(Icons.person_add_alt_1_rounded, color: teal, size: 32),
        const SizedBox(height: 16),
        const Text('Add a student',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        const Text('A new connection starts here.',
            style: TextStyle(color: Colors.black54)),
        const SizedBox(height: 24),
        TextFormField(
            controller: name,
            maxLength: 80,
            enabled: !saving,
            decoration: const InputDecoration(
                labelText: 'Full name', prefixIcon: Icon(Icons.person_outline)),
            validator: (v) => (v ?? '').trim().length < 2
                ? 'Enter at least 2 characters.'
                : null),
        const SizedBox(height: 12),
        TextFormField(
            controller: email,
            maxLength: 120,
            enabled: !saving,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
                labelText: 'Email address',
                prefixIcon: Icon(Icons.alternate_email)),
            validator: (v) =>
                RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch((v ?? '').trim())
                    ? null
                    : 'Enter a valid email address.'),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
            initialValue: department,
            isExpanded: true,
            decoration: const InputDecoration(
                labelText: 'Department',
                prefixIcon: Icon(Icons.school_outlined)),
            items: departments
                .map((d) => DropdownMenuItem(
                    value: d, child: Text(d, overflow: TextOverflow.ellipsis)))
                .toList(),
            onChanged: saving ? null : (v) => setState(() => department = v!)),
        const SizedBox(height: 20),
        TextFormField(
            controller: note,
            maxLength: 300,
            maxLines: 3,
            enabled: !saving,
            decoration: const InputDecoration(
                labelText: 'Short note (optional)', alignLabelWithHint: true)),
        const SizedBox(height: 12),
        SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton.icon(
                onPressed: saving ? null : submit,
                icon: saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.add),
                label: Text(saving ? 'Saving to Firebase…' : 'Save student'))),
        const SizedBox(height: 14),
        const Text('Records are private to this signed-in installation.',
            style: TextStyle(fontSize: 12, color: Colors.black54)),
      ])));
  Widget directory() =>
      panel(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Your campus circle',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        const Text('Firebase updates appear here automatically.',
            style: TextStyle(color: Colors.black54)),
        const SizedBox(height: 20),
        TextField(
            decoration: const InputDecoration(
                hintText: 'Search name, email or department',
                prefixIcon: Icon(Icons.search)),
            onChanged: (v) => setState(() => search = v.trim().toLowerCase())),
        const SizedBox(height: 20),
        StreamBuilder<DatabaseEvent>(
            stream: records,
            builder: (context, snapshot) {
              if (snapshot.hasError)
                return Column(children: [
                  const Icon(Icons.error_outline, color: Colors.red),
                  Text('Unable to load records: ${snapshot.error}'),
                  TextButton(
                      onPressed: () =>
                          setState(() => records = widget.ref.onValue),
                      child: const Text('Retry'))
                ]);
              if (!snapshot.hasData)
                return const Center(
                    child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator()));
              final entries = snapshot.data!.snapshot.children.toList();
              entries.sort((a, b) => ((b.child('createdAt').value as num?) ?? 0)
                  .compareTo((a.child('createdAt').value as num?) ?? 0));
              final filtered = entries
                  .where((r) => ['name', 'email', 'department'].any((k) =>
                      '${r.child(k).value ?? ''}'
                          .toLowerCase()
                          .contains(search)))
                  .toList();
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '${entries.length} students • ${filtered.length} shown',
                        style: const TextStyle(
                            color: teal, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 16),
                    if (filtered.isEmpty)
                      const Padding(
                          padding: EdgeInsets.symmetric(vertical: 36),
                          child: Center(
                              child: Column(children: [
                            Icon(Icons.groups_outlined, size: 56, color: teal),
                            SizedBox(height: 12),
                            Text('No students to show'),
                            SizedBox(height: 6),
                            Text('Add a student or try another search.')
                          ]))),
                    ...filtered.map((r) {
                      final fullName = '${r.child('name').value ?? 'Student'}';
                      return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: const Color(0xFFE6ECF1)),
                              borderRadius: BorderRadius.circular(18)),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                    backgroundColor: const Color(0xFFE0F3F2),
                                    foregroundColor: teal,
                                    child: Text(fullName.isEmpty
                                        ? '?'
                                        : fullName
                                            .substring(0, 1)
                                            .toUpperCase())),
                                const SizedBox(width: 12),
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      Text(fullName,
                                          style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold)),
                                      Text('${r.child('email').value ?? ''}',
                                          style: const TextStyle(
                                              color: Colors.black54)),
                                      const SizedBox(height: 8),
                                      Text(
                                          '${r.child('department').value ?? ''}',
                                          style: const TextStyle(
                                              color: teal, fontSize: 12)),
                                      if ('${r.child('note').value ?? ''}'
                                          .isNotEmpty)
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8),
                                            child: Text(
                                                '${r.child('note').value}'))
                                    ])),
                                IconButton(
                                    tooltip: 'Delete student',
                                    onPressed: () => remove(r.key!),
                                    icon: const Icon(Icons.delete_outline,
                                        size: 20)),
                              ]));
                    }),
                  ]);
            }),
      ]));
  @override
  Widget build(BuildContext context) => Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                  child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1160),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(children: [
                              Icon(Icons.hub_rounded, color: teal, size: 32),
                              SizedBox(width: 10),
                              Text('CAMPUS CONNECT',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 2))
                            ]),
                            const SizedBox(height: 26),
                            Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(28),
                                decoration: BoxDecoration(
                                    gradient: const LinearGradient(colors: [
                                      Color(0xFF112D42),
                                      Color(0xFF087F8C)
                                    ]),
                                    borderRadius: BorderRadius.circular(26)),
                                child: const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('YOUR PEOPLE. ONE PLACE.',
                                          style: TextStyle(
                                              color: Color(0xFF9CE5D8),
                                              letterSpacing: 2,
                                              fontSize: 12)),
                                      SizedBox(height: 14),
                                      Text(
                                          'Stay connected.\nBuild your campus circle.',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                              height: 1.15)),
                                      SizedBox(height: 14),
                                      Text(
                                          'A simple student directory, powered by Firebase.',
                                          style:
                                              TextStyle(color: Colors.white70))
                                    ])),
                            const SizedBox(height: 24),
                            StreamBuilder<DatabaseEvent>(
                                stream: widget.ref.root
                                    .child('.info/connected')
                                    .onValue,
                                builder: (context, s) => Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: Text(
                                        s.data?.snapshot.value == true
                                            ? '● Database connected'
                                            : '○ Database connection pending',
                                        style: const TextStyle(color: teal)))),
                            LayoutBuilder(
                                builder: (context, constraints) =>
                                    constraints.maxWidth >= 850
                                        ? Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                                Expanded(
                                                    flex: 4,
                                                    child: inputForm()),
                                                const SizedBox(width: 24),
                                                Expanded(
                                                    flex: 6, child: directory())
                                              ])
                                        : Column(children: [
                                            inputForm(),
                                            const SizedBox(height: 24),
                                            directory()
                                          ])),
                            const SizedBox(height: 24),
                          ]))))));
}
