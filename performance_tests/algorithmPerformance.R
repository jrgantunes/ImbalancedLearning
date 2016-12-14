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
  
  set.seed((randomSeed))
  inputMatrix <- matrix(rep(1:numSamples), numFeatures, nrow = numSamples)
  
  shuffledIndices <- sample(numSamples)
  inputMatrix <- inputMatrix[shuffledIndices, ]
  
  queriesIndices <- sample(numSamples, numQueries)
  queriesMatrix <- inputMatrix[queriesIndices, , drop = FALSE]
  
  return(list(inputMatrix = inputMatrix, queriesMatrix = queriesMatrix))
}