import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/guinea_match_service.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final GuineaMatchService _service = GuineaMatchService();
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _service.userName);
    _service.addListener(_onServiceUpdate);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _service.removeListener(_onServiceUpdate);
    super.dispose();
  }

  void _onServiceUpdate() {
    if (mounted) setState(() {});
  }

  void _saveProfile() {
    _service.updateProfile(_nameController.text.trim(), _service.favoriteTeam);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil mis à jour')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favCount = _service.favMatchIds.length;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.darkNav,
        elevation: 0,
        title: const Text('Mon Espace', style: TextStyle(color: AppTheme.textMain, fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Avatar & Name Card
            Card(
              color: AppTheme.surfaceCard,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: AppTheme.primary,
                      child: Icon(Icons.person, color: AppTheme.buttonTextDark, size: 36),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_service.userName, style: const TextStyle(color: AppTheme.textMain, fontWeight: FontWeight.bold, fontSize: 18)),
                          const SizedBox(height: 4),
                          Text('Club de cœur : ${_service.favoriteTeam}', style: const TextStyle(color: AppTheme.primary, fontSize: 13, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 2),
                          Text('$favCount rencontre(s) en favoris', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Profile Form
            const Text('Modifier mon profil', style: TextStyle(color: AppTheme.textMain, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // Name field
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Nom de supporter',
                labelStyle: const TextStyle(color: AppTheme.textSecondary),
                filled: true,
                fillColor: AppTheme.surfaceCard,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Favorite team dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _service.favoriteTeam,
                  dropdownColor: AppTheme.surfaceCard,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: AppTheme.primary),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  onChanged: (val) {
                    if (val != null) {
                      _service.updateProfile(_nameController.text.trim(), val);
                    }
                  },
                  items: _service.teams.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: AppTheme.buttonHeight,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: AppTheme.buttonTextDark,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.buttonRadius)),
                ),
                child: const Text('Enregistrer les modifications', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ),
            const SizedBox(height: 24),

            // Reset Data Button
            OutlinedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: AppTheme.surfaceCard,
                    title: const Text('Réinitialiser les données ?', style: TextStyle(color: Colors.white)),
                    content: const Text('Cette action réinitialisera votre profil et supprimera vos favoris enregistrés.', style: TextStyle(color: AppTheme.textSecondary)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Annuler', style: TextStyle(color: AppTheme.textSecondary)),
                      ),
                      TextButton(
                        onPressed: () {
                          _service.resetData();
                          _nameController.text = _service.userName;
                          Navigator.pop(ctx);
                        },
                        child: const Text('Réinitialiser', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 44),
                side: const BorderSide(color: AppTheme.border),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.buttonRadius)),
              ),
              child: const Text('Réinitialiser les favoris et données', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }
}

