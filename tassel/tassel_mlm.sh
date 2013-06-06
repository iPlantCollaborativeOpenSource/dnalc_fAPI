#!/bin/bash

## Arguments
## input files
#population='/iplant/home/shared/KBase_staging/tassel/mdp_population_structure.txt'
#traits='/iplant/home/shared/KBase_staging/tassel/mdp_traits.txt'
#genotype='/iplant/home/shared/KBase_staging/tassel/mdp_genotype.hmp.txt'
#kinship='/iplant/home/shared/KBase_staging/tassel/mdp_kinship.txt'

## configurable parameters
#export='mlm'
#filterAlignMinFreq='0.05'
#mlmCompressionLevel='Optimum'
#mlmMaxP='1'
#mlmVarCompEst='P3D'

# Example command line incantation.  The order of the arguments matters
# tassel4.0_standalone/start_tassel.pl -fork1  -h 'mdp_genotype.hmp.txt' -filterAlign  -filterAlignMinFreq '0.05' -fork2  
# -r 'mdp_traits.txt' -fork3  -q 'mdp_population_structure.txt' -excludeLastTrait  -fork4  -k 'mdp_kinship.txt' \
# -combine5  -input1  -input2  -input3 -intersect  -combine6  -input5  -input4  -mlm  -mlmMaxP '1' -mlmVarCompEst 'P3D'\
# -mlmCompressionLevel 'Optimum' -export  'mlm' -runfork1  -runfork2  -runfork3  -runfork4

echoerr() { echo "$@" 1>&2; }

tar xzf tassel4.0_standalone.tgz

export CWD=${PWD}
export PATH="${PATH}:${CWD}/tassel4.0_standalone"

# input files
GENOTYPE=${genotype}
TRAITS=${traits}
POPULATION=${population}
KINSHIP=${kinship}

GENOTYPE_F=$(basename $GENOTYPE)
iget -fT $GENOTYPE
TRAITS_F=$(basename $TRAITS)
iget -fT $TRAITS
POPULATION_F=$(basename $POPULATION)
iget -fT $POPULATION
KINSHIP_F=$(basename $KINSHIP)
iget -fT $KINSHIP

# parameters                               # default
EXPORT=${export}                           # 'mlm'
FILTERALIGNMINFREQ=${filterAlignMinFreq}   # '0.05'
MLMCOMPRESSIONLEVEL=${mlmCompressionLevel} # 'Optimum'
MLMMAXP=${mlmMaxP}                         # '1'
MLMVARCOMPEST=${mlmVarCompEst}             # 'P3D'


# assemble arguments
ARGS="-fork1 -h '$GENOTYPE_F' -filterAlign  -filterAlignMinFreq '$FILTERALIGNMINFREQ' -fork2 -r '$TRAITS_F' -fork3"
ARGS="$ARGS -q '$POPULATION_F' -excludeLastTrait  -fork4  -k '$KINSHIP_F' -combine5 -input1 -input2 -input3"
ARGS="$ARGS -intersect -combine6  -input5  -input4  -mlm -mlmMaxP '$MLMMAXP' -mlmVarCompEst '$MLMVARCOMPEST'"
ARGS="$ARGS -mlmCompressionLevel '$MLMCOMPRESSIONLEVEL' -export $EXPORT -runfork1  -runfork2  -runfork3  -runfork4"

echoerr "Command line argument for wrapper script:
$ARGS"

run_tassel.pl $ARGS

rm -rf $GENOTYPE_F $TRAITS_F $POPULATION_F $KINSHIP_F tassel* mlp*
