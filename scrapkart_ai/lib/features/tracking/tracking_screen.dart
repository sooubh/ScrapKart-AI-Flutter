import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/text_styles.dart';
import '../../core/widgets/glass_card.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  GoogleMapController? _mapController;
  bool _isSearching = true;
  bool _isAssigned = false;
  
  // Nashik Coordinates
  static const LatLng _userLocation = LatLng(20.0125, 73.7915); // Panchvati, Nashik
  LatLng _collectorLocation = const LatLng(19.9975, 73.7898); // College Road, Nashik
  
  Timer? _trackingTimer;
  double _progress = 0.0;
  String _eta = 'Fetching...';
  String _distance = 'Calculating...';

  final List<Map<String, dynamic>> _collectors = [
    {'name': 'Rahul Sharma', 'rating': '4.8', 'phone': '+91 9876543210', 'vehicle': 'MH-15-AB-1234'},
    {'name': 'Amit Patil', 'rating': '4.9', 'phone': '+91 9823456789', 'vehicle': 'MH-15-XY-5678'},
    {'name': 'Sanjay Deshmukh', 'rating': '4.7', 'phone': '+91 9123456780', 'vehicle': 'MH-15-ZK-9012'},
  ];
  
  late Map<String, dynamic> _assignedCollector;

  @override
  void initState() {
    super.initState();
    _startAssignmentSequence();
  }

  void _startAssignmentSequence() async {
    // 1. Show searching state for 3 seconds
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    
    setState(() {
      _isSearching = false;
      _isAssigned = true;
      _assignedCollector = _collectors[0]; // Assign the first one for demo
      _eta = '12 Min';
      _distance = '3.2 km';
    });

    // 2. Start movement simulation
    _startMovementSimulation();
  }

  void _startMovementSimulation() {
    const duration = Duration(milliseconds: 100);
    const steps = 600; // 60 seconds of movement
    int currentStep = 0;

    final double latStep = (_userLocation.latitude - _collectorLocation.latitude) / steps;
    final double lngStep = (_userLocation.longitude - _collectorLocation.longitude) / steps;

    _trackingTimer = Timer.periodic(duration, (timer) {
      if (currentStep >= steps) {
        timer.cancel();
        return;
      }

      if (mounted) {
        setState(() {
          _collectorLocation = LatLng(
            _collectorLocation.latitude + latStep,
            _collectorLocation.longitude + lngStep,
          );
          currentStep++;
          _progress = currentStep / steps;
          
          // Update ETA based on progress
          final int remainingMinutes = (12 * (1 - _progress)).toInt();
          _eta = remainingMinutes > 0 ? '$remainingMinutes Min' : 'Arriving';
          _distance = '${(3.2 * (1 - _progress)).toStringAsFixed(1)} km';
        });
      }
    });
  }

  @override
  void dispose() {
    _trackingTimer?.cancel();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Track Collector', style: AppTextStyles.title),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
          // Google Map Focused on Nashik
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: const CameraPosition(
              target: _userLocation,
              zoom: 14.0,
            ),
            markers: {
              Marker(
                markerId: const MarkerId('pickup'),
                position: _userLocation,
                infoWindow: const InfoWindow(title: 'Your Pickup Location'),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              ),
              if (_isAssigned)
                Marker(
                  markerId: const MarkerId('collector'),
                  position: _collectorLocation,
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
                  infoWindow: InfoWindow(title: '${_assignedCollector['name']} (${_assignedCollector['vehicle']})'),
                ),
            },
            polylines: {
              if (_isAssigned)
                Polyline(
                  polylineId: const PolylineId('route'),
                  points: [_collectorLocation, _userLocation],
                  color: AppColors.primary,
                  width: 5,
                ),
            },
            myLocationEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),

          // Searching Overlay
          if (_isSearching)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: GlassCard(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(color: AppColors.primary),
                      const SizedBox(height: 24),
                      Text('Finding Nearest Collector...', style: AppTextStyles.title),
                      const SizedBox(height: 8),
                      Text('Scanning Nashik City Area', style: AppTextStyles.body),
                    ],
                  ),
                ),
              ),
            ).animate().fadeIn(),

          // Collector Info Card
          if (_isAssigned)
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: GlassCard(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildStatusHeader(),
                          const SizedBox(height: 16),
                          _buildProgressBar(),
                          const SizedBox(height: 16),
                          _buildCollectorInfo(),
                          const SizedBox(height: 16),
                          _buildStatsRow(),
                          const SizedBox(height: 20),
                          _buildActionButtons(),
                        ],
                      ),
                    ).animate().slideY(begin: 1.0, duration: 600.ms, curve: Curves.easeOutBack),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Vehicle On The Way', style: AppTextStyles.title.copyWith(fontSize: 18)),
            Text(_assignedCollector['vehicle'], style: AppTextStyles.body.copyWith(fontSize: 14)),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Live',
            style: AppTextStyles.body.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: _progress,
            minHeight: 8,
            backgroundColor: Colors.white24,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildCollectorInfo() {
    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: AppColors.primary.withOpacity(0.2),
          child: const Icon(Icons.person, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_assignedCollector['name'], style: AppTextStyles.title.copyWith(fontSize: 18)),
              Text('ScrapKart Verified Collector', style: AppTextStyles.body.copyWith(fontSize: 12)),
            ],
          ),
        ),
        Row(
          children: [
            const Icon(Icons.star_rounded, color: Colors.orange, size: 20),
            const SizedBox(width: 4),
            Text(_assignedCollector['rating'], style: AppTextStyles.title.copyWith(fontSize: 16)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem('ETA', _eta, AppColors.primary),
        Container(width: 1, height: 30, color: Colors.white24),
        _buildStatItem('Distance', _distance, AppColors.textPrimary),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.body.copyWith(fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.title.copyWith(fontSize: 16, color: valueColor)),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildButton(
            icon: Icons.call_rounded,
            label: 'Call',
            color: AppColors.tertiary,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Calling ${_assignedCollector['name']}...')),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildButton(
            icon: Icons.message_rounded,
            label: 'Message',
            color: Colors.white,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Opening chat with ${_assignedCollector['name']}...')),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildButton({
    required IconData icon, 
    required String label, 
    required Color color, 
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: AppColors.textPrimary),
            const SizedBox(width: 8),
            Text(label, style: AppTextStyles.button.copyWith(color: AppColors.textPrimary, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
