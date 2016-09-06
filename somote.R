overIntraCluster <- function(X, overNum = 0, k) {
  library(FNN)
  XOver <- NULL
  overInd <- sample(nrow(X), size = overNum, replace = (nrow(X) < overNum))
  k <- min(k, nrow(X))
  nnMat <- knnx.index(data = X, query = X[overInd, ], k)
  indMat <- matrix(c(nnMat[, 1], apply(matrix(nnMat[, -1], nrow = nrow(nnMat)), 1, function(x) x[sample(k - 1, 1)])), nrow = overNum, byrow = FALSE)
  for (i in 1:nrow(indMat)) {
    XOver <- rbind(XOver, X[indMat[i, 1], ] + runif(1) * (X[indMat[i, 2], ] - X[indMat[i, 1], ]))
  }
  return(XOver)
}

overInterCluster <- function(X1, X2, overNum = 0) {
  library(FNN)
  XOver <- NULL
  overInd1 <- sample(nrow(X1), size = overNum, replace = (nrow(X1) < overNum))
  overInd2 <- sample(nrow(X2), size = overNum, replace = (nrow(X2) < overNum))
  indMat <- matrix(c(overInd1, overInd2), nrow = overNum, byrow = FALSE)
  for (i in 1:nrow(indMat)) {
    XOver <- rbind(XOver, X1[indMat[i, 1], ] + runif(1) * (X2[indMat[i, 2], ] - X1[indMat[i, 1], ]))
  }
  return(XOver)
}

somNeighbors <- function(clID, somModel) {
  gridDim <- somModel$grid$xdim
  if (length((ceiling(clID / gridDim) %% 2) == 1) > 0) {
    if ((ceiling(clID / gridDim) %% 2) == 1) {
      diff <- c(ifelse(clID %% gridDim != 1, -1, NA),
                ifelse(clID %% gridDim != 0, 1, NA), gridDim, -gridDim, 
                ifelse(clID %% gridDim != 0, gridDim + 1, NA),
                ifelse(clID %% gridDim != 0, 1 - gridDim, NA))
    } else {
      diff <- c(ifelse(clID %% gridDim != 1, -1, NA),
                ifelse(clID %% gridDim != 0, 1, NA), gridDim, -gridDim, 
                ifelse(clID %% gridDim != 1, gridDim - 1, NA),
                ifelse(clID %% gridDim != 1, -gridDim -1, NA))
    }
    diff <- diff[!is.na(diff)]
    clNeigh <- clID + diff
    clNeigh <- clNeigh[clNeigh > 0 & clNeigh <= gridDim ^2]
  } else {
    clNeigh <- NULL
  }
  return(clNeigh)
}

somote <- function(ds, overNum = 0, ratio = 0.7, k = 3, onlyNewCases = FALSE) {
  library(kohonen)
  library(proxy)
  dsUpIntra <- NULL
  dsUpInter <- NULL
  dsUp <- NULL
  p <- ncol(ds)
  if (overNum > 0 & sum(ds[, p] == 1) > 0) {
    N_intra <- round(ratio * overNum)
    N_inter <- overNum - N_intra
    gridDim <- floor(sqrt(sum(ds[, p] == 1)))
    somGrid <- somgrid(xdim = gridDim, ydim = gridDim, topo="hexagonal")
    somModel <- som(data = as.matrix(ds[, -p]), grid=somGrid, alpha=c(0.05, 0.001), rlen = 200, n.hood = "circular")
    crossTable <- table(somModel$unit.classif, ds[, p])
    IR <- (crossTable[, 1] + 1) / (crossTable[, 2] + 1)
    cl_f <- as.numeric(names(IR)[IR < 1])
    if (length(cl_f) > 0) {
      clustersList <- list()
      denClusters <- c()
      denIntraClusters <- c()
      denInterClusters <- c()
      for (i in cl_f) {
        inCluster <- ds[somModel$unit.classif == i, ]
        inClusterPos <- unique(inCluster[inCluster[, p] == 1, -p])
        clustersList[[as.character(i)]] <- inClusterPos
        clTotalDist <- sum(dist(inClusterPos))
        denClusters[as.character(i)] <- (nrow(inClusterPos) ^ 3) / clTotalDist
      }
      denIntraClusters <- denClusters[is.finite(denClusters)]
      if (length(denClusters[is.finite(denClusters)]) > 0) {
        denClusters[is.infinite(denClusters)] <- max(denClusters[is.finite(denClusters)])
      } else {
        denClusters[is.infinite(denClusters)] <- rep(1, length(denClusters))
      }
      for (i in cl_f) {
        for (j in cl_f[cl_f > i]) {
          if (j %in% somNeighbors(i, somModel)) {
            denInterClusters[paste(as.character(i), as.character(j), sep = "-")] <- denClusters[as.character(i)] + denClusters[as.character(j)]
          }
        }
      }
      if (length(denIntraClusters) > 0) {
        w_intra <- (denIntraClusters ^ (-1)) / sum(denIntraClusters ^ (-1))
      } else {
        w_intra <- NULL
      }
      if (length(denInterClusters) > 0) {
        w_inter <- (denInterClusters ^ (-1)) / sum(denInterClusters ^ (-1))
      } else {
        w_inter <- NULL
      }
      
      intraNumVec <- round(N_intra * w_intra)
      names(intraNumVec) <- names(w_intra)
      intraNumVec <- intraNumVec[intraNumVec > 0]
      interNumVec <- round(N_inter * w_inter)
      names(interNumVec) <- names(w_inter)
      interNumVec <- interNumVec[interNumVec > 0]
      
      intraNewCases <- list()
      for (name in names(intraNumVec)) {
        X <- clustersList[[name]]
        intraNewCases[[name]] <- overIntraCluster(X, overNum = intraNumVec[name], k)
      }
      
      interNewCases <- list()
      for (name in names(interNumVec)) {
        name1 <- gsub("-.+", "", name)
        name2 <- gsub(".+-", "", name)
        X1 <- clustersList[[name1]]
        X2 <- clustersList[[name2]]
        interNewCases[[name]] <- overInterCluster(X1, X2, overNum = interNumVec[name])
      }
      
      for (partialDs in intraNewCases) {
        dsUpIntra <- rbind(dsUpIntra, partialDs)
      }
      for (partialDs in interNewCases) {
        dsUpInter <- rbind(dsUpInter, partialDs)
      }
      
    }
  }
  if (!is.null(dsUpIntra) | !is.null(dsUpInter)) {
    dsUp <- cbind(rbind(dsUpIntra, dsUpInter), 1)
    names(dsUp) <- names(ds)
  }
  if (onlyNewCases) {
    ds <- dsUp
  } else {
    ds <- rbind(ds, dsUp)
  }
  row.names(ds) <- 1:nrow(ds)
  return(ds)
}