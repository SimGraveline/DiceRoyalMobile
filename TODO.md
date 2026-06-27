# TODO — Dice Royal

## Phase 1 — Fondations
- [x] Room et viewport/caméra portrait mobile
- [x] Constantes du jeu (cell size, grid dimensions, etc.)
- [x] Grille 2D array (source de vérité)
- [x] Rendu de la grille avec draw functions
- [x] Rendu de la dead zone line
- [x] Rendu d'un dé (draw, pas de sprite)

## Phase 2 — Paire et mouvement
- [ ] Spawn d'une paire au centre
- [ ] Mouvement gauche/droite
- [ ] Rotation CW/CCW avec wall kick
- [ ] Chute automatique (drop speed ajustable)
- [ ] Contrôles clavier (pour tester)

## Phase 3 — Stacking et detach (point d'échec historique #1)
- [ ] Spawn rules (1:1 et 2:2 interdits, odds ajustables)
- [ ] Détection de collision avec le sol et les dés stackés
- [ ] Detach de la paire : un dé touche → paire se sépare → l'autre dé continue de tomber
- [ ] Écriture des dés dans la grille array
- [ ] Spawn de la prochaine paire à la position X précédente

## Phase 4 — Matching et chain drop (point d'échec historique #2)
- [ ] Détection des chaînes orthogonales (2×2, 3×3, etc.)
- [ ] État "dying" sur les dés éliminés
- [ ] Gravité : les dés au-dessus des morts tombent
- [ ] Chain resolution en boucle jusqu'au repos
- [ ] Cas spécial des 1
- [ ] Mécanique des dés mourants (placer un dé de même valeur orthogonalement à un dying)
- [ ] Game over check quand la grille est au repos

## Phase 5 — Features de gameplay
- [ ] Soft drop / hard drop
- [ ] Next pair (queue + affichage)
- [ ] Hold / swap (spawn hérite position et orientation de la paire active)
- [ ] Ghost preview
- [ ] Score et combos
- [ ] Level et augmentation de vitesse
- [ ] High score (sauvegarde persistante)

## Phase 6 — Écrans et UI
- [ ] Layout de l'écran de jeu (titre, score, level, boxes, boutons)
- [ ] Splash screen
- [ ] Pause screen (resume, restart, quit, ghost/hold toggles, scores)
- [ ] Help screen (contrôles mobile, checkbox "don't show again" + persistance locale)
- [ ] Game over screen (score, high score, mention record battu, replay, quit)
- [ ] Logo screens
- [ ] Countdown 3-2-1-STACK
- [ ] Transitions et retour de focus

## Phase 7 — Contrôles additionnels
- [ ] Mobile touch (swipes, tap zones)
- [ ] Gamepad

## Phase 8 — Polish
- [ ] Presentation (pluie de dés, DxR background, transitions fade, zoom dé, juice dying, bling high score)
- [ ] Audio (thème, sons de stack/clear/combo/high score)

## Phase 9 — Metadata
- [ ] Images plateformes (splash screen, icônes — GX.games, HTML5, Windows, macOS, Ubuntu, tvOS, iOS, Android)
- [ ] Évaluer intégrations sociales (Facebook, etc.)
