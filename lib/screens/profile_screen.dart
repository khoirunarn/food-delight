import 'package:flutter/material.dart';
import '../models/register_model.dart'; // Pastikan path ini sesuai
import 'register_screen.dart'; // Tambahkan import ke halaman registrasi

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name, _email, _password, _city;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Fungsi untuk memuat data pengguna
  Future<void> _loadUserData() async {
    final userData = await RegisterModel.fetchUserData();
    setState(() {
      _name = userData['name'];
      _email = userData['email'];
      _password = userData['password'];
      _city = userData['city'];
    });
  }

  // Fungsi untuk menyimpan data pengguna
  Future<void> _saveUserData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await RegisterModel.saveUserData(
        name: _name!,
        email: _email!,
        password: _password!,
        city: _city!,
      );
      setState(() {}); // Refresh UI
    }
  }

  // Fungsi untuk menghapus data pengguna dan pindah ke halaman registrasi
  Future<void> _deleteUserData() async {
    await RegisterModel.deleteUserData();
    setState(() {
      _name = null;
      _email = null;
      _password = null;
      _city = null;
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  // Fungsi untuk menampilkan dialog edit
  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _name,
                    decoration: const InputDecoration(labelText: 'Name'),
                    onSaved: (value) => _name = value,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Enter your name' : null,
                  ),
                  TextFormField(
                    initialValue: _email,
                    decoration: const InputDecoration(labelText: 'Email'),
                    onSaved: (value) => _email = value,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Enter your email'
                        : null,
                  ),
                  TextFormField(
                    initialValue: _password,
                    decoration: const InputDecoration(labelText: 'Password'),
                    onSaved: (value) => _password = value,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Enter your password'
                        : null,
                  ),
                  TextFormField(
                    initialValue: _city,
                    decoration: const InputDecoration(labelText: 'City'),
                    onSaved: (value) => _city = value,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Enter your city' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  _saveUserData();
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color.fromARGB(255, 255, 137, 210),
        leading: IconButton(
  icon: const Icon(Icons.arrow_back),
  onPressed: () {
    Navigator.pop(context); // Kembali ke halaman sebelumnya
  },
),

      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: const NetworkImage(
                    'https://via.placeholder.com/150'), // Placeholder image
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(height: 20),
              Text(
                _name ?? 'No Name',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 137, 210),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Email: ${_email ?? 'No Email'}",
                          style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 10),
                      Text("Password: ${_password ?? 'No Password'}",
                          style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 10),
                      Text("City: ${_city ?? 'No City'}",
                          style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _showEditDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 165, 207),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('Edit Profile'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _deleteUserData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('Delete Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}