import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../services/storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _storage = StorageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          color: AppColors.neonBlue),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        "PARAMÈTRES",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          letterSpacing: 4,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Options
              _buildSettingTile(
                icon: Icons.phone_android,
                title: "Accéléromètre",
                subtitle: "Contrôler avec l'inclinaison",
                trailing: Switch(
                  value: _storage.getUseAccelerometer(),
                  onChanged: (val) {
                    _storage.setUseAccelerometer(val);
                    setState(() {});
                  },
                  activeColor: AppColors.neonBlue,
                ),
              ),

              _buildSettingTile(
                icon: Icons.volume_up,
                title: "Son",
                subtitle: "Activer les effets sonores",
                trailing: Switch(
                  value: _storage.getSoundEnabled(),
                  onChanged: (val) {
                    _storage.setSoundEnabled(val);
                    setState(() {});
                  },
                  activeColor: AppColors.neonBlue,
                ),
              ),

              _buildSettingTile(
                icon: Icons.vibration,
                title: "Vibrations",
                subtitle: "Retour haptique",
                trailing: Switch(
                  value: _storage.getVibrationEnabled(),
                  onChanged: (val) {
                    _storage.setVibrationEnabled(val);
                    setState(() {});
                  },
                  activeColor: AppColors.neonBlue,
                ),
              ),

              const Divider(color: AppColors.surfaceLight, height: 40),

              _buildSettingTile(
                icon: Icons.delete_outline,
                title: "Réinitialiser",
                subtitle: "Effacer toute la progression",
                trailing: const Icon(Icons.chevron_right,
                    color: AppColors.neonPink),
                onTap: () => _showResetDialog(),
              ),

              const Spacer(),

              // Crédits
              const Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      "Brain Maze v1.0.0",
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Made By laroma_dev",
                      style: TextStyle(
                        color: AppColors.neonBlue,
                        fontSize: 12,
                      ),
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

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.surface,
          border: Border.all(
            color: AppColors.neonBlue.withOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.neonBlue, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          "Réinitialiser ?",
          style: TextStyle(color: AppColors.neonPink),
        ),
        content: const Text(
          "Toute votre progression sera perdue.",
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Annuler",
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              _storage.resetAll();
              Navigator.pop(ctx);
              setState(() {});
            },
            child: const Text("Réinitialiser",
                style: TextStyle(color: AppColors.neonPink)),
          ),
        ],
      ),
    );
  }
}