# Functions to generate data and time nearest neighbours algorithms

# Load packages
library(FNN)
library(microbenchmark)

# Functions to generate data
generateSequentialData <- function(numSamples, numFeatures, numQueries, randomSeed) {
  
  # Generates a matrix and a random query index. Every row of the 
  # matrix is a vector of dimension equal to numFeatures and a
  # constant value equal to the row number. The matrix rows are
  # shuffled such that the performance results of the nearest
  # neighbours algorithm do not depend on the particular structure
  # of the generated matrix.
  #
  # Args:
  #   numSamples: The number of rows for the generated matrix.
  #   numFeatures: The number of columns for the generated matrix.
  #   randomSeed: The random state used in sample functions.
  #
  # Returns:
  #   A list which contains the inputMateix and an index for the query sample.
  
  # Set random state
  set.seed((randomSeed))
  
  # Create sequential matrix
  inputMatrix <- matrix(rep(1:numSamples), numFeatures, nrow = numSamples)
  
  # Shuffle matrix rows
  shuffledIndices <- sample(numSamples)
  inputMatrix <- inputMatrix[shuffledIndices, ]
  
  # Choose a random query matrix
  queriesIndices <- sample(numSamples, numQueries)
  queryMatrix <- inputMatrix[queriesIndices, , drop = FALSE]
  
  return(list(inputMatrix = inputMatrix, queryMatrix = queryMatrix))
}