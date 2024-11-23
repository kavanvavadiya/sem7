import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from scipy.spatial.distance import mahalanobis

def load_cluster_data(file1_path, file2_path):
    """ Load cluster data from CSV files. """
    cluster1_data = pd.read_csv(file1_path).values
    cluster2_data = pd.read_csv(file2_path).values
    return cluster1_data, cluster2_data

def calculate_norms(point, center1, center2, covariance_matrix):
    """ Calculate Euclidean and Mahalanobis distances. """
    euclidean_distance1 = np.linalg.norm(point - center1)
    euclidean_distance2 = np.linalg.norm(point - center2)
    
    inverse_cov_matrix = np.linalg.inv(covariance_matrix)
    mahalanobis_distance1 = mahalanobis(point, center1, inverse_cov_matrix)
    mahalanobis_distance2 = mahalanobis(point, center2, inverse_cov_matrix)
    
    return euclidean_distance1, euclidean_distance2, mahalanobis_distance1, mahalanobis_distance2

def plot_clusters(cluster1_data, cluster2_data, center1, center2, input_point):
    """ Create a 3D plot of the clusters, centers, and input point. """
    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')
    
    # Plot cluster points
    ax.scatter(cluster1_data[:, 0], cluster1_data[:, 1], cluster1_data[:, 2], c='b', label='Cluster 1', alpha=0.5)
    ax.scatter(cluster2_data[:, 0], cluster2_data[:, 1], cluster2_data[:, 2], c='r', label='Cluster 2', alpha=0.5)
    
    # Plot cluster centers
    ax.scatter(center1[0], center1[1], center1[2], c='b', marker='x', s=100, label='Center 1')
    ax.scatter(center2[0], center2[1], center2[2], c='r', marker='x', s=100, label='Center 2')
    
    # Plot input point
    ax.scatter(input_point[0], input_point[1], input_point[2], c='g', marker='o', s=100, label='Input Point')
    
    # Add plot details
    ax.set_xlabel('X axis')
    ax.set_ylabel('Y axis')
    ax.set_zlabel('Z axis')
    ax.legend()
    plt.show()

def main():
    # Load the cluster data from CSV files
    cluster1_data, cluster2_data = load_cluster_data("3D_cluster1.csv", "3D_cluster2.csv")
    
    # Compute the centers of the clusters
    center1 = np.mean(cluster1_data, axis=0)
    center2 = np.mean(cluster2_data, axis=0)
    
    # Calculate the covariance matrix of all data
    combined_data = np.vstack([cluster1_data, cluster2_data])
    covariance_matrix = np.cov(combined_data, rowvar=False)
    
    # Define an input point for distance calculations
    input_point = np.array([2, 2, 2])
    
    # Compute distances
    euclidean_dist1, euclidean_dist2, mahalanobis_dist1, mahalanobis_dist2 = calculate_norms(
        input_point, center1, center2, covariance_matrix
    )
    
    # Print the calculated distances
    print(f"Euclidean Distance to Cluster 1 Center: {euclidean_dist1:.2f}")
    print(f"Euclidean Distance to Cluster 2 Center: {euclidean_dist2:.2f}")
    print(f"Mahalanobis Distance to Cluster 1 Center: {mahalanobis_dist1:.2f}")
    print(f"Mahalanobis Distance to Cluster 2 Center: {mahalanobis_dist2:.2f}")
    
    # Plot clusters and input point
    plot_clusters(cluster1_data, cluster2_data, center1, center2, input_point)

if __name__ == "__main__":
    main()
