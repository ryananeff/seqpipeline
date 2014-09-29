#!/bin/bash

shopt -s expand_aliases # or else the script won't expand aliases

alias qsub="qsub -q gibbons.q -V -S /bin/bash -cwd -hold_jid hg38_a";

qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19625_merged.bam SRR031785_bwamem_hg38.realigned.bam SRR031806_bwamem_hg38.realigned.bam SRR031807_bwamem_hg38.realigned.bam SRR031808_bwamem_hg38.realigned.bam 
SRR031809_bwamem_hg38.realigned.bam SRR034421_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19700_merged.bam SRR032234_bwamem_hg38.realigned.bam SRR032235_bwamem_hg38.realigned.bam SRR032230_bwamem_hg38.realigned.bam SRR032231_bwamem_hg38.realigned.bam 
SRR032232_bwamem_hg38.realigned.bam SRR032233_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19701_merged.bam SRR031613_bwamem_hg38.realigned.bam SRR031612_bwamem_hg38.realigned.bam SRR031617_bwamem_hg38.realigned.bam SRR031616_bwamem_hg38.realigned.bam 
SRR031615_bwamem_hg38.realigned.bam SRR031614_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19703_merged.bam SRR032324_bwamem_hg38.realigned.bam SRR032325_bwamem_hg38.realigned.bam SRR030621_bwamem_hg38.realigned.bam SRR030620_bwamem_hg38.realigned.bam 
SRR031611_bwamem_hg38.realigned.bam SRR031610_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19704_merged.bam SRR030625_bwamem_hg38.realigned.bam SRR030624_bwamem_hg38.realigned.bam SRR030627_bwamem_hg38.realigned.bam SRR030626_bwamem_hg38.realigned.bam 
SRR030629_bwamem_hg38.realigned.bam SRR030628_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19707_merged.bam SRR032322_bwamem_hg38.realigned.bam SRR032323_bwamem_hg38.realigned.bam SRR032320_bwamem_hg38.realigned.bam SRR032321_bwamem_hg38.realigned.bam 
SRR032319_bwamem_hg38.realigned.bam SRR032318_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19711_merged.bam SRR032223_bwamem_hg38.realigned.bam SRR032222_bwamem_hg38.realigned.bam SRR032227_bwamem_hg38.realigned.bam SRR032226_bwamem_hg38.realigned.bam 
SRR032225_bwamem_hg38.realigned.bam SRR032224_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19712_merged.bam SRR032856_bwamem_hg38.realigned.bam SRR031786_bwamem_hg38.realigned.bam SRR031810_bwamem_hg38.realigned.bam SRR032229_bwamem_hg38.realigned.bam 
SRR032228_bwamem_hg38.realigned.bam SRR032236_bwamem_hg38.realigned.bam SRR032237_bwamem_hg38.realigned.bam SRR032421_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19713_merged.bam SRR038704_bwamem_hg38.realigned.bam SRR038705_bwamem_hg38.realigned.bam SRR038702_bwamem_hg38.realigned.bam SRR038703_bwamem_hg38.realigned.bam 
SRR044222_bwamem_hg38.realigned.bam SRR044223_bwamem_hg38.realigned.bam SRR044226_bwamem_hg38.realigned.bam SRR044227_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19818_merged.bam SRR038698_bwamem_hg38.realigned.bam SRR038699_bwamem_hg38.realigned.bam SRR038700_bwamem_hg38.realigned.bam SRR038701_bwamem_hg38.realigned.bam 
SRR044224_bwamem_hg38.realigned.bam SRR044225_bwamem_hg38.realigned.bam SRR044228_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19819_merged.bam SRR043217_bwamem_hg38.realigned.bam SRR043207_bwamem_hg38.realigned.bam SRR043208_bwamem_hg38.realigned.bam SRR043219_bwamem_hg38.realigned.bam 
SRR039239_bwamem_hg38.realigned.bam SRR039238_bwamem_hg38.realigned.bam SRR039237_bwamem_hg38.realigned.bam SRR039236_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19834_merged.bam SRR043212_bwamem_hg38.realigned.bam SRR043213_bwamem_hg38.realigned.bam SRR043215_bwamem_hg38.realigned.bam SRR043218_bwamem_hg38.realigned.bam 
SRR039233_bwamem_hg38.realigned.bam SRR039232_bwamem_hg38.realigned.bam SRR039235_bwamem_hg38.realigned.bam SRR039234_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19835_merged.bam SRR043210_bwamem_hg38.realigned.bam SRR043211_bwamem_hg38.realigned.bam SRR043216_bwamem_hg38.realigned.bam SRR038710_bwamem_hg38.realigned.bam 
SRR038713_bwamem_hg38.realigned.bam SRR038712_bwamem_hg38.realigned.bam SRR038711_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19900_merged.bam SRR038706_bwamem_hg38.realigned.bam SRR038707_bwamem_hg38.realigned.bam SRR043205_bwamem_hg38.realigned.bam SRR043214_bwamem_hg38.realigned.bam 
SRR043206_bwamem_hg38.realigned.bam SRR043209_bwamem_hg38.realigned.bam SRR038708_bwamem_hg38.realigned.bam SRR038709_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19901_merged.bam SRR032326_bwamem_hg38.realigned.bam SRR032327_bwamem_hg38.realigned.bam SRR032369_bwamem_hg38.realigned.bam SRR032330_bwamem_hg38.realigned.bam 
SRR032399_bwamem_hg38.realigned.bam SRR032398_bwamem_hg38.realigned.bam SRR032328_bwamem_hg38.realigned.bam SRR032329_bwamem_hg38.realigned.bam SRR032400_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19904_merged.bam SRR029896_bwamem_hg38.realigned.bam SRR029890_bwamem_hg38.realigned.bam SRR029891_bwamem_hg38.realigned.bam SRR029892_bwamem_hg38.realigned.bam 
SRR029893_bwamem_hg38.realigned.bam SRR029894_bwamem_hg38.realigned.bam SRR029895_bwamem_hg38.realigned.bam SRR029889_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19908_merged.bam SRR029908_bwamem_hg38.realigned.bam SRR029906_bwamem_hg38.realigned.bam SRR029907_bwamem_hg38.realigned.bam SRR029904_bwamem_hg38.realigned.bam 
SRR029905_bwamem_hg38.realigned.bam SRR029902_bwamem_hg38.realigned.bam SRR029903_bwamem_hg38.realigned.bam SRR029901_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19909_merged.bam SRR029933_bwamem_hg38.realigned.bam SRR029932_bwamem_hg38.realigned.bam SRR029926_bwamem_hg38.realigned.bam SRR029930_bwamem_hg38.realigned.bam 
SRR029927_bwamem_hg38.realigned.bam SRR029934_bwamem_hg38.realigned.bam SRR029928_bwamem_hg38.realigned.bam SRR029929_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19916_merged.bam SRR030038_bwamem_hg38.realigned.bam SRR030039_bwamem_hg38.realigned.bam SRR030049_bwamem_hg38.realigned.bam SRR030042_bwamem_hg38.realigned.bam 
SRR030041_bwamem_hg38.realigned.bam SRR030040_bwamem_hg38.realigned.bam SRR030050_bwamem_hg38.realigned.bam SRR030051_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19917_merged.bam SRR029924_bwamem_hg38.realigned.bam SRR029919_bwamem_hg38.realigned.bam SRR029918_bwamem_hg38.realigned.bam SRR029935_bwamem_hg38.realigned.bam 
SRR029923_bwamem_hg38.realigned.bam SRR029920_bwamem_hg38.realigned.bam SRR029917_bwamem_hg38.realigned.bam SRR029936_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19920_merged.bam SRR030618_bwamem_hg38.realigned.bam SRR030619_bwamem_hg38.realigned.bam SRR030610_bwamem_hg38.realigned.bam SRR030611_bwamem_hg38.realigned.bam 
SRR030612_bwamem_hg38.realigned.bam SRR030613_bwamem_hg38.realigned.bam SRR030614_bwamem_hg38.realigned.bam SRR030615_bwamem_hg38.realigned.bam SRR030616_bwamem_hg38.realigned.bam SRR030617_bwamem_hg38.realigned.bam 
SRR030607_bwamem_hg38.realigned.bam SRR030606_bwamem_hg38.realigned.bam SRR030623_bwamem_hg38.realigned.bam SRR030622_bwamem_hg38.realigned.bam SRR030609_bwamem_hg38.realigned.bam SRR030608_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19921_merged.bam SRR030037_bwamem_hg38.realigned.bam SRR030046_bwamem_hg38.realigned.bam SRR030048_bwamem_hg38.realigned.bam SRR030043_bwamem_hg38.realigned.bam 
SRR030045_bwamem_hg38.realigned.bam SRR030036_bwamem_hg38.realigned.bam SRR030044_bwamem_hg38.realigned.bam SRR029909_bwamem_hg38.realigned.bam SRR029915_bwamem_hg38.realigned.bam SRR029914_bwamem_hg38.realigned.bam 
SRR029916_bwamem_hg38.realigned.bam SRR029911_bwamem_hg38.realigned.bam SRR029910_bwamem_hg38.realigned.bam SRR029913_bwamem_hg38.realigned.bam SRR029912_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19982_merged.bam SRR031624_bwamem_hg38.realigned.bam SRR031625_bwamem_hg38.realigned.bam SRR031622_bwamem_hg38.realigned.bam SRR031623_bwamem_hg38.realigned.bam 
SRR031620_bwamem_hg38.realigned.bam SRR031621_bwamem_hg38.realigned.bam SRR031619_bwamem_hg38.realigned.bam SRR031618_bwamem_hg38.realigned.bam SRR032432_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA19985_merged.bam SRR061670_bwamem_hg38.realigned.bam SRR061641_bwamem_hg38.realigned.bam SRR061663_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20126_merged.bam SRR061637_bwamem_hg38.realigned.bam SRR061618_bwamem_hg38.realigned.bam SRR061624_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20127_merged.bam SRR061665_bwamem_hg38.realigned.bam SRR061664_bwamem_hg38.realigned.bam SRR061669_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20276_merged.bam SRR061667_bwamem_hg38.realigned.bam SRR061659_bwamem_hg38.realigned.bam SRR061638_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20278_merged.bam SRR061621_bwamem_hg38.realigned.bam SRR061626_bwamem_hg38.realigned.bam SRR061619_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20281_merged.bam SRR061631_bwamem_hg38.realigned.bam SRR061647_bwamem_hg38.realigned.bam SRR061644_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20282_merged.bam SRR061645_bwamem_hg38.realigned.bam SRR061639_bwamem_hg38.realigned.bam SRR061655_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20287_merged.bam SRR061653_bwamem_hg38.realigned.bam SRR061632_bwamem_hg38.realigned.bam SRR061660_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20289_merged.bam SRR061650_bwamem_hg38.realigned.bam SRR061657_bwamem_hg38.realigned.bam SRR061654_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20291_merged.bam SRR062546_bwamem_hg38.realigned.bam SRR061612_bwamem_hg38.realigned.bam SRR061613_bwamem_hg38.realigned.bam SRR061611_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20294_merged.bam SRR061623_bwamem_hg38.realigned.bam SRR061622_bwamem_hg38.realigned.bam SRR062545_bwamem_hg38.realigned.bam SRR061614_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20296_merged.bam SRR061652_bwamem_hg38.realigned.bam SRR061634_bwamem_hg38.realigned.bam SRR061642_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20298_merged.bam SRR768212_bwamem_hg38.realigned.bam SRR768213_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20299_merged.bam SRR061658_bwamem_hg38.realigned.bam SRR061656_bwamem_hg38.realigned.bam SRR061677_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20314_merged.bam SRR061636_bwamem_hg38.realigned.bam SRR061627_bwamem_hg38.realigned.bam SRR061625_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20317_merged.bam SRR061616_bwamem_hg38.realigned.bam SRR061617_bwamem_hg38.realigned.bam SRR061620_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20322_merged.bam SRR061678_bwamem_hg38.realigned.bam SRR061662_bwamem_hg38.realigned.bam SRR061646_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20332_merged.bam SRR062547_bwamem_hg38.realigned.bam SRR061640_bwamem_hg38.realigned.bam SRR061651_bwamem_hg38.realigned.bam SRR061635_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20334_merged.bam SRR061666_bwamem_hg38.realigned.bam SRR061661_bwamem_hg38.realigned.bam SRR061668_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20336_merged.bam SRR061649_bwamem_hg38.realigned.bam SRR061648_bwamem_hg38.realigned.bam SRR061643_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20340_merged.bam SRR061674_bwamem_hg38.realigned.bam SRR061675_bwamem_hg38.realigned.bam SRR061676_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20341_merged.bam SRR061615_bwamem_hg38.realigned.bam SRR061609_bwamem_hg38.realigned.bam SRR061610_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20342_merged.bam SRR061671_bwamem_hg38.realigned.bam SRR061672_bwamem_hg38.realigned.bam SRR061673_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20344_merged.bam SRR061629_bwamem_hg38.realigned.bam SRR061628_bwamem_hg38.realigned.bam SRR061630_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20346_merged.bam SRR061607_bwamem_hg38.realigned.bam SRR061606_bwamem_hg38.realigned.bam SRR061608_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20348_merged.bam SRR061681_bwamem_hg38.realigned.bam SRR061683_bwamem_hg38.realigned.bam SRR061682_bwamem_hg38.realigned.bam"
qsub -b y -N merge -o /dev/null -e mergeout.err "samtools merge NA20356_merged.bam SRR061679_bwamem_hg38.realigned.bam SRR061680_bwamem_hg38.realigned.bam SRR061633_bwamem_hg38.realigned.bam"
