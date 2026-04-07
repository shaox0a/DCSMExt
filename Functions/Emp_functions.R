# emp_EC_est = function(data, coord) {
#   library(SpatialExtremes)
#   fmad <- fmadogram(data = t(data), coord = coord)
# 
#   distances = fmad[,1]
#   extcoeffs <- pmin(fmad[,3], 2)
#   ec.emp = cbind(extcoeffs, distances)
#   print("-----")
#   ec.emp
# }
# 
# # library(SpatialExtremes)
# # fmad <- fmadogram(data = t(sim$f_true), coord = as.matrix(sim$s))
# # # saveRDS(fmad, file = "fmad.Rdata")
# # 
# # distances = fmad[,1]
# # extcoeffs <- pmin(fmad[,3], 2)
# # ec.emp = cbind(extcoeffs, distances)
# # saveRDS(ec.emp, file = "empEC_fmad7_rPareto.Rdata")
# 
# 
# # conditional exceedance probability
# emp_CEP_est = function(data, coord, risk, q, q1) {
#   func_risk = apply(data, 2, risk)
#   threshold <- quantile(func_risk, q)
#   exceed_id = which(func_risk > threshold)
#   exceed <- as.matrix(data[, exceed_id])
#   
#   D = rdist(coord)
#   
#   u1 = quantile(as.numeric(exceed), q1)
#   
#   cep.pairs = do.call("cbind", sapply(1:(nrow(exceed)-1), function(i) {
#     sapply((i+1):nrow(exceed), function(j) { 
#       print(c(i,j))
#       giveni = sum(exceed[i,]>u1 & exceed[j,]>u1) / sum(exceed[i,]>u1)
#       givenj = sum(exceed[j,]>u1 & exceed[i,]>u1) / sum(exceed[j,]>u1)
#       c(giveni, givenj, D[i,j])
#     }) }))
#   str(cep.pairs)
#   
#   cep.average = colMeans(cep.pairs[1:2,])
#   cep.average = cbind(cep.average, cep.pairs[3,])
#   
#   # ec.emp = cep.average
#   # ec.emp[,1] = 2 - ec.emp[,1]
#   print("-----")
#   cep.average
# }


emp_extdep_est = function(data, coord, model, 
                          risk=NULL, q=NULL, q1=NULL, 
                          exceed_id = NULL) {
  if (model == "MSP-BR") {
    library(SpatialExtremes)
    fmad <- fmadogram(data = t(data), coord = coord)
    
    distances = fmad[,1]
    extcoeffs <- pmin(fmad[,3], 2)
    ec.emp = cbind(extcoeffs, distances)
    print("-----")
    return(ec.emp)
  } else if (model == "r-Pareto") {
    if (is.null(exceed_id)) {
      func_risk = apply(data, 2, risk)
      threshold <- quantile(func_risk, q)
      exceed_id = which(func_risk > threshold)
    }
    
    exceed <- as.matrix(data[, exceed_id])
    
    D = rdist(coord)
    
    # # if (isPareto1) {
    # #   u1 = rep(1/(1-q1), nrow(data))
    # # } else {
    # #   u1 = apply(data, 1, quantile, q1, na.rm = TRUE)
    # #   # this setting is consistent with the case using F(Z(s)) instead of Z(s)
    # # }
    # u1 = apply(data, 1, quantile, q1, na.rm = TRUE)
    # 
    # cep.pairs = do.call("cbind", sapply(1:(nrow(exceed)-1), function(i) {
    #   print(i/nrow(exceed))
    #   sapply((i+1):nrow(exceed), function(j) {
    #     cep = sum(exceed[i,]>u1[i] & exceed[j,]>u1[j]) /
    #       (0.5*sum(exceed[i,]>u1[i]) + 0.5*sum(exceed[j,]>u1[j]))
    #     cep = ifelse(is.na(cep), 0, cep)
    #     c(cep, D[i,j])
    #   }) }))
    # str(cep.pairs)
    
    u1 = quantile(as.numeric(exceed), q1)
    ### is it okay?? this is somewhat reasonable by setting cep = ifelse(is.na(cep), 0, cep)
    # yet it would limit the estimate "resolution" for some pairs

    cep.pairs = do.call("cbind", sapply(1:(nrow(exceed)-1), function(i) {
      # print(i/nrow(exceed))
      sapply((i+1):nrow(exceed), function(j) {
        cep = sum(exceed[i,]>u1 & exceed[j,]>u1) /
          (0.5*sum(exceed[i,]>u1) + 0.5*sum(exceed[j,]>u1))
        cep = ifelse(is.na(cep), 0, cep)
        c(cep, D[i,j])
      }) }))
    str(cep.pairs)
    

    print("-----")
    cep.pairs = t(cep.pairs)
    return(cep.pairs)
  }
}

