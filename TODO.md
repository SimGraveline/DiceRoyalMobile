# TODO — Dice Royal - DESKTO P

## THIS SESSION
- [X] Ajout de screenshake
- [X] Ajout de rumble
- [ ] Ajout / Remplacement de SFX
- [ ] Ajout de VFX

## NEXT SESSION
- [ ] Faire diff Desktop Vs Mobile, mettre à jour version mobile avec nouveau gameplay et features.
- [ ] Mettre version Mobile mise à jour sur GX, itch, GameJolt et update porfolio.
- [ ] Nouveaux visuels + animations pour special dice.
- [ ] Gestion du data de difficulté avec CSV?

## GAMEPLAY
- [ ] Décider si le match preview (highlight de la chaîne à venir) reste dans sa forme actuelle pour la release. La fonctionnalité communique ce qu'elle doit, mais la direction visuelle n'est pas arrêtée. Interrupteur : `MATCH_PREVIEW_ENABLED`. À considérer aussi : est-ce que ça devrait avoir son propre toggle dans le menu pause, comme Enable Preview.
- [ ] Étendre (ou non) le match preview aux suites, à la règle des 1 et aux spéciaux (Bomb, Clear R/C). Volontairement exclus du premier jet : chacun aurait besoin de son propre langage visuel, un Clear qui va balayer une rangée ne se montre pas comme une chaîne.

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
- [ ] COMPORTEMENT INTENTIONNEL, NE PAS "RÉPARER" : une paire verticale Bomb-en-bas fait exploser la Bomb deux fois, avec deux cibles différentes. La Bomb se pose d'abord et cible la valeur sous elle (tous les 3 de la grille, par exemple); elle entre en dying sans disparaître. Le partenaire du dessus tombe ensuite sur elle et la re-déclenche — scr_die_try_activate_below vérifie seulement que la case en dessous est une Bomb, jamais si elle est déjà en dying ou a déjà explosé — donc elle cible aussi la valeur de ce partenaire (tous les 2). La re-activation remet aussi son timer de dying au maximum. Sim l'a vu en jeu le 2026-08-16 et a décidé de le garder : le joueur doit sortir la paire, la garder verticale, l'orienter Bomb-en-bas et viser la bonne colonne, et il paie le dé du dessus comme simple détonateur. À surveiller au playtest : si poser une Bomb autrement devient irrationnel, l'exploit a mangé le reste du design du dé.
- [ ] NON REPRODUIT : un cas où le highlight du match preview manquait alors qu'il aurait dû s'allumer. Observé le 2026-08-16 — trois 4 posés sur cinq 5 en train de mourir, le 4 de la paire amené au-dessus des trois 4, aucun highlight. Tentative de reproduction avec une séquence de spawn forcée : le cas se comporte correctement, donc quelque chose du plateau réel n'a pas été remarqué. La lecture du code ne montre aucun défaut sur ce scénario (les 4 ne sont pas mourants, donc ils passent les filtres; groupe de 4 pour un seuil de 4). L'instrumentation (log + séquence de spawn forcée) a été retirée. Si ça se revoit, noter l'orientation de la paire et l'état exact de la grille avant de rebrancher un log.
- [ ] Trous dans la colonne droite du HUD quand Show Queue ou Enable Hold/Swap sont désactivés dans le menu pause. scr_ui_hud_layout réserve toujours les 3 emplacements (Unlocks, Next, Hold) et scr_ui_draw saute seulement le dessin — l'espace reste vide au lieu d'être récupéré par les boîtes restantes.