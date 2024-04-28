# Analyzing a single metagenome for taxonomy

## basic gather stuff

First let's install the necessary software. We'll be using
[the sourmash software](https://sourmash.readthedocs.io/en/latest/index.html)
along with a few sourmash plugins.

```
mamba create -n tax -y sourmash sourmash_plugin_branchwater
```

Now let's convert a metagenome into sourmash sketch format
[(docs])(https://sourmash.readthedocs.io/en/latest/command-line.html#sourmash-sketch-make-sourmash-signatures-from-sequence-data):

```
sourmash sketch dna -p abund IBD_tutorial_output/metaG/1-trimmed/CD136/*.fq.gz --name CD136 -o CD136.sig.zip
```

And search it against the latest
[Genome Taxonomy Database (GTDB)](https://gtdb.ecogenomic.org/)
containing all known genomes.

Do the primary search with the 'fastgather' extension to sourmash:
```
sourmash scripts fastgather CD136.sig.zip /group/ctbrowngrp/sourmash-db/gtdb-rs214/gtdb-rs214-k31.zip -o CD136.x.gtdb-rs214.fastgather.csv -c 16
```

Display the results of the first search in a nicer format using 'sourmash gather' [(docs](https://sourmash.readthedocs.io/en/latest/classifying-signatures.html#analyzing-metagenomic-samples-with-gather):
```
sourmash gather CD136.sig.zip /group/ctbrowngrp/sourmash-db/gtdb-rs214/gtdb-rs214-k31.zip -o CD136.x.gtdb-rs214.gather.csv --picklist CD136.x.gtdb-rs214.fastgather.csv:match_name:ident
```

You should see the output below. What does this mean?
```
overlap     p_query p_match avg_abund
---------   ------- ------- ---------
5.0 Mbp       27.5%   96.7%       7.3    GCF_000598785.2 Bacteroides fragilis...
3.6 Mbp       10.3%   64.2%       3.8    GCF_009678525.1 Parabacteroides dist...
3.2 Mbp        4.6%   59.0%       1.9    GCF_015550345.1 Bacteroides uniformi...
1.6 Mbp       30.7%   58.4%      25.3    GCA_023708525.1 Faecalibacterium pra...
3.6 Mbp        1.2%    8.0%       3.8    GCF_009024595.1 Parabacteroides dist...
1.6 Mbp        5.6%   10.2%      25.1    GCF_017377615.1 Faecalibacterium sp....
2.6 Mbp        0.5%    3.3%       3.7    GCF_015548395.1 Parabacteroides dist...
1.6 Mbp        2.3%    5.1%      24.6    GCA_905199165.1 Faecalibacterium pra...
3.5 Mbp        0.2%    1.9%       2.8    GCA_009678725.1 Parabacteroides dist...
2.1 Mbp        0.1%    1.5%       1.9    GCF_009020375.1 Bacteroides uniformi...
3.3 Mbp        0.2%    1.5%       3.6    GCF_015552355.1 Parabacteroides dist...
1.6 Mbp        1.4%    2.4%      25.2    GCF_000166035.1 Faecalibacterium cf....
4.0 Mbp        0.3%    1.1%       7.3    GCF_009024655.1 Bacteroides fragilis...
1.6 Mbp        1.0%    1.9%      25.3    GCA_019425405.1 Faecalibacterium sp....
found less than 50.0 kbp in common. => exiting
```

Points to make:

* 
* @CTB: add venn diagram

Prepare the taxonomic lineages file so that the commands run fast:

```
sourmash tax prepare -t /group/ctbrowngrp/sourmash-db/gtdb-rs214/gtdb-rs214.lineages.csv -F sql -o gtdb-rs214.lineages.sqldb
```

Now let's generate a taxonomic analysis at the species level:

```
sourmash tax metagenome -g CD136.x.gtdb-rs214.gather.csv  -t gtdb-rs214.lineages.sqldb -F human
```

You should see:
```
sample name    proportion   cANI   lineage
-----------    ----------   ----   -------
CD136             41.0%     92.5%  d__Bacteria;p__Bacillota_A;c__Clostridia;o__Oscillospirales;f__Ruminococcaceae;g__Faecalibacterium;s__Faecalibacterium prausnitzii_D
CD136             27.8%     95.1%  d__Bacteria;p__Bacteroidota;c__Bacteroidia;o__Bacteroidales;f__Bacteroidaceae;g__Bacteroides;s__Bacteroides fragilis
CD136             14.1%     -      unclassified
CD136             12.4%     94.7%  d__Bacteria;p__Bacteroidota;c__Bacteroidia;o__Bacteroidales;f__Tannerellaceae;g__Parabacteroides;s__Parabacteroides distasonis
CD136              4.6%     93.7%  d__Bacteria;p__Bacteroidota;c__Bacteroidia;o__Bacteroidales;f__Bacteroidaceae;g__Bacteroides;s__Bacteroides uniformis
```

we can also roll this up from species to other taxonomic ranks, like
class, by adding `-r <rank>`:

```
sourmash tax metagenome -g CD136.x.gtdb-rs214.gather.csv  -t gtdb-rs214.lineages.sqldb  -F human -r class
```

```
sample name    proportion   cANI   lineage
-----------    ----------   ----   -------
CD136             44.9%     98.0%  d__Bacteria;p__Bacteroidota;c__Bacteroidia
CD136             41.0%     92.5%  d__Bacteria;p__Bacillota_A;c__Clostridia
CD136             14.1%     -      unclassified
```

things to discuss:

* what does "unclassified" mean?
* what is cANI? (what is ANI!)
