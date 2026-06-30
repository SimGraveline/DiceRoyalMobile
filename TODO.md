# TODO — Dice Royal

## Phase 1 — Fondations
- [x] Room et viewport/caméra portrait mobile
- [x] Constantes du jeu (cell size, grid dimensions, etc.)
- [x] Grille 2D array (source de vérité)
- [x] Rendu de la grille avec draw functions
- [x] Rendu de la dead zone line
- [x] Rendu d'un dé (sprite spr_dice avec subimages par valeur)

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
- [x] Next pair (queue + affichage)
- [x] Hold / swap (spawn hérite position et orientation de la paire active)
- [x] Ghost preview (trainée + preview, toggle on/off)
- [x] Score et combos (stack points + élimination × valeur × combo)
- [x] Level et augmentation de vitesse (11 niveaux, seuils progressifs)
- [x] High score (sauvegarde persistante, score jaune quand battu)

## Phase 6 — Écrans et UI
- [x] Layout de l'écran de jeu (titre, score, level, boxes, boutons, pause basic)
- [x] Splash screen (dice rain, "Tap to Stack!" clignotant)
- [x] Thème vocal (snd_theme) sur le splash screen (fade out au début du fade visuel)
- [x] Pause screen (resume, restart, quit, mute music toggle, navigation clavier/gamepad/touch)
- [x] Help screen (HOW TO PLAY, règles, contrôles mobile, toggle ?)
- [x] Game over screen (score, high score, NEW BEST pulse, restart/quit menu)
- [x] Logo screens (GameMaker + Grave Games, timings ajustables)
- [x] Countdown 3-2-1-STACK (scale animation, au lancement)
- [x] Transition fade (dé zoom in/out entre splash et game)
- [ ] Retour de focus

## Phase 7 — Contrôles additionnels
- [x] Mobile touch (swipes, tap zones)
- [x] Gamepad

## Phase 8 — Polish
- [x] DxR background animé (scroll diagonal, changement de direction, shake per-logo)
- [x] Sprites pour les dés (spr_dice) et ghost preview (spr_dice_ghost)
- [x] UI polish (text shadows, rounded corners grid/boxes, couleurs custom, fonts multiples)
- [x] Thème instrumental en loop (mute par défaut, toggle M)
- [x] Dice rain (splash screen background)
- [x] Transition fade (dé zoom in/out)
- [ ] Presentation restante (juice dying, bling high score)
- [x] Mute SFX (toggle dans pause menu, wrapper scr_audio_play_sfx)
- [x] Audio SFX partiels (snd_dice_stack, snd_chain_dying, snd_highscore)
- [ ] Audio SFX restants (combo, autres)
- [x] Fix de la taille de la zone du hold (20%)
- [x] Ajout de dés de face 7-8-9
- [x] Améliorer la courbe de progression
- [x] Suite 1→N ou N→1 horizontale/verticale (scores 6000/7000/8000/10000)
- [x] Dés spéciaux : Mimic (lvl 4, 1/15), Bomb (lvl 3, 1/15), Random (lvl 2, 1/15)
- [x] Son snd_level au level up
- [x] Fix paire qui descend avant le countdown (gate fade_active dans scr_game_update)
- [X] Tweak du ghost à la verticale
- [ ] Level up VFX (agrandir texte LEVEL+# de 40%, rouge, shadow blanc, pendant 1s) — implémenté mais visuellement incorrect, à revoir
- [ ] Repenser la Bombe... 8 cases autour explose plutôt que tous les dés de la même valeur.

## Phase 9 — Metadata
- [ ] Images plateformes (splash screen, icônes — GX.games, HTML5, Windows, macOS, Ubuntu, tvOS, iOS, Android)
- [ ] Évaluer intégrations leaderboard en ligne (Firebase/Firestore)
- [ ] Évaluer intégrations sociales (Facebook, etc.)

## Questions en suspens
- **Gravité vs snap** — En ce moment, les dés stackés qui perdent leur support snappent instantanément (scr_grid_gravity), mais la paire active qui perd son support tombe lentement au drop speed (scr_pair_update). Incohérent. Sim préfère la gravité visible (pas le snap) parce que ça donne un meilleur game feel et du temps de réaction au joueur, mais appliquer la gravité partout ouvre des problèmes de complexité (dés en chute pendant que le joueur joue, collisions mid-air, etc.). Pas de solution retenue pour l'instant.
