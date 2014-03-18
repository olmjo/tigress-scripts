size = 2000 ;
rng(1) ;
mat = rand(size, size) ;

tic ;

mat2 = transpose(mat) * mat ;
chol(mat2) ;

st = toc ;
disp(st)

exit ;

