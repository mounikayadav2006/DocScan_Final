import 'package:flutter/material.dart';

/// EXPERIMENT 6a - Reusable custom widgets.
class CustomCardTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;

  const CustomCardTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: color.withAlpha(30),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: onTap == null ? null : const Icon(Icons.chevron_right),
      ),
    );
  }
}

/// Small statistic card with a count-up animation (implicit animation, Exp 8b).
class StatCard extends StatelessWidget {
  final IconData icon;
  final int value;
  final String label;

  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(45),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(height: 4),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: value.toDouble()),
              duration: const Duration(milliseconds: 900),
              builder: (context, v, _) => Text(
                v.round().toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Text(label,
                style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

/// Gradient banner used at the top of the home screen.
class GradientHeader extends StatelessWidget {
  final Widget child;
  const GradientHeader({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cs.primary, cs.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: child,
    );
  }
}
