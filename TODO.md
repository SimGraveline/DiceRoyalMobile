# TODO — DICE ROYAL

> **Deux phases séquentielles, pas de travail en parallèle.** Desktop d'abord (GameMaker / Steam),
> mobile ensuite (Unity / mobile stores).
>
> **Les dates sont des cibles de _release candidate_, pas des dates de sortie.** Ce qui se passe
> ensuite (approbation Steam / iOS / Android, roll-out) se décidera une fois le candidat en main.
> Si ça déborde, ça déborde.

---

# PHASE 1 — DICE ROYAL DESKTOP

| | |
|---|---|
| **Moteur** | GameMaker |
| **Plateforme commerciale** | Steam — 4,99 $ |
| **Plateformes version light / démo** | Itch, GameJolt, GX.games — gratuit |
| **Langues** | Anglais + Français |
| **Cible RC** | 13 septembre 2026 |

---

## 1. MENUS

> **Structure arrêtée le 2026-08-20**, à partir du flow Miro et du mock-up de template.
> Elle fait autorité sur la **navigation**, pas sur le layout : les mock-ups détaillés de chaque
> écran restent à faire. Challenge Mode et Rewards font partie du plan complet, mais leur design
> n'est pas fait — si l'un des deux se coupe, les menus s'ajustent en conséquence.

### 1.1 Template de menu
- [ ] Template commun aux écrans de navigation : titre de page en haut à gauche, cadre de
      « selection preview » à gauche, liste des items alignée à droite avec un dé par rang
      (la face du dé = la position dans la liste), sous-titre de l'item sélectionné sous la liste,
      prompt d'input en bas à droite
  - Le cadre de preview sert à toutes les sauces : texte, tableau de scores, animation d'aide,
    schéma de contrôles, etc.
  - Le Main Menu a 7 items — le 7e (Quit) porte un **dé blanc**, hors de la série 1-6
  - Certains écrans auront leur propre layout (Options, Leaderboards, Controls, Customize) —
    à définir au mock-up
- [ ] **Dice rain en arrière-plan de tous les menus** (le même effet que le splash screen)
  - Tourne **en continu** d'un écran à l'autre — ne jamais le réinitialiser sur un changement de
    menu, sinon la pluie saute à chaque navigation
  - Le fond du cadre de preview est **opaque** — la pluie ne passe pas derrière
- [ ] `TBD` **Look du focus et du mouse over** — à déterminer
- [ ] Faire les mock-ups détaillés de chaque écran
- [ ] SFX de navigation (voir section AUDIO) et souris fonctionnelle dans les menus
      (la souris ne sert jamais en jeu)

### 1.2 Séquence de boot
- [ ] Logo GameMaker → Logo Grave Games → **Sélection de langue** → **Message Autosave +
      Photosensibilité** → Splash Screen → Main Menu
  - [ ] Écran Sélection de langue : **au premier boot seulement**, ensuite changeable dans Options
  - [ ] Écran message « this game saves automatically when this appears » + « this game may
        trigger photosensitive » : **à chaque boot**
  - [ ] **Localiser le texte du logo GameMaker** (« proudly made with ») — il passe *avant* la
        sélection de langue, donc il est forcément en anglais au tout premier boot, puis dans la
        langue choisie à partir du boot suivant
    - _Aucune plateforme visée (Steam, App Store, Google Play) ne l'exige — c'est un requirement de
      certification console. Gardé quand même : ça coûte presque rien et ça couvre l'aspect santé._

### 1.3 Arborescence
- [ ] **MAIN MENU** — Select Mode, Rewards, Stats, Achievements, Help, Options, Quit
- [ ] **MODE SELECTION** — Arcade, Challenge, Casual, Back
  - **Arcade** = mode régulier
  - **Casual** = mode facile : courbe de difficulté plus basse, pas de junk, pas de brick
  - **Challenge** = défis à débloquer, design `TBD` (ex. : « clear X dice in Y minutes »)
- [ ] **ARCADE MODE** — Start, Customize, Leaderboards, Options, Back
- [ ] **CASUAL MODE** — Start, Customize, Options, Back _(pas de leaderboard)_
- [ ] **CHALLENGE MODE** — Select Challenge `<##>`, Back
  - Le setup de chaque challenge est imposé par le challenge lui-même (ex. : celui-ci sans ghost,
    celui-là sans Next) — donc pas de sous-menu Options pour ce mode
  - Pas de Start séparé : confirmer un challenge le lance
- [ ] **CUSTOMIZE** — Random Theme On/Off, Select Theme `<##>`, Back _(pas final)_
- [ ] **STATS** — Arcade, Challenge, Casual, Back
- [ ] **REWARDS** — `TBD`, design à faire
- [ ] **LEADERBOARDS** — Your Ranks, Top Players, Back
  - Tableau Steam
  - _Périodes (All Time / Month / Week / Day) coupées — pas de notion de période côté Steam, pas assez important pour le travail que ça demanderait._
- [ ] **ACHIEVEMENTS** — List, Back
  - Liste des achievements Steam avec thumbnail et complétion
- [ ] **HELP** — Rules, Specials, Controls, Back
  - **Specials** = le Dice Index
  - **CONTROLS** — Keyboard, Gamepad, Back
- [ ] **OPTIONS — global** — Language, Music, Sound FX, Rumble, Shake, Credits, Back
  - `TBD` On/Off vs sliders de volume pour Music et SFX
  - `TBD` Remappage clavier / manette — s'il entre, la liste passe à 7 items
  - **CREDITS** — écran unique : mon nom + licences et crédits d'assets
- [ ] **OPTIONS — par mode** (Arcade et Casual séparément) — Dice Preview, Chain Preview,
      Next Preview, Enable Hold, Show Grid, Back
  - [ ] **Chaque mode a ses propres settings, sauvegardés séparément** — le menu pause écrit dans
        le set du mode en cours, pas dans un set global
  - **Theme** : option du visuel des dés et/ou random based on levelling up (via Customize)

### 1.4 Écrans existants à modifier
- [ ] **SPLASH** — mène maintenant au Main Menu au lieu de lancer une partie directement
- [ ] **PAUSE** — retrait du Help, ajout des On/Off : Rumble, Grid Shake, Chain Preview
- [ ] **GAME OVER** — texte qui incite le joueur à rejouer : « You are in the Top 5 today »,
      « You are this close to beating your record », etc.
  - [ ] Sauvegarde automatique au Game Over + icône animée

---

## 2. HUD
- [ ] Boutons de navigation à l'interface dans les menus : A / Enter → Confirm, B / Backspace → Back
- [ ] Adapter le HUD in-game quand Hold et/ou Next sont désactivés
- [ ] Ajouter une CROWN à côté du high score quand le record personnel est battu
- [ ] Changer le visuel des dés / de la grille en montant de niveau (si l'option est active)

---

## 3. AUDIO
- [ ] Remplacer le thème musical : splash screen et main game
- [ ] Remplacer les SFX 8-bits
- [ ] Ajouter les SFX de navigation de menu : change focus, menu confirm, menu back
- [ ] Ajouter le Voice Over pour les chaînes : « Nice », « Superb », « Legendary », etc.
  - Source : banques d'assets, avec crédit au créateur à l'écran Credits
  - VO : text-to-speech ou IA, selon ce qui donne les meilleurs résultats

---

## 4. VFX
- [ ] Jeter un coup d'œil à Pixel Composer pour les effets visuels
- [ ] Ajouter les textes pour les chaînes : « Nice », « Superb », « Legendary », etc.
- [ ] Améliorer le Chain Preview
- [ ] Ajouter Curseur et VFX sur Clic

---

## 5. VISUEL
- [ ] Jeter un coup d'œil à Pixel Composer pour les visuels
- [ ] Refaire les dés spéciaux avec une version miniature pour le HUD (au lieu du scale down)
- [ ] Faire 20 variations de visuel de dés
- [ ] Faire 20 variations de visuel de grille
- [ ] Faire 20 variations de visuel de HUD (color match du thème courant)
- [ ] Refaire le logo Grave Games (proper vector)

---

## 6. GAMEPLAY
- [ ] **Casual Mode** — courbe de difficulté plus basse, pas de Junk Drop, pas de Brick
- [ ] **Challenge Mode** — designer les challenges et le système de déblocage. Chaque challenge
      impose son propre setup (ghost, Next, Hold, etc. forcés on/off)
- [ ] Revoir le levelling up
- [ ] Revoir la courbe de progression de vitesse
- [ ] Revoir l'ordre d'unlock des specials
- [ ] Se donner un outil plus efficace pour gérer les constantes de difficulté et de progression
      (CSV externe ? autre chose ? à évaluer rendu là)

---

## 7. AUTRES
- [ ] Trouver le titre final : Dice Royal Stacked, Dice Stacks!, Royal Stacks!, TBD
  - [ ] Ajuster le nouveau nom partout dans le jeu
- [ ] Localisation anglais + français, avec fichier externe pour gérer les strings
- [ ] Ajouter un Attract Mode après X secondes sur le splash screen
- [ ] Mettre à jour les informations sauvegardées (à ce jour, seul le high score est écrit sur
      disque). À couvrir : les options globales, **un jeu de settings par mode**, les stats par
      mode, la langue choisie, les rewards / unlocks, et le fait que la sélection de langue a
      déjà été faite une fois
- [ ] Mettre le jeu en pause quand la fenêtre perd le focus (alt-tab)
- [ ] Ajouter un léger rumble de manette sur le Chain Preview
- [ ] **Rewards / Unlocks** — design `TBD`. L'accès existe dans le Main Menu (voir section 1)
- [ ] Évaluer les options de résolution d'écran
- [ ] Retirer tous les éléments de debug
- [ ] Adresser la liste d'ISSUE TRACKING
- [ ] Mettre à jour TODO.md, README.md et le GDD (DICEROYAL.md) - quand le projet est fini.
- [ ] Version « strip down » / démo sur Itch, GameJolt et GX.games : pas d'achievements,
      pas de leaderboard, pas de rewards
  - [ ] Flag de build Steam ON/OFF, pour que la version light compile sans le code Steam
  - [ ] Évaluer CrazyGames (et autres portails de jeux)
- [ ] Updater LinkedIn et le portfolio
- [ ] Effacer les repos des vieilles versions sur GitHub
- [ ] Évaluer forme de passe de QA.

---

## 8. STEAM
- [ ] Création du compte développeur
- [ ] Intégration des meta-datas et des autres features Steam
- [ ] Intégration Steam : achievements, leaderboard
- [ ] Produire les assets de la page boutique : capsules (plusieurs formats), screenshots, trailer,
      icônes d'achievements
- [ ] Évaluer la compatibilité Steam Deck (le jeu tourne via Proton ; vérification à demander à
      Valve — Verified / Playable / Unsupported)
- [ ] Demander à Jonathan pour le co-crédit Aftergrinder
- [ ] Upload de la version à accès restreints
- [ ] Faire faire plein de playtests à « friends and family » (informel, rien de structuré)
- [ ] Publier
- `TBD` Stratégie de roll-out — à décider une fois qu'on a un release candidate, selon le budget,
  le temps et les ressources du moment

---

## 9. POST-LAUNCH — TBD
- [ ] Mode multiplayer
- [ ] « More Games » / « Bonus Games » : variation Money Puzzle Exchanger, Bejeweled, etc.

---
---

# PHASE 2 — DICE ROYAL MOBILE

| | |
|---|---|
| **Moteur** | Unity |
| **Plateformes** | App Store, Google Play |
| **Prix** | Gratuit — revenus publicitaires |
| **Cible RC** | 4 octobre 2026 |

> **Port Unity plutôt qu'adaptation de la version GameMaker.** J'ai besoin d'XP en Unity, l'AdSense
> est plus accessible et la publication est plus simple. Pas impossible que je rechange d'idée en
> cours de route, mais c'est le plan pour l'instant.
>
> Je vais suivre des formations Unity en ligne pendant le développement de la version desktop, pour
> être plus à l'aise au moment de faire la version mobile.
>
> **La liste ci-dessous assume que la partie desktop est terminée et contient tout ce qui précède.**
> Liste initiale — va évoluer en fonction du développement desktop.

- [ ] Création d'un nouveau repo GitHub (dissociation de la version desktop)

---

## 10. FEATURES À RETIRER
- [ ] **Hold** — le feature se cut pour la version mobile (ne pas mettre d'option On/Off dans le menu)
- [ ] **Unlock Info** — retirer du HUD

---

## 11. FEATURES À AJOUTER
- [ ] **Ads** — bannière dans le bas de l'écran in-game, écouter une pub après X parties,
      écouter une pub pour « annuler » un game over
- [ ] **MTX** `TBD` — très basse priorité. Le balancing que ça demanderait ne se justifie pas.
      Probablement une seule MTX : payer 5,00 $ pour retirer les pubs (ne pas oublier "restore my purchase".
      À réévaluer en fonction de mes cours de design économique.

---

## 12. FEATURES À MODIFIER
- [ ] Adapter le Zen Mode en fonction du nouveau gameplay mobile
- [ ] Retirer la box NEXT et mettre la next paire « floating above » la grille
- [ ] Adapter le Main Menu
- [ ] Repenser le HUD in-game
- [ ] Repenser le menu Pause
- [ ] Repenser le menu Game Over
- [ ] Adapter le Help Screen
- [ ] Les specials ne sont plus des « drops », ils deviennent des boutons : soit collectés in-game,
      soit proposés avec une pub pour poursuivre après un game over
- [ ] Passer le leaderboard sur Firebase ou quelque chose du genre
- [ ] Ajuster la courbe de difficulté (level + speed) en fonction du support mobile et du nouveau
      gameplay

---

## 13. AUTRES
- [ ] Évaluer le support tablettes
- [ ] Faire faire plein de playtests à « friends and family »
- [ ] Mettre à jour TODO.md, README.md et le GDD (DICEROYAL.md) - quand le projet est fini.
- [ ] Retirer les versions sur Itch, GameJolt, GX.games
- [ ] Updater LinkedIn et le portfolio
- [ ] Effacer les repos des vieilles versions sur GitHub
- [ ] Évaluer forme de passe de QA

---

## 14. APP STORE / GOOGLE PLAY
- [ ] Créer les comptes de développeur
- [ ] Intégration des requirements
- [ ] Publication
- [ ] Plus TBD

---

## 15. POST-LAUNCH — TBD
- [ ] Challenge Mode
- [ ] « More Games » / « Bonus Games » : variation Money Puzzle Exchanger, Bejeweled, etc.

---
---

# ISSUE TRACKING

- [ ] **Recalibrer les seuils de niveaux** (`LEVEL_THRESHOLDS`) et possiblement les vitesses
  (`LEVEL_SPEEDS`). Ils ont été calibrés quand les chaînes profondes ne rapportaient presque rien ;
  depuis que le multiplicateur monte au lieu de descendre et que les suites donnent 6000, la même
  partie rapporte beaucoup plus, donc les niveaux arrivent plus tôt et la vitesse grimpe plus tôt.
  Repère : une seule belle chaîne ou une seule suite suffit maintenant à franchir le seuil du
  niveau 2 (5000). À reprendre dans `DR_DifficultyProgression.xlsx` après quelques parties de feeling.

- [ ] **Le score peut déborder de sa boîte HUD.** Le texte est justifié à gauche dans une boîte de
  largeur fixe (`BOX_WIDTH`), sans aucune gestion d'overflow — un score assez long dépasse vers la
  droite, en direction de la grille. Touche autant Score que High Score. Va se manifester plus tôt
  maintenant que le multiplicateur de chaîne monte au lieu de descendre. Pistes : rapetisser la
  police quand le texte dépasse la largeur utile, formater le nombre (séparateurs de milliers, ou
  notation courte type 1.2M), ou élargir la boîte.

- [ ] **La meilleure chaîne d'une partie n'est pas comptabilisée si c'est la dernière.** Si ta
  meilleure chaîne est celle qui te fait perdre, elle n'entre jamais dans « BEST » : le compteur ne
  se fige qu'au spawn de la paire suivante, qui n'arrive jamais en game over.

- [ ] **Lag / fuite mémoire sur le build HTML5.** Deux causes trouvées et corrigées le 2026-07-17
  (`surface_resize` appelé à chaque frame, layout du HUD recalculé à chaque frame), mais le problème
  n'a été qu'atténué, pas résolu — le lag apparaît plus tard qu'avant. Redevient bloquant dès qu'on
  publie la version light sur Itch / GameJolt / GX.games. Prochaine étape : profiling réel avec les
  DevTools Chrome (Performance / Memory) pendant une session de jeu.

- [ ] **Trous dans la colonne droite du HUD** quand Show Queue ou Enable Hold/Swap sont désactivés
  dans le menu pause. `scr_ui_hud_layout` réserve toujours les 3 emplacements (Unlocks, Next, Hold)
  et `scr_ui_draw` saute seulement le dessin — l'espace reste vide au lieu d'être récupéré par les
  boîtes restantes.

- [ ] **AVANT RELEASE — remettre la musique à ON par défaut.** `scr_save_load` lit `music_muted`
  avec 1 (muté) comme valeur par défaut — volontaire en dev pour ne pas subir la musique à chaque
  test, mais un joueur qui lance le jeu pour la première fois (aucun `.ini` sur sa machine) démarre
  en silence. Le SFX est déjà à 0 (actif), c'est seulement la musique.

- [ ] **AVANT RELEASE — désactiver les raccourcis de debug.** Q ferme le jeu instantanément, R
  relance la partie, F5 efface le high score — les trois sont actifs partout (logos, splash, en jeu),
  sans confirmation, et pollés tout en haut de `scr_game_update`. Pratiques en dev, inacceptables
  dans un build public.

- [ ] **NON REPRODUIT — highlight du match preview manquant.** Observé le 2026-08-16 : trois 4 posés
  sur cinq 5 en train de mourir, le 4 de la paire amené au-dessus des trois 4, aucun highlight.
  Tentative de reproduction avec une séquence de spawn forcée : le cas se comporte correctement, donc
  quelque chose du plateau réel n'a pas été remarqué. La lecture du code ne montre aucun défaut sur
  ce scénario (les 4 ne sont pas mourants, donc ils passent les filtres ; groupe de 4 pour un seuil
  de 4). L'instrumentation (log + séquence de spawn forcée) a été retirée. Si ça se revoit, noter
  l'orientation de la paire et l'état exact de la grille avant de rebrancher un log.

- [ ] **[MOBILE] Déplacement tactile plus smooth** pour la version mobile.

- [ ] **COMPORTEMENT INTENTIONNEL, NE PAS « RÉPARER » — double explosion de la Bomb verticale.**
  Une paire verticale Bomb-en-bas fait exploser la Bomb deux fois, avec deux cibles différentes. La
  Bomb se pose d'abord et cible la valeur sous elle (tous les 3 de la grille, par exemple) ; elle
  entre en dying sans disparaître. Le partenaire du dessus tombe ensuite sur elle et la re-déclenche
  — `scr_die_try_activate_below` vérifie seulement que la case en dessous est une Bomb, jamais si
  elle est déjà en dying ou a déjà explosé — donc elle cible aussi la valeur de ce partenaire (tous
  les 2). La re-activation remet aussi son timer de dying au maximum. Vu en jeu le 2026-08-16 et
  décidé de le garder : le joueur doit sortir la paire, la garder verticale, l'orienter Bomb-en-bas
  et viser la bonne colonne, et il paie le dé du dessus comme simple détonateur. À surveiller au
  playtest : si poser une Bomb autrement devient irrationnel, l'exploit a mangé le reste du design
  du dé.
