#!/bin/bash
#jobName=sheldon
#ref_seq=/iplant/home/shared/iplant_DNA_subway/genomes/arabidopsis_thaliana/genome.fas
#query1=/iplant/home/smckay/cufflinks_test/hy5_rep1-fx386-th900-cl96.gtf
#query2=/iplant/home/smckay/cufflinks_test/hy5_rep2-fx920-th856-cl55.gtf
#query3=/iplant/home/smckay/cufflinks_test/WT_rep1-fx282-th294-cl44.gtf
#query4=/iplant/home/smckay/cufflinks_test/WT_rep2-fx790-th268-cl31.gtf

# Hard coded output directory
output_dir="./cuffmerge_out"

# function to print to STDERR
echoerr() { echo "$@" 1>&2; }

# The reference genome sequence
genome=${ref_seq}

JOB=${jobName}

# GTF files (from cufflinks) for merging 
queries[0]=${query1}
queries[1]=${query2}
queries[2]=${query3}
queries[3]=${query4}
queries[4]=${query5}
queries[5]=${query6}
queries[6]=${query7}
queries[7]=${query8}
queries[8]=${query9}
queries[9]=${query10}
queries[10]=${query11}
queries[11]=${query12}
# more...

tar xzf bin.tgz
export CWD=${PWD}
export PATH="${PATH}:${CWD}/bin"

seq=$(basename $genome)
iget -fT $genome

# Number of CPUs available for threading
THREADS=$(cat /proc/cpuinfo | grep processor | wc -l)

# Create manifest for cuffmerge
MANIFEST='manifest.txt'
touch $MANIFEST

for i in $(seq 0 1 12)
do
    echoerr $i
    file=${queries[$i]}
    if [[ -n $file ]]; then
	infile=$(basename $file)
	iget -fT $file
	if [[ -s $infile ]]; then
	    echo $infile >> $MANIFEST
	    echoerr $infile
	fi
    fi
done


echoerr "Inspecting list of GTF files to merge..."
lines=$(cat $MANIFEST | wc -l)
unique=$(sort -u $MANIFEST | wc -l)

# Check for duplicated file names
if ! [[ "$unique" -eq "$lines" ]]; then
    echoerr "Error: Each GTF file to be merged must have a unique filename"
    exit 1
fi
# Check for > 2 files to merge
if ! [[ $unique -ge 2 ]]; then
    echoerr "Error: at least two GTF files are required for merging"
    exit 1
fi

if [[ -n $lines ]]; then
  ARGS="-p $THREADS -o $output_dir -s $seq $MANIFEST";
  echoerr "Executing cuffmerge ${ARGS}..."
  cuffmerge $ARGS

  MERGEDONE=$(ls -alh $output_dir)
  echoerr "DONE!
  $MERGEDONE                                                                                                                                                  "

  cp $output_dir/merged.gtf $output_dir/${JOB}-merged.gtf
fi

# remember to remove cruft
