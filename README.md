
Guide d'utilisation des scripts:

---------------------------------------------------------------------------------------------------------
1. Initialisation des scripts
    Pour initialiser les scripts, donnez-leur les droits d'exécution et supprimez les fichiers inutiles :

        cmd:
            %chmod u+x init-trashbox.sh
            %chmod u+x sae_delete.sh
            %chmod u+x sae_restore.sh
            %chmod u+x sae_trashbox_ls.sh

---------------------------------------------------------------------------------------------------------
2. Suppression d'un fichier/dossier
    Pour supprimer un fichier ou un dossier, utilisez :
    bash:
        ./sae_delete.sh chemin_du_fichier [chemin_du_fichier_2 ...]

        Les fichiers/dossiers seront déplacés dans .sh-trashbox.
        Le fichier INDEX garde une trace des suppressions.

---------------------------------------------------------------------------------------------------------
3. Restauration d'un fichier/dossier
    Utilisez sae_restore.sh pour restaurer un élément depuis .sh-trashbox :

    Restaurer à l'emplacement d'origine :
        bash:
            ./sae_restore.sh -r nom_element

    Restaurer dans un dossier spécifique :
        bash:
            ./sae_restore.sh -d nom_dossier nom_element

    Restaurer dans le dossier courant :
        bash:
            ./sae_restore.sh nom_element

---------------------------------------------------------------------------------------------------------
4. Liste des éléments supprimés
    Pour afficher le contenu de la corbeille, utilisez :
        bash:
        ./sae_trashbox_ls.sh

---------------------------------------------------------------------------------------------------------
Note : Les scripts doivent être exécutés dans le dossier sae_broyeur (le dossier contenant .sh-trashbox).
