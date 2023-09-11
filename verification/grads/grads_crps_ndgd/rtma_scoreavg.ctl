dset  mean.grads_EXPID                          
options sequential template
undef -9.9999E+2
title rtma_scores
xdef   128 linear 1.0  1.0
ydef     1 linear 1.0  1.0
zdef     1 linear 1.0  1.0
tdef   300 linear 00z01mar2000  3hr
vars    9
crpsf      1 0 Continuous Ranked Probability for m ensembles
crpsc      1 0 Continuous Ranked Probability with respect to climate
rmsa       1 0 RMSE of ensemble mean
rmsm       1 0 RMSE of ensemble 50% probability forecast      
sprd       1 0 ensemble spread for m members
merr       1 0 ensemble mean error                
abse       1 0 ensemble absolute mean error                
ctp90      1 0 ensemble 90% probability forecast account   
ctp10      1 0 ensemble 10% probability forecast account   
endvars
