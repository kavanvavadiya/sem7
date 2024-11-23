import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from scipy.spatial.distance import mahalanobis


def compute_euclidean_norm(point, center1, center2):
    dist1 = np.linalg.norm(point - center1)
    dist2 = np.linalg.norm(point - center2)
    return dist1, dist2

def compute_mahalanobis_norm(point, center1, center2, cov_matrix):
    dist1 = mahalanobis(point, center1, np.linalg.inv(cov_matrix))
    dist2 = mahalanobis(point, center2, np.linalg.inv(cov_matrix))
    return dist1, dist2

def visualize_plot_clusters(cluster1, cluster2, center1, center2, point):

    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')
    
    ax.scatter(cluster1[:, 0], cluster1[:, 1], cluster1[:, 2], c='g', label='3D Cluster 1', alpha=0.5)
    ax.scatter(cluster2[:, 0], cluster2[:, 1], cluster2[:, 2], c='r', label='3D Cluster 2', alpha=0.5)
    
    ax.scatter(center1[0], center1[1], center1[2], c='g', marker='x', s=150, label='Center 1')
    ax.scatter(center2[0], center2[1], center2[2], c='r', marker='x', s=150, label='Center 2')
    
    ax.scatter(point[0], point[1], point[2], marker='o', label='Input Point')
    
    ax.set_xlabel('X axis')
    ax.set_ylabel('Y axis')
    ax.set_zlabel('Z axis')
    ax.legend()
    plt.show()

def main():
   
    firstFileName = '3D_cluster1.csv'
    secondFileName = '3D_cluster2.csv'
    
    firstCulster = pd.read_csv(firstFileName).values
    secondtCulster = pd.read_csv(secondFileName).values

    centerOfFirst = np.mean(firstCulster, axis=0)
    centerOfSecond = np.mean(secondtCulster, axis=0)

    covMatrix = np.cov(np.vstack([firstCulster, secondtCulster]), rowvar=False)

    input_point = np.array([5,5,5])  

    firstEuclideanDistance, secondEuclideanDistance = compute_euclidean_norm(input_point, centerOfFirst, centerOfSecond)
    firstMahalanobisDistance, secondMahalanobisDistance = compute_mahalanobis_norm(input_point, centerOfFirst, centerOfSecond,covMatrix)
    

    print(f"Euclidean Distance to Cluster 1 Center: {firstEuclideanDistance}")
    print(f"Euclidean Distance to Cluster 2 Center: {secondEuclideanDistance}")
    print(f"Mahalanobis Distance to Cluster 1 Center: {firstMahalanobisDistance}")
    print(f"Mahalanobis Distance to Cluster 2 Center: {secondMahalanobisDistance}")

    
    # Visualization
    visualize_plot_clusters(firstCulster, secondtCulster, centerOfFirst, centerOfSecond, input_point)

if __name__ == "__main__":
    main()
