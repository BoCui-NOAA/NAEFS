dset /global/ecm/ecmgrb.2003010112
dtype grib
options template yrev
index pgb1.map
undef -9.99E+33
title ECMWF-MRF Model
xdef   144 linear    0.000  2.500
ydef    73 linear  -90.000  2.500
zdef    13 levels
    1000     925     850     700     500     400     300     250     200     150
     100      70      50
tdef     6 linear        12Z01JAN03  24hr
vars     3
z         13 7,100,0 Geopotential height (gpm)
t         13 11,100,0 Temperature (K)
ps         0 2,102,0  Pressure reduced to MSL (Pa)
endvars

