import random
import math

def gaussian_random(mean, stddev):
    """Generate a random number with a Gaussian distribution."""
    u1 = random.random()
    u2 = random.random()
    z = math.sqrt(-2 * math.log(u1)) * math.cos(2 * math.pi * u2)
    return mean + z * stddev

def generate_random_vectors(m, N):
    """Generate m random N-dimensional vectors with Gaussian distribution."""
    vectors = []
    variance = 1 / N
    stddev = math.sqrt(variance)
    for _ in range(m):
        vector = [gaussian_random(0, stddev) for _ in range(N)]
        vectors.append(vector)
    return vectors

def calculate_distance(vector):
    """Calculate the Euclidean distance of a vector from the origin."""
    return math.sqrt(sum(x ** 2 for x in vector))

def calculate_angle(vector1, vector2):
    """Calculate the angle between two vectors in radians."""
    dot_product = sum(x * y for x, y in zip(vector1, vector2))
    norm1 = calculate_distance(vector1)
    norm2 = calculate_distance(vector2)
    if norm1 == 0 or norm2 == 0:
        raise ValueError("Cannot calculate angle with zero-length vector.")
    cos_theta = dot_product / (norm1 * norm2)
    # Clip cos_theta to avoid numerical issues with arccos
    cos_theta = max(-1.0, min(1.0, cos_theta))
    return math.acos(cos_theta)

if __name__ == "__main__":
    m = 5  # Number of vectors
    N = 3  # Dimension of each vector
    
    # Generate random vectors
    vectors = generate_random_vectors(m, N)
    
    # Calculate distances from the origin
    distances = [calculate_distance(vector) for vector in vectors]
    print("Distances from the origin:", distances)
    
    # Calculate angles between pairs of vectors
    angles = [[0] * m for _ in range(m)]
    for i in range(m):
        for j in range(i + 1, m):
            angle = calculate_angle(vectors[i], vectors[j])
            angles[i][j] = angle
            angles[j][i] = angle
    
    print("Angles between pairs of vectors (in radians):")
    for row in angles:
        print(row)