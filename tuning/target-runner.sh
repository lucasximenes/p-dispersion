#!/bin/bash

# R parameters

CONFIG_ID="$1"

INSTANCE_ID="$2"

SEED="${3}"

INSTANCE="${4}"

ELITE_SIZE="-e ${5}"

MUTANTS="-m ${6}"

POPULATION_SIZE="-p ${7}"

RHO="-r ${8}"

EXE="/home/lucas.guilhon/IND2602/p-dispersion/BRKGA.jl"

JL_PROJECT="/home/lucas.guilhon/IND2602/p-dispersion/BRKGA"

JULIA="/usr/bin/julia --depwarn=no"

#/home/lucas.guilhon/julia-1.9.3/bin/julia --project=${JL_PROJECT} ${EXE} -i ${INSTANCE} ${ELITE_SIZE} ${MUTANTS} ${POPULATION_SIZE} | tail -n 1
${JULIA} ${EXE} -i ${INSTANCE} ${ELITE_SIZE} ${MUTANTS} ${POPULATION_SIZE} ${RHO} | tail -n1

# main_complete.jl -c <config_file> -s <seed> -r <stop_rule> -a <stop_arg> -t <max_time> -i <instance_file> -e <elite> -m <mutant> -p <pop>