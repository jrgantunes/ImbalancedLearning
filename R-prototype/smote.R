smote <- function(ds, overNum = 0, k = 4, onlyNewCases = FALSE) {
  require(unbalanced)
  dsUp <- NULL
  p <- ncol(ds)
  if (overNum > 0) {
    dsUp <- ubSmoteExs(ds[ds[, p] == 1, ], p, N = 100 * overNum / sum(ds[, p] == 1), k)
    dsUp <- dsUp[apply(dsUp, 1, function(x) sum(is.na(x)) == 1), ]
    if (nrow(dsUp) > 0) {
      dsUp[, p] <- 1
    }
  }
  if (onlyNewCases) {
    ds <- dsUp
  } else {
    ds <- rbind(ds, dsUp)
  }
  row.names(ds) <- 1:nrow(ds)
  return(ds)
}