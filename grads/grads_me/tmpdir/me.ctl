dset ^ncepfnmoc_glbanl.t00z.pgrb2a_mdf00
index ^ncepfnmoc_glbanl.t00z.pgrb2a_mdf00.idx
undef 9.999E+20
title ncepfnmoc_glbanl.t00z.pgrb2a_mdf00
* produced by g2ctl v0.0.4q
* command line options: -verf ncepfnmoc_glbanl.t00z.pgrb2a_mdf00
* griddef=1:0:(360 x 181):grid_template=0:winds(N/S): lat-lon grid:(360 x 181) units 1e-06 input WE:NS output WE:SN res 48 lat 90.000000 to -90.000000 by 1.000000 lon 0.000000 to 359.000000 by 1.000000 #points=65160:winds(N/S)

dtype grib2
ydef 181 linear -90.000000 1
xdef 360 linear 0.000000 1.000000
tdef 1 linear 00Z05jul2022 1mo
* PROFILE hPa
zdef 8 levels 100000 92500 85000 70000 50000 25000 20000 10000
options pascals
vars 9
HGTprs    8,100  0,3,5 ** (1000 925 850 700 500 250 200 100) Geopotential Height [gpm]
PRMSLmsl   0,101,0   0,3,1 ** mean sea level Pressure Reduced to MSL [Pa]
TMPprs    8,100  0,0,0 ** (1000 925 850 700 500 250 200 100) Temperature [K]
TMP2m   0,103,2   0,0,0 ** 2 m above ground Temperature [K]
UGRDprs    8,100  0,2,2 ** (1000 925 850 700 500 250 200 100) U-Component of Wind [m/s]
UGRD10m   0,103,10   0,2,2 ** 10 m above ground U-Component of Wind [m/s]
VGRDprs    8,100  0,2,3 ** (1000 925 850 700 500 250 200 100) V-Component of Wind [m/s]
VGRD10m   0,103,10   0,2,3 ** 10 m above ground V-Component of Wind [m/s]
VVEL850mb   0,100,85000   0,2,8 ** 850 mb Vertical Velocity (Pressure) [Pa/s]
ENDVARS
EDEF 1
e1 1  00Z05jul2022 1,0
ENDEDEF
