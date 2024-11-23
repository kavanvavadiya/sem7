import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from scipy.spatial.distance import mahalanobis

def read_clusters(file1, file2):
    """ Read cluster data from CSV files. """
    cluster1 = pd.read_csv(file1).values
    cluster2 = pd.read_csv(file2).values
    return cluster1, cluster2

def compute_norms(point, center1, center2, cov_matrix):
    """ Compute Euclidean and Mahalanobis norms. """
    euclidean_dist1 = np.linalg.norm(point - center1)
    euclidean_dist2 = np.linalg.norm(point - center2)
    
    inv_cov_matrix = np.linalg.inv(cov_matrix)
    mahalanobis_dist1 = mahalanobis(point, center1, inv_cov_matrix)
    mahalanobis_dist2 = mahalanobis(point, center2, inv_cov_matrix)
    
    return euclidean_dist1, euclidean_dist2, mahalanobis_dist1, mahalanobis_dist2

def visualize_clusters(cluster1, cluster2, center1, center2, point):
    """ Visualize the clusters and the input point in 3D. """
    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')
    
    # Plot clusters
    ax.scatter(cluster1[:, 0], cluster1[:, 1], cluster1[:, 2], c='b', label='Cluster 1', alpha=0.5)
    ax.scatter(cluster2[:, 0], cluster2[:, 1], cluster2[:, 2], c='r', label='Cluster 2', alpha=0.5)
    
    # Plot cluster centers
    ax.scatter(center1[0], center1[1], center1[2], c='b', marker='x', s=100, label='Center 1')
    ax.scatter(center2[0], center2[1], center2[2], c='r', marker='x', s=100, label='Center 2')
    
    # Plot input point
    ax.scatter(point[0], point[1], point[2], c='g', marker='o', s=100, label='Input Point')
    
    # Add labels and legend
    ax.set_xlabel('X axis')
    ax.set_ylabel('Y axis')
    ax.set_zlabel('Z axis')
    ax.legend()
    plt.show()

def main():
    # File paths
    file1 = '3D_cluster1.csv'  # Path to the CSV file for Cluster 1
    file2 = '3D_cluster2.csv'  # Path to the CSV file for Cluster 2
    
    # Read data
    cluster1, cluster2 = read_clusters(file1, file2)
    
    # Compute cluster centers
    center1 = np.mean(cluster1, axis=0)
    center2 = np.mean(cluster2, axis=0)
    
    # Compute covariance matrix
    all_data = np.vstack([cluster1, cluster2])
    cov_matrix = np.cov(all_data, rowvar=False)
    
    # Input point
    input_point = np.array([2, 2, 2])
    
    # Compute norms
    euclidean_dist1, euclidean_dist2, mahalanobis_dist1, mahalanobis_dist2 = compute_norms(
        input_point, center1, center2, cov_matrix
    )
    
    print(f"Euclidean Distance to Cluster 1 Center: {euclidean_dist1:.2f}")
    print(f"Euclidean Distance to Cluster 2 Center: {euclidean_dist2:.2f}")
    print(f"Mahalanobis Distance to Cluster 1 Center: {mahalanobis_dist1:.2f}")
    print(f"Mahalanobis Distance to Cluster 2 Center: {mahalanobis_dist2:.2f}")
    
    # Visualization
    visualize_clusters(cluster1, cluster2, center1, center2, input_point)

if __name__ == "__main__":
    main()
