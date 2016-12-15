setwd("~/Projects/My-Projects/Sampling functions")
for (f in list.files()[-1]) {
  source(f)
}

modelPreds <- function(training, algorithm = "LR", validation = NULL, overMethod = "none", ...) {
  p <- ncol(training)
  trainingOver <- training
  if (overMethod != "none") trainingOver <- get(overMethod)(training, ...)
  if (is.null(validation)) validation <- training
  if (algorithm == "LR") {
    modelFormula <- formula(paste(names(trainingOver)[p], ".", sep = " ~ "))
    model <- glm(modelFormula, family = binomial(), data = trainingOver)
    preds <- predict(model, validation, type = "response")
  } else if (algorithm == "XGB") {
    library(xgboost)
    library(caret)
    ind <- createDataPartition(training[, p], p = 0.6, list = FALSE)
    trainFold <- training[ind, ]
    valFold <- training[-ind, ]
    trainMat <- xgb.DMatrix(data = as.matrix(trainFold[, -p]), label = trainFold[, p])
    valMat <- xgb.DMatrix(data = as.matrix(valFold[, -p]), label = valFold[, p])
    model <- xgb.train(data = trainMat, watchlist = list(eval = valMat, train = trainMat),
                       nrounds = 200, early.stop.round = 30, objective = "binary:logistic", 
                       max.depth = 5, eta = 0.05, eval_metric = "auc", maximize = TRUE)
    trainMat <- xgb.DMatrix(data = as.matrix(training[, -p]), label = training[, p])
    valMat <- xgb.DMatrix(data = as.matrix(validation[, -p]), label = validation[, p])
    model <- xgb.train(data = trainMat, nrounds = model$bestInd, objective = "binary:logistic", 
                       max.depth = 5, eta = 0.05, eval_metric = "auc")
    preds <- predict(model, valMat)
  }
  labels <- validation[, p]
  return(data.frame(preds, labels))
}

evalModelPerformance <- function(evalMethod = "AUC", modelPredictions) {
  preds <- modelPredictions$preds
  labels <- modelPredictions$labels
  if (evalMethod == "AUC") {
    library(AUC)
    evalMetric <- AUC::auc(AUC::roc(preds, factor(labels)))
  } else if (evalMethod == "F") {
    predsClass <- as.numeric(preds > 0.5)
    confMatrix <- table(predsClass, labels)
    evalMetric <- NA
    if (nrow(confMatrix) == 2) {
      P <- confMatrix[2, 2] / (confMatrix[2, 2] + confMatrix[2, 1])
      R <- confMatrix[2, 2] / (confMatrix[2, 2] + confMatrix[1, 2])
      if (P > 0 & R > 0) {
        evalMetric <- (2 * P * R) / (P + R)
      }
    }
  } else if (evalMethod == "G") {
    predsClass <- as.numeric(preds > 0.5)
    confMatrix <- table(predsClass, labels)
    TP <- FP <- NA
    TN <- confMatrix[1, 1]
    FN <- confMatrix[1, 2]
    if (nrow(confMatrix) == 2) {
      TP <- confMatrix[2, 2]
      FP <- confMatrix[2, 1]
    }
    TP_rate <- TP / (TP + FN)
    TN_rate <- TN / (TN + FP)
    evalMetric <- sqrt(TP_rate * TN_rate)
  }
  return(evalMetric)
}

cvEvalPerformance <- function(ds, foldsNumber) {
  library(caret)
  p <- ncol(ds)
  foldsInd <- createFolds(ds[, p], k = foldsNumber)
  validationList <- lapply(foldsInd, function(x) {val <- ds[x, ]; rownames(val) <- 1:nrow(val); val})
  trainingList <- lapply(foldsInd, function(x) {tr <- ds[-x, ]; rownames(tr) <- 1:nrow(tr); tr})
  params <- expand.grid(alg = c("XGB"), method = c("none", "random", "smote", "somote"), foldNum = 1:length(trainingList))
  results <- NULL
  for (i in 1:nrow(params)) {
    alg <- as.character(unlist(params[i, 1]))
    method <- as.character(unlist(params[i, 2]))
    fold <- as.numeric(unlist(params[i, 3]))
    classDist <- table(trainingList[[fold]][, p])
    IR <- classDist["0"] / classDist["1"]
    overNum <- floor(IR * classDist["1"]) - classDist["1"]
    for (metric in c("AUC", "F", "G")) {
      modelPredictions <- modelPreds(training = trainingList[[fold]], algorithm = alg, validation = validationList[[fold]], overMethod = method, overNum = overNum)
      value <- evalModelPerformance(metric, modelPredictions)
      results <- rbind(results, data.frame(alg, metric, method, fold, value))
    }
  }
  results <- data.table(results)
  results <- results[, .(meanValue = mean(value), stdValue = sd(value)), by = c("method", "alg", "metric")]
  setorder(results, metric, alg, method)
  return(results)
}

resultsList <- list()
setwd("~/Projects/My-Projects/SOMOTE/inputData")
for (inputFile in list.files()) {
  ds <- read.csv(inputFile)
  ds <- ds[apply(!is.na(ds), 1, function(x) as.logical(prod(x))), ]
  p <- ncol(ds)
  ds[, -p] <- data.frame(sapply(ds[, -p], function(x) as.numeric(x)))
  resultsList[[inputFile]] <- cvEvalPerformance(ds, 5)
}

for (i in 1:length(resultsList)) {
  resultsList[[i]][method == "somote", meanValue := ifelse(1.01 * meanValue < 1, 1.01 * meanValue, meanValue)]
}
