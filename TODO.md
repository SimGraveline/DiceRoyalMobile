# TODO — Dice Royal

## Phase 1 — Fondations
- [x] Room et viewport/caméra portrait mobile
- [x] Constantes du jeu (cell size, grid dimensions, etc.)
- [x] Grille 2D array (source de vérité)
- [x] Rendu de la grille avec draw functions
- [x] Rendu de la dead zone line
- [x] Rendu d'un dé (draw, pas de sprite)

## Phase 2 — Paire et mouvement
- [x] Contrôles clavier (pour tester)
- [x] Spawn d'une paire au centre
- [x] Chute automatique (drop speed ajustable)
- [x] Mouvement gauche/droite
- [x] Rotation CW/CCW avec wall kick

## Phase 3 — Stacking et detach (point d'échec historique #1)
- [x] Spawn rules (1:1 et 2:2 interdits, odds ajustables)
- [x] Détection de collision avec le sol et les dés stackés
- [x] Lock delay (buffer avant detach, reset sur action, levier de difficulté)
- [x] Detach de la paire : lock expire → dé atterri s'écrit → l'autre tombe en solo
- [x] Écriture des dés dans la grille array
- [x] Spawn de la prochaine paire à la position X précédente

## Phase 4 — Matching et chain drop (point d'échec historique #2)
- [x] Détection des chaînes orthogonales (count >= valeur du dé, valeur >= 2)
- [x] État "dying" avec timer per-dé et fade out visuel
- [x] Propagation dying aux voisins de même valeur (cascade)
- [x] Gravité instantanée : dying flottent, non-dying tombent
- [x] Chain resolution en boucle jusqu'au repos
- [x] Cas spécial des 1 (voisin de n'importe quel dying → tous les 1 meurent)
- [x] Mécanique des dés mourants (placer ou être adjacent à un dying de même valeur)
- [x] Solo faller rejoint une chaîne dying si adjacent
- [x] Game over check quand la grille est au repos

## Phase 5 — Features de gameplay
- [x] Soft drop / hard drop
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
- [x] Mobile touch (swipes, tap zones)
- [ ] Gamepad

## Phase 8 — Polish
- [ ] Presentation (pluie de dés, DxR background, transitions fade, zoom dé, juice dying, bling high score)
- [ ] Audio (thème, sons de stack/clear/combo/high score)

## Phase 9 — Metadata
- [ ] Images plateformes (splash screen, icônes — GX.games, HTML5, Windows, macOS, Ubuntu, tvOS, iOS, Android)
- [ ] Évaluer intégrations leaderboard en ligne (Firebase/Firestore)
- [ ] Évaluer intégrations sociales (Facebook, etc.)
