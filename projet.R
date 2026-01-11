install.packages(c("readr","dplyr","janitor","tidyr"), dependencies = TRUE)
library(readr)
library(dplyr)
library(janitor)
library(tidyr)

# ==================================
# MISE EN FORME DES BASES DE DONNEES 
# ===================================

kart <- read_delim(
  "projet analyse de données - kart.csv",
  delim = ",",
  locale = locale(decimal_mark = ","),   #indique que les décimales sont avec des virgules 
  show_col_types = FALSE,
  trim_ws = TRUE
) %>% clean_names()

roue <- read_delim(
  "projet analyse de données - roue.csv",
  delim = ",",
  locale = locale(decimal_mark = ","),
  show_col_types = FALSE,
  trim_ws = TRUE
) %>% clean_names()

planeur <- read_delim(
  "projet analyse de données - planeur.csv",
  delim = ",",
  locale = locale(decimal_mark = ","),
  show_col_types = FALSE,
  trim_ws = TRUE
) %>% clean_names()


kart    <- kart    %>% rename(nom_kart = nom_du_kart)
roue    <- roue    %>% rename(nom_roue = roue)
planeur <- planeur %>% rename(nom_planeur = planeur)


summary(kart)
summary(roue)
summary(planeur)

personnages <- read_delim(
  "base personnages mario - Feuille 1.csv",
  delim = ",",
  locale = locale(decimal_mark = ","),
  show_col_types = FALSE
) %>%
  clean_names() %>%                         # "taille", "personnage", "vitesse_sol", etc.
  mutate(taille = na_if(taille, "")) %>%   
  fill(taille, .direction = "down") %>%     # propage Petit/Moyen/Grand...
  rename(
    vitesse_sol = vitesse_sol,
    vitesse_eau = vitesse_eau,
    vitesse_air = vitesse_air,
    vitesse_antigravite = vitesse_anti_gravite,
    acceleration = acceleration,
    poids = poids,
    # tes colonnes s'appellent "maniabilite_(sol/eau/air/anti_gravite)" dans cette base,
    # mais dans tes autres bases tu utilises "manutention_(...)"
    manutention_sol = maniabilite_sol,
    manutention_eau = maniabilite_eau,
    manutention_air = maniabilite_air,
    manutention_antigravite = maniabilite_anti_gravite,
    mini_turbo = mini_turbo,
    traction = traction
  ) %>%
  mutate(
    vitesse = rowMeans(across(c(vitesse_sol, vitesse_eau, vitesse_air, vitesse_antigravite)), na.rm = TRUE),
    maniabilite = rowMeans(across(c(manutention_sol, manutention_eau, manutention_air, manutention_antigravite)), na.rm = TRUE)
  ) %>%
  select(
    personnage, taille,
    vitesse, vitesse_sol, vitesse_eau, vitesse_air, vitesse_antigravite,
    acceleration, poids,
    maniabilite, manutention_sol, manutention_eau, manutention_air, manutention_antigravite,
    traction, mini_turbo
  )

summary(personnages)

# ===========================
# MISE EN FORME DES CIRCUITS
# ===========================

# 1) Circuits à EAU
circuits_eau <- c(
  "Water Park",
  "Cheep Cheep Beach",
  "Dolphin Shoals",
  "Sherbet Land",
  "Piranha Plant Slide",
  "Yoshi Valley (sections)",
  "Ice Ice Outpost"
)

# 2) Circuits à VOL
circuits_vol <- c(
  "Sunshine Airport",
  "Cloudtop Cruise",
  "Shy Guy Falls",
  "Wario Stadium",
  "DK Jungle",
  "Big Blue",
  "Hyrule Circuit"
)

# 3) Circuits à GRANDE VITESSE
circuits_vitesse <- c(
  "Mario Kart Stadium",
  "Mario Circuit",
  "Toad’s Turnpike",
  "Mount Wario",
  "Mute City",
  "Bowser’s Castle",
  "Rainbow Road (MK8)"
)


# 4) Circuits TECHNIQUES
circuits_tech <- c(
  "Thwomp Ruins",
  "Twisted Mansion",
  "Royal Raceway",
  "Yoshi Circuit",
  "Neo Bowser City",
  "Ribbon Road",
  "Dragon Driftway",
  "Music Park",
  "Super Bell Subway"
)


circuits_tbl <- bind_rows(
  tibble(circuit = circuits_eau, categorie = "EAU"),
  tibble(circuit = circuits_vol, categorie = "VOL"),
  tibble(circuit = circuits_vitesse, categorie = "VITESSE"),
  tibble(circuit = circuits_tech, categorie = "TECHNIQUE")
) %>%
  group_by(circuit) %>%
  summarise(categories = paste(sort(unique(categorie)), collapse = " + "), .groups = "drop")


# ============================================================
# PARAMETRAGE DES VARIABLES DE PERFORMANCE ET DES PONDERATIONS 
# ============================================================

stats_cols <- c(
  "vitesse","vitesse_sol","vitesse_eau","vitesse_air","vitesse_antigravite",
  "acceleration","poids","maniabilite",
  "manutention_sol","manutention_eau","manutention_air","manutention_antigravite",
  "mini_turbo"
)


poids_categorie <- function(categorie) {
  categorie <- toupper(categorie)
  
  if (categorie == "EAU")       return(c(sol=0.40, eau=0.45, air=0.05, anti=0.10))
  if (categorie == "VOL")       return(c(sol=0.35, eau=0.10, air=0.40, anti=0.15))
  if (categorie == "VITESSE")   return(c(sol=0.45, eau=0.05, air=0.10, anti=0.40))
  if (categorie == "TECHNIQUE") return(c(sol=0.45, eau=0.05, air=0.10, anti=0.40))
  
  # si la catégorie n'est pas reconnue : profil moyen
  c(sol=0.50, eau=0.10, air=0.10, anti=0.30)
}

# ==================
# QUESTIONNAIRE
# ==================

questionnaire <- function(top_n = 10) {
  
  cat("\n=== QUESTIONNAIRE MK8D ===\n")
  cat("Réponds dans la CONSOLE puis appuie sur Entrée.\n\n")
  
  # Préparation (listes propres)
  personnages2 <- personnages %>%
    mutate(personnage_clean = trimws(tolower(personnage)))
  
  circuits2 <- circuits_tbl %>%
    mutate(circuit_clean = trimws(tolower(circuit)))
  
  # ==========================
  # CHOIX PERSONNAGE 
  # ==========================
  cat("Voici tous les personnages du jeu, choisi en un :\n")
  print(head(sort(unique(personnages$personnage)), 53))
  cat("\n")
  
  p <- NULL
  repeat {
    perso_choisi <- readline("Personnage (nom exact) : ")
    perso_clean <- trimws(tolower(perso_choisi))
    
    p <- personnages2 %>% filter(personnage_clean == perso_clean)
    
    if (nrow(p) > 0) {
      p <- p %>% select(-personnage_clean)
      break
    } else {
      cat("\n personnage introuvable.\n")
      cat(" Copie-colle le nom exact depuis la liste (respecte espaces / accents / apostrophes).\n\n")
      cat("Exemples :\n")
      print(head(sort(unique(personnages$personnage)), 53))
      cat("\n")
    }
  }
  
  # ==========================
  # CHOIX CIRCUIT 
  # ==========================
  
  cat("Voici tous les circuits possibles du jeu, choisis en un :\n")
  print(head(sort(unique(circuits_tbl$circuit)), 30))
  cat("\n")
  
  categorie <- NULL
  repeat {
    circuit_choisi <- readline("Circuit (nom exact) : ")
    circuit_clean_input <- trimws(tolower(circuit_choisi))
    
    tmp <- circuits2 %>%
      filter(circuit_clean == circuit_clean_input) %>%
      pull(categories)
    
    if (length(tmp) > 0) {
  categorie <- tmp[1]          # on prend la première catégorie
  w <- poids_categorie(categorie)
  break
} else {
  cat("\n circuit introuvable.\n")
  cat(" copie-colle le nom EXACT depuis la liste.\n\n")
  print(head(sort(unique(circuits_tbl$circuit)), 30))
  cat("\n")
}
  # ==========================
  # PRÉFÉRENCES 
  # ==========================
  cat("\nPréférences (0 à 10)\n")
  
  ask_pref <- function(label) {
    repeat {
      x <- readline(paste0(label, " : "))
      x <- suppressWarnings(as.numeric(x))
      
      if (!is.na(x) && x >= 0 && x <= 10) {
        return(x)
      } else {
        cat(" valeur invalide.\n")
        cat(" Entre un nombre compris entre 0 et 10.\n\n")
      }
    }
  }
  
  p_vitesse <- ask_pref("Vitesse")
  p_drift   <- ask_pref("Mini-turbo / drift")
  p_mania   <- ask_pref("Maniabilité")
  p_accel   <- ask_pref("Accélération")
  p_poids   <- ask_pref("Poids")
  
  prefs <- c(
    vitesse = p_vitesse,
    mini_turbo = p_drift,
    maniabilite = p_mania,
    acceleration = p_accel,
    poids = p_poids
  )
  
  if (sum(prefs) == 0) prefs <- prefs + 1
  prefs <- prefs / sum(prefs)
  
  # ==========================
  # COMBOS ET SCORE 
  # ==========================
  # On génère toutes les combinaisons possibles kart × roue × planeur et on renomme les colonnes de stats pour éviter les doublons.
  combos <- crossing(
    kart %>%
      select(nom_kart, all_of(stats_cols)) %>%
      rename_with(~ paste0(.x, "_kart"), all_of(stats_cols)),
    
    roue %>%
      select(nom_roue, all_of(stats_cols)) %>%
      rename_with(~ paste0(.x, "_roue"), all_of(stats_cols)),
    
    planeur %>%
      select(nom_planeur, all_of(stats_cols)) %>%
      rename_with(~ paste0(.x, "_planeur"), all_of(stats_cols))
  )
  
  full <- combos     # On crée un tableau qui contiendra les stats finales.
  #Pour chaque statistique (vitesse, poids, maniabilité, etc.), on additionne : kart + roue + planeur + personnage.
  for (col in stats_cols) {
    full[[col]] <-
      full[[paste0(col, "_kart")]] +
      full[[paste0(col, "_roue")]] +
      full[[paste0(col, "_planeur")]] +
      p[[col]]
  }
  
  full <- full %>%
    select(nom_kart, nom_roue, nom_planeur, all_of(stats_cols))    #On garde uniquement les colonnes utiles pour la suite.
  # On calcule la vitesse contextuelle (pondérée selon sol, eau, air, antigravité).
  v_ctx <- full$vitesse_sol*w["sol"] + full$vitesse_eau*w["eau"] + full$vitesse_air*w["air"] + full$vitesse_antigravite*w["anti"]
  #On calcule la maniabilité contextuelle.
  m_ctx <- full$manutention_sol*w["sol"] + full$manutention_eau*w["eau"] + full$manutention_air*w["air"] + full$manutention_antigravite*w["anti"]

  #Chaque critère est pondéré par la préférence normalisée du joueur.   
  score <- 0
  score <- score + prefs["vitesse"]      * v_ctx
  score <- score + prefs["mini_turbo"]   * full$mini_turbo
  score <- score + prefs["maniabilite"]  * m_ctx
  score <- score + prefs["acceleration"] * full$acceleration
  score <- score + prefs["poids"]        * full$poids
 
  # On ajoute le score au tableau et on classe par ordre décroissant

  resultats <- full %>% mutate(score = score) %>% arrange(desc(score))
  
  cat("\n=== MEILLEUR COMBO ===\n")
  print(resultats %>% slice(1) %>% select(nom_kart, nom_roue, nom_planeur, score))
  
  cat("\n=== TOP ", top_n, " ===\n", sep="")
  print(resultats %>% slice_head(n = top_n) %>% select(nom_kart, nom_roue, nom_planeur, score))
  
  invisible(resultats)
    }
  }
}
# ==========================
# LANCER LE QUESTIONNAIRE
# ==========================

questionnaire(10)


