while true; do
    read -p "Do you need to DL Rmpi? [y/n]" yn
    case $yn in
        [Yy]* ) 
            wget http://www.stats.uwo.ca/faculty/yu/Rmpi/download/linux/Rmpi_0.6-3.tar.gz -O rmpi.tar.gz; 
            break;;

        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

module load openmpi/gcc/1.4.5/64

while true; do
    read -p "Do you need to add openmpi libs to the linker path? [y/n]" yn
    case $yn in
        [Yy]* )
            echo -e "LD_LIBRARY_PATH=/usr/local/openmpi/1.4.5/gcc/x86_64/lib64\n" >> ~/.bashrc;
            echo -e "export LD_LIBRARY_PATH\n" >> ~/.bashrc;
            break;;

        [Nn]* ) 
            break;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "Do you need to install Rmpi? [y/n]" yn
    case $yn in
        [Yy]* ) 
            Rscript install_rmpi.R; 
            break;;

        [Nn]* ) 
            break;;
        * ) echo "Please answer yes or no.";;
    esac
done



source ~/.bashrc

Rscript install_rmpi.R

## Rscript install_misc.R

