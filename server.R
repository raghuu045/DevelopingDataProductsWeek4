library(shiny)
modelFit <- function(pred,outcome) {
        set.seed(1678)
        #pred <- mtcars[,-1]
        #outcome <- mtcars[,1]
        outcome <- unlist(outcome)
        
        p <- ncol(pred)
        
        ## identify numeric predicates.
        numColLog <- lapply(pred, is.numeric) 
        
        ## convert to vector.
        numColLog <- unlist(numColLog ) 
        
        ## initializing as numeric with values 0.
        corValues <- numeric(p)  
        
        ## Calculate Correlation between predicates and 
        ## outcome for all numeric predicates.
        for (i in seq_len(p)) {
                if (numColLog[i]) {
                        corValues[i] <- cor(outcome,pred[i])
                }
        }
        
        ## Pick the highest correlation predicates (> .40). 
        ord <- order(corValues,decreasing = TRUE)
        highCorIndex <- corValues > .40
        predHighCor <- ord[1:length(ord[highCorIndex])]
        predHighCor
        
        ## Select the highest correlated predicate (first one) for the model.
        modelSelectpred <- colnames(pred[predHighCor[1]])
        
        ## Removes the first element as we have already selected
        predHighCor <- predHighCor[-1]  
        
        modelSelectdata <- pred[modelSelectpred]
        
        if ( length(predHighCor) > 1) {
                ## identify the correlation between the highest correlated 
                ## predicate (1st one) and other identified predicates. 
                cor_high <- sapply(2:length(predHighCor), function(x) { 
                        Y=pred[predHighCor[1]]; X=pred[predHighCor[x]]; 
                        cor <- cor(Y,X) ; c(cor,colnames(predHighCor[x]))})
                df_cor_high <- data.frame(t(cor_high))
                
                ## Identify the predicates which has low correlation (< .60) 
                ## with highest (1st one) predicate. 
                lowCorIndex <- df_cor_high < .60
                predlowCor <- predHighCor[lowCorIndex]
                #predlowCor
                
                ## Add the low correlation predictors 
                modelSelectdata <- cbind(modelSelectdata, pred[predlowCor])
                modelSelectpred <- c(modelSelectpred, colnames(pred[predlowCor]))
        }
        
        ## fit the model and identify adjusted r^2 for numeric predicates.
        modelSelectR2 <- summary(lm(outcome ~ .,data=modelSelectdata))$adj.r.squared
        
        ## Keep adding non-numeric attributes one at a time and check for adjusted r^2
        j <- length(modelSelectpred)
        for (i in seq_len(p)) {
                if (!numColLog[i]) {
                        j <- j + 1 
                        modelSelectpred[j] <- colnames(pred[i]) 
                        modelSelectdata <- cbind(modelSelectdata,pred[i]) 
                        modelSelectR2[j] <- summary(lm(outcome ~ .,
                                                       data=modelSelectdata))$adj.r.squared
                }
        }
        
        #modelSelectR2
        #modelSelectpred
        
        ## We are getting the maximum R^2 value when we add all 
        ## non-numeric attributes to the model
        lm(outcome ~ ., data = modelSelectdata)
        
}

## Saves the old inquires ('<<-' retains data between runs)
cacheOldSelection <- function(x,flag) {
        setOld <- function(predicted, flag) {
                
                if(!exists("oldValues", mode = "list")) { 
                        oldValues <<- data.frame()
                }
                 
                if (flag == "Y") {
                        oldValues <<- data.frame()
                }
                else {
                        oldValues <<- rbind(oldValues,predicted)
                }
                
        }
        getOld <- function() {
                oldValues
        }
        list(setOld = setOld,
             getOld = getOld)
}


shinyServer(function(input, output) {
        
        output$predictedvalue <- renderText({
                set.seed(1678)
                QuarterMileTime <- input$QuarterMileTime
                Drat <- input$sliderDrat
                Am <- as.numeric(input$radioButtonAm)
                Vs <- as.numeric(input$radioButtonVs)
                NotShowMessage <- input$NotShowMessage
                ##clearHistory <- input$clearHistory
                newData <- data.frame(drat = Drat,vs =Vs,
                                      am = Am, qsec = QuarterMileTime)
                       
                bestfit <- modelFit(mtcars[,-1],mtcars[,1])
                Mpg <- round(predict(bestfit,newdata = newData),1.0)
                ## Commented code is for saving and clearing prior inquires. It is 
                ## not working if I host the app as web application in 
                ## shinyapps.io, as it has to retain the object between runs  => START
                #newData$mpg <- Mpg
                #a <- cacheOldSelection()
                #if (clearHistory) {
                        #a$setOld(newData,'Y')
                #}
                #else{
                        #a$setOld(newData,'N')
                #}
                ## => END
                if (NotShowMessage) {
                        paste(Mpg)
                }
                else {
                        if (Mpg < 18) {
                                paste("Low Mileage:",Mpg)
                        }
                        else {
                                paste("Good Mileage:",Mpg)
                        }
                }
                
        })
        ## Below code is for displaying history of prior inquires. The code 
        ## not working if I host the app as web application in 
        ## shinyapps.io, as it has to retain the object between runs  => START1
        #output$hist <- renderPrint({
                ## Added the below lines to capture if there is any change in
                ## any of the input variables. Only if there is a change in 
                ## any of the input Variables, the code for output$hist is
                ## getting executed. Added these as dummy steps to have this   
                ## code executed everytime we press SUBMIT button. 
                #QuarterMileTime <- input$QuarterMileTime
                #Drat <- input$sliderDrat
                #Am <- as.numeric(input$radioButtonAm)
                #Vs <- as.numeric(input$radioButtonVs)
                ## Below code is for displaying history of prior inquires. The code is 
                ## not working if I host the app as web application in shinyapps.io, 
                ## as it has to retain the object between runs  => START2
                #clearHistory <- input$clearHistory
                #priorInq <- a$getOld()
                #if (clearHistory) {
                 #       paste("History Cleared!!!")    
                #}
                #else {
                 #       if ( dim(priorInq)[1] <= 1) {
                  #              paste("No prior inquires!!!") 
                  #      }
                  #      else {
                  #      priorInq[-dim(priorInq)[1],]
                  #      }
                #}
                ## => END2
        #}) => END1
        
})