#!/bin/bash
vcf=~/MTB_SEQ/vcf
jvc=~/MTB_SEQ/jvc
data_folder=~/MTB_SEQ/data
fastqc_out=~/MTB_SEQ/fastqc_output
unzipped_folder=~/MTB_SEQ/fastqc_output/unzipped_files
html_folder=~/MTB_SEQ/fastqc_output/html_files
REF=~/MTB_SEQ/REFERENCE/H37Rv.fna
out_dir=~/MTB_SEQ/REFERENCE/
mtb_Db='Mycobacterium_tuberculosis_h37rv'
vcf_file=/home/odette/MTB_SEQ/vcf/ERR3077932_renamed.vcf
annotated_file=/home/odette/MTB_SEQ/vcf/annotated_vcfs
renaming_txt=~/MTB_SEQ/bin/renaming_file.txt
renamed_vcf_files_dir=~/MTB_SEQ/vcf/renamed_vcf_files
unrenamed_vcf_files_dir=~/MTB_SEQ/vcf/unrenamed_vcf_files/unfiltered
fields_to_extract=("POS" "REF" "ALT" "ANN[*].GENE" "ANN[*].EFFECT" "ANN[*].IMPACT") 
# mkdir ~/MTB_SEQ/vcf/annotated_vcfs/{sorted,unsorted}
# #rename the #chrome to chromosome
# for v_file in "${unrenamed_vcf_files_dir}"/*.vcf; do
# renamed_output="${renamed_vcf_files_dir}/$(basename "$v_file" .vcf).renamed.vcf"
# bcftools annotate \
#     --rename-chrs "$renaming_txt" "$v_file" \
#     -o "$renamed_output"
# done


# # #snpEff Command

# for v_file in "${renamed_vcf_files_dir}"/*.renamed.vcf; do
# annotated_output="${annotated_file}/unsorted/$(basename "$v_file" .renamed.vcf).annotated.vcf"
# snpEff "$mtb_Db" "$v_file" > "$annotated_output"
# done

# for annot_f in "${annotated_file}"/*.annotated.vcf; do
#     output="${vcf}/fields/$(basename "$annot_f" .annotated.vcf).txt"
#     cat "$annot_f" | ~/snpEff/scripts/vcfEffOnePerLine.pl | java -jar ~/snpEff/SnpSift.jar extractFields - ${fields_to_extract[*]} > "$output"
# done

#merge vcf files
list_files="${annotated_file}/unsorted/vcf_files.txt"

find "${annotated_file}"/unsorted -maxdepth 1 -type f -name "*.vcf" > $list_files

# cat $list_files | while read vcf_file
# do
# sorted_output="${annotated_file}/sorted/$(basename "$vcf_file" .vcf).sorted.vcf.gz"
# bcftools sort $vcf_file -Oz -o $sorted_output
# bcftools index -t -f $sorted_output
# done
zvcf=${annotated_file}/sorted/zvcf.txt
find "${annotated_file}/sorted" -maxdepth 1 -type f -name "*.vcf.gz" -not -name "merged.vcf.gz"> "${zvcf}"

bcftools merge -l $zvcf -Oz -o ${annotated_file}/sorted/merged.vcf.gz
bcftools merge -l $zvcf -Ov -o ${annotated_file}/sorted/merged.vcf