#!/bin/bash

#init-trashbox.sh--------------------------------------------------------

#Vérifier si le script est exécuté dans le dossier spécifié
working_directory=sae_broyeur
if ! pwd | grep $working_directory > /dev/null 2>&1 ; then
  echo "Vous n'êtes pas dans le dossier $working_directory !!";
  exit 1
fi

#Définir les noms des dossiers et fichiers utilisés
trashbox_directory=".sh-trashbox"   # Dossier poubelle
id_file="ID"                       # Fichier contenant le prochain ID
index_file="INDEX"                 # Fichier contenant les index

#Vérifier si le dossier .sh-trashbox existe, sinon le créer
if [ ! -d "$trashbox_directory" ]; then
    mkdir "$trashbox_directory"
    echo "Le dossier $trashbox_directory a été créé avec succès."

    #Initialiser l'ID à 1
    initial_id=1
    #Créer le fichier ID et y écrire l'ID initial
    echo "$initial_id" > "$trashbox_directory/$id_file"
    #Créer un fichier INDEX vide
    touch "$trashbox_directory/$index_file"
    echo "Les fichiers nécessaires ont été créés."
fi
