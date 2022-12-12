
#  copy ens mean , gfs and c00 files

46 20 * * * bash -l -c /lfs/h2/emc/vpppg/noscrub/bo.cui/naefs.v7.0.0/mycron/sub/sub_save_naefs_v6.sh > /lfs/h2/emc/vpppg/noscrub/bo.cui/naefs.v7.0.0/mycron/output/out_save_naefs_v6 2>&1

46 20 * * * bash -l -c /lfs/h2/emc/vpppg/noscrub/bo.cui/naefs.v7.0.0/mycron/sub/sub_naefs_hpss.sh > /lfs/h2/emc/vpppg/noscrub/bo.cui/naefs.v7.0.0/mycron/output/out_hpss_naefs_v7 2>&1

#  naefs v7                               

45 06 * * * bash -l -c /lfs/h2/emc/vpppg/noscrub/bo.cui/naefs.v7.0.0/mycron/sub/sub_gefs_debias > /lfs/h2/emc/vpppg/noscrub/bo.cui/naefs.v7.0.0/mycron/output/out_gefs_debias 2>&1

45 09 * * * bash -l -c /lfs/h2/emc/vpppg/noscrub/bo.cui/naefs.v7.0.0/mycron/sub/sub_gefs_avgspr > /lfs/h2/emc/vpppg/noscrub/bo.cui/naefs.v7.0.0/mycron/output/out_gefs_avgspr 2>&1

45 09 * * * bash -l -c /lfs/h2/emc/vpppg/noscrub/bo.cui/naefs.v7.0.0/mycron/sub/sub_naefs_avgspr > /lfs/h2/emc/vpppg/noscrub/bo.cui/naefs.v7.0.0/mycron/output/out_naefs_avgspr 2>&1

30 10 * * * bash -l -c /lfs/h2/emc/vpppg/noscrub/bo.cui/naefs.v7.0.0/mycron/sub/sub_gefs_ndgd > /lfs/h2/emc/vpppg/noscrub/bo.cui/naefs.v7.0.0/mycron/output/out_gefs_ndgd 2>&1

30 10 * * * bash -l -c /lfs/h2/emc/vpppg/noscrub/bo.cui/naefs.v7.0.0/mycron/sub/sub_naefs_ndgd > /lfs/h2/emc/vpppg/noscrub/bo.cui/naefs.v7.0.0/mycron/output/out_naefs_ndgd 2>&1
