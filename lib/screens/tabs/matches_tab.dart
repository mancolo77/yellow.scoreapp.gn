import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/guinea_match_service.dart';

class MatchesTab extends StatefulWidget {
  const MatchesTab({super.key});

  @override
  State<MatchesTab> createState() => _MatchesTabState();
}

class _MatchesTabState extends State<MatchesTab> {
  final GuineaMatchService _service = GuineaMatchService();
  String _selectedDate = 'Tous';
  String _statusFilter = 'Tous'; // 'Tous', 'À venir', 'Terminés'

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
    var matches = _service.matches;

    // Filter by date
    if (_selectedDate != 'Tous') {
      matches = matches.where((m) => m.date == _selectedDate).toList();
    }

    // Filter by status
    if (_statusFilter == 'À venir') {
      matches = matches.where((m) => !m.isFinished).toList();
    } else if (_statusFilter == 'Terminés') {
      matches = matches.where((m) => m.isFinished).toList();
    }

    // Group by tour
    final Map<String, List<GuineaMatch>> grouped = {};
    for (final m in matches) {
      grouped.putIfAbsent(m.tour, () => []).add(m);
    }

    final dates = ['Tous', 'Hier', 'Aujourd\'hui', 'Demain', '04 Nov', '05 Nov', '08 Nov'];

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.darkNav,
        elevation: 0,
        title: const Text('Championnat National', style: TextStyle(color: AppTheme.textMain, fontSize: 20, fontWeight: FontWeight.bold)),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'Guinée',
                style: TextStyle(color: AppTheme.buttonTextDark, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Disclaimer banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.border),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: AppTheme.textSecondary),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Données fictives — démonstration',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Horizontal date ribbon
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: dates.map((d) {
                  final isSel = _selectedDate == d;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(d),
                      selected: isSel,
                      selectedColor: AppTheme.primary,
                      backgroundColor: AppTheme.surfaceCard,
                      labelStyle: TextStyle(
                        color: isSel ? AppTheme.buttonTextDark : AppTheme.textSecondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      onSelected: (_) => setState(() => _selectedDate = d),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),

            // Status filter buttons
            Row(
              children: ['Tous', 'À venir', 'Terminés'].map((st) {
                final isSel = _statusFilter == st;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: ElevatedButton(
                      onPressed: () => setState(() => _statusFilter = st),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSel ? AppTheme.primary : AppTheme.surfaceCard,
                        foregroundColor: isSel ? AppTheme.buttonTextDark : Colors.white,
                        elevation: 0,
                        minimumSize: const Size(0, 40),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.buttonRadius)),
                      ),
                      child: Text(
                        st,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Matches
            if (grouped.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.sports_soccer_outlined, size: 48, color: AppTheme.textSecondary),
                    SizedBox(height: 12),
                    Text(
                      'Aucun match trouvé pour cette sélection.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                    ),
                  ],
                ),
              )
            else
              ...grouped.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        entry.key,
                        style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                    ...entry.value.map((m) => _buildMatchCard(context, m)),
                    const SizedBox(height: 8),
                  ],
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchCard(BuildContext context, GuineaMatch match) {
    final isFav = _service.favMatchIds.contains(match.id);
    return Card(
      color: AppTheme.surfaceCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        onTap: () => _showMatchDetails(context, match),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${match.date} • ${match.time}',
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: match.isFinished ? AppTheme.border : AppTheme.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          match.status,
                          style: TextStyle(
                            color: match.isFinished ? AppTheme.textSecondary : AppTheme.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _service.toggleFavorite(match.id),
                        child: Icon(
                          isFav ? Icons.star_rounded : Icons.star_outline_rounded,
                          color: isFav ? AppTheme.primary : AppTheme.textSecondary,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(color: AppTheme.border, height: 18),
              Row(
                children: [
                  // Team A
                  Expanded(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: AppTheme.filterBg,
                          child: Text(match.codeA, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 11)),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          match.teamA,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppTheme.textMain, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  // Center score or VS
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: match.score != null
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.border,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              match.score!,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
                            ),
                          )
                        : const Text(
                            'VS',
                            style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                  ),
                  // Team B
                  Expanded(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: AppTheme.filterBg,
                          child: Text(match.codeB, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 11)),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          match.teamB,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppTheme.textMain, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMatchDetails(BuildContext context, GuineaMatch match) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(match.tour, style: const TextStyle(color: AppTheme.primary, fontSize: 13, fontWeight: FontWeight.bold)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.border,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(match.status, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(match.codeA, style: const TextStyle(color: AppTheme.primary, fontSize: 26, fontWeight: FontWeight.bold)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      match.score ?? 'VS',
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                    ),
                  ),
                  Text(match.codeB, style: const TextStyle(color: AppTheme.primary, fontSize: 26, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  '${match.teamA}  —  ${match.teamB}',
                  style: const TextStyle(color: AppTheme.textMain, fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
              const Divider(color: AppTheme.border, height: 24),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 16, color: AppTheme.textSecondary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(match.stadium, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.access_time_rounded, size: 16, color: AppTheme.textSecondary),
                  const SizedBox(width: 8),
                  Text('${match.date} à ${match.time}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  match.description,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text('Données fictives — démonstration', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontStyle: FontStyle.italic)),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
