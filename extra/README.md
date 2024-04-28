## Making venn diagram in single-metagenome-taxonomy.md

```
sourmash sig grep "GCF_000598785.2" databases/gtdb-rs214-k31.zip -o GCF_000598785.2.sig.zip
sourmash sig grep "GCA_023708525.1" databases/gtdb-rs214-k31.zip -o GCA_023708525.1.sig.zip

sourmash sig rename GCF_000598785.2.sig.zip "B. fragilis I1345" -o B.fragilis.sig.zip
sourmash sig rename GCA_023708525.1.sig.zip "F. prausnitzii" -o F.prausnitzii.sig.zip

pip install sourmash_plugin_venn

sourmash scripts venn -k 31 CD136.sig.zip B.fragilis.sig.zip F.prausnitzii.sig.zip -o CD136-venn.png
```

## Making abundhist in single-metagenome-taxonomy.md

```
pip install sourmash_plugin_abundhist
sourmash scripts abundhist CD136.sig.zip --max 50 --bins 20 --figure CD136-abundance.png --ymax 4000
```
