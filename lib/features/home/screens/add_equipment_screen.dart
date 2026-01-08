import 'package:flutter/material.dart';
import 'package:pawhere/services/database_service.dart';
import 'package:pawhere/services/traccar_service.dart';

class AddEquipmentScreen extends StatefulWidget {
  const AddEquipmentScreen({Key? key}) : super(key: key);
  static const routeName = '/add-equipment';

  @override
  State<AddEquipmentScreen> createState() => _AddEquipmentScreenState();
}

class _AddEquipmentScreenState extends State<AddEquipmentScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imeiController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final TraccarService _traccarService = TraccarService();
  final DatabaseService _dbService = DatabaseService();

  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _imeiController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {Color color = Colors.black87}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  // Accept 15–20 numeric digits only (IMEI/Account ID).
  bool _validImei(String v) => RegExp(r'^[0-9]{15,20}$').hasMatch(v);

  Future<void> _addEquipment() async {
    final name = _nameController.text.trim();
    // Keep digits only (removes spaces, dashes, etc.)
    final sanitizedImei = _imeiController.text.replaceAll(RegExp(r'\D'), '');
    if (sanitizedImei != _imeiController.text) {
      _imeiController.text = sanitizedImei; // reflect cleaned value in UI
    }
    final imei = sanitizedImei;
    final password = _passwordController.text.trim();

    if (name.isEmpty || imei.isEmpty || password.isEmpty) {
      _showSnackBar('Please fill all fields.', color: Colors.red);
      return;
    }
    if (!_validImei(imei)) {
      _showSnackBar(
        'Device ID must be 15–20 digits (numbers only). You entered ${imei.length}.',
        color: Colors.red,
      );
      return;
    }

    setState(() => _isSaving = true);
    _showSnackBar('Verifying backend connectivity...', color: Colors.blueGrey);

    // Optional simple check: can we reach positions endpoint (admin proxy)?
    bool backendOk = false;
    try {
      await TraccarService().fetchDevicePositions();
      backendOk = true; // call succeeded (regardless of empty list)
    } catch (_) {
      backendOk = false;
    }

    if (!backendOk) {
      setState(() => _isSaving = false);
      _showSnackBar('Backend unreachable. Try again.', color: Colors.red);
      return;
    }

    _showSnackBar('Saving device...', color: Colors.blueGrey);

    bool dbSuccess = false;
    try {
      dbSuccess = await _dbService.addLinkedPet(
          name: name, imei: imei, password: password);
    } catch (e) {
      _showSnackBar('Save error: $e', color: Colors.red);
    }

    setState(() => _isSaving = false);

    if (dbSuccess) {
      _showSnackBar('Device added.', color: Colors.green);
      if (mounted) Navigator.of(context).pop();
    } else {
      _showSnackBar('Failed to add device.', color: Colors.red);
    }
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: InputBorder.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Add Equipment', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFFF4A905),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInputField(
                controller: _nameController, hintText: 'Pet/Tracker Name'),
            const SizedBox(height: 12),
            _buildInputField(
              controller: _imeiController,
              hintText: 'IMEI / Account ID',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            _buildInputField(
              controller: _passwordController,
              hintText: 'Password',
              isPassword: true,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isSaving ? null : _addEquipment,
                icon: _isSaving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.black))
                    : const Icon(Icons.save, color: Colors.black),
                label: Text(_isSaving ? 'Saving...' : 'Save',
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF4A905),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
