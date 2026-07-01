# TODO — Dice Royal

# Fonctionnalités de jeu à intégrer
- [x] Ajouter Brick Dice
- [x] Ajouter Junk Drop

# À améliorer
- [x] Refaire les SVG des dés (le resize déforme le vector)

# En continue
- [ ] Nouvelle passe de balancing
- [ ] Ajout d'effets visuel pour améliorer le juice
- [ ] Ajout d'effets audio pour améliorer le juice

# Metadata / Publishing / Platform Support
- [ ] Évaluer intégrations leaderboard en ligne (Firebase/Firestore)
- [ ] Évaluer intégrations sociales (Facebook, etc.)
- [ ] Retour de focus
- [ ] Images plateformes (splash screen, icônes — GX.games, HTML5, Windows, macOS, Ubuntu, tvOS, iOS, Android)

## Questions en suspens
- [ ] **Gravité vs snap** — En ce moment, les dés stackés qui perdent leur support snappent instantanément (scr_grid_gravity), mais la paire active qui perd son support tombe lentement au drop speed (scr_pair_update). Incohérent. Sim préfère la gravité visible (pas le snap) parce que ça donne un meilleur game feel et du temps de réaction au joueur, mais appliquer la gravité partout ouvre des problèmes de complexité (dés en chute pendant que le joueur joue, collisions mid-air, etc.). Pas de solution retenue pour l'instant.
- [x] **Repenser la Bombe** — Faire exploser les 8 cases autour de la bombe, plutôt que tous les dés de la même valeur.

## À investiguer (Bug)
- [ ] **Fast Rotation** A vitesse de drop rapide, il semble que la rotation permettre de "clip" un dé de la pair dans un dé de la grille.
- [ ] **Odds de Specials** — J'ai l'impression qu'ils ne spawn pas aussi souvent qu'il devrait.
- [x] **Combo Score Reset** — J'ai l'impression qu'après un combo, le "multiplier" ne se reset pas, ce qui cause certain niveau de monter quasiment après juste 1 chain.
