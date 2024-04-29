# 2024-pig-paradigm-workshop

## Installation / building the site

```
mamba env create -n nnf-workshop -f environment.yml
mamba activate nnf-workshop
pip install -r requirements.txt
```

and then either `mkdocs build` or `mkdocs serve`.

Note, the website at
[ngs-docs.github.io/2024-pig-paradigm-workshop/](https://ngs-docs.github.io/2024-pig-paradigm-workshop/)
will automatically build and deploy on merge to main.
