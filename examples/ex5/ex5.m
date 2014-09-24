MC = 10 ;
DUR = 30 ;
parpool('local', str2num(getenv('PROCS'))) ;

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
