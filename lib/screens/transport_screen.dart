import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'route_process_screen.dart';

class TransportScreen extends StatefulWidget {
  const TransportScreen({super.key});

  @override
  State<TransportScreen> createState() => _TransportScreenState();
}

class _TransportScreenState extends State<TransportScreen> {
  String selectedTransport = "All";
  bool _showRoutes = false;
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  String? _selectedRoute;

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Route Planner',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(decoration: BoxDecoration(color: Colors.grey.shade100)),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMainContainer(),
                    const SizedBox(height: 20),
                    if (_showRoutes) _buildRoutesContainer(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContainer() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: _containerDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader("Plan Your Journey", "Enter Your Destination Details"),
          const SizedBox(height: 15),
          _buildTextField("From", "Current Location", _fromController),
          const SizedBox(height: 10),
          _buildTextField("To", "Enter Destination", _toController),
          const SizedBox(height: 20),
          const Text("Transport Preference",
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildTransportOption(Icons.map_outlined, "All"),
                _buildTransportOption(Icons.directions_bus, "Bus"),
                _buildTransportOption(Icons.train_outlined, "Train"),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (_fromController.text.isEmpty ||
                    _toController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter both locations'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }
                setState(() {
                  _showRoutes = true;
                });
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 18),
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
              ),
              child: const Text("Find Route",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutesContainer() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _containerDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader("Available Routes", "Select the best route"),
          const SizedBox(height: 10),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildRouteOption(
                "Fastest Route",
                "Shortest travel time with express service",
                "15-20 mins",
                "bus",
              ),
              _buildRouteOption(
                "Alternative Route",
                "Balanced option with moderate traffic",
                "25-30 mins",
                "train",
              ),
              _buildRouteOption(
                "Scenic Route",
                "Longer but with beautiful views",
                "30-40 mins",
                "mixed",
              ),
            ],
          ),
        ],
      ),
    );
  }

  BoxDecoration _containerDecoration() {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.9),
      borderRadius: BorderRadius.circular(25),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          spreadRadius: 3,
        ),
      ],
    );
  }

  Widget _buildHeader(String title, String subtitle) {
    return Column(
      children: [
        Center(
          child: Text(
            title,
            style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
        ),
        const SizedBox(height: 5),
        Center(
          child: Text(
            subtitle,
            style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600]),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
      String label, String hintText, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
        ),
      ],
    );
  }

  Widget _buildTransportOption(IconData icon, String label) {
    bool isSelected = selectedTransport == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTransport = label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? Border.all(color: Colors.black, width: 2) : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.black54),
            const SizedBox(height: 5),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteOption(String routeName, String details, String time, String transportType) {
  bool isSelected = _selectedRoute == routeName;
  return GestureDetector(
    onTap: () {
      setState(() {
        _selectedRoute = routeName;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RouteProcessScreen(
            routeName: routeName,
            transportType: transportType,
            estimatedTime: time,
          ),
        ),
      );
    },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color:
              isSelected ? Colors.blue.shade50 : Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  routeName,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.blue : Colors.black),
                ),
                Row(
                  children: _getTransportIcons(transportType),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              "Estimated time: $time",
              style: TextStyle(
                fontSize: 14,
                color: isSelected ? Colors.blue : Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              details,
              style: TextStyle(
                fontSize: 14,
                color: isSelected ? Colors.blue : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _getTransportIcons(String transportType) {
    switch (transportType) {
      case 'bus':
        return const [
          Icon(Icons.directions_bus, color: Colors.red, size: 20),
        ];
      case 'train':
        return const [
          Icon(Icons.train, color: Colors.green, size: 20),
        ];
      case 'mixed':
        return const [
          Icon(Icons.directions_bus, color: Colors.red, size: 20),
          SizedBox(width: 5),
          Icon(Icons.train, color: Colors.green, size: 20),
        ];
      default:
        return const [
          Icon(Icons.directions, color: Colors.grey, size: 20),
        ];
    }
  }
}
