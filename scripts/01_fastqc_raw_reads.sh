#!/bin/bash

DATA_DIRECTORY=					#path to raw data directory
PREFIX=						#prefix for working directory path
WORKING_DIRECTORY=${PREFIX}/results		#path to results directory
SCRIPT=${PREFIX}/scripts                    	#path to script directory
HEADER=${SCRIPT}/input_files/header.txt         #path to header.txt file

#Creating results and scripts directory
mkdir -p $WORKING_DIRECTORY/fastqc_raw_reads
mkdir -p ${SCRIPT}/01_fastqc_raw_reads_scripts

#Running QC script on every fastq files
cd $DATA_DIRECTORY
for file in $(ls *.bz2) ;
do
	base=$(basename $file) ;
	cp ${HEADER} ${SCRIPT}/01_fastqc_raw_reads_scripts/${base%%.*}_fastqc.qsub ;
	echo "cd ${DATA_DIRECTORY}" >> ${SCRIPT}/01_fastqc_raw_reads_scripts/${base%%.*}_fastqc.qsub ;
	echo "#bunzip2 $base" >> ${SCRIPT}/01_fastqc_raw_reads_scripts/${base%%.*}_fastqc.qsub ;
	echo "#gzip ${base%.bz2*}" >> ${SCRIPT}/01_fastqc_raw_reads_scripts/${base%%.*}_fastqc.qsub ;
	fq=${base%%.*}.fastq.gz ;
	echo ". /appli/bioinfo/fastqc/0.11.5/env.sh" >> ${SCRIPT}/01_fastqc_raw_reads_scripts/${base%%.*}_fastqc.qsub ;
	echo "fastqc ${fq} -o ${WORKING_DIRECTORY}/fastqc_raw_reads >& ${WORKING_DIRECTORY}/fastqc.log" >> ${SCRIPT}/01_fastqc_raw_reads_scripts/${base%%.*}_fastqc.qsub ;
	qsub ${SCRIPT}/01_fastqc_raw_reads_scripts/${base%%.*}_fastqc.qsub ;
done ;


