#! /usr/bin/env python
import sys
import argparse
import numpy as np
from sklearn.manifold import MDS
import matplotlib.pyplot as plt
from scipy.sparse import lil_matrix, csr_matrix

def create_sparse_similarity_matrix(tuples, num_objects):
    # Initialize matrix in LIL format for efficient setup
    similarity_matrix = lil_matrix((num_objects, num_objects))

    for obj1, obj2, similarity in tuples:
        similarity_matrix[obj1, obj2] = similarity
        if obj1 != obj2:
            similarity_matrix[obj2, obj1] = similarity

    # Ensure diagonal elements are 1
    similarity_matrix.setdiag(1)

    # Convert to CSR format for efficient operations later
    return similarity_matrix.tocsr()


def plot_mds_sparse(matrix):
    # Convert sparse similarity to dense dissimilarity matrix
    #dissimilarities = 1 - matrix.toarray()
    dissimilarities = 1 - matrix
    mds = MDS(n_components=2, dissimilarity='precomputed', random_state=42)
    mds_coords = mds.fit_transform(dissimilarities)
    plt.scatter(mds_coords[:, 0], mds_coords[:, 1])
    plt.title('MDS Plot')
    plt.xlabel('Dimension 1')
    plt.ylabel('Dimension 2')


def main():
    p = argparse.ArgumentParser()
    p.add_argument('comparison_matrix')
    p.add_argument('-o', '--output-figure', required=True)
    args = p.parse_args()

    with open(args.comparison_matrix, 'rb') as f:
        mat = np.load(f)

    # Example usage
    # Assume object indices instead of names for simplicity
    #similarity_tuples = [(0, 1, 0.7), (0, 2, 0.4), (1, 2, 0.5)]
    #num_objects = 3  # You should know the total number of objects
    #sparse_matrix = create_sparse_similarity_matrix(similarity_tuples, num_objects)
    plot_mds_sparse(mat)

    plt.savefig(args.output_figure)


if __name__ == '__main__':
    sys.exit(main())
