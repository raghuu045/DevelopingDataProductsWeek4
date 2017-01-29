library(shiny)
shinyUI(fluidPage(
        titlePanel("Miles per Gallon for selected features of the car"),
        sidebarLayout(
                sidebarPanel(
                        numericInput("QuarterMileTime", "Pick 1/4 mile time:", 
                                     value = 15.5, min=14.5, max=25.0, step = .01),
                        sliderInput("sliderDrat", "Pick Rear axle ratio:",
                                    min=2.5, max=5, value = 2.760),
                        radioButtons("radioButtonAm","Transmission Type:",
                                     c("Automatic" = "0",
                                       "Manual" = "1")),
                        radioButtons("radioButtonVs","V/S:",
                                     c("Zero" = "0",
                                       "One" = "1")),
                        checkboxInput("NotShowMessage", "Not Show Message",value = FALSE),
                        ## The below functionality is not working in shinyapps.io, as
                        ## it has to retain object (for history) between runs. => START
                        ##checkboxInput("clearHistory", "Clear History",value = FALSE ),
                        ## => END
                        submitButton("Submit")
                ),
                
                mainPanel(
                        tabsetPanel(type= "tab",
                                    tabPanel("Application",
                                             h1("Miles Per Gallon"),
                                             textOutput("predictedvalue"),
                                             tags$head(tags$style("#predictedvalue
                                                        {color: blue;
                                                         font-size: 50px;
                                                         font-style: italic;}"
                                                                 )
                                                       )
                                             ## The below functionality is not working 
                                             ## in shinyapps.io, as it has to retain 
                                             ## object (for history) between runs. => START
                                             ##h3("History:"),
                                             ##verbatimTextOutput("hist")
                                             ## => END
                                             ),
                                    tabPanel("Usage",
                                             h1("Instructions to use the Application:"),
                                             "1. Select the required features on the left
                                             panel for your car.",
                                             br(),
                                             "2. Click the submit button.",
                                             br(),
                                             ##"3. The Application will display miles per gallon 
                                             ##for the selected features and the history for
                                             ##prior inquires.",
                                             "3. The Application will display miles per gallon 
                                             for the selected features along with a message 
                                             next to it.",
                                             br(),
                                             "4. Now you can select different features and 
                                             click submit button.",
                                             br(),
                                             ##"5. The application will display miles per gallon
                                             ##for the newly selected features and the prior 
                                             ##entry in the history.",
                                             "5. The application will display miles per gallon
                                             for the newly selected features and the 
                                             corresponding message for it.",
                                             br(),
                                             ##"6. If you want to clear the history, Check the 
                                             ##box next to clear history on the left panel 
                                             ##and click submit button.",
                                             "6. If you don't want the message to be displayed
                                             check the box next to \"Not Show Message\" on the
                                             left panel and click submit button.",
                                             br(),
                                             ##"7. Application will display as \"History 
                                             ## cleared!!!\" ",
                                             "7. The message will be cleared.",
                                             br(),
                                             ##"8. Now uncheck the box next to clear history on 
                                             ##the left panel and click submit button.",
                                             "8. Now uncheck the box next to \"Not Show 
                                             Message\" on the left panel and click submit 
                                             button.",
                                             br(),
                                             ##"9. Application will display as \"No prior 
                                             ##inquires!!!\" "
                                             "9. The message will re-appear."
                                             ),
                                    tabPanel("Process",
                                             h1("How the Application works:"),
                                             "1. You select the features and click submit
                                              button.",
                                             br(),
                                             "2. Application will go and fit a linear 
                                             regression model on mtcars dataset from 
                                             \"datasets\" package.",
                                             br(),
                                             "3. Identifies all the numberic attributes.",
                                             br(),
                                             "4. Picks the attributes for the 
                                             model based on the correlation between the 
                                             attributes.",
                                             br(),
                                             "5. Identifies all the predictors which has high
                                             correlation (> 0.4) to the outcome (mpg). ",
                                             br(),
                                             "6. From the identified list of predictors picks
                                             the one which has the maximum correlation to the 
                                             outcome (mpg). Selects this predictor for the 
                                             model. ",
                                             br(),
                                             "7. Now identifies the predictors from the list, 
                                             which has low correlation to the selected 
                                             predictor. (< 0.6) ",
                                             br(),
                                             "8. Adds all the idenitifed predictors to the 
                                             model. ",
                                             br(),
                                             "9. Adds all the non-numeric attributes to the 
                                             model. ",
                                             br(),
                                             "10. Fits the linear regression model. ",
                                             br(),
                                             "11. Predicts the outcome for the selected 
                                             features using the fitted model.",
                                             br(),
                                             ##"12. Displays the outcome (Miles Per Gallon) for
                                             ##the selected features and also saves the 
                                             ##selected features and the outcome.",
                                             "12. Displays the outcome (Miles Per Gallon) for
                                             the selected features and the corresponding
                                             message next to it.",
                                             br(),
                                             ##"13. Displays saved inquires on the \"History:\" 
                                             ##section of the application. ",
                                             ##br(),
                                             ##"14. You check the box next to clear history and
                                             ##click submit button. ",
                                             "13. You check the box next to \"Not Show 
                                             Message\" and click submit button.",
                                             br(),
                                             ##"15. Application clears the history and display
                                             ##as \"History cleared!!!\" ",
                                             "14. The application will not show the message.",
                                             br(),
                                             ##"16. You uncheck the box next to clear history on 
                                             ##the left panel and click submit button.",
                                             "15. You uncheck the box next to \"Not Show 
                                             Message\" on the left panel and click submit 
                                             button.",
                                             br(),
                                             ##"17. Application will display as \"No prior 
                                             ##inquires!!!\", as the saved history has been 
                                             ##cleared. "
                                             "16. The application will show the message."
                                             
                                            )
                        )
                       
                )
        )
        
))