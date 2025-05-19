import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Mahasiswa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'Form Mahasiswa'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final nimController = TextEditingController();
  final namaController = TextEditingController();
  final semesterController = TextEditingController();

  final FocusNode myFocusNode = FocusNode();

  String? selectedProdi;

  final List<String> prodiList = [
    'Informatika',
    'Sistem Informasi',
    'Teknik Komputer',
    'Teknik Elektro',
  ];

  @override
  void dispose() {
    nimController.dispose();
    namaController.dispose();
    semesterController.dispose();
    myFocusNode.dispose();
    super.dispose();
  }

  void showData() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Data Mahasiswa"),
          content: Text(
            'NIM: ${nimController.text}\n'
            'Nama: ${namaController.text}\n'
            'Prodi: $selectedProdi\n'
            'Semester: ${semesterController.text}',
          ),
          actions: [
            TextButton(
              child: const Text("Tutup"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void validateInput() {
    FormState? form = formKey.currentState;

    if (form!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua data sudah tervalidasi.')),
      );
      showData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: nimController,
                decoration: const InputDecoration(
                  labelText: 'NIM',
                  hintText: 'Masukkan NIM',
                  icon: Icon(Icons.person_pin),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'NIM tidak boleh kosong';
                  } else if (!RegExp(r'^\d{8,}$').hasMatch(value)) {
                    return 'NIM harus minimal 8 digit angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: namaController,
                focusNode: myFocusNode,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  hintText: 'Masukkan Nama',
                  icon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  } else if (value.length < 3) {
                    return 'Nama minimal 3 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: selectedProdi,
                items:
                    prodiList
                        .map(
                          (prodi) => DropdownMenuItem(
                            value: prodi,
                            child: Text(prodi),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedProdi = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Program Studi',
                  icon: Icon(Icons.school),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Prodi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: semesterController,
                decoration: const InputDecoration(
                  labelText: 'Semester',
                  hintText: 'Masukkan Semester',
                  icon: Icon(Icons.format_list_numbered),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Semester tidak boleh kosong';
                  }
                  int? sem = int.tryParse(value);
                  if (sem == null || sem < 1 || sem > 14) {
                    return 'Semester harus antara 1 - 14';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: validateInput,
                    child: const Text('Submit'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).requestFocus(myFocusNode);
                    },
                    child: const Text('Fokus ke Nama'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
