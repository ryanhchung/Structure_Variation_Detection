#!/bin/bash -e

export PATH=$PATH:/data/Programs/STAR-Fusion/STAR-Fusion-v1.10.0:/data/Programs/STAR/STAR-2.7.8a/bin/Linux_x86_64

if [ $# -lt 2 ]
then
    echo usage: $0 [FQ_1] [FQ_2]
        exit 1
fi

FQ_1=$1
FQ_2=$2



#Cancer Tissue
raw=`echo $FQ_1 | cut -d "_" -f 1 | awk '{print $0"_CT"}'`

#File Path
CT_dir=/data/Projects/Multiomics_Lung/Rawdata/RNA_tissue/allFASTQ
resource_lib=/data/Reference/GRCh38/STAR/GRCh38_gencode_v37_CTAT_lib_Mar012021.plug-n-play/ctat_genome_lib_build_dir
fusiondir=/data/Projects/Multiomics_Lung/Fusion



#Program Path
starfusion=/data/Programs/STAR-Fusion/STAR-Fusion-v1.10.0/STAR-Fusion

cd ${fusiondir}
mkdir ${raw}



${starfusion} --genome_lib_dir ${resource_lib} \
             --left_fq ${CT_dir}/${FQ_1} \
             --right_fq ${CT_dir}/${FQ_2} \
             --output_dir ${fusiondir}/${raw}
             
             
             
