MC = 10 ;
DUR = 20 ;
parpool(getenv('PROCS')) ;

tic ;
for i = 1:MC
  pause(DUR / MC) ;
end
st = toc ;
disp(st) ;

tic ;
parfor i = 1:MC
  pause(DUR / MC) ;
end
pt = toc ;
disp(pt) ;

exit ;
