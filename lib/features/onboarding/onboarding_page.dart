import 'package:flutter/material.dart';
import 'onboarding_data.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const OnboardingPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        children: [
          const Spacer(flex: 1),
          _buildIllustration(),
          const Spacer(flex: 1),
          _buildContent(),
          const Spacer(flex: 1),
        ],
      ),
    );
  }

  Widget _buildIllustration() {
    return Container(
      width: 320,
      height: 320,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ..._buildBackgroundCircles(),
          ..._buildFloatingIcons(),
          _buildMainIcon(),
        ],
      ),
    );
  }

  List<Widget> _buildBackgroundCircles() {
    return List.generate(3, (index) {
      return AnimatedContainer(
        duration: Duration(milliseconds: 1000 + (index * 200)),
        width: 280 - (index * 40.0),
        height: 280 - (index * 40.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: data.color.withOpacity(0.05 - (index * 0.01)),
          border: Border.all(
            color: data.color.withOpacity(0.1),
            width: 1,
          ),
        ),
      );
    });
  }

  List<Widget> _buildFloatingIcons() {
    return data.backgroundIcons.asMap().entries.map((entry) {
      int idx = entry.key;
      IconData icon = entry.value;
      double radius = 80;

      double xPosition = 160 + (radius * (idx == 0 ? 1 : idx == 1 ? -0.5 : -0.5));
      double yPosition = 160 + (radius * (idx == 0 ? 0 : idx == 1 ? 0.866 : -0.866));

      return Positioned(
        left: xPosition,
        top: yPosition,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: data.color.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: data.color,
            size: 24,
          ),
        ),
      );
    }).toList();
  }

  Widget _buildMainIcon() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            data.color,
            data.color.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: data.color.withOpacity(0.3),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(
        data.primaryIcon,
        color: Colors.white,
        size: 56,
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        _buildStatsBadge(),
        const SizedBox(height: 24),
        _buildTitle(),
        const SizedBox(height: 8),
        _buildSubtitle(),
        const SizedBox(height: 20),
        _buildDescription(),
      ],
    );
  }

  Widget _buildStatsBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: data.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        data.stats,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: data.color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      data.title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: Color(0xFF0A1628),
        height: 1.1,
        letterSpacing: -0.8,
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      data.subtitle,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: data.color,
        letterSpacing: -0.2,
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      data.description,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 16,
        color: Color(0xFF64748B),
        height: 1.6,
        letterSpacing: 0.1,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}