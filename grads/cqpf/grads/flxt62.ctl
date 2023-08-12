dset /reanl1/ncar01/fluxgrb8508%d2%h2
options template
index sflux.map 
undef -9.99e33
dtype grib
format yrev
undef -9.99e33
title fluxgrb
tdef 10 linear 00Z01AUG85 6hr
xdef 192 linear 0 1.875
zdef 1 linear 1 1
ydef 94 levels -88.54195 -86.65317 -84.75323 -82.85077 -80.94736    
  -79.04349      -77.13935      -75.23505      -73.33066      -71.42619    
  -69.52167      -67.61710      -65.71251      -63.80790      -61.90326    
  -59.99861      -58.09395      -56.18928      -54.28460      -52.37991    
  -50.47522      -48.57052      -46.66582      -44.76111      -42.85640    
  -40.95169      -39.04697      -37.14225      -35.23753      -33.33281    
  -31.42809      -29.52336      -27.61863      -25.71391      -23.80917    
  -21.90444      -19.99971      -18.09498      -16.19025      -14.28551    
  -12.38078      -10.47604      -8.571312      -6.666580      -4.761841    
  -2.857109     -0.9523697      0.9523621       2.857101       4.761833    
   6.666565       8.571304       10.47604       12.38077       14.28551    
   16.19024       18.09497       19.99970       21.90443       23.80917    
   25.71389       27.61862       29.52335       31.42808       33.33280    
   35.23752       37.14224       39.04697       40.95168       42.85638    
   44.76111       46.66580       48.57051       50.47520       52.37990    
   54.28459       56.18927       58.09395       59.99860       61.90326    
   63.80789       65.71249       67.61710       69.52165       71.42618    
   73.33064       75.23505       77.13934       79.04347       80.94736    
   82.85077       84.75322       86.65315       88.54195 
vars    40
ps    0 1,1,0 Pressure (Pa):land and sea surface                    
tsfc       0 11,1,0 Temperature (K):land and sea surface                
tlcldt     0 11,13,0 Temperature (K):low cloud top level                   
tmccldt    0 11,23,0 Temperature (K):middle cloud top level                
thcldt     0 11,33,0 Temperature (K):high cloud top level
t0        0 11,105,0 Temperature (K) at 2 meter
tmax       0 15,1,0 Maximum surface temperature (K)
tmin       0 16,1,0 Minimum surface temperature (K)
u0        0 33,105,0 u wind (m/s) at 10 meter
v0        0 34,105,0 v of wind (m/s) at 10 meter
q0        0 51,105,0 Specific humidity (kg/kg) at surface
runoff     0 58,1,0 Total runoff (kg/m**2):land surface
p          0 61,1,0 Total precipitation (kg/m**2):land and sea surface    
pc         0 63,1,0 Convective precipitation (kg/m**2):land and sea surfac
snow       0 65,1,0 Wate equiv. of accum. snow depth (kg/m**2)          
cloudl     0 71,14,0 Total cloud cover (%):low cloud level                 
cloudm     0 71,24,0 Total cloud cover (%):middle cloud level
cloudh     0 71,34,0 Total cloud cover (%):high cloud level                
lsmask     0 81,1,0 Land-sea mask (1=land; 0=sea) (1/0)                   
soilmois   0 086,1,0 Soil moisture content (kg/m**2):land and sea surface
shf        0 122,1,0 Sensible heat flux (W/m**2):land and sea surface    
lhf        0 121,1,0 Latent heat flux (W/m**2):land and sea surface      
covvu      0 150,1,0  Covariance between V, U
covtu      0 151,1,0  Covariance between T, U
gflux      0 155,1,0 Ground heat flux (W/m**2):land and sea surface        
ustress    0 170,1,0 Zonal wind stress (N/m**2):land and sea surface     
vstress    0 171,1,0 Meridional wind stress (N/m**2):land and sea surface
psigllcb   0 175,12,0 Model level closest to given pressure (int)           
psigllct   0 175,13,0 Model level closest to given pressure (int)           
psiglmcb   0 175,22,0 Model level closest to given pressure (int)           
psiglmct   0 175,23,0 Model level closest to given pressure (int)           
psiglhcb   0 175,32,0 Model level closest to given pressure (int)           
psiglev    0 175,33,0 Model level closest to given pressure (int)           
dswflx     0 204,1,0 Downward solar radiation flux (W/m**2)                
dlwflx     0 205,1,0 Downward long wave radiation flux (W/m**2)            
uswflx     0 211,1,0 Upward solar radiation flux (W/m**2)                  
ulwflx     0 212,1,0 Upward long wave radiation flux (W/m**2)              
olr        0 212,107,0 Upward long wave radiation flux (W/m**2)              
isr        0 204,107,0 outgoing short wave radiation flux (W/m**2)
osr        0 211,107,0 outgoing short wave radiation flux (W/m**2)
endvars
