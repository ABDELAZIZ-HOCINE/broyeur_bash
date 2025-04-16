#!/bin/bash

#sae_delete.sh------------------------------------------------------

#Vérifier si le script est exécuté dans le dossier spécifié
working_directory=sae_broyeur
if ! pwd | grep $working_directory > /dev/null 2>&1 ; then
  echo "Vous n'êtes pas dans le dossier $working_directory !!";
  exit 1
fi

#Donner les permissions d'exécution au script init-trashbox.sh et l'exécuter
chmod u+x init-trashbox.sh
./init-trashbox.sh

#Vérifier si au moins un argument est fourni
if [ $# -lt 1 ]; then
    echo "usage: $0 nom_element"
    exit 1 
fi
echo "-----------------------------------------------"

#Créer une boucle pour traiter les éléments passés en paramètres
for item in "$@"; do
    #Vérifier si le chemin existe
    if [ -e "$item" ]; then
        #Extraire le nom de l'élément sans le chemin du répertoire parent
        FILENAME=$(echo "$item" | sed "s|$(dirname "$item")/||")
        #Déterminer l'adressage complet de l'élément à supprimer
        if [ "$FILENAME" == "$(echo "$item" | sed "s|\./||")" ]; then
            DIRNAME="$(dirname "$item")"
            FULL_PATH="$DIRNAME/$FILENAME"
            FULL_PATH_b="$DIRNAME/:$FILENAME"
        else
            DIRNAME="./$(dirname "$(echo "$item" | sed "s|\./||") ")"
            FULL_PATH="$DIRNAME/$FILENAME"
            FULL_PATH_b="$DIRNAME/:$FILENAME"
        fi

        #Vérifier si l'élément est un dossier ou un fichier
        if [ -d "$FULL_PATH" ]; then
            item_type='d'  
        elif [ -f "$FULL_PATH" ]; then
            item_type='f'
        fi
        
        #Lire le numéro d'ordre actuel depuis .sh-trashbox/ID
        order_number=$(cat ".sh-trashbox/ID" | head -n 1)

        #Déplacer l'élément vers .sh-trashbox sous le nom correspondant à order_number
        mv "$FULL_PATH" ".sh-trashbox/$order_number" 

        #Vérifier si le déplacement a été réussi
        if [ $? -eq 0 ]; then
            #Afficher un message en fonction du type de l'élément
            if [ "$item_type" == 'd' ]; then
                echo "Le dossier \"$FILENAME\" a été supprimé avec succès !"
            elif [ "$item_type" == 'f' ]; then
                echo "Le fichier \"$FILENAME\" a été supprimé avec succès !"
            fi

            #Ajouter une référence de l'élément supprimé dans INDEX
            echo "$order_number:/$FULL_PATH_b:($(date +"%Y/%m/%d/%H:%M:%S"))" >> .sh-trashbox/INDEX
            #Incrémenter le numéro d'ordre pour la prochaine suppression
            echo "$((order_number+1))" > .sh-trashbox/ID

                    #Débogage (optionnel, à activer si nécessaire)
                    #echo "-----------------------------------------------"
                    #Afficher l'adressage précédent et le chemin complet
                    #echo "L'adressage précédent est : $DIRNAME"
                    #echo "Chemin complet : $FULL_PATH"
                    #Afficher le numéro d'ordre
                    #echo "Le numéro d'ordre est : $order_number"
                    #Afficher le prochain numéro d'ordre
                    #echo "Prochain ordre : $(cat .sh-trashbox/ID)"  
                    #echo "-----------------------------------------------"

        fi
        echo "-----------------------------------------------"
    else
        #Afficher un message d'erreur si l'élément n'existe pas
        echo "L'élément \"$item\" n'existe pas"
        echo "-----------------------------------------------"
        #Passer à l'argument suivant si l'élément n'est pas supprimé
        shift
    fi
done