#!/bin/bash

#sae_trashbox_ls.sh----------------------------------------------------

#Vérifier si le script est exécuté dans le dossier spécifié
working_directory=sae_broyeur
if ! pwd | grep $working_directory > /dev/null 2>&1 ; then
  echo "Vous n'êtes pas dans le dossier $working_directory !!";
  exit 1
fi
echo "-----------------------------------------------"

#Définir les noms des dossiers et fichiers utilisés
trashbox_directory=".sh-trashbox"   # Dossier poubelle
id_file="ID"                       # Fichier contenant le prochain ID
index_file="INDEX"                 # Fichier contenant les index

#Vérifier le nombre d'arguments
if [ $# -ne 0 ]; then
    echo "usage: $0"
    exit 1 
fi

#Vérification de l'existence du fichier INDEX_FILE dans le répertoire trashbox_directory
if [ ! -f $trashbox_directory/$index_file ]; then
    #Si le fichier .INDEX n'existe pas, on affiche un message et on quitte le script
    echo "Aucun fichier supprimé"
    exit 1
fi



afficher_arbo() {
    local s_real_full_path=$1 #Chemin du fichier ou répertoire
    local s_full_path=$2
    local indent=$3  # Indentation passée à chaque appel récursif

    # Extraire le nom du fichier ou du répertoire à partir du chemin
    local s_dirname=$(dirname "$s_full_path")
    local s_filename=$(echo "$s_full_path" | sed "s|$s_dirname/||")

    # Vérifier si le chemin est un fichier
    if [ -f "$s_real_full_path" ]; then
        echo "${indent} $s_filename ----(est un fichier) : suprimé le : $date_supp"
        return
    fi

    # Vérifier si le chemin est un dossier
    if [ -d "$s_real_full_path" ]; then
        local s_nb_items=$(ls "$s_real_full_path" | wc -w)  
        # Si le dossier est vide
        if [ "$s_nb_items" -eq 0 ]; then
            echo "${indent} $s_filename ----(est un dossier vide) : suprimé le : $date_supp"
        else
            echo "${indent} $s_filename ----(est un dossier) : suprimé le : $date_supp"
            
            # Parcourir les éléments du dossier
            for element in "$s_real_full_path"/*; do
                if [ -e "$element" ]; then
                    # Appeler récursivement avec une indentation accrue
                    afficher_arbo "$element" "$element" "${indent}  |__  "
                fi
            done
        fi
    else
        echo "${indent} $s_filename ----(chemin non valide ou introuvable)"
    fi
}

#On compte le nombre de lignes (éléments) dans le fichier INDEX_FILE
nb_items=$(cat "$trashbox_directory/$index_file" | wc -l)

#Si le fichier INDEX_FILE contient des éléments
if [ $nb_items -gt 0 ]; then
    #Affichage de l'entête de la liste des fichiers supprimés
    echo "Liste des fichiers supprimés : "   
    echo "------------------------------"
    echo "$trashbox_directory:"
    
    #On parcourt chaque ligne du fichier INDEX_FILE pour afficher les fichiers et dossiers supprimés
    for i in $(seq 1 $nb_items); do
        #Récupérer chaque ligne
        line=$(tail -n $(($nb_items - $i + 1)) "$trashbox_directory/$index_file" | head -n 1)
        #Extrait une ligne spécifique de INDEX pour analyse
        full_path=$(echo $(echo $line | sed -E 's/^[0-9]*:\/|:[^:]*\([^)]*\)$//g') | sed "s|:||")
        #Extraction du répertoire parent
        dirname=$(dirname "$full_path")
        #Extraction du nom de l'élément uniquement (sans le chemin)
        filename=$(echo "$full_path" | sed "s|$dirname/||")
        #Extraction de l'ID de l'élément supprimé
        order=$(echo $line | cut -d ":" -f 1)
        #extraire la date de suppression
        date_supp=$(echo "$line" | sed -E 's/.*\((.*)\).*/\1/')
        #Réconstuire le vrai chemin
        real_full_path=$( echo  $full_path | sed "s|^\./[^/]*|$trashbox_directory/$order|" )

                #Débogage (optionnel, à activer si nécessaire)
                #echo "-----------------------------------------------"
                #echo "La ligne $i: $line"
                #echo "Le chemin complet : $full_path"
                #echo "Le chemin précédent : $dirname"
                #echo "Le fichier : $filename"
                #echo "L'ordre : $order"
                #echo "Le chemin reel complet : $real_full_path"
                #echo "-----------------------------------------------"
        
        afficher_arbo "$real_full_path" "$full_path" "${indent}"
        echo ""
    done
else
    #Si le fichier INDEX_FILE est vide (aucun fichier/dossier supprimé), on affiche un message
    echo "Aucun fichier supprimé"
    echo "-----------------------------------------------"
    exit 1
fi
echo "-----------------------------------------------"
