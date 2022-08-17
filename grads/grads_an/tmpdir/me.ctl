dset ^geefi.t00z.pgrb2a.0p50_bcf048
index ^geefi.t00z.pgrb2a.0p50_bcf048.idx
undef 9.999E+20
title geefi.t00z.pgrb2a.0p50_bcf048
* produced by g2ctl v0.1.0
* command line options: -verf geefi.t00z.pgrb2a.0p50_bcf048
* griddef=1:0:(720 x 361):grid_template=0:winds(N/S): lat-lon grid:(720 x 361) units 1e-06 input WE:NS output WE:SN res 48 lat 90.000000 to -90.000000 by 0.500000 lon 0.000000 to 359.500000 by 0.500000 #points=259920:winds(N/S)

dtype grib2
ydef 361 linear -90.000000 0.5
xdef 720 linear 0.000000 0.500000
tdef 1 linear 00Z25jul2022 1mo
zdef 1 linear 1 1
vars 3
PRMSLmsl   0,101,0   0,3,1 ** mean sea level Pressure Reduced to MSL [Pa]
TMP2m   0,103,2   0,0,0 ** 2 m above ground Temperature [K]
WIND10m   0,103,10   0,2,1 ** 10 m above ground Wind Speed [m/s]
ENDVARS
EDEF 1
E199 1  00Z25jul2022 199
ENDEDEF
