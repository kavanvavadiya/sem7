import random
import math

def vector_genrator(m,N):
    '''creating vectors'''
    vectors = []
    mean = 0
    standardDeviation = math.sqrt(1/N)
    for i in range(m):
        vector = [gaussian_random(mean, standardDeviation) for _ in range(N)]
        vectors.append(vector)
    return vectors
def gaussian_random(mean, stddev):
    u1 = random.random()
    u2 = random.random()
    z = math.sqrt(-2 * math.log(u1)) * math.cos(2 * math.pi * u2)
    return mean + z * stddev

def calculate_distance(vector):
    """Calculate the Euclidean distance of a vector from the origin."""
    return math.sqrt(sum(x ** 2 for x in vector))

def calculate_angle(vector1, vector2):
    """Calculate the angle between two vectors in radians."""
    dot_product = sum(x * y for x, y in zip(vector1, vector2))
    norm1 = calculate_distance(vector1)
    norm2 = calculate_distance(vector2)
    if norm1 == 0 or norm2 == 0:
        return
    cos_theta = dot_product / (norm1 * norm2)
    cos_theta = max(-1.0, min(1.0, cos_theta))
    return math.acos(cos_theta)

if __name__ == "__main__":
    '''Write and upload a Python program that generates m random N-dimensional vectors where each coordinate of a vector follows a Gaussian distribution with zero mean and 1/N variance. The program should then calculates the distance of each vector from the origin and the angle between each pair of vectors'''

    '''Taking m random vectors of dimentions N '''
    m = 4 # for eg. taking 4 random vectors
    N = 7 # for eg. taking each vectors of N dimentionals
    genratedVectors = vector_genrator(m,N)
    distances = [calculate_distance(vector) for vector in genratedVectors]
    print("Distances from the origin:", distances)
    
    angles = [[0] * m for _ in range(m)]
    for i in range(m):
        for j in range(i + 1, m):
            angle = calculate_angle(genratedVectors[i], genratedVectors[j])
            angles[i][j] = angle
            angles[j][i] = angle
    
    print("Angles between pairs of vectors in radians:")
    for angle in angles:
        print(angle)