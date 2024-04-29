# Analyzing metagenomes for Antimicrobial Resistance (AMR) Genes

We're going to use
[AMRFinderPlus](https://www.ncbi.nlm.nih.gov/pathogens/antimicrobial-resistance/AMRFinder/),
together with the
[megahit metagenome assembler](https://github.com/voutcn/megahit) and
the
[prodigal gene finder](https://bmcbioinformatics.biomedcentral.com/articles/10.1186/1471-2105-11-119),
to look for antimicrobial resistance genes in the CD136 metagenome.

We're going to do this by assembling the CD136 metagenome using the megahit
assembler. This will give us contigs that represent the high coverage portion
of the metagenome.

## Install amrfinder, megahit, and prodigal.

First, install the software. Run:
```
mamba create -n amrfinder -y ncbi-amrfinderplus megahit prodigal csvtk
conda activate amrfinder
```

Next, download the amrfinderplus database. Run:
```
amrfinder -u
```

And, finally, set up & change to a working directory. Run:
```
mkdir ~/amr/
cd ~/amr/
```

## Assemble your metagenome:

We'll start by assembling the CD136 metagenome into contigs. In this
case, we're not going to bin the contigs, because AMR genes
[don't assemble well](https://www.biorxiv.org/content/10.1101/2023.12.13.571436v1.full), and in particular don't assemble into regions that are
connected to their host genome. So we run the assembler, and look at genes
on the resulting contigs.

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
These are the (partial & complete) genes found by the `prodigal` software.

And, finally, run AMRfinder on the proteins:
```
amrfinder -p CD136.assembly.faa -t 16 -o CD136.amrfinder.tsv --plus
```
(This will take under a minute.)

AMRfinder will produce a spreadsheet named `CD136.amrfinder.tsv` that
contains a number of columns - you can see the list like so, using
`csvtk headers`:

```
csvtk -t headers CD136.amrfinder.tsv
```

To pick out just a few columns, you can use `csvtk cut`.

Run:
```
csvtk -t cut -f "% Coverage of reference sequence","HMM description" CD136.amrfinder.tsv 
```

and you will see:
```
% Coverage of reference sequence        HMM description
89.41   CfxA family broad-spectrum class A beta-lactamase
87.59   23S ribosomal RNA methyltransferase Erm
52.84   NA
100.00  macrolide efflux MFS transporter Mef(En2)
100.00  lincosamide nucleotidyltransferase Lnu(AN2)
100.00  CepA family extended-spectrum class A beta-lactamase
```

The first column here is the amount of the known (reference) sequence
that is present in the metagenome, and the second is the description of
the match.

Note: If you wanted to get the abundance of these in the metagenome,
you would have to find the DNA contig that the relevant gene was on,
using the column "Protein identifier", and then map the metagenome
reads to it to get the abundance. This is because assembly collapses
the abundance of the output contigs, and you have to recover it through
other means.

