#! /usr/bin/env python
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import sys
import argparse


def main():
    p = argparse.ArgumentParser()
    p.add_argument('df')
    p.add_argument('-o', '--output-figure', required=True)
    args = p.parse_args()

    df = pd.read_csv(args.df, sep = '\t')
    df_all = df.Class.value_counts().to_frame().reset_index()
    figure = sns.barplot(data=df_all, x="count", y="Class", hue="Class", legend=False)
    figure.figure.set_size_inches(15,5)
    figure.figure.savefig(args.output_figure)



if __name__ == '__main__':
    sys.exit(main())