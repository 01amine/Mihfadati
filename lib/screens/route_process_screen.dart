import 'package:flutter/material.dart';

import 'ar_map.dart';

class RouteProcessScreen extends StatefulWidget {
  final String routeName;
  final String transportType;
  final String estimatedTime;

  const RouteProcessScreen({
    super.key,
    required this.routeName,
    required this.transportType,
    required this.estimatedTime,
  });

  @override
  State<RouteProcessScreen> createState() => _RouteProcessScreenState();
}

class _RouteProcessScreenState extends State<RouteProcessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Live Updates Section
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.directions_bus, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Live Updates',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text("Bus 42 is arriving in 3 minutes at Kherouba"),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Route Progress Section
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Route Progress",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildRouteStep("Central Station", "25 minutes remaining"),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Icon(Icons.arrow_downward, size: 20),
                    ),
                    _buildRouteStep("Algiers Center", "10 minutes remaining"),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: 0.5,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("10:30 am"),
                        Text("12:00 pm"),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Steps List Section
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [
                    _buildStepListItem(
                      icon: Icons.directions_walk,
                      title: "Walk to Bus stop",
                      subtitle: "200m · 5 minutes",
                    ),
                    _buildStepListItem(
                      icon: Icons.directions_bus,
                      title: "Take Bus 42",
                      subtitle: "12 stops · 25 minutes",
                    ),
                    _buildStepListItem(
                      icon: Icons.directions_walk,
                      title: "Walk to Destination",
                      subtitle: "150m · 3 minutes",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRouteStep(String location, String time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(location),
        Text(
          time,
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildStepListItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ARMapView(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
