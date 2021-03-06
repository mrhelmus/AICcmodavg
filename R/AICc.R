##compute AIC, AICc, QAIC, QAICc
##generic
AICc <- function(mod, return.K = FALSE, second.ord = TRUE, nobs = NULL, ...){
  UseMethod("AICc", mod)
}

AICc.default <- function(mod, return.K = FALSE, second.ord = TRUE, nobs = NULL, ...){
  stop("\nFunction not yet defined for this object class\n")
}



##aov objects
AICc.aov <-
  function(mod, return.K = FALSE, second.ord = TRUE, nobs = NULL, ...){
    
    if(identical(nobs, NULL)) {n <- length(mod$fitted)} else {n <- nobs}
    LL <- logLik(mod)[1]
    K <- attr(logLik(mod), "df")  #extract correct number of parameters included in model - this includes LM
    if(second.ord == TRUE) {AICc <- -2*LL+2*K*(n/(n-K-1))}  else{AICc <- -2*LL+2*K}
    if(return.K == TRUE) AICc[1] <- K #attributes the first element of AICc to K
    AICc
  }



##clm objects
AICc.clm <-
  function(mod, return.K = FALSE, second.ord = TRUE, nobs = NULL, ...){
    
    if(identical(nobs, NULL)) {n <- length(fitted(mod))} else {n <- nobs}
    LL <- logLik(mod)[1]
    K <- attr(logLik(mod), "df")  #extract correct number of parameters included in model - this includes LM
    if(second.ord == TRUE) {AICc <- -2*LL+2*K*(n/(n-K-1))}  else{AICc <- -2*LL+2*K}
    if(return.K == TRUE) AICc[1] <- K #attributes the first element of AICc to K
    AICc       
  }


##clmm objects
AICc.clmm <-
  function(mod, return.K = FALSE, second.ord = TRUE, nobs = NULL, ...){

    if(identical(nobs, NULL)) {n <- length(fitted(mod))} else {n <- nobs}
    LL <- logLik(mod)[1]
    K <- attr(logLik(mod), "df")  #extract correct number of parameters included in model - this includes LM
    if(second.ord == TRUE) {AICc <- -2*LL+2*K*(n/(n-K-1))}  else{AICc <- -2*LL+2*K}
    if(return.K == TRUE) AICc[1] <- K #attributes the first element of AICc to K
    AICc
  }


##coxme objects
AICc.coxme <- function(mod, return.K = FALSE, second.ord = TRUE, nobs = NULL, ...){
  
  if(identical(nobs, NULL)) {n <- length(mod$linear.predictor)} else {n <- nobs}
  LL <- extractLL(mod)[1]
  K <- attr(extractLL(mod), "df")  #extract correct number of parameters included in model
  if(second.ord==TRUE) {AICc <- -2*LL+2*K*(n/(n-K-1))}  else{AICc <- -2*LL+2*K}
  if(return.K==TRUE) AICc[1] <- K #attributes the first element of AICc to K
  AICc
}


##coxph objects
AICc.coxph <- function(mod, return.K = FALSE, second.ord = TRUE, nobs = NULL, ...){
    
  if(identical(nobs, NULL)) {n <- length(residuals(mod))} else {n <- nobs}
  LL <- extractLL(mod)[1]
  K <- attr(extractLL(mod), "df")  #extract correct number of parameters included in model
  if(second.ord == TRUE) {AICc <- -2*LL+2*K*(n/(n-K-1))}  else{AICc <- -2*LL+2*K}
  if(return.K == TRUE) AICc[1] <- K #attributes the first element of AICc to K
  AICc
}


##glm and lm objects
AICc.glm <-
  function(mod, return.K = FALSE, second.ord = TRUE, nobs = NULL, c.hat = 1, ...){
    
    if(is.null(nobs)) {
      n <- length(mod$fitted)
    } else {n <- nobs}
    
    LL <- logLik(mod)[1]
    K <- attr(logLik(mod), "df")  #extract correct number of parameters included in model - this includes LM
      
    if(c.hat == 1) {
      if(second.ord == TRUE) {AICc <- -2*LL+2*K*(n/(n-K-1))} else{AICc <- -2*LL+2*K}
    }
    if(c.hat > 1 && c.hat <= 4) {
      K <- K+1
      if(second.ord==TRUE) {
        AICc <- (-2*LL/c.hat)+2*K*(n/(n-K-1))
        ##adjust parameter count to include estimation of dispersion parameter
      } else{
        AICc <- (-2*LL/c.hat)+2*K}
    }

    if(c.hat > 4) stop("High overdispersion and model fit is questionable\n")
    if(c.hat < 1) stop("You should set \'c.hat\' to 1 if < 1, but values << 1 might also indicate lack of fit\n")

    ##check if negative binomial and add 1 to K for estimation of theta if glm( ) was used
    if(!is.na(charmatch(x="Negative Binomial", table=family(mod)$family))) {
      if(is.null(mod$theta)) {
        K <- K+1
        if(second.ord == TRUE) {
          AICc <- -2*LL+2*K*(n/(n-K-1))
        } else {
          AICc <- -2*LL+2*K
        }
                                                                                                    }
      if(c.hat != 1) stop("You should not use the c.hat argument with the negative binomial")
    }
    ##add 1 for theta parameter in negative binomial fit glm( )
    ##check if gamma and add 1 to K for estimation of shape parameter if glm( ) was used
    ##an extra condition must be added to avoid adding a parameter for theta with negative binomial when glm.nb( ) is fit which estimates the correct number of parameters
    if(return.K == TRUE) AICc[1] <- K #attributes the first element of AICc to K
    AICc
  }



##gls objects
AICc.gls <-
  function(mod, return.K = FALSE, second.ord = TRUE, nobs = NULL, ...){
    
    if(identical(nobs, NULL)) {n<-length(mod$fitted)} else {n <- nobs}
    LL <- logLik(mod)[1]
    K <- attr(logLik(mod), "df")  #extract correct number of parameters included in model - this includes LM
    if(second.ord == TRUE) {AICc <- -2*LL+2*K*(n/(n-K-1))}  else{AICc <- -2*LL+2*K}
    if(return.K == TRUE) AICc[1] <- K #attributes the first element of AICc to K
    AICc
  }


##lm objects
AICc.lm <-
  function(mod, return.K = FALSE, second.ord = TRUE, nobs = NULL, ...){
    
    if(identical(nobs, NULL)) {n <- length(mod$fitted)} else {n <- nobs}
    LL <- logLik(mod)[1]
    K <- attr(logLik(mod), "df")  #extract correct number of parameters included in model - this includes LM
    if(second.ord == TRUE) {AICc <- -2*LL+2*K*(n/(n-K-1))}  else{AICc <- -2*LL+2*K}
    if(return.K == TRUE) AICc[1] <- K #attributes the first element of AICc to K
    AICc
  }



##lme objects
AICc.lme <-
  function(mod, return.K = FALSE, second.ord = TRUE, nobs = NULL, ...){
    
    if(identical(nobs, NULL)) {n <- nrow(mod$fitted)} else {n <- nobs}
    LL <- logLik(mod)[1]
    K <- attr(logLik(mod), "df")  #extract correct number of parameters included in model - this includes LM
    if(second.ord == TRUE) {AICc <- -2*LL+2*K*(n/(n-K-1))}  else{AICc <- -2*LL+2*K}
    if(return.K == TRUE) AICc[1] <- K #attributes the first element of AICc to K
    AICc
  }


##lmekin objects
AICc.lmekin <-
  function(mod, return.K = FALSE, second.ord = TRUE, nobs = NULL, ...){

    if(identical(nobs, NULL)) {n <- length(mod$residuals)} else {n <- nobs}
    LL <- extractLL(mod)[1]
    K <- attr(extractLL(mod), "df")  #extract correct number of parameters included in model - this includes LM
    if(second.ord == TRUE) {AICc <- -2*LL+2*K*(n/(n-K-1))}  else{AICc <- -2*LL+2*K}
    if(return.K == TRUE) AICc[1] <- K #attributes the first element of AICc to K
    return(AICc)
  }


##maxlike objects
AICc.maxlikeFit <- function(mod, return.K = FALSE, second.ord = TRUE, nobs = NULL, c.hat = 1, ...) {
  
  LL <- extractLL(mod)[1]
  K <- attr(extractLL(mod), "df")

  if(is.null(nobs)) {
    n <- nrow(mod$points.retained)
  } else {n <- nobs}
  
  if(second.ord == TRUE) {AICc <- -2 * LL + 2 * K * (n/(n - K - 1))} else {AICc <- -2*LL + 2*K}
  
  if(c.hat != 1) stop("\nThis function does not support overdispersion in \'maxlikeFit\' models\n")

  if(identical(return.K, TRUE)) {
    return(K)
  } else {return(AICc)}
}


##mer object
AICc.mer <-
  function(mod, return.K = FALSE, second.ord = TRUE, nobs = NULL, ...){

    if(is.null(nobs)) {
      n <- mod@dims["n"]
    } else {n <- nobs}
      
    LL <- logLik(mod)[1]
    K <- attr(logLik(mod), "df")  #extract correct number of parameters included in model
    
    if(second.ord == TRUE) {AICc <- -2*LL+2*K*(n/(n-K-1))} else{AICc <- -2*LL+2*K}
    
    if(return.K == TRUE) AICc[1] <- K #attributes the first element of AICc to K
    AICc
  }


##merMod objects
AICc.merMod <-
  function(mod, return.K = FALSE, second.ord = TRUE, nobs = NULL, ...){
 
    if(is.null(nobs)) {
      n <- mod@devcomp$dims["n"]
      names(n) <- NULL
    } else {n <- nobs}
    
    LL <- logLik(mod)[1]
    K <- attr(logLik(mod), "df")  #extract correct number of parameters included in model
      
    if(second.ord == TRUE) {AICc <- -2*LL+2*K*(n/(n-K-1))} else{AICc <- -2*LL+2*K}
                    
    if(return.K == TRUE) AICc[1] <- K #attributes the first element of AICc to K
    AICc
  }


##mult objects
AICc.multinom <-
  function(mod, return.K = FALSE, second.ord = TRUE, nobs = NULL, c.hat = 1, ...){

    if(identical(nobs, NULL)) {n<-length(mod$fitted)/length(mod$lev)} else {n <- nobs}
    LL <- logLik(mod)[1]
    K <- attr(logLik(mod), "df")  #extract correct number of parameters included in model - this includes LM
      
    if(c.hat == 1) {
      if(second.ord==TRUE) {
        AICc <- -2*LL+2*K*(n/(n-K-1))
      } else{
        AICc <- -2*LL+2*K
      }
    }
    if(c.hat > 1 && c.hat <= 4) {
      K <- K+1
      if(second.ord == TRUE) {
        AICc <- (-2*LL/c.hat)+2*K*(n/(n-K-1)) #adjust parameter count to include estimation of dispersion parameter
      } else{
        AICc <- (-2*LL/c.hat)+2*K
      }
    }
    if(c.hat > 4) stop("High overdispersion and model fit is questionable")
    
    if(return.K==TRUE) AICc[1]<-K #attributes the first element of AICc to K
    AICc
  }


##nlme objects
AICc.nlme <-
  function(mod, return.K = FALSE, second.ord = TRUE, nobs = NULL, ...){

    if(identical(nobs, NULL)) {n <- nrow(mod$fitted)} else {n <- nobs}
    LL <- logLik(mod)[1]
    K <- attr(logLik(mod), "df")  #extract correct number of parameters included in model - this includes LM
    if(second.ord == TRUE) {AICc <- -2*LL+2*K*(n/(n-K-1))}  else{AICc <- -2*LL+2*K}
    if(return.K == TRUE) AICc[1] <- K #attributes the first element of AICc to K
    AICc
  }


##nls objects
AICc.nls <-
  function(mod, return.K = FALSE, second.ord = TRUE, nobs = NULL, ...){

    if(identical(nobs, NULL)) {n <- length(fitted(mod))} else {n <- nobs}
    LL <- logLik(mod)[1]
    K <- attr(logLik(mod), "df")  #extract correct number of parameters included in model
    if(second.ord == TRUE) {AICc <- -2*LL+2*K*(n/(n-K-1))}  else{AICc <- -2*LL+2*K}
    if(return.K == TRUE) AICc[1] <- K #attributes the first element of AICc to K
    AICc
  }


##polr objects
AICc.polr <-
function(mod, return.K = FALSE, second.ord = TRUE, nobs = NULL, ...){

  if(identical(nobs, NULL)) {n<-length(mod$fitted)} else {n <- nobs}
  LL <- logLik(mod)[1]
  K <- attr(logLik(mod), "df")  #extract correct number of parameters included in model - this includes LM
      
  if(second.ord == TRUE) {
    AICc <- -2*LL+2*K*(n/(n-K-1))
  } else{
    AICc <- -2*LL+2*K
  }
                                 
  if(return.K == TRUE) AICc[1] <- K #attributes the first element of AICc to K
  AICc
}



##rlm objects
AICc.rlm <-
  function(mod, return.K = FALSE, second.ord = TRUE, nobs = NULL, ...){

    if(identical(nobs, NULL)) {n <- length(mod$fitted)} else {n <- nobs}
    LL <- logLik(mod)[1]
    K <- attr(logLik(mod), "df")  #extract correct number of parameters included in model - this includes LM
    if(second.ord == TRUE) {AICc <- -2*LL+2*K*(n/(n-K-1))}  else{AICc <- -2*LL+2*K}
    if(return.K == TRUE) AICc[1] <- K #attributes the first element of AICc to K
    AICc
  }


##unmarkedFit objects
##create function to extract AICc from 'unmarkedFit'
AICc.unmarkedFit <- function(mod, return.K = FALSE, second.ord = TRUE, nobs = NULL, c.hat = 1, ...) {
  
  LL <- extractLL(mod)[1]
  K <- attr(extractLL(mod), "df")
  
  if(is.null(nobs)) {
    n <- dim(mod@data@y)[1]
  } else {n <- nobs}
  
  if(c.hat == 1) {
    if(second.ord == TRUE) {AICc <- -2 * LL + 2 * K * (n/(n - K - 1))} else {AICc <- -2*LL + 2*K}
  }
  if(c.hat > 1 && c.hat <= 4) {
    ##adjust parameter count to include estimation of dispersion parameter
    K <- K + 1
    if(second.ord == TRUE) {
      AICc <- (-2 * LL/c.hat) + 2 * K * (n/(n - K - 1))
    } else {
      AICc <- (-2 * LL/c.hat) + 2*K}
  }

  if(c.hat > 4) stop("\nHigh overdispersion and model fit is questionable\n")
  if(c.hat < 1) stop("\nYou should set \'c.hat\' to 1 if < 1, but values << 1 might also indicate lack of fit\n")

  if(identical(return.K, TRUE)) {
    return(K)
  } else {return(AICc)}
}


##vglm objects
AICc.vglm <- function(mod, return.K = FALSE, second.ord = TRUE, nobs = NULL, c.hat = 1, ...){
    
    if(is.null(nobs)) {
      n <- nrow(mod@fitted.values)
    } else {n <- nobs}
    
    LL <- extractLL(mod)

    ##extract number of estimated parameters
    K <- attr(extractLL(mod), "df")
    
    if(c.hat !=1) {
      fam.name <- mod@family@vfamily
      if(fam.name != "poissonff" && fam.name != "binomialff") stop("\nOverdispersion correction only appropriate for Poisson or binomial models\n")
    }
    if(c.hat == 1) {
      if(second.ord == TRUE) {AICc <- -2*LL+2*K*(n/(n-K-1))} else{AICc <- -2*LL+2*K}
    }
    if(c.hat > 1 && c.hat <= 4) {
      K <- K + 1
      if(second.ord==TRUE) {
        AICc <- (-2*LL/c.hat) + 2*K*(n/(n-K-1))
        ##adjust parameter count to include estimation of dispersion parameter
      } else{
        AICc <- (-2*LL/c.hat) + 2*K}
    }

    if(c.hat > 4) stop("High overdispersion and model fit is questionable\n")
    if(c.hat < 1) stop("You should set \'c.hat\' to 1 if < 1, but values << 1 might also indicate lack of fit\n")

    if(return.K == TRUE) AICc[1] <- K #attributes the first element of AICc to K
    AICc
  }


##zeroinfl objects
AICc.zeroinfl <-
  function(mod, return.K = FALSE, second.ord = TRUE, nobs = NULL, ...){
    
    if(identical(nobs, NULL)) {n <- length(mod$fitted)} else {n <- nobs}
    LL <- logLik(mod)[1]
    K <- attr(logLik(mod), "df")  #extract correct number of parameters included in model - this includes LM
    if(second.ord == TRUE) {AICc <- -2*LL + 2*K*(n/(n-K-1))}  else{AICc <- -2*LL + 2*K}
    if(return.K == TRUE) AICc[1] <- K #attributes the first element of AICc to K
    AICc
  }

##phylolm objects
AICc.phylolm <-
  function(mod, return.K = FALSE, second.ord = TRUE, nobs = NULL, ...){

    if(identical(nobs, NULL)) {n <- length(mod$residuals)} else {n <- nobs}
    LL <- logLik(mod)$logLik
    K <- logLik(mod)$df  #extract correct number of parameters included in model - this includes LM
    if(second.ord == TRUE) {AICc <- -2*LL+2*K*(n/(n-K-1))}  else{AICc <- -2*LL+2*K}
    if(return.K == TRUE) AICc[1] <- K #attributes the first element of AICc to K
    return(AICc)
  }

##phyloglm objects  
  AICc.phyloglm<-
  function(mod, return.K = FALSE, second.ord = TRUE, nobs = NULL, ...){

    if(identical(nobs, NULL)) {n <- length(mod$residuals)} else {n <- nobs}
    LL <- logLik(mod)$logLik
    K <- logLik(mod)$df  #extract correct number of parameters included in model - this includes LM
    if(second.ord == TRUE) {AICc <- -2*LL+2*K*(n/(n-K-1))}  else{AICc <- -2*LL+2*K}
    if(return.K == TRUE) AICc[1] <- K #attributes the first element of AICc to K
    return(AICc)
  }

