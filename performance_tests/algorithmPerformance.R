# Functions to generate data and time nearest neighbours algorithms

# Load packages
library(FNN)
library(microbenchmark)

# Functions to generate data
generateSequentialData <- function(numSamples, numFeatures, randomSeed) {
  
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
  
  set.seed((randomSeed))
  inputMatrix <- matrix(rep(1:numSamples), numFeatures, nrow = numSamples)
  shuffledIndices <- sample(nrow(inputMatrix))
  queryIndex <- sample(nrow(inputMatrix), 1)
  inputMatrix <- inputMatrix[shuffledIndices, ]
  return(list(inputMatrix = inputMatrix, queryIndex = queryIndex))
}

# Functions to time nearest neighbours algorithm
