# TODO — Dice Royal - DESKTO P

## THIS SESSION
- [ ] Ajout de screenshake
- [ ] Ajout de rumble
- [ ] Ajout / Remplacement de SFX
- [ ] Ajout de VFX

## NEXT SESSION
- [ ] Faire diff Desktop Vs Mobile, mettre à jour version mobile avec nouveau gameplay et features.
- [ ] Mettre version Mobile mise à jour sur GX, itch, GameJolt et update porfolio.
- [ ] Nouveaux visuels + animations pour special dice.
- [ ] Gestion du data de difficulté avec CSV?

## GAMEPLAY
- [ ] 

## GAME MODES
- [ ] Ajouter Mode Casual/ Zen (après balancing final).
- [ ] Ajouter Mode Multiplayer du Main Mode. - GROS CHANTIER
- [ ] Ajouter Mode Bonus ala "Bejeweled". - GROS CHANTIER
- [ ] Ajouter Mode Bonus ala "Money Puzzle Exchanger". - GROS CHANTIER

## SYSTEMS
- [ ] Ajouter online leaderboard.
- [ ] Ajouter achievements.
- [ ] Ajouter rewards (thèmes visuels; Dice, Cards, Dominio, Chips (unlock avec achievements)).

## MENUS
- [ ] Ajouter attract mode -> Après X secondes dans Splash Screen.
- [ ] Ajouter menu après splash screen; start, how to play, bonus modes, unlocks, leaderboard, options.
- [ ] Ajouter menu start -> Sélection Arcade / Casual.
- [ ] Ajouter menu how to play -> Controls, Interface, Dice Index.
- [ ] Ajouter menu bonus modes -> Sélection Bejeweled / Money Puzzle Exchanger.
- [ ] Ajouter menu unlocks -> Achievements, Rewards, Theme Selection.
- [ ] Ajouter menu options -> Music on / off, SFX.
- [ ] Modifier menu pause -> Ajouter Toggle "Next", Help.
- [ ] Modifier menu help -> Ajouter Dice Index.

## POLISH
- [ ] Ajouter une indication visuelle des touches utiles dans les menus.
- [ ] Refaire visuel avec Pixel Composer pour un look "modern Robotron".
- [ ] Ajouter VFX.
- [ ] Changer le thème musical.
- [ ] Refaire les SFX / Ajouter SFX.

## TEST & DEBUG
- [ ] 

## BUGS
- [ ] 

## PENDING
- [ ] Solo Dice Instant Drop Vs Normal Drop

## PUBLISHING
- [ ] Créer compte développeur Steam.
- [ ] Demander à Jonathan pour co-credits d'Aftergrinder.
- [ ] Produire les assets pour publication Steam.

## ISSUE TRACKING
- [ ] Recalibrer les seuils de niveaux (LEVEL_THRESHOLDS) et possiblement les vitesses (LEVEL_SPEEDS). Ils ont été calibrés quand les chaînes profondes ne rapportaient presque rien; depuis que le multiplicateur monte au lieu de descendre et que les suites donnent 6000, la même partie rapporte beaucoup plus, donc les niveaux arrivent plus tôt et la vitesse grimpe plus tôt. Repère : une seule belle chaîne ou une seule suite suffit maintenant à franchir le seuil du niveau 2 (5000). À reprendre dans DR_DifficultyProgression.xlsx après quelques parties de feeling.
- [ ] Le score peut déborder de sa boîte HUD. Le texte est justifié à gauche dans une boîte de largeur fixe (BOX_WIDTH), sans aucune gestion d'overflow — un score assez long dépasse vers la droite, en direction de la grille. Touche autant Score que High Score. Va se manifester plus tôt maintenant que le multiplicateur de chaîne monte au lieu de descendre. Pistes : rapetisser la police quand le texte dépasse la largeur utile, formater le nombre (séparateurs de milliers, ou notation courte type 1.2M), ou élargir la boîte.
- [ ] Si ta meilleure chaîne d'une partie est la toute dernière (celle qui te fait perdre), elle n'est jamais comptabilisée dans "BEST". Le compteur ne se fige qu'au spawn de la paire suivante, qui n'arrive jamais en game over.
- [ ] AVANT RELEASE : remettre la musique à ON par défaut. scr_save_load lit music_muted avec 1 (muté) comme valeur par défaut — volontaire en dev pour ne pas subir la musique à chaque test, mais un joueur qui lance le jeu pour la première fois (aucun .ini sur sa machine) démarre en silence. Le SFX est déjà à 0 (actif), c'est seulement la musique.
- [ ] AVANT RELEASE : désactiver les raccourcis de debug. Q ferme le jeu instantanément, R relance la partie, F5 efface le high score — les trois sont actifs partout (logos, splash, en jeu), sans confirmation, et pollés tout en haut de scr_game_update. Pratiques en dev, inacceptables dans un build public.
- [ ] Trous dans la colonne droite du HUD quand Show Queue ou Enable Hold/Swap sont désactivés dans le menu pause. scr_ui_hud_layout réserve toujours les 3 emplacements (Unlocks, Next, Hold) et scr_ui_draw saute seulement le dessin — l'espace reste vide au lieu d'être récupéré par les boîtes restantes.