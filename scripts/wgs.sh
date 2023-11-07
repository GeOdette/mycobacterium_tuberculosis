#!/bin/bash 
set -e
vcf=~/MTB_SEQ/vcf
jvc=~/MTB_SEQ/jvc
data_folder=~/MTB_SEQ/data
fastqc_out=~/MTB_SEQ/fastqc_output
unzipped_folder=~/MTB_SEQ/fastqc_output/unzipped_files
html_folder=~/MTB_SEQ/fastqc_output/html_files
REF=~/MTB_SEQ/REFERENCE/H37Rv.fna
out_dir=~/MTB_SEQ/REFERENCE/
unrenamed_files_unf_dir=~/MTB_SEQ/vcf/unrenamed_vcf_files/unfiltered
unrenamed_files_f_dir=~/MTB_SEQ/vcf/unrenamed_vcf_files/filtered
bam_dir=~/MTB_SEQ/bam
sorted_bam_dir=~/MTB_SEQ/bam/sorted_bam
unsorted_bam_dir=~/MTB_SEQ/bam/unsorted_bam
marked_duplicates=~/MTB_SEQ/marked_duplicates

#prepare the ref file
# echo "Indexing reference genome fna file*********"
# samtools faidx $REF

# echo "Indexing complete................"

# echo "Creating the .dict file for the reference genome"
# gatk CreateSequenceDictionary \
#     -R $REF \
#     -O "${out_dir}/$(basename $REF .fna).dict"

# echo ".dict file created and stored in the ${out_dir} directory................"
# # Run FASTQC

# for fastqc_file in "${data_folder}"/*.fastq; do
#   fastqc "$fastqc_file" \
#   -o "$fastqc_out"
# done

# #UNZIPPING

# for zip_file in "${fastqc_out}"/*.zip; do
# html_file="${fastqc_out}/$(basename "$zip_file" .zip).html"
# unzip $zip_file \
#     -d $unzipped_folder
# mv $html_file $html_folder
# done

# # Reading the fastqc sumamry files

# for txt in "${unzipped_folder}"/*_fastqc/summary.txt; do
# cat $txt >> ${fastqc_out}/collated_summary.txt
# done

# #skipped trimming

# #get the ref file and index it

# #align reads to get the bam file
# echo "Indexing the ref genome****"
# bwa index "$REF"
# echo "Indexing the ref genome done****"


# echo "Starting alignment of reads to the reference genome"
# for r1 in "${data_folder}"/*_1.fastq; do
#     r2="${data_folder}/$(basename "$r1" _1.fastq)_2.fastq"
#     unsorted_bam_file="${unsorted_bam_dir}/$(basename "$r1" _1.fastq).bam"
#     bwa mem "$REF" "$r1" "$r2" > "$unsorted_bam_file"
# done

# echo "Alignment of reads to the reference genome complete"

# #Mark duplicates

# for bam_file in "${unsorted_bam_dir}"/*.bam; do
#     bam_sorted="${sorted_bam_dir}/$(basename "$bam_file" .bam)_sorted.bam"
#     samtools sort "$bam_file" \
#     -o "$bam_sorted"
# done

# echo "all sorted"

# echo "Starting to mark duplicates"

# for sorted_bam_file in "${sorted_bam_dir}"/*_sorted.bam; do
#     deduped_out="${marked_duplicates}/$(basename "$sorted_bam_file" _sorted.bam)_deduped.bam"
#     metrics_file="${data_folder}/$(basename $sorted_bam_file _sorted.bam)_Metrics.bam"
#     gatk MarkDuplicates \
#         -I $sorted_bam_file \
#         -O $deduped_out \
#         -M $metrics_file
# done

# echo "duplicates marked"


# #ADDING READGROUP
# for dedup_reads in "${marked_duplicates}"/*_deduped.bam; do  
# ID="$(basename $dedup_reads _deduped.bam)" 
# SM="$(basename $dedup_reads _deduped.bam)" 
# gatk AddOrReplaceReadGroups \
#     -I $dedup_reads \
#     -O ${bam_dir}/$(basename "$dedup_reads" _deduped.bam)_R.bam \
#     --RGID $ID \
#     --RGSM $SM \
#     --RGPL 'illumina' \
#     --RGLB 'mtb' \
#     --RGPU 'unit1'
# done


# for bam_file in "${bam_dir}"/*_R.bam; do 
#     vcf_file="${unrenamed_files_unf_dir}/$(basename "$bam_file" _R.bam).vcf" 
#     samtools index $bam_file
#     gatk HaplotypeCaller \
#         -R $REF \
#         -I $bam_file \
#         -O $vcf_file; 
# done

# # Filtering SNPS
# for f in "${unrenamed_files_unf_dir}"/*.vcf; do
#     filtration_out="${unrenamed_files_f_dir}/snps/$(basename "$f" .vcf)_filtered.vcf"
#     gatk VariantFiltration \
#         -R $REF \
#         -V $f \
#         -O $filtration_out \
#         --filter-name "QUAL_filter" \
#         -filter "QUAL < 30.0" \
#         --filter-name "QD_filter" \
#         -filter "QD < 2.0" \
#         --filter-name "FS_filter" \
#         -filter "FS > 60.0" \
#         --filter-name "MQ_filter" \
#         -filter "MQ < 40.0" \
#         --filter-name "SOR_filter" \
#         -filter "SOR > 4.0" \
#         --filter-name "ReadPosRankSum_filter" \
#         -filter "ReadPosRankSum < -8.0" \
#         --genotype-filter-expression "DP < 10" \
#         --genotype-filter-name "DP_filter" \
#         --genotype-filter-expression "GQ < 20" \
#         --genotype-filter-name "GQ_filter"
# done

# # Filtering Indels
# for f in "${unrenamed_files_unf_dir}"/*.vcf; do
#     filtration_out="${unrenamed_files_f_dir}/indels/$(basename "$f" .vcf)_filtered.vcf"
#     gatk VariantFiltration \
#         -R $REF \
#         -V $f \
#         -O $filtration_out \
#         --filter-name "QD_filter" \
#         -filter "QD < 2.0" \
#         --filter-name "FS_filter" \
#         -filter "FS > 200.0" \
#         --filter-name "SOR_filter" \
#         -filter "SOR > 4.0" \
#         --filter-name "ReadPosRankSum_filter" \
#         -filter "ReadPosRankSum < -8.0" \
#         --genotype-filter-expression "DP < 10" \
#         --genotype-filter-name "DP_filter" \
#         --genotype-filter-expression "GQ < 20" \
#         --genotype-filter-name "GQ_filter"
# done


# for bam_file in "${bam_dir}"/*_R.bam; do 
#     gvcf_file="${jvc}/$(basename "$bam_file" _R.bam).g.vcf" 
#     gatk HaplotypeCaller \
#         -R $REF \
#         -I $bam_file  \
#         --emit-ref-confidence GVCF \
#         -O $gvcf_file;
# done

# for gvcf in "${jvc}"/*.g.vcf; do
# gatk GenotypeGVCFs \
#     -R $REF \
#     --V $gvcf \
#     -O "${jvc}"/joint.vcf
# done

