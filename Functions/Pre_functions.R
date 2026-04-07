

# GPD
fit_GPD = function(data, q = 0.95) {
  mles.matrix = matrix(NaN, nrow = nrow(data), ncol = 3)
  for (i in 1:nrow(data)) {
    # print(i)
    thr <- as.numeric(quantile(data[i,], probs = q))
    fitGP <- evd::fpot(
      data[i,],
      threshold = thr,
      std.err = FALSE,
      method = "Nelder-Mead",
      control = list(maxit = 10000)
    )
    scales <- fitGP$estimate[1]
    shapes <- fitGP$estimate[2]
    
    mles.matrix[i, ] = c(thr, scales, shapes)
  }
  
  mles.matrix
}


stand_margins = function(data, mles.matrix = NULL, q = 0.95, scheme = "GPD"){
  normalized_data <- matrix(NA, nrow = nrow(data), ncol = ncol(data))
  
  for(i in 1:nrow(data)){
    # print(i)
    # Compute local empirical CDF
    empiricalCdf <- ecdf(data[i,])
    
    if (scheme == "GPD") {
      thr = mles.matrix[i,1]
      scales = mles.matrix[i,2]
      shapes = mles.matrix[i,3]
      
      cases.below.thr <- which(data[i,] <= thr & !is.na(data[i,]))
      cases.above.thr <- which(data[i,] > thr & !is.na(data[i,]))
      
      # Use empirical cdf below the threshold
      normalized_data[i, cases.below.thr] <- 1 / (1 - empiricalCdf(data[i, cases.below.thr]))
      # Use estimated GP distribution above the threshold
      normalized_data[i, cases.above.thr] <-
        1 /  ((1 - q) * (1 + shapes*(data[i, cases.above.thr] - thr) / scales)^(-1 / shapes))
    } else if (scheme == "ECDF") {
      normalized_data[i, ] <- 1 / (1 - empiricalCdf(data[i, ]))
    }
    
    
  }
  
  normalized_data
}


# if(frechet == TRUE){
#   # Use empirical cdf below the threshold
#   normalized_database[i, cases.below.thr] <- -1 / log(empiricalCdf(data[i, cases.below.thr]))
#   # Use estimated GP distribution above the threshold
#   normalized_database[i, cases.above.thr] <-
#     -1 / log(1 - (1 - q) * (1 + shapes*(data[i, cases.above.thr] - thr) / scales)^(-1 / shapes))
# } else {
#   # Use empirical cdf below the threshold
#   normalized_database[i, cases.below.thr] <- 1 / (1 - empiricalCdf(data[i, cases.below.thr])) #- 1
#   # Use estimated GP distribution above the threshold
#   normalized_database[i, cases.above.thr] <-
#     1 /  ((1 - q) * (1 + shapes*(data[i, cases.above.thr] - thr) / scales)^(-1 / shapes)) #- 1
# }


# data.unitp1 = matrix(NaN, nrow = dim(data)[1], ncol = dim(data)[2])
# for (i in 1:nrow(data)) {
#   print(i)
#   cases.below.thr <- which(data[i, ] < mles.matrix[i, 1])
#   cases.above.thr <- setdiff(1:ncol(data), cases.below.thr)
#   unif.alldata <- rank(data[i, ], ties.method = "random") / (ncol(data) + 1)
#   out <- rep(NA, ncol(data))
#   out[cases.below.thr] <- 1 / (1 - unif.alldata[cases.below.thr])
#   out[cases.above.thr] <- 1 / (1 - length(cases.below.thr) / (ncol(data) + 1)) /
#     (1 - pgpd(data[i, cases.above.thr], xi = mles.matrix[i, 3],
#               mu = mles.matrix[i, 1], beta = mles.matrix[i, 2]))
#   data.unitp1[i,] = out
# }