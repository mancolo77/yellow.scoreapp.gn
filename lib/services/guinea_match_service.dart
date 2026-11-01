import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GuineaMatch {
  final String id;
  final String tour; // 'Journée 1', 'Journée 2', etc.
  final String teamA;
  final String codeA;
  final String teamB;
  final String codeB;
  final String date; // '01 Nov', '02 Nov', '03 Nov', etc.
  final String time; // '16:00', '18:30'
  final String? score; // '2 - 1', null if upcoming
  final String stadium;
  final String status; // 'Terminé', 'À venir'
  final String description;

  const GuineaMatch({
    required this.id,
    required this.tour,
    required this.teamA,
    required this.codeA,
    required this.teamB,
    required this.codeB,
    required this.date,
    required this.time,
    this.score,
    required this.stadium,
    required this.status,
    required this.description,
  });

  bool get isFinished => score != null || status == 'Terminé';
}

class GuineaMatchService with ChangeNotifier {
  static final GuineaMatchService _instance = GuineaMatchService._internal();
  factory GuineaMatchService() => _instance;
  GuineaMatchService._internal();

  final Set<String> _favMatchIds = {'gm_1', 'gm_3'};
  String _userName = 'Supporter Guinée';
  String _favoriteTeam = 'Horoya AC';

  Set<String> get favMatchIds => Set.unmodifiable(_favMatchIds);
  String get userName => _userName;
  String get favoriteTeam => _favoriteTeam;

  final List<String> teams = const [
    'Horoya AC',
    'Hafia FC',
    'AS Kaloum',
    'CI Kamsar',
    'Satellite FC',
    'Milo FC Kankan',
    'Wakriya AC',
    'Flamme Olympique',
  ];

  final List<GuineaMatch> matches = const [
    // Journée 1
    GuineaMatch(
      id: 'gm_1',
      tour: 'Journée 1',
      teamA: 'Horoya AC',
      codeA: 'HAC',
      teamB: 'Hafia FC',
      codeB: 'HFC',
      date: 'Aujourd\'hui',
      time: '16:00',
      score: '2 - 1',
      stadium: 'Stade Général Lansana Conté, Nongo',
      status: 'Terminé',
      description: 'Victoire serrée de Horoya AC avec un doublé décisif en seconde période.',
    ),
    GuineaMatch(
      id: 'gm_2',
      tour: 'Journée 1',
      teamA: 'AS Kaloum',
      codeA: 'ASK',
      teamB: 'CI Kamsar',
      codeB: 'CIK',
      date: 'Aujourd\'hui',
      time: '18:30',
      score: '0 - 0',
      stadium: 'Stade de la Mission, Kaloum',
      status: 'Terminé',
      description: 'Match nul tactique et défensif avec peu d\'occasions franches.',
    ),
    GuineaMatch(
      id: 'gm_3',
      tour: 'Journée 1',
      teamA: 'Satellite FC',
      codeA: 'SFC',
      teamB: 'Milo FC Kankan',
      codeB: 'MFC',
      date: 'Demain',
      time: '16:00',
      score: null,
      stadium: 'Stade du 28 Septembre, Conakry',
      status: 'À venir',
      description: 'Duel au sommet entre les attaquants de Satellite et la solide défense de Kankan.',
    ),
    GuineaMatch(
      id: 'gm_4',
      tour: 'Journée 1',
      teamA: 'Wakriya AC',
      codeA: 'WAC',
      teamB: 'Flamme Olympique',
      codeB: 'FLA',
      date: 'Demain',
      time: '18:00',
      score: null,
      stadium: 'Stade de l\'Amitié, Kamsar',
      status: 'À venir',
      description: 'Deux formations réputées pour leur jeu rapide en contre-attaque.',
    ),

    // Journée 2
    GuineaMatch(
      id: 'gm_5',
      tour: 'Journée 2',
      teamA: 'Hafia FC',
      codeA: 'HFC',
      teamB: 'AS Kaloum',
      codeB: 'ASK',
      date: '04 Nov',
      time: '16:00',
      score: null,
      stadium: 'Stade Petit Sory, Nongo',
      status: 'À venir',
      description: 'Le classico guinéen entre les deux géants historiques de Conakry.',
    ),
    GuineaMatch(
      id: 'gm_6',
      tour: 'Journée 2',
      teamA: 'CI Kamsar',
      codeA: 'CIK',
      teamB: 'Horoya AC',
      codeB: 'HAC',
      date: '04 Nov',
      time: '18:30',
      score: null,
      stadium: 'Stade de l\'Amitié, Kamsar',
      status: 'À venir',
      description: 'Déplacement périlleux pour Horoya dans le bastion de Kamsar.',
    ),
    GuineaMatch(
      id: 'gm_7',
      tour: 'Journée 2',
      teamA: 'Milo FC Kankan',
      codeA: 'MFC',
      teamB: 'Wakriya AC',
      codeB: 'WAC',
      date: '05 Nov',
      time: '16:00',
      score: null,
      stadium: 'Stade M\'Balou Mady Diakité, Kankan',
      status: 'À venir',
      description: 'Choc de province avec le public enthousiaste de la Haute-Guinée.',
    ),
    GuineaMatch(
      id: 'gm_8',
      tour: 'Journée 2',
      teamA: 'Flamme Olympique',
      codeA: 'FLA',
      teamB: 'Satellite FC',
      codeB: 'SFC',
      date: '05 Nov',
      time: '18:00',
      score: null,
      stadium: 'Stade de la Mission, Kaloum',
      status: 'À venir',
      description: 'Rencontre prometteuse entre deux équipes tournées vers l\'offensive.',
    ),

    // Journée 3
    GuineaMatch(
      id: 'gm_9',
      tour: 'Journée 3',
      teamA: 'Horoya AC',
      codeA: 'HAC',
      teamB: 'Milo FC Kankan',
      codeB: 'MFC',
      date: '08 Nov',
      time: '16:00',
      score: null,
      stadium: 'Stade Général Lansana Conté, Nongo',
      status: 'À venir',
      description: 'Test majeur pour les ambitions de titre des deux formations.',
    ),
    GuineaMatch(
      id: 'gm_10',
      tour: 'Journée 3',
      teamA: 'AS Kaloum',
      codeA: 'ASK',
      teamB: 'Wakriya AC',
      codeB: 'WAC',
      date: '08 Nov',
      time: '18:30',
      score: null,
      stadium: 'Stade de la Mission, Kaloum',
      status: 'À venir',
      description: 'Kaloum reçoit Wakriya pour tenter d\'accrocher le peloton de tête.',
    ),
    GuineaMatch(
      id: 'gm_11',
      tour: 'Journée 3',
      teamA: 'Hafia FC',
      codeA: 'HFC',
      teamB: 'Flamme Olympique',
      codeB: 'FLA',
      date: '09 Nov',
      time: '16:00',
      score: null,
      stadium: 'Stade Petit Sory, Nongo',
      status: 'À venir',
      description: 'Hafia cherche à imposer son rythme face à la jeunesse de Flamme.',
    ),
    GuineaMatch(
      id: 'gm_12',
      tour: 'Journée 3',
      teamA: 'CI Kamsar',
      codeA: 'CIK',
      teamB: 'Satellite FC',
      codeB: 'SFC',
      date: '09 Nov',
      time: '18:00',
      score: null,
      stadium: 'Stade de l\'Amitié, Kamsar',
      status: 'À venir',
      description: 'Opposition équilibrée entre le jeu physique et la vivacité technique.',
    ),

    // Matchs précédents (Résultats)
    GuineaMatch(
      id: 'gm_13',
      tour: 'Matchs Préparatoires',
      teamA: 'Horoya AC',
      codeA: 'HAC',
      teamB: 'AS Kaloum',
      codeB: 'ASK',
      date: 'Hier',
      time: '17:00',
      score: '3 - 2',
      stadium: 'Stade Général Lansana Conté, Nongo',
      status: 'Terminé',
      description: 'Festival de buts et intensité maximale pour ce derby préparatoire.',
    ),
    GuineaMatch(
      id: 'gm_14',
      tour: 'Matchs Préparatoires',
      teamA: 'Hafia FC',
      codeA: 'HFC',
      teamB: 'Satellite FC',
      codeB: 'SFC',
      date: 'Hier',
      time: '15:30',
      score: '1 - 0',
      stadium: 'Stade Petit Sory, Nongo',
      status: 'Terminé',
      description: 'Une tête victorieuse sur corner à la 78e minute a fait la différence.',
    ),
    GuineaMatch(
      id: 'gm_15',
      tour: 'Matchs Préparatoires',
      teamA: 'Milo FC Kankan',
      codeA: 'MFC',
      teamB: 'CI Kamsar',
      codeB: 'CIK',
      date: '28 Oct',
      time: '16:00',
      score: '2 - 0',
      stadium: 'Stade M\'Balou Mady Diakité, Kankan',
      status: 'Terminé',
      description: 'Prestation magistrale des locaux portés par leur public.',
    ),
    GuineaMatch(
      id: 'gm_16',
      tour: 'Matchs Préparatoires',
      teamA: 'Wakriya AC',
      codeA: 'WAC',
      teamB: 'Horoya AC',
      codeB: 'HAC',
      date: '26 Oct',
      time: '16:30',
      score: '1 - 1',
      stadium: 'Stade de l\'Amitié, Kamsar',
      status: 'Terminé',
      description: 'Partage des points après une égalisation de Wakriya en toute fin de match.',
    ),
    GuineaMatch(
      id: 'gm_17',
      tour: 'Matchs Préparatoires',
      teamA: 'Flamme Olympique',
      codeA: 'FLA',
      teamB: 'AS Kaloum',
      codeB: 'ASK',
      date: '25 Oct',
      time: '16:00',
      score: '0 - 2',
      stadium: 'Stade de la Mission, Kaloum',
      status: 'Terminé',
      description: 'Kaloum s\'impose avec maîtrise grâce à deux contres tranchants.',
    ),
    GuineaMatch(
      id: 'gm_18',
      tour: 'Matchs Préparatoires',
      teamA: 'Satellite FC',
      codeA: 'SFC',
      teamB: 'Wakriya AC',
      codeB: 'WAC',
      date: '24 Oct',
      time: '17:00',
      score: '2 - 2',
      stadium: 'Stade du 28 Septembre, Conakry',
      status: 'Terminé',
      description: 'Rencontre spectaculaire avec quatre buts marqués en première mi-temps.',
    ),
    GuineaMatch(
      id: 'gm_19',
      tour: 'Matchs Préparatoires',
      teamA: 'CI Kamsar',
      codeA: 'CIK',
      teamB: 'Hafia FC',
      codeB: 'HFC',
      date: '22 Oct',
      time: '16:00',
      score: '1 - 3',
      stadium: 'Stade de l\'Amitié, Kamsar',
      status: 'Terminé',
      description: 'Démonstration collective de Hafia qui a su concrétiser ses opportunités.',
    ),
    GuineaMatch(
      id: 'gm_20',
      tour: 'Matchs Préparatoires',
      teamA: 'Milo FC Kankan',
      codeA: 'MFC',
      teamB: 'Flamme Olympique',
      codeB: 'FLA',
      date: '20 Oct',
      time: '16:00',
      score: '3 - 1',
      stadium: 'Stade M\'Balou Mady Diakité, Kankan',
      status: 'Terminé',
      description: 'Milo FC confirme son excellente forme physique avec une large victoire.',
    ),
  ];

  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final fav = prefs.getStringList('fav_matches_guinea');
      if (fav != null) {
        _favMatchIds.clear();
        _favMatchIds.addAll(fav);
      }
      final name = prefs.getString('user_name_guinea');
      if (name != null) _userName = name;
      final team = prefs.getString('fav_team_guinea');
      if (team != null) _favoriteTeam = team;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('fav_matches_guinea', _favMatchIds.toList());
      await prefs.setString('user_name_guinea', _userName);
      await prefs.setString('fav_team_guinea', _favoriteTeam);
    } catch (_) {}
  }

  void toggleFavorite(String id) {
    if (_favMatchIds.contains(id)) {
      _favMatchIds.remove(id);
    } else {
      _favMatchIds.add(id);
    }
    _save();
    notifyListeners();
  }

  void updateProfile(String name, String team) {
    _userName = name;
    _favoriteTeam = team;
    _save();
    notifyListeners();
  }

  void resetData() {
    _favMatchIds.clear();
    _userName = 'Supporter Guinée';
    _favoriteTeam = 'Horoya AC';
    _save();
    notifyListeners();
  }
}
