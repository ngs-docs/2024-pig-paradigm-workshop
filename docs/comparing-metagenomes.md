# Comparing metagenomes

## Comparing based on content

* reference free, annotation free @CTB

Here we are going to use the
[`sourmash plot`](https://sourmash.readthedocs.io/en/latest/command-line.html#sourmash-plot-cluster-and-visualize-comparisons-of-many-signatures)
command to compare and cluster many metagenomes based on their content.

As with the [single metagenome analysis](single-metagenomes-taxonomy.md), we have two options here: with, or without abundance information.

If we use abundance information, we will be comparing the genomic
*diversity* of the data set.  In this kind of comparison, if two
samples have the same dominant species, but many different species
at lower abundances, the two samples will appear to be quite similar.

If we discard abundance information and just focus on genomic content,
we will be looking at *richness*. In this kind of comparison, samples
with similar dominant species but many lower abundance species will look
very different.

<!-- @CTB we could do a gather of a different sample here, and show case. -->

### Non abundance-weighted comparison of species composition & richness

Let's first compare all of the samples without abundances.

Run:
```
sourmash compare CD*.sig.zip -o compare.flat.cmp -k 31 --ignore-abund
```

and then plot.

Run:
```
sourmash plot compare.flat.cmp
```

You will get a file `compare.flat.cmp.matrix.png` that looks like this:

![unweighted (flat) sample comparison matrix](images/compare.flat.cmp.matrix.png))

Points to discuss:

* neither the distance matrix nor the dendrogram on the left show strong
  signs of clustering.
  
You can convert the distance matrix to an MDS plot where you will see that
there is no clear clustering there either, of course (since it's a different
view of the same data).

@CTB provide command.

![unweighted (flat) MDS plot](images/compare.flat.mds.png)

### Abundance-weighted comparison of diveristy

Now let's compare the samples using content abundance.

Run:
```
sourmash compare CD*.sig.zip -o compare.abund.cmp -k 31
```



And then plot.

Run:
```
sourmash plot compare.abund.cmp
```

![abundance-weighted sample comparison matrix](images/compare.abund.cmp.matrix.png)

Points to discuss:

* unlike the previous figures, here we see a clear set of clustering that
  corresponds to sample origin.

If you plot this via MDS, you'll see the same thing:

![weighted (abund) MDS plot](images/compare.abund.mds.png)

<!--

## Comparing based on taxonomy


```
mamba create -y -n workshop-r r-base r-tidyverse r-vegan r-ape r-rcolorbrewer

```

-->
