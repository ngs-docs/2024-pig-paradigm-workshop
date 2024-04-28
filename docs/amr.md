# Analyzing metagenomes for Antimicrobial Resistance (AMR)

## amrfinder

```
mamba create -n amrfinder -y ncbi-amrfinderplus megahit prodigal
```

```
megahit -1 IBD_tutorial_output/metaG/1-trimmed/CD136/CD136.1.paired.fq.gz -2 IBD_tutorial_output/metaG/1-trimmed/CD136/CD136.2.paired.fq.gz -o CD136.assembly.d
```

```
prodigal -p meta -q -i CD136.assembly.d/final.contigs.fa -a CD136.assembly.faa
```

```
amrfinder -p CD136.assembly.faa -t 16 -o CD136.amrfinder.csv  --plus
```

