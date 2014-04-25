#!/bin/bash
. /etc/profile.d/modules.sh

LOCATION=$(hostname)
RMPIVER=0.6-3

case ${LOCATION} in
    della4)
        export OMPIVERS=1.6.5
        echo "Using openmpi version ${OMPIVERS}."
        ;;
    della3)
        export OMPIVERS=1.4.5
        echo "Using openmpi version ${OMPIVERS}."
        ;;
    *)
        export OMPIVERS=1.4.5
        echo "Using openmpi version ${OMPIVERS}."
        ;;
esac


while true; do
    read -p "Do you need to DL Rmpi? [y/n]" yn
    case $yn in
        [Yy]* )
            wget http://www.stats.uwo.ca/faculty/yu/Rmpi/download/linux/Rmpi_${RMPIVER}.tar.gz -O rmpi.tar.gz;
            break;;

        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

module load openmpi/gcc/${OMPIVERS}/64

while true; do
    read -p "Do you need to add openmpi libs to the linker path? [y/n]" yn
    case $yn in
        [Yy]* )
            echo -e "LD_LIBRARY_PATH=/usr/local/openmpi/${OMPIVERS}/gcc/x86_64/lib64\n" >> ~/.bashrc;
            echo -e "export LD_LIBRARY_PATH\n" >> ~/.bashrc;
            break;;

        [Nn]* )
            break;;
        * ) echo "Please answer yes or no.";;
    esac
done

ulimit -l unlimited

while true; do
    read -p "Do you need to install Rmpi? [y/n]" yn
    case $yn in
        [Yy]* )
            R CMD INSTALL --configure-args="--with-Rmpi-include=/usr/local/openmpi/${OMPIVERS}/gcc/x86_64/include
                --with-Rmpi-libpath=/usr/local/openmpi/${OMPIVERS}/gcc/x86_64/lib64
                --with-Rmpi-type=OPENMPI" \
                    rmpi.tar.gz
            break;;

        [Nn]* )
            break;;
        * ) echo "Please answer yes or no.";;
    esac
done



source ~/.bashrc


while true; do
    read -p "Do you need to misc. HPC packages? [y/n]" yn
    case $yn in
        [Yy]* )
            Rscript install_misc.R;
            break;;

        [Nn]* )
            break;;
        * ) echo "Please answer yes or no.";;
    esac
done
