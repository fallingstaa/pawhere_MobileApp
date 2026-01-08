import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pawhere/features/tracking/tracking_screen.dart';

class PetDetailScreen extends StatefulWidget {
  const PetDetailScreen({
    Key? key,
    required this.appId,
    required this.userId,
    required this.petId,
  }) : super(key: key);

  static const routeName = '/pet-detail';

  final String appId;
  final String userId;
  final String petId;

  @override
  State<PetDetailScreen> createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends State<PetDetailScreen> {
  final TextEditingController _imeiController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPairing = false;

  DocumentReference<Map<String, dynamic>> get _petRef =>
      FirebaseFirestore.instance.doc(
        'artifacts/${widget.appId}/users/${widget.userId}/pets/${widget.petId}',
      );

  Stream<DocumentSnapshot<Map<String, dynamic>>> get _petStream =>
      _petRef.snapshots();

  @override
  void dispose() {
    _imeiController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _validImei(String v) => RegExp(r'^[0-9]{15,20}$').hasMatch(v);

  Future<void> _pairNow(String petName, BuildContext sheetCtx) async {
    FocusScope.of(sheetCtx).unfocus();

    // digits only
    final sanitizedImei = _imeiController.text.replaceAll(RegExp(r'\D'), '');
    if (sanitizedImei != _imeiController.text) {
      _imeiController.text = sanitizedImei;
    }
    final imei = sanitizedImei;
    final password = _passwordController.text.trim();

    if (imei.isEmpty || password.isEmpty) {
      _snack('Enter IMEI and password', error: true);
      return;
    }
    if (!_validImei(imei)) {
      _snack('IMEI/Account ID must be 15–20 digits', error: true);
      return;
    }

    setState(() => _isPairing = true);
    try {
      await _petRef.set({
        'imei': imei,
        'name': petName,
        'pairedAt': FieldValue.serverTimestamp(),
        'pairedBy': widget.userId,
      }, SetOptions(merge: true));

      if (!mounted) return;

      _snack('Paired successfully', error: false);

      // Close the sheet, then navigate to Tracking
      Navigator.of(sheetCtx).maybePop();
      await Future.delayed(const Duration(milliseconds: 150));

      if (!mounted) return;
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => TrackingScreen(
          appId: widget.appId,
          userId: widget.userId,
          petId: widget.petId,
        ),
      ));
    } catch (e) {
      _snack('Failed to pair: $e', error: true);
    } finally {
      if (mounted) setState(() => _isPairing = false);
    }
  }

  void _openPairSheet(String petName, {String? currentImei}) {
    _imeiController.text = currentImei ?? _imeiController.text;
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final insets = MediaQuery.of(ctx).viewInsets;
        // Make the sheet stateful so the button can show a spinner
        return StatefulBuilder(
          builder: (sheetCtx, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: insets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 6),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text('Pair device to "$petName"',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),
                  _input(
                    controller: _imeiController,
                    hint: 'IMEI / Account ID (digits only)',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  _input(
                    controller: _passwordController,
                    hint: 'Device Password',
                    obscure: true,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      key: const ValueKey('pair_device_btn'),
                      onPressed: _isPairing
                          ? null
                          : () async {
                              setSheetState(() {});
                              await _pairNow(petName, sheetCtx);
                              setSheetState(() {});
                            },
                      icon: _isPairing
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.black),
                            )
                          : const Icon(Icons.link, color: Colors.black),
                      label: Text(_isPairing ? 'Pairing...' : 'Pair device',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
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
            );
          },
        );
      },
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    bool obscure = false,
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
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: InputBorder.none,
        ),
      ),
    );
  }

  void _snack(String msg, {required bool error}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(msg),
          backgroundColor: error ? Colors.red : Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFFF4A905),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: _petStream,
        builder: (context, snap) {
          if (snap.hasError) {
            return const Center(child: Text('Failed to load pet'));
          }
          if (!snap.hasData || !snap.data!.exists) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snap.data!.data()!;
          final name = (data['name'] as String?) ?? 'Pet';
          final imagePath = data['imagePath'] as String?;
          final imei = data['imei'] as String?;
          final status = data['status'] as String?;
          final lat = (data['latestLatitude'] as num?)?.toDouble();
          final lng = (data['latestLongitude'] as num?)?.toDouble();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: (imagePath != null && imagePath.isNotEmpty)
                        ? AssetImage(imagePath) as ImageProvider
                        : const AssetImage('assets/images/dog.jpg'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text(
                          (imei == null || imei.isEmpty)
                              ? 'Not paired'
                              : 'IMEI: $imei',
                          style: TextStyle(
                            color: (imei == null || imei.isEmpty)
                                ? Colors.red
                                : Colors.black87,
                          ),
                        ),
                        if (status != null) Text('Status: $status'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _openPairSheet(name, currentImei: imei),
                  icon: const Icon(Icons.link, color: Colors.black),
                  label: Text(
                    (imei == null || imei.isEmpty)
                        ? 'Pair device'
                        : 'Re-pair device',
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF4A905),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (imei != null && imei.isNotEmpty)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => TrackingScreen(
                          appId: widget.appId,
                          userId: widget.userId,
                          petId: widget.petId,
                        ),
                      ));
                    },
                    icon: const Icon(Icons.map),
                    label: const Text('Open Tracking'),
                  ),
                ),
              if (lat != null && lng != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('Last location: $lat, $lng',
                      style: const TextStyle(color: Colors.grey)),
                ),
            ],
          );
        },
      ),
    );
  }
}
