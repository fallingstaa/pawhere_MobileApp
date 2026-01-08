import 'package:flutter/material.dart';
import 'package:pawhere/features/home/screens/add_equipment_screen.dart';
import 'package:pawhere/features/home/screens/main_feature_shell.dart';
import 'package:pawhere/services/database_service.dart';

class PairingScreen extends StatefulWidget {
  const PairingScreen({super.key});
  static const routeName = '/pair';

  @override
  State<PairingScreen> createState() => _PairingScreenState();
}

class _PairingScreenState extends State<PairingScreen> {
  final TextEditingController _accImeiController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DatabaseService _db = DatabaseService();
  bool _isPairing = false;

  @override
  void dispose() {
    _accImeiController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _navigateToMainFeatureShell() {
    Navigator.of(context).pushReplacementNamed(MainFeatureShell.routeName);
  }

  void _goDirectToAddEquipment() {
    // First go to shell, then push add equipment
    Navigator.of(context).pushReplacementNamed(MainFeatureShell.routeName);
    // Delay push until after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const AddEquipmentScreen()),
      );
    });
  }

  void _mockScanQr() {
    FocusScope.of(context).unfocus();
    _accImeiController.text = '123456789012345';
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Simulated QR scan complete.')));
  }

  Future<void> _pairDevice() async {
    final imei = _accImeiController.text.trim();
    final password = _passwordController.text.trim();
    final accountName = 'Paw Tracker $imei';

    if (imei.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter both IMEI/Account ID and Password.')),
      );
      return;
    }

    setState(() => _isPairing = true);
    bool success = false;
    try {
      success = await _db.addLinkedPet(
          name: accountName, imei: imei, password: password);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isPairing = false);
    }

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Successfully paired $accountName!'),
            backgroundColor: Colors.green),
      );
      _navigateToMainFeatureShell();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Pairing failed. Check credentials.'),
            backgroundColor: Colors.red),
      );
    }
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    Color backgroundColor = const Color(0xFFF0F0F0),
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ).copyWith(hintText: hintText),
      ),
    );
  }

  Widget _buildInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildInputField(
          controller: _accImeiController,
          hintText: 'IMEI or Account ID',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),
        _buildInputField(
          controller: _passwordController,
          hintText: 'Password',
          isPassword: true,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: OutlinedButton.icon(
            onPressed: _isPairing ? null : _mockScanQr,
            icon: const Icon(Icons.qr_code_scanner,
                color: Color(0xFF134694), size: 20),
            label: const Text('Scan QR Code (Simulated)',
                style: TextStyle(
                    color: Color(0xFF134694), fontWeight: FontWeight.bold)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF134694)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              Center(
                  child: Image.asset('assets/images/pawhere_logo.jpg',
                      height: 100)),
              const SizedBox(height: 24),
              const Text('Pair Your Pawwhere GPS Device',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              _buildInputSection(),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isPairing ? null : _pairDevice,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF4A905),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 0,
                ),
                child: _isPairing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.black, strokeWidth: 3),
                      )
                    : const Text('Pair Device', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: _isPairing ? null : _navigateToMainFeatureShell,
                  child: const Text('Skip and explore', style: TextStyle(color: Color(0xFF134694))),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: _isPairing ? null : _goDirectToAddEquipment,
                  child: const Text('Add equipment without pairing',
                      style: TextStyle(color: Colors.black54, decoration: TextDecoration.underline)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
