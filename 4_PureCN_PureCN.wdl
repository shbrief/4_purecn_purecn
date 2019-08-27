workflow runPureCN {
	call PureCN
	meta {
		author: "Sehyun Oh"
        email: "shbrief@gmail.com"
        description: "PureCN.R of PureCN"
    }
}

task PureCN {
	File tumor_loess
	File var_calls
	File var_calls_idx
	File var_calls_stats
	File normalDB
	File mappingBiase
	File intervalWeight
	File interval   # _gcgene.txt
	
	File snpblacklist 
	String out_dir
	String genome
	
	String fname = basename(tumor_loess)
	String SAMPLEID = sub(fname, "_coverage_loess.txt", "")

	command <<<
		Rscript /usr/local/lib/R/site-library/PureCN/extdata/PureCN.R \
        --out ${out_dir}/${SAMPLEID} \
        --tumor ${tumor_loess} \
        --sampleid ${SAMPLEID} \
        --vcf ${var_calls} \
        --statsfile ${var_calls_stats} \
        --normaldb ${normalDB} \
        --normal_panel ${mappingBiase} \
        --intervals ${interval} \
        --intervalweightfile ${intervalWeight} \
        --snpblacklist ${snpblacklist} \
        --genome ${genome} \
        --force --postoptimize --seed 123
	>>>

	runtime {
		docker: "quay.io/shbrief/pcn_docker"
		cpu : 4
		memory: "16 GB"
	}
	
	output {
		File chromosome_pdf = "${SAMPLEID}_chromosomes.pdf"
        File csv = "${SAMPLEID}.csv"
        File dnacoy_seg = "${SAMPLEID}_dnacopy.seg"
        File genes_csv = "${SAMPLEID}_genes.csv"
        File local_optima_pdf = "${SAMPLEID}_local_optima.pdf"
        File log = "${SAMPLEID}.log"
        File loh_csv = "${SAMPLEID}_loh.csv"
        File pdf = "${SAMPLEID}.pdf"
        File res = "${SAMPLEID}.rds"
        File segmentation_pdf = "${SAMPLEID}_segmentation.pdf"
        File variants_csv = "${SAMPLEID}_variants.csv"
	}
}