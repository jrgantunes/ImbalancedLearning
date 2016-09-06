random <- function(ds, overNum = 0, onlyNewCases = FALSE) {
  dsUp <- NULL
  p <- ncol(ds)
  if (overNum > 0) {
    overInd <- as.numeric(sample(row.names(subset(ds, ds[, p] == 1)), overNum, replace = TRUE))
    dsUp <- ds[overInd, ]
  }
  if (onlyNewCases) {
    ds <- dsUp
  } else {
    ds <- rbind(ds, dsUp)
  }
  row.names(ds) <- 1:nrow(ds)
  return(ds)
}