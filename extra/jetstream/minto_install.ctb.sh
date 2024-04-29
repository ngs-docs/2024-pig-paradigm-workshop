#!/usr/bin/env bash
set -e
set -x

cd $HOME

. /opt/miniconda3/etc/profile.d/conda.sh

# Get MIntO

git clone --depth 1 https://github.com/microbiomix/MIntO.git

# Create MIntO conda env

conda config --set channel_priority strict
conda create --yes -n MIntO mamba snakemake=7 -c conda-forge -c bioconda
conda activate MIntO
export MINTO_DIR="$HOME/MIntO"
cd $MINTO_DIR

# Create conda envs

cat >> $MINTO_DIR/smk/precreate_envs.smk <<__EOM__
import os
my_envs = ['MIntO_base.yml', 'avamb.yml', 'mags.yml', 'checkm2.yml', 'gene_annotation.yml', 'r_pkgs.yml']
rule make_all_envs:
    input:
        expand("created-{name}", name=my_envs)
for env_file in my_envs:
    rule:
        output:
            temp("created-%s" % env_file)
        conda:
            config["minto_dir"]+"/envs/%s" % env_file
        shell:
            "touch {output}"
__EOM__

snakemake --use-conda --conda-prefix $MINTO_DIR/conda_env --config minto_dir=$MINTO_DIR --cores 4 -s $MINTO_DIR/smk/precreate_envs.smk
mamba clean --tarballs --yes

# Patch assembly to avoid indexing contig files

sed -i "s/\.len//" $MINTO_DIR/smk/assembly.smk

# Set up minimal database downloads

sed -i -e "s|minto_dir: /mypath/MIntO|minto_dir: $MINTO_DIR|" $MINTO_DIR/configuration/dependencies.yaml
cat >> $MINTO_DIR/configuration/dependencies.yaml <<__EOM__
enable_GTDB: no
enable_phylophlan: no
enable_metaphlan: no
enable_motus: no
__EOM__

# Download databases

snakemake --use-conda --restart-times 1 --keep-going --latency-wait 60 --cores 14 --resources mem=50 --jobs 4 --shadow-prefix="./.snakemake" --conda-prefix $MINTO_DIR/conda_env --snakefile $MINTO_DIR/smk/dependencies.smk --configfile $MINTO_DIR/configuration/dependencies.yaml -U checkm2_db Kofam_db functional_db_descriptions KEGG_maps download_fetchMGs


# Download Tutorial data

mkdir -p $HOME/tutorial/metaG
cd $HOME/tutorial/metaG

# Get tarball, extract and delete tarball

#wget --no-check-certificate https://arumugamlab.sund.ku.dk/tutorials/202404_MIntO/tutorial_data.tar.bz2
#tar xfj tutorial_data.tar.bz2
#rm tutorial_data.tar.bz2
tar xfj /opt/shared/tutorial_data.tar.bz2
