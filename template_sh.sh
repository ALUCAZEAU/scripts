#!/bin/sh
# Auteur : Alexandre LUCAZEAU
# Date : 
# Description : 
# TODO : ajouter trap
# 	
# ==============================================================

# =================================================================
#           FONCTIONS DE BASES
# =================================================================
Usage() {
echo "
\nUsage : ${NOM_SHELL} 
\tDescription
\tDescription

\nExemple : ${NOM_SHELL} nom_param
\n"
exit 1
}

# Fonction Code_Retour
# --------------------
Code_Retour() {
CODE_RETOUR=$1
TYPE_TESTE=$2

if [ ${CODE_RETOUR} -gt 0 ]
then
        echo "Erreur ${CODE_RETOUR} lors de l'exécution : ${TYPE_TESTE} ! "
        exit ${CODE_RETOUR}
else
        echo "\t\t${TYPE_TESTE} .[OK]."
fi
}

# =================================================================
#           VARIABLES
# =================================================================
REP=${HOME}

 
# =================================================================
#           MAIN
# =================================================================

mkdir -p ${REP}
Code_Retour $? "Creation repertoire ${REP}"
