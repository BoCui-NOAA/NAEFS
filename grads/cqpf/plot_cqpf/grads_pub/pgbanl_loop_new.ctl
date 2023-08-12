dset  /global/shared/stat/pra/pgbf00.%y4%m2%d2%h2
*dset  /global/shared/stat/prs/pgbf%f2.2008092300 
options template yrev
TITLE  avn
*index /ptmp/wx20yz/pgbf00.%y4%m2%d2%h2_map
index /ptmp/wx20yz/pgbf%f2.2008040100.index
*TDEF    30 LINEAR 00z01Apr2005 24hr
*TDEF    30 LINEAR 12z23Sep2008 24hr
TDEF    30 LINEAR 12z23feb2010 24hr
UNDEF  -9.90E+20
XDEF  144 LINEAR  0.0 2.5
YDEF   73 LINEAR   -90.0 2.5
ZDEF    26 LEVELS 1000 975 950 925 900 850 800 750 700 650 600 550
                  500 450 400 350 300 250 200 150 100
                  70 50 30 20 10
VARS   88
z          26   7,100,0 geopotential height (m)                 
u          26  33,100,0 u component (m/sec)                     
v          26  34,100,0 v component (m/sec)                     
t          26  11,100,0 temperature (deg K)                         
rh         21  52,100,0 rh (%)
w          21  39,100,0 omega (pa/sec)
zta        26  41,100,0 abs. vorticity (/sec)
cldw       26  153,100,0 Cloud water content (kg/kg)
upbl        0  33,116,7680 pbl mean u (m/sec)
upbl        0  34,116,7680 pbl mean v (m/sec)
tpbl        0  11,116,7680 pbl mean temp (K)
rhpbl       0  52,116,7680 pbl mean rh (%)
sfcp        0   1,  1,0 surface pressure (Pa)
dsfcdp      0   3,  1,0 surface pressure tendency (Pa/s)
pwat        0  54,200,0 Precipitable water (kg / m**2)
rhmean      0  52,200,0 Column avg. relative humidity (%)
ttp         0  11,  7,0 tropopause temperature (deg K)
ptp         0   1,  7,0 tropopause pressure (Pa)
utp         0  33,  7,0 tropopause u comp (m/sec)
vtp         0  34,  7,0 tropopause v comp (m/sec)
dvtp        0 136,  7,0 tropopause shear (/sec)
sfcli       0 131,  1,0 Surface L.I. (deg K)
li          0 132,  1,0 Best L.I. (deg K)
tmaxw       0  11,  6,0 temperature at max wind level (K)
pmaxw       0   1,  6,0 pressure at max wind level (Pa)
umaxw       0  33,  6,0 u comp at max wind level (m/sec)
vmaxw       0  34,  6,0 v comp at max wind level (m/sec)
zsfc        0   7,  1,0 model surface hight (m)
pmsl        0   2,102,0 mean sea level pressure (Pa)
thetas      0  13,107,9950  theta at sigma level 1 (deg K)
tsig1       0  11,107,9950  Temp at sigma level 1 (deg K)
wsig1       0  39,107,9950  omega at sigma level 1 (Pa/sec)
rhsig1      0  52,107,9950  RH at sigma level 1 (Pa/sec)
usig1       0  33,107,9950  u at sigma level 1 (m/sec)
vsig1       0  34,107,9950  v at sigma level 1 (m/sec)
uws         0  124,1,0  Surface Zonal Wind Stress
vws         0  125,1,0  Surface Meridional Wind Stress
shf         0  122,1,0  Sensible Heat Flux at Surface
lhf         0  121,1,0  Latent Heat Flux at Surface
ts          0  11,1,0   Surface Temperature
smois       0  144,112,2760  Soil Moisture Content
snoww       0  65,1,0   Snow Depth (Water Equivalent)
dlws        0  205,1,0  Downward Long Wave Flux at Surface
ulws        0  212,1,0  Upward Long Wave Flux at Surface
ulwt        0 212,8,0   Upward Long Wave Flux at Top of Atmos.
uswt        0 211,8,0   Upward solar radiation flux at Top of Atmos.
usws        0 211,1,0   Upward solar radiation flux at surface
dsws        0 204,1,0   Downward solar radiation flux at surface
cldh        0  71,234,0 Total Cloud Cover, High Level
scldht      0 1,233,0 Sigma level at high cloud top level
scldhb      0 1,232,0 Sigma level at high cloud bottom level
tcldht      0 11,233,0  Temperature at high cloud top level
cldm        0  71,224,0  Total Cloud Cover, Middle Level     
scldmt      0 1,223,0 Sigma level at middle cloud top level
scldmb      0 1,222,0 Sigma level at middle cloud bottom level
tcldmt      0 11,223,0  Temperature at middle cloud top level
cldl        0  71,214,0  Total Cloud Cover, Low Level     
scldlt      0 1,213,0 Sigma level at low cloud top level
scldlb      0 1,212,0 Sigma level at low cloud bottom level
tcldlt      0 11,213,0  Temperature at low cloud top level
p           0 61,1,0   Total Precipitation (mm)
pc          0 63,1,0  Convective Precipitation (mm)
ghf         0 155,1,0  Ground Heat Flux
lsmask      0 81,1,0   Land/Sea Mask
icemsk      0 91,1,0   Sea Ice Mask
u0          0 33,105,10 U Wind at 10 meter height
v0          0 34,105,10 V Wind at 10 meter height
t0          0 11,105,2 Temperature at 2 meter height
sh0         0 51,105,2 Specific Humidity at 2 meter height
rh0         0 52,105,2 Specific Humidity at 2 meter height
ps          0 1,1,0    Surface Pressure
runoff      0 90,1,0  Total runoff (kg/m**2):land surface
ep          0 145,1,0  Potential Evap (Watts/m**2):land surface
tmax        0 15,105,2   Maximum surface temperature (K)
tmin        0 16,105,2   Minimum surface temperature (K)
cldwrk      0 146,200,0  Cloud Work Function (J/kg)
albedo      0 84,1,0  Albedo (%)
strxgw      0 147,1,0 Gravity wave induced zonal stress ( N/m2)
strygw      0 148,1,0 Gravity wave induced meridional stress ( N/m2)
qsfc        0 51,115,7680 0-30 mb above ground specific humidity (kg/kg)
dpdt        0 59,1,0 precipitation rate (kg/m**2/s)
dpcdt       0 214,1,0 convective precipitation rate (kg/m**2/s)
raincov     0 140,1,0 categorical rain (1=rain,0=not)
frzrcov     0 141,1,0 categorical freezing rain (1=frrain,0=not)
icepcov     0 142,1,0 categorical ice pellets (1=ice,0=not)
snowcov     0 143,1,0 categorical snow (1=snow,0=not)
cldpbl      0  71,211,0 pbl cloud fraction
cldtot      0  71,200,0 total cloud fraction
ENDVARS
