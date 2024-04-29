#! /bin/bash
set -x
set -e

. /opt/miniconda3/etc/profile.d/conda.sh

# add my ssh key
#echo ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBHFz3WLVqV+0md4OkZi/S0a79cOO7Ax8S4Dledp832JhMQ0GJ0ZlmEnWZrIv83KnRexpAEi5w6H1aSackGjucgQ= t@TitusMatsalmoth.attlocal.net >> ~/.ssh/authorized_keys

mkdir ~/data/

cd ~/data/
#curl -JLO http://farm.cse.ucdavis.edu/~ctbrown/transfer/IBD_tutorial_subset.tar.gz
tar xzf /opt/shared/IBD_tutorial_subset.tar.gz
#curl -JLO http://farm.cse.ucdavis.edu/~ctbrown/transfer/tutorial_other.tar.gz
tar xzf /opt/shared/tutorial_other.tar.gz

mkdir ~/databases/
cd ~/databases/
ln -fs /opt/shared/gtdb-rs214-k31.zip .
ln -fs /opt/shared/gtdb-rs214.lineages.csv.gz .
#curl -JLO https://farm.cse.ucdavis.edu/~ctbrown/sourmash-db/gtdb-rs214/gtdb-rs214-k31.zip
#curl -JLO https://farm.cse.ucdavis.edu/~ctbrown/sourmash-db/gtdb-rs214/gtdb-rs214.lineages.csv.gz

cd ~/

# fix up conda channels
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge
conda config --set channel_priority strict

## pre-download packages

# single metagenome tutorial
mamba create -n test.tax -y sourmash sourmash_plugin_branchwater
conda activate test.tax
pip install sourmash_plugin_abundhist sourmash_plugin_venn

# comparison tutorial
mamba create -n test.smash -y sourmash scikit-learn

# AMRfinder tutorial
mamba create -n test.amrfinder -y ncbi-amrfinderplus megahit prodigal csvtk

## minto install
bash /opt/shared/minto_install.ctb.sh
