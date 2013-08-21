install.packages("rmpi.tar.gz",
                 configure.args="
--with-Rmpi-include=/usr/local/openmpi/1.6.3/gcc/x86_64/include/
--with-Rmpi-libpath=/usr/local/openmpi/1.6.3/gcc/x86_64/lib64/
--with-Rmpi-type=OPENMPI
"
                 )
