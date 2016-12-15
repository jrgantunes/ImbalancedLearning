# Functions to generate data and time nearest neighbours algorithms

# Load packages
library(microbenchmark)

# Function to time nearest neighbours algorithm
timeAlgorithm <- function(inputMatrix, queryMatrix, k, knnFunction, numEvaluations, ...) {
  
  # Calculates statistics for the execution time of a nearest 
  # neighbour algorithm that uses the knnFunction for k neighbours, 
  # inputMatrix as the input matrix and queryMatrix as the query
  # matrix. The process is repeated numEvaluations times.
  #
  # Args:
  #   inputMatrix: The input matrix.
  #   queryMatrix: The query matrix.
  #   k: The number of nearest neighbours.
  #   knnFunction: The nearest neighbour function.
  #   numEvaluations: The number of experiment evaluations.
  #
  # Returns:
  #   An object of class "microbenchmark".
  
  timingResults <- microbenchmark(knnFunction(inputMatrix, queryMatrix, k, ...), times = numEvaluations)
  return(timingResults)
}