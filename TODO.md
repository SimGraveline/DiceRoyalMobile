# TODO — Dice Royal

# Fonctionnalités de jeu à intégrer
- [x] Ajouter Brick Dice.
- [x] Ajouter Junk Drop.
- [x] Ajouter "hide preview" dans pause menu.
- [X] Ajouter texte "Beta Version" dans le haut du splash screen.
- [ ] Ajouter une section "Dice" dans le help... un glossaire.

# À améliorer
- [x] Refaire les SVG des dés (le resize déforme le vector).
- [x] Réduire opacité du preview.
- [x] Changer visuel de la bombe (changer celui de brick à place).
- [x] Rendre le junk drop moins prévisible.

# En continue
- Nouvelle passe de balancing.
- Ajout d'effets visuel pour améliorer le juice.
- Ajout d'effets audio pour améliorer le juice.

# Metadata / Publishing / Platform Support
- [ ] Évaluer intégrations leaderboard en ligne (Firebase/Firestore).
- [ ] Évaluer intégrations sociales (Facebook, etc.).
- [ ] Retour de focus.
- [ ] Images plateformes (splash screen, icônes — GX.games, HTML5, Windows, macOS, Ubuntu, tvOS, iOS, Android).

## Questions en suspens
- [ ] **Gravité vs snap** — En ce moment, les dés stackés qui perdent leur support snappent instantanément (scr_grid_gravity), mais la paire active qui perd son support tombe lentement au drop speed (scr_pair_update). Incohérent. Sim préfère la gravité visible (pas le snap) parce que ça donne un meilleur game feel et du temps de réaction au joueur, mais appliquer la gravité partout ouvre des problèmes de complexité (dés en chute pendant que le joueur joue, collisions mid-air, etc.). Pas de solution retenue pour l'instant.
- [x] **Repenser la Bombe** — Faire exploser les 8 cases autour de la bombe, plutôt que tous les dés de la même valeur.
- [X] **Levels** — Réflexion sur affichage du level et / ou passage de niveau basé sur le temps et / ou combinaison temps + points.
- [x] **Version PC** — Prévoir une version PC du jeu pour convention, re-dispositionner interface, ajout QR Code pour mobile. Branche GitHud? Same build + hotkeys? 

## À investiguer (Bug)
- [x] **Fast Rotation** — À vitesse de drop rapide, la rotation permettait de "clip" un dé de la pair dans un dé de la grille. Deux causes trouvées et fixées : (1) `_touching` était calculé avant la rotation dans `scr_pair_update`, donc le drop qui suivait se basait sur une valeur périmée qui ne reflétait pas la nouvelle orientation — recalculé après le mouvement/la rotation. (2) le wall-kick dans `scr_pair_rotate` ne validait que la cellule de l'esclave après le kick, jamais celle du maître — pouvait clipper le maître dans une pile de l'autre côté (mur d'un côté, pile de l'autre).
- [x] **Odds de Specials** — J'ai l'impression qu'ils ne spawn pas aussi souvent qu'il devrait.
- [x] **Combo Score Reset** — J'ai l'impression qu'après un combo, le "multiplier" ne se reset pas, ce qui cause certain niveau de monter quasiment après juste 1 chain.
- [x] Investiguer spawn de pair [1][1] et odds de Brick dans Junk. — Pair [1][1] : règle confirmée saine (le Random dice non-exclu est accepté, laissé tel quel). Odds de Brick dans Junk : bug confirmé et fixé (pool uniforme → pondération alignée sur DICE_BRICK_CHANCE).
- [x] **Junk Drop qui arrêtait de tomber** — Découvert en testant la randomisation de l'intervalle. Le comptage de paires dépendait d'un mécanisme annexe (`junk_track_pending`/`timer`) qui exigeait que la paire descende sous `SPAWN_ROW` ou attende 2s — une paire qui se verrouille immédiatement (pile haute) ne comptait jamais. Retiré ce mécanisme, le comptage se fait maintenant directement dans `scr_pair_spawn()`.
