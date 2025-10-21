    import 'package:flutter/material.dart';

    class AddEquipmentScreen extends StatelessWidget {
    const AddEquipmentScreen({Key? key}) : super(key: key);

    // Define a static route name for easy navigation
    static const routeName = '/add-equipment';

    @override
    Widget build(BuildContext context) {
        return Scaffold(
        appBar: AppBar(
            // The back arrow is automatically handled by the AppBar
            backgroundColor: const Color(0xFFF4A905),
            title: const Text(
            'Add Equipment',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            iconTheme: const IconThemeData(color: Colors.white), // Makes the back arrow white
            centerTitle: true,
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
                const Text(
                'Add Pet\'s Info',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                ),
                ),
                const SizedBox(height: 20),

                // Account Name Field
                _buildInputField(
                hintText: 'Account Name',
                // The design uses a grey background for the fields
                backgroundColor: const Color(0xFFE0E0E0), 
                ),
                const SizedBox(height: 16),

                // IMEI Number Field
                _buildInputField(
                hintText: 'IMEI number',
                backgroundColor: const Color(0xFFE0E0E0),
                ),
                const Padding(
                padding: EdgeInsets.only(top: 4.0, bottom: 16.0),
                child: Text(
                    'Please enter the new device IMEI number',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                ),

                // Device Password Field
                _buildInputField(
                hintText: 'Device password',
                isPassword: true,
                backgroundColor: const Color(0xFFE0E0E0),
                ),
                const Padding(
                padding: EdgeInsets.only(top: 4.0, bottom: 40.0),
                child: Text(
                    'Please enter the new device password',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                ),

                // Add Equipment Button
                SizedBox(
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                    // TODO: Implement logic to save pet/equipment data
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Equipment Add Logic To Be Implemented!')),
                    );
                    },
                    style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF134694),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                    ),
                    ),
                    child: const Text(
                    'Add Equipment',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                ),
                ),
            ],
            ),
        ),
        );
    }

    Widget _buildInputField({
        required String hintText,
        Color backgroundColor = Colors.white,
        bool isPassword = false,
    }) {
        return Container(
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
            obscureText: isPassword,
            decoration: InputDecoration(
            hintText: hintText,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            border: InputBorder.none, // Removes the standard underline
            ),
        ),
        );
    }
    }