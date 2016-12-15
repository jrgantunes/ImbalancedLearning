# Load packages and functions
library(FNN)
for (file in c("genDataFuncs.R", "timeAlgsFuncs.R")) source(file)  # Set working directory to ImbalancedLearning/performance_tests

# Generate sequential data
seqData <- genSeqData(numSamples = 10000, numFeatures = 10, numQueries = 5, randomSeed = 1)

# Timing of algorithm
timeAlg <- timeAlgorithm(inputMatrix = seqData$inputMatrix, 
                         queryMatrix = seqData$queryMatrix, 
                         k = 5,
                         knnFunction = knnx.index,
                         numEvaluations = 10)