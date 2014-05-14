#!/bin/bash
. /etc/profile.d/modules.sh

##
## Functions
##

useVer() {
    echo -e "* Using $1 version $2."
}

ansYN() {
    echo -e "Please answer yes or no."
    }

##
## Banner
##

echo -e "-----------------------------"
echo -e "TIGRESS Setup for R-based HPC"
echo -e "-----------------------------"
echo -e ""

##
## Set Vars 1
##

LOCATION=$(hostname)
RMPIVERS=0.6-3


while true; do
    read -p "\
@ Do you want to set up your account to use an updated compiler version?
    Note 1: may be necessary for some R packages
    Note 2: only needs to be done once per system
    Note 3: may have no effect on certain machines
[y/n]" yn
    case $yn in
        [Yy]* )
            if [ "${LOCATION}" == "tukey" ]
            then 
                echo "tukey"
                break
            fi
            echo -e "module load rh\n" >> ~/.bashrc; ## for new gcc suite
            source ~/.bashrc
            break
            ;;

        [Nn]* ) 
            break
            ;;
        * ) 
            ansYN 
            ;;
    esac
done

##
## Set Vars 2
##

GCCVERS=$(gcc --version | grep ^gcc | sed 's/^.* //g' | sed 's/)//g')

##
## Detect Location
##

case ${LOCATION} in
    della4)
        export OMPIVERS=1.6.5
        ;;
    della3)
        export OMPIVERS=1.4.5
        ;;
    tukey)
        export OMPIVERS=1.6.3
        ;;
    adroit.Princeton.EDU)
        export OMPIVERS=1.3.0
        ;;
    *)
        export OMPIVERS=1.4.5
        ;;
esac

##
## Disclose Version
##

echo ""
useVer OpenMPI ${OMPIVERS}
useVer Rmpi ${RMPIVERS}
useVer GCC ${GCCVERS}
echo ""



##
## Rmpi DL
##
while true; do
    read -p "\
@ Do you need to DL Rmpi?
[y/n]" yn
    case $yn in
        [Yy]* )
            wget http://www.stats.uwo.ca/faculty/yu/Rmpi/download/linux/Rmpi_${RMPIVERS}.tar.gz -O rmpi.tar.gz;
            break;;

        [Nn]* ) break;;
        * ) ansYN ;;
    esac
done
echo ""



##
## OpenMPI Libs
## 

while true; do
    read -p "\
@ Do you need to add OpenMPI support?
    Note: needs to only be added once
[y/n]" yn
    case $yn in
        [Yy]* )
            echo -e "module load openmpi/gcc/${OMPIVERS}/64\n" >> ~/.bashrc ;
            source ~/.bashrc
            break;;

        [Nn]* )
            break;;
        * ) ansYN ;;
    esac
done
echo ""

##
## Rmpi Install
##

while true; do
    read -p "\
@ Do you need to install Rmpi?
[y/n]" yn
    case $yn in
        [Yy]* )
            module load openmpi/gcc/${OMPIVERS}/64
            R CMD INSTALL --configure-args="--with-Rmpi-include=/usr/local/openmpi/${OMPIVERS}/gcc/x86_64/include
                --with-Rmpi-libpath=/usr/local/openmpi/${OMPIVERS}/gcc/x86_64/lib64
                --with-Rmpi-type=OPENMPI" \
                    rmpi.tar.gz

            break;;

        [Nn]* )
            break;;
        * ) ansYN ;;
    esac
done
echo ""


##
## Misc Package Install
##

while true; do
    read -p "\
@ Do you need to install misc. HPC R packages?
[y/n]" yn
    case $yn in
        [Yy]* )            
            Rscript install_misc.R;
            break;;
        [Nn]* )
            break;;
        * ) ansYN ;;
    esac
done
echo ""
