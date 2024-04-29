# Analyzing metagenomes for Antimicrobial Resistance (AMR) Genes

## Install amrfinder, megahit, and prodigal.

@CTB links to software

```
mamba create -n amrfinder -y ncbi-amrfinderplus megahit prodigal csvtk
conda activate amrfinder
```

Download the amrfinder database:
```
amrfinder -u
```

and set up & change to a working directory:
```
mkdir ~/amr/
cd ~/amr/
```

## Assemble your metagenome:

We'll start by assembling the CD136 metagenome into contigs. In this
case, we're not going to bin the contigs, because AMR genes
[don't assemble well](https://www.biorxiv.org/content/10.1101/2023.12.13.571436v1.full).

Run:
```
megahit -1 ../data/IBD_tutorial_subset/metag/1-trimmed/CD136/CD136.1.paired.fq.gz \
    -2 ../data/IBD_tutorial_subset/metag/1-trimmed/CD136/CD136.2.paired.fq.gz \
    -o CD136.assembly.d
```
This will take about 2 minutes, and produce (among other files) a set of
assembled contigs in `CD136.assembly.d/final.contigs.fa`.

Now, predict proteins in the assembled contigs using prodigal:
```
prodigal -p meta -q -i CD136.assembly.d/final.contigs.fa -a CD136.assembly.faa
```

This will produce a FASTA file containing many protein sequences:
```
head CD136.assembly.faa
```

And, finally, run AMRfinder on the proteins:
```
amrfinder -p CD136.assembly.faa -t 16 -o CD136.amrfinder.csv  --plus
```

```
csvtk -t cut -f "% Coverage of reference sequence","HMM description" CD136.amrfinder.csv 
```

@CTB examine output files.
