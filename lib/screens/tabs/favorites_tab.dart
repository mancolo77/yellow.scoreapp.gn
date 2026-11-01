import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/guinea_match_service.dart';

class FavoritesTab extends StatefulWidget {
  const FavoritesTab({super.key});

  @override
  State<FavoritesTab> createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab> {
  final GuineaMatchService _service = GuineaMatchService();

  @override
  void initState() {
    super.initState();
    _service.addListener(_onServiceUpdate);
  }

  @override
  void dispose() {
    _service.removeListener(_onServiceUpdate);
    super.dispose();
  }

  void _onServiceUpdate() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final favMatches = _service.matches.where((m) => _service.favMatchIds.contains(m.id)).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.darkNav,
        elevation: 0,
        title: const Text('Mes Favoris', style: TextStyle(color: AppTheme.textMain, fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.screenPadding),
        child: favMatches.isEmpty
            ? Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.star_border_rounded, size: 54, color: AppTheme.textSecondary),
                    SizedBox(height: 16),
                    Text(
                      'Aucun match favori',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Appuyez sur l\'étoile d\'une rencontre pour la conserver dans vos favoris.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${favMatches.length} rencontre${favMatches.length > 1 ? "s" : ""} sauvegardée${favMatches.length > 1 ? "s" : ""}',
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  ...favMatches.map((m) => Card(
                        color: AppTheme.surfaceCard,
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: AppTheme.filterBg,
                            child: Text(m.codeA, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 11)),
                          ),
                          title: Text('${m.teamA} vs ${m.teamB}', style: const TextStyle(color: AppTheme.textMain, fontWeight: FontWeight.bold, fontSize: 14)),
                          subtitle: Text('${m.date} à ${m.time} • ${m.stadium}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(m.score ?? m.status, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.star_rounded, color: AppTheme.primary),
                                onPressed: () => _service.toggleFavorite(m.id),
                              ),
                            ],
                          ),
                        ),
                      )),
                ],
              ),
      ),
    );
  }
}
