#!/bin/sh

export tests="/data/projects_gibbons/home/neffra/tests_scripts"

$tests/initial_pipe.sh small_sim_1.fastq small_sim_2.fastq small_sim 001 TEST 2>test_initial_pipe.err
if [ $? -ne 0 ]; then echo "$(date): error in initial_pipe.sh"; exit 1; else echo "$(date): initial_pipe.sh done."; fi

$tests/merge_controller.sh small_sim 2>test_merge.err
if [ $? -ne 0 ]; then echo "$(date): error in merge_controller.sh"; exit 1; else echo "$(date): merge_controller.sh done."; fi

$tests/hc_gryphon.sh small_sim 2>test_gvcf.err
if [ $? -ne 0 ]; then echo "$(date): error in hc_gryphon.sh"; exit 1; else echo "$(date): hc_gryphon.sh done."; fi
