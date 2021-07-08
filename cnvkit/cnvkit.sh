#!/bin/bash -e

ref_dir=/data/Reference/GRCh38/GATK_bundle
ref=${ref_dir}/Homo_sapiens_assembly38.fasta
target=${ref_dir}/whole_exome_illumina_coding_v1/whole_exome_illumina_coding_v1.Homo_sapiens_assembly38.targets.interval_list

if [ $# -lt 2 ]
then
    echo usage: $0 [T_prefix] [N_prefix]
        exit 1
fi


T_prefix=$1
N_prefix=$2

T_output_home=`echo $T_prefix | rev | cut -d "_" -f 1 | rev`
N_output_home=`echo $N_prefix | rev | cut -d "_" -f 1 | rev`
prefix=`echo $T_prefix | cut -d "_" -f 1`
#printf 'filename =  %s\n' "$prefix"

t_dir=/data/Projects/Multiomics_Lung/WES_bam/${T_output_home}/${T_prefix}
log_dir=${t_dir}/log
cnvdir=/data/Projects/Multiomics_Lung/CNV

cd ${cnvdir}
mkdir ${T_prefix}

tumor_bam=${t_dir}/${T_prefix}.sorted.dedup.recal.bam
normal_bam=/data/Projects/Multiomics_Lung/WES_bam/${N_output_home}/${N_prefix}/${N_prefix}.sorted.dedup.recal.bam

echo "process 1 start"
python /data/Programs/cnvkit/cnvkit.py batch ${tumor_bam} --normal ${normal_bam} --drop-low-coverage \
        -t ${target} -f ${ref} \
        --access /data/Projects/Multiomics_Lung/CNV/codes/access.hg38.bed \
        --output-reference $cnvdir/${T_prefix}/${prefix}.cnn -d $cnvdir/${T_prefix}/

echo "process 2 start"
python /data/Programs/cnvkit/cnvkit.py batch --drop-low-coverage ${tumor_bam} -r $cnvdir/${T_prefix}/${prefix}.cnn -p 8 --scatter --diagram -d $cnvdir/${T_prefix}/


#Execute commandline -> cat sample.txt | while read tumor normal;do echo bash cnvkit.sh $tumor $normal;done
