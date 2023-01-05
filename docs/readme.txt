NAEFS v7.0.0 Implementation Instructions:

1. Checkout NAEFS repository

 https://github.com/NOAA-EMC/NAEFS/tree/develop                        

2. Set up the package

   copy this directory to your file location

  (2) Build the executables of NAEFS
      Go to the sorc sub-directory, following the instructions in README.build file,
      all the executables will be generated and saved in the exec sub-directory.

3. Start the test run
   Check and modify (if it is necessary) job cards in sub-directory ecf
  
4. Resources requirements

  (1) Compute resource information:
      Computer: Current need around 25 nodes; future will need more nodes 
      Please check the ecf directory, the computer resource requirement
      can be found in each jobs' ecf file

  (2) Disk space

      NCEP GEFS ensmeble:

      Main change happen for directories pgrb2ap5_bc, pgrb2ap5_an, pgrb2ap5_wt with 10 more ensemble members 
      - pgrb2ap5_bc: 22GB, 0.5d bias corrected forecasts (3 hourly for day 8)
      - pgrb2ap5_an: 10GB, 0.5d anomaly forecast
      - pgrb2ap5_wt: 500mb, 0.5d weight for each member

      FNMOC ensmeble:

      Main change happen for new directories pgrb2ap5_bc, pgrb2ap5_an, pgrb2ap5_w, disk space changes from 25GB to 
      142G per day
      - new pgrb2ap5_bc: 1.4, 0.5d bias corrected forecasts (3 hourly for day 8)
      - new pgrb2ap5_an: 8.8GB, 0.5d anomaly forecast
      - new pgrb2ap5_wt: 8.2mb, 0.5d weight for each member
      - gempak:          117GB, 0.5d bias corrected forecasts

   (3) fix files are available at: /lfs/h1/ops/canned/packages/hps/naefs.v6.0.11/fix


5. New Products

   GEFS 0.5d bias corrected forecasts, 0.5d anomaly forecasts for member 21 to 30

  (1) File names for GEFS bias corrected products  
      GEFS filenames pgrb2ap5_bc/ge###.t##z.pgrb2a.0p50_bcf###                

  (2) File names for GEFS anomaly forecast  
      GEFS filenames pgrb2ap5_an/ge###.t##z.pgrb2a.0p50_anf###                

  (3) File names for GEFS bias weight for each ensemble member 
      GEFS filenames pgrb2ap5_wt/ge###.t##z.pgrb2a.0p50_wtf###                

   FNMOC changes in directory names, file names and contents 

  (1) Replacing the FNMOC sub-directory pgrb2a with pgrb2ap5

      File names are changed to
      pgrb2ap5/geavg.tCCz.pgrb2a.0p50fHHH  
      pgrb2ap5/gespr.tCCz.pgrb2a.0p50fHHH

  (2) Replacing the FNMOC sub-directory pgrb2a_bc with pgrb2ap5_bc 

      File names are changed to
      pgrb2ap5_bc/geavg.tCCz.pgrb2a.0p50_bcfHHH  
      pgrb2ap5_bc/gespr.tCCz.pgrb2a.0p50_bcfHHH

  (3) Replacing the FNMOC sub-directory pgrb2a_an with pgrb2ap5_an 

      File names are changed to
      pgrb2ap5_an/geavg.tCCz.pgrb2a.0p50_anfHHH  
      pgrb2ap5_an/gespr.tCCz.pgrb2a.0p50_anfHHH

  (4) Replacing the FNMOC sub-directory pgrb2a_wt with pgrb2ap5_wt 

      File names are changed to
      pgrb2ap5_wt/geavg.tCCz.pgrb2a.0p50_wtfHHH  
      pgrb2ap5_wt/gespr.tCCz.pgrb2a.0p50_wtfHHH

      where HHH=003, 006, 009, ...... 192, 198, 204,...,384.
