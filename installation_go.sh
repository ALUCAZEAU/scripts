#!/bin/sh
# Auteur : Alexandre LUCAZEAU
# Date : 20180925
# Description : Installation de go
# TODO : ajouter trap
# 	
# ==============================================================

# =================================================================
#           FONCTIONS DE BASES
# =================================================================
Usage() {
echo "
\nUsage : ${NOM_SHELL} 
\tinstall, update, remove go install
\t

\nExemple : 
\n	${NOM_SHELL} --remove
\n	${NOM_SHELL} --help
\n	${NOM_SHELL} --install
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
VERSION=1.11
GFIC=https://dl.google.com/go/go${VERSION}.linux-amd64.tar.gz 

# =================================================================
#           FONCTIONS
# =================================================================

# dl() : download go
# -----------------------------------------------------------------
function dl(){
	if [ -f /tmp/go.tar.gz ]; then
		rm /tmp/go.tar.gz
		Code_Retour $? "F1.1 : delete old /tmp/go.tar.gz"
	fi
	wget ${GFIC} -O /tmp/go.tar.gz
	Code_Retour $? "F1.2 : download go"
}

# install() : extract tar file and delete
function install(){
	ORI=$(pwd)
	if [ -d ${REP}/.go/${VERSION} ]; then
		rm -rf ${REP}/.go/${VERSION}
		Code_Retour $? "F2.1 : delete ${REP}/.go/${VERSION}"
	fi
	mkdir ${REP}/.go/${VERSION}
	Code_Retour $? "F2.2 : Create ${VERSION} dir"
	cd ${REP}/.go/
	tar xzf /tmp/go.tar.gz -C ${VERSION} --strip-components 1 
	Code_Retour $? "F2.3 : extract tar file to ${REP}/.go/${VERSION}"
	rm /tmp/go.tar.gz
	Code_Retour $? "F2.4 : delete tar file"
	cd ${ORI}
}

# defenv() : create env file and add source to bashrc
# -----------------------------------------------------------------
function defenv(){
	touch ${REP}/.go/envgo
	{
		echo 'export GOROOT=$HOME/.go/'${VERSION}
		echo 'export PATH=$PATH:$GOROOT/bin'
		echo 'export GOPATH=$HOME/go'
		echo 'export PATH=$PATH:$GOPATH/bin'
	} >> "${REP}/.go/envgo"
	grep -q envgo ${HOME}/.bashrc
	if [ $? -eq 1 ]; then
		echo "[[ -f ${HOME}/.go/envgo ]] && source ${HOME}/.go/envgo" >> ${HOME}/.bashrc
		Code_Retour $? "F3.1 : Add envgo to bashrc"
	fi
}

# remove() : delete golang
# -----------------------------------------------------------------
function remove() {
	rm -rf ${REP}/.go/
	Code_Retour $? "F4.1 : delete ${REP}/.go/"
	sed -i '/envgo/d' ${HOME}/.bashrc
	Code_Retour $? "F4.2 : delete source envgo to bashrc"
	exit 0
}

# =================================================================
#           MAIN
# =================================================================

if [ "$1" == "--remove" ]; then
	remove
elif [ "$1" == "--help" ]; then
	Usage
fi

mkdir -p ${REP}/.go/
Code_Retour $? "E1 : Creation repertoire contenant go : ${REP}/.go"
mkdir -p ${REP}/git/go/{src,pkg,bin}
Code_Retour $? "E2 : Creation repertoire contenant nos developpement en go : ${REP}/git/go/{src/pkg/bin}"

dl
install
defenv
echo "Fin"
