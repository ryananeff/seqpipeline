#!/bin/bash

shopt -s expand_aliases # or else the script won't expand aliases

alias qsub="qsub -q gibbons.q -V -S /bin/bash -cwd -hold_jid afrgh38_a";

qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19625_merged.afrgh38.bam SRR031785_bwamem_afrgh38.realigned.bam SRR031806_bwamem_afrgh38.realigned.bam SRR031807_bwamem_afrgh38.realigned.bam SRR031808_bwamem_afrgh38.realigned.bam 
SRR031809_bwamem_afrgh38.realigned.bam SRR034421_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19700_merged.afrgh38.bam SRR032234_bwamem_afrgh38.realigned.bam SRR032235_bwamem_afrgh38.realigned.bam SRR032230_bwamem_afrgh38.realigned.bam SRR032231_bwamem_afrgh38.realigned.bam 
SRR032232_bwamem_afrgh38.realigned.bam SRR032233_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19701_merged.afrgh38.bam SRR031613_bwamem_afrgh38.realigned.bam SRR031612_bwamem_afrgh38.realigned.bam SRR031617_bwamem_afrgh38.realigned.bam SRR031616_bwamem_afrgh38.realigned.bam 
SRR031615_bwamem_afrgh38.realigned.bam SRR031614_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19703_merged.afrgh38.bam SRR032324_bwamem_afrgh38.realigned.bam SRR032325_bwamem_afrgh38.realigned.bam SRR030621_bwamem_afrgh38.realigned.bam SRR030620_bwamem_afrgh38.realigned.bam 
SRR031611_bwamem_afrgh38.realigned.bam SRR031610_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19704_merged.afrgh38.bam SRR030625_bwamem_afrgh38.realigned.bam SRR030624_bwamem_afrgh38.realigned.bam SRR030627_bwamem_afrgh38.realigned.bam SRR030626_bwamem_afrgh38.realigned.bam 
SRR030629_bwamem_afrgh38.realigned.bam SRR030628_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19707_merged.afrgh38.bam SRR032322_bwamem_afrgh38.realigned.bam SRR032323_bwamem_afrgh38.realigned.bam SRR032320_bwamem_afrgh38.realigned.bam SRR032321_bwamem_afrgh38.realigned.bam 
SRR032319_bwamem_afrgh38.realigned.bam SRR032318_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19711_merged.afrgh38.bam SRR032223_bwamem_afrgh38.realigned.bam SRR032222_bwamem_afrgh38.realigned.bam SRR032227_bwamem_afrgh38.realigned.bam SRR032226_bwamem_afrgh38.realigned.bam 
SRR032225_bwamem_afrgh38.realigned.bam SRR032224_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19712_merged.afrgh38.bam SRR032856_bwamem_afrgh38.realigned.bam SRR031786_bwamem_afrgh38.realigned.bam SRR031810_bwamem_afrgh38.realigned.bam SRR032229_bwamem_afrgh38.realigned.bam 
SRR032228_bwamem_afrgh38.realigned.bam SRR032236_bwamem_afrgh38.realigned.bam SRR032237_bwamem_afrgh38.realigned.bam SRR032421_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19713_merged.afrgh38.bam SRR038704_bwamem_afrgh38.realigned.bam SRR038705_bwamem_afrgh38.realigned.bam SRR038702_bwamem_afrgh38.realigned.bam SRR038703_bwamem_afrgh38.realigned.bam 
SRR044222_bwamem_afrgh38.realigned.bam SRR044223_bwamem_afrgh38.realigned.bam SRR044226_bwamem_afrgh38.realigned.bam SRR044227_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19818_merged.afrgh38.bam SRR038698_bwamem_afrgh38.realigned.bam SRR038699_bwamem_afrgh38.realigned.bam SRR038700_bwamem_afrgh38.realigned.bam SRR038701_bwamem_afrgh38.realigned.bam 
SRR044224_bwamem_afrgh38.realigned.bam SRR044225_bwamem_afrgh38.realigned.bam SRR044228_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19819_merged.afrgh38.bam SRR043217_bwamem_afrgh38.realigned.bam SRR043207_bwamem_afrgh38.realigned.bam SRR043208_bwamem_afrgh38.realigned.bam SRR043219_bwamem_afrgh38.realigned.bam 
SRR039239_bwamem_afrgh38.realigned.bam SRR039238_bwamem_afrgh38.realigned.bam SRR039237_bwamem_afrgh38.realigned.bam SRR039236_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19834_merged.afrgh38.bam SRR043212_bwamem_afrgh38.realigned.bam SRR043213_bwamem_afrgh38.realigned.bam SRR043215_bwamem_afrgh38.realigned.bam SRR043218_bwamem_afrgh38.realigned.bam 
SRR039233_bwamem_afrgh38.realigned.bam SRR039232_bwamem_afrgh38.realigned.bam SRR039235_bwamem_afrgh38.realigned.bam SRR039234_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19835_merged.afrgh38.bam SRR043210_bwamem_afrgh38.realigned.bam SRR043211_bwamem_afrgh38.realigned.bam SRR043216_bwamem_afrgh38.realigned.bam SRR038710_bwamem_afrgh38.realigned.bam 
SRR038713_bwamem_afrgh38.realigned.bam SRR038712_bwamem_afrgh38.realigned.bam SRR038711_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19900_merged.afrgh38.bam SRR038706_bwamem_afrgh38.realigned.bam SRR038707_bwamem_afrgh38.realigned.bam SRR043205_bwamem_afrgh38.realigned.bam SRR043214_bwamem_afrgh38.realigned.bam 
SRR043206_bwamem_afrgh38.realigned.bam SRR043209_bwamem_afrgh38.realigned.bam SRR038708_bwamem_afrgh38.realigned.bam SRR038709_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19901_merged.afrgh38.bam SRR032326_bwamem_afrgh38.realigned.bam SRR032327_bwamem_afrgh38.realigned.bam SRR032369_bwamem_afrgh38.realigned.bam SRR032330_bwamem_afrgh38.realigned.bam 
SRR032399_bwamem_afrgh38.realigned.bam SRR032398_bwamem_afrgh38.realigned.bam SRR032328_bwamem_afrgh38.realigned.bam SRR032329_bwamem_afrgh38.realigned.bam SRR032400_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19904_merged.afrgh38.bam SRR029896_bwamem_afrgh38.realigned.bam SRR029890_bwamem_afrgh38.realigned.bam SRR029891_bwamem_afrgh38.realigned.bam SRR029892_bwamem_afrgh38.realigned.bam 
SRR029893_bwamem_afrgh38.realigned.bam SRR029894_bwamem_afrgh38.realigned.bam SRR029895_bwamem_afrgh38.realigned.bam SRR029889_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19908_merged.afrgh38.bam SRR029908_bwamem_afrgh38.realigned.bam SRR029906_bwamem_afrgh38.realigned.bam SRR029907_bwamem_afrgh38.realigned.bam SRR029904_bwamem_afrgh38.realigned.bam 
SRR029905_bwamem_afrgh38.realigned.bam SRR029902_bwamem_afrgh38.realigned.bam SRR029903_bwamem_afrgh38.realigned.bam SRR029901_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19909_merged.afrgh38.bam SRR029933_bwamem_afrgh38.realigned.bam SRR029932_bwamem_afrgh38.realigned.bam SRR029926_bwamem_afrgh38.realigned.bam SRR029930_bwamem_afrgh38.realigned.bam 
SRR029927_bwamem_afrgh38.realigned.bam SRR029934_bwamem_afrgh38.realigned.bam SRR029928_bwamem_afrgh38.realigned.bam SRR029929_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19916_merged.afrgh38.bam SRR030038_bwamem_afrgh38.realigned.bam SRR030039_bwamem_afrgh38.realigned.bam SRR030049_bwamem_afrgh38.realigned.bam SRR030042_bwamem_afrgh38.realigned.bam 
SRR030041_bwamem_afrgh38.realigned.bam SRR030040_bwamem_afrgh38.realigned.bam SRR030050_bwamem_afrgh38.realigned.bam SRR030051_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19917_merged.afrgh38.bam SRR029924_bwamem_afrgh38.realigned.bam SRR029919_bwamem_afrgh38.realigned.bam SRR029918_bwamem_afrgh38.realigned.bam SRR029935_bwamem_afrgh38.realigned.bam 
SRR029923_bwamem_afrgh38.realigned.bam SRR029920_bwamem_afrgh38.realigned.bam SRR029917_bwamem_afrgh38.realigned.bam SRR029936_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19920_merged.afrgh38.bam SRR030618_bwamem_afrgh38.realigned.bam SRR030619_bwamem_afrgh38.realigned.bam SRR030610_bwamem_afrgh38.realigned.bam SRR030611_bwamem_afrgh38.realigned.bam 
SRR030612_bwamem_afrgh38.realigned.bam SRR030613_bwamem_afrgh38.realigned.bam SRR030614_bwamem_afrgh38.realigned.bam SRR030615_bwamem_afrgh38.realigned.bam SRR030616_bwamem_afrgh38.realigned.bam SRR030617_bwamem_afrgh38.realigned.bam 
SRR030607_bwamem_afrgh38.realigned.bam SRR030606_bwamem_afrgh38.realigned.bam SRR030623_bwamem_afrgh38.realigned.bam SRR030622_bwamem_afrgh38.realigned.bam SRR030609_bwamem_afrgh38.realigned.bam SRR030608_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19921_merged.afrgh38.bam SRR030037_bwamem_afrgh38.realigned.bam SRR030046_bwamem_afrgh38.realigned.bam SRR030048_bwamem_afrgh38.realigned.bam SRR030043_bwamem_afrgh38.realigned.bam 
SRR030045_bwamem_afrgh38.realigned.bam SRR030036_bwamem_afrgh38.realigned.bam SRR030044_bwamem_afrgh38.realigned.bam SRR029909_bwamem_afrgh38.realigned.bam SRR029915_bwamem_afrgh38.realigned.bam SRR029914_bwamem_afrgh38.realigned.bam 
SRR029916_bwamem_afrgh38.realigned.bam SRR029911_bwamem_afrgh38.realigned.bam SRR029910_bwamem_afrgh38.realigned.bam SRR029913_bwamem_afrgh38.realigned.bam SRR029912_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19982_merged.afrgh38.bam SRR031624_bwamem_afrgh38.realigned.bam SRR031625_bwamem_afrgh38.realigned.bam SRR031622_bwamem_afrgh38.realigned.bam SRR031623_bwamem_afrgh38.realigned.bam 
SRR031620_bwamem_afrgh38.realigned.bam SRR031621_bwamem_afrgh38.realigned.bam SRR031619_bwamem_afrgh38.realigned.bam SRR031618_bwamem_afrgh38.realigned.bam SRR032432_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19985_merged.afrgh38.bam SRR061670_bwamem_afrgh38.realigned.bam SRR061641_bwamem_afrgh38.realigned.bam SRR061663_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20126_merged.afrgh38.bam SRR061637_bwamem_afrgh38.realigned.bam SRR061618_bwamem_afrgh38.realigned.bam SRR061624_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20127_merged.afrgh38.bam SRR061665_bwamem_afrgh38.realigned.bam SRR061664_bwamem_afrgh38.realigned.bam SRR061669_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20276_merged.afrgh38.bam SRR061667_bwamem_afrgh38.realigned.bam SRR061659_bwamem_afrgh38.realigned.bam SRR061638_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20278_merged.afrgh38.bam SRR061621_bwamem_afrgh38.realigned.bam SRR061626_bwamem_afrgh38.realigned.bam SRR061619_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20281_merged.afrgh38.bam SRR061631_bwamem_afrgh38.realigned.bam SRR061647_bwamem_afrgh38.realigned.bam SRR061644_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20282_merged.afrgh38.bam SRR061645_bwamem_afrgh38.realigned.bam SRR061639_bwamem_afrgh38.realigned.bam SRR061655_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20287_merged.afrgh38.bam SRR061653_bwamem_afrgh38.realigned.bam SRR061632_bwamem_afrgh38.realigned.bam SRR061660_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20289_merged.afrgh38.bam SRR061650_bwamem_afrgh38.realigned.bam SRR061657_bwamem_afrgh38.realigned.bam SRR061654_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20291_merged.afrgh38.bam SRR062546_bwamem_afrgh38.realigned.bam SRR061612_bwamem_afrgh38.realigned.bam SRR061613_bwamem_afrgh38.realigned.bam SRR061611_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20294_merged.afrgh38.bam SRR061623_bwamem_afrgh38.realigned.bam SRR061622_bwamem_afrgh38.realigned.bam SRR062545_bwamem_afrgh38.realigned.bam SRR061614_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20296_merged.afrgh38.bam SRR061652_bwamem_afrgh38.realigned.bam SRR061634_bwamem_afrgh38.realigned.bam SRR061642_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20298_merged.afrgh38.bam SRR768212_bwamem_afrgh38.realigned.bam SRR768213_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20299_merged.afrgh38.bam SRR061658_bwamem_afrgh38.realigned.bam SRR061656_bwamem_afrgh38.realigned.bam SRR061677_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20314_merged.afrgh38.bam SRR061636_bwamem_afrgh38.realigned.bam SRR061627_bwamem_afrgh38.realigned.bam SRR061625_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20317_merged.afrgh38.bam SRR061616_bwamem_afrgh38.realigned.bam SRR061617_bwamem_afrgh38.realigned.bam SRR061620_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20322_merged.afrgh38.bam SRR061678_bwamem_afrgh38.realigned.bam SRR061662_bwamem_afrgh38.realigned.bam SRR061646_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20332_merged.afrgh38.bam SRR062547_bwamem_afrgh38.realigned.bam SRR061640_bwamem_afrgh38.realigned.bam SRR061651_bwamem_afrgh38.realigned.bam SRR061635_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20334_merged.afrgh38.bam SRR061666_bwamem_afrgh38.realigned.bam SRR061661_bwamem_afrgh38.realigned.bam SRR061668_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20336_merged.afrgh38.bam SRR061649_bwamem_afrgh38.realigned.bam SRR061648_bwamem_afrgh38.realigned.bam SRR061643_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20340_merged.afrgh38.bam SRR061674_bwamem_afrgh38.realigned.bam SRR061675_bwamem_afrgh38.realigned.bam SRR061676_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20341_merged.afrgh38.bam SRR061615_bwamem_afrgh38.realigned.bam SRR061609_bwamem_afrgh38.realigned.bam SRR061610_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20342_merged.afrgh38.bam SRR061671_bwamem_afrgh38.realigned.bam SRR061672_bwamem_afrgh38.realigned.bam SRR061673_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20344_merged.afrgh38.bam SRR061629_bwamem_afrgh38.realigned.bam SRR061628_bwamem_afrgh38.realigned.bam SRR061630_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20346_merged.afrgh38.bam SRR061607_bwamem_afrgh38.realigned.bam SRR061606_bwamem_afrgh38.realigned.bam SRR061608_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20348_merged.afrgh38.bam SRR061681_bwamem_afrgh38.realigned.bam SRR061683_bwamem_afrgh38.realigned.bam SRR061682_bwamem_afrgh38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20356_merged.afrgh38.bam SRR061679_bwamem_afrgh38.realigned.bam SRR061680_bwamem_afrgh38.realigned.bam SRR061633_bwamem_afrgh38.realigned.bam"
