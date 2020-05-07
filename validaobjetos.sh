#!/bin/sh
#
#  Script %name        validaobjetos.sh %
#  %version            1 %
#  Description         Scrip para sacar un informe de archivos asociados a un user
#  %created_by         Diego Villegas (FDM) %
#  %date_created       Thu Dec  8 140451 SAT 2016
# =====================================================================================
# change log
# =====================================================================================
# Mod.ID         Who                       When                         Description
# =====================================================================================
#
# =====================================================================================
HOME=/home/usperfil
INPUTFILE=$HOME/input
USERFILE=$HOME/usuarios
OBJECTFILE=$HOME/objetos
HOSTNAME=`uname -n`
DATE=`date +"%m-%d-%Y"`

echo "usuario;grupo;path">"$OBJECTFILE/objetos_$HOSTNAME_$DATE.csv"
chmod +r $USERFILE/usuarios_$HOSTNAME_$DATE.csv
if [ -f $INPUTFILE/listausuarios.txt ]; then
        for i in `cat $INPUTFILE/listausuarios.txt`
        do
                echo "usuario $i"
                COUNT=`cat /etc/passwd |grep $i | wc -l | tr -d  ' '`
                if [  $COUNT -eq  0 ]
                then
                        echo "Usuario $i no existe">> $OBJECTFILE/objetos_$HOSTNAME_$DATE.csv 2>&1
                elif [ $COUNT -eq  1 ]
                then
                        echo "archivos de usuario $i" >> $OBJECTFILE/objetos_$HOSTNAME_$DATE.csv 2>&1
                        ouser=`cat /etc/passwd | grep $i | awk -F '{ print $6 }'`
                        if [ -d $ouser ]; then
                                        ls -la $ouser | grep -v $i | awk '{print $3,";",$4,";",$NF}'| tr -d ' '>> $OBJECTFILE/objetos_$HOSTNAME_$DATE.csv 2>&1

                        fi
                        find / -ls | grep $i |awk '{print $5,";",$6,";",$NF}'| tr -d ' '>> $OBJECTFILE/objetos_$HOSTNAME_$DATE.csv 2>&1
                fi
        done
fi
