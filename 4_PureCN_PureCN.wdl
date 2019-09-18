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
        File res = "${SAMPLEID}.rds"
	}
}