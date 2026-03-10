lib/
├── main.dart                          ✅
├── core/
│   └── theme.dart                     ✅ Design System complet
├── game/
│   ├── brain_maze_game.dart           ✅ Moteur de jeu
│   ├── components/
│   │   ├── ball.dart                  ✅ Balle + trail + glow
│   │   ├── wall.dart                  ✅ Murs statiques
│   │   ├── goal.dart                  ✅ Objectif animé
│   │   ├── trap.dart                  ✅ Pièges mortels
│   │   ├── teleporter.dart            ✅ Téléporteurs
│   │   └── moving_wall.dart           ✅ Murs mouvants
│   └── levels/
│       ├── level_model.dart           ✅ Modèle de données
│       └── level_data.dart            ✅ 10 niveaux complets
├── screens/
│   ├── home_screen.dart               ✅ Menu animé néon
│   ├── level_select_screen.dart       ✅ Grille avec étoiles
│   ├── game_screen.dart               ✅ HUD + overlays
│   └── settings_screen.dart           ✅ Paramètres complets
├── services/
│   ├── storage_service.dart           ✅ Hive (persistance)
│   └── ad_service.dart                ✅ AdMob (monétisation)
└── widgets/
    ├── neon_button.dart               ✅ Bouton néon animé
    ├── star_display.dart              ✅ Affichage étoiles
    └── animated_background.dart       ✅ Particules de fond