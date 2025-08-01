# CollegeSearchTool
# Ryan Womack
# ryanwomack.com
# 2024-07-19
# see https://github.com/ryandata/CollegeSearchTool for sources of data and description

library(ggvis)
library(dplyr)
library(shiny)
library(plotly)
library(ggrepel)

# set working directory to source file location
# setwd("~/womack/documents/ryan/work/shiny/CollegeSearchTool")

# read data (see college_data.R file for the filtering of the raw data)
collegedata <- read.csv("college_data.csv")

axis_vars <- c(
  "Admissions Rate" = "ADM_RATE",
  "SAT Math 25%" = "SATMT25",
  "SAT Math 75%" = "SATMT75",
  "SAT Verbal 25%" = "SATVR25",
  "SAT Verbal 75%" = "SATVR75",
  "Asian %" = "UGDS_ASIAN",
  "Black %" = "UGDS_BLACK",
  "Hispanic %" = "UGDS_HISP",
  "White %" = "UGDS_WHITE",
  "1st Generation %" = "FIRST_GEN",
  "Pell %" = "PCTPELL",
  "Asian Completion" = "C150_4_ASIAN",
  "Black Completion" = "C150_4_BLACK",
  "Hispanic Completion" = "C150_4_HISP",
  "White Completion" = "C150_4_WHITE",
  "1st Gen Completion" = "FIRSTGEN_COMP_ORIG_YR6_RT",
  "Non-1stG Completion" = "NOT1STGEN_COMP_ORIG_YR6_RT",
  "Avg Family Income" = "FAMINC",
  "1st Gen Debt, median" = "FIRSTGEN_DEBT_MDN",
  "Non-1stG Debt, median" = "NOTFIRSTGEN_DEBT_MDN",
  "10yr Earnings, median" = "MD_EARN_WNE_P10"
)
collegedata$FIRSTGEN_DEATH_YR2_RT
# Define UI

ui <- 

fluidPage(
  titlePanel("CollegeSearchTool"),
  fluidRow(
    column(3,
           wellPanel(
             selectInput(inputId = "xvar",
                         label = "X-axis variable",
                         choices = axis_vars,
                         selected = "ADM_RATE"),
             selectInput(inputId = "yvar",
                         label = "Y-axis variable",
                         choices = axis_vars,
                         selected = "ADM_RATE"),
             selectInput(inputId = "sorter",
                         label = "sorting variable",
                         choices = axis_vars,
                         selected = "ADM_RATE"),
           wellPanel(
             h4("Filter"),
             sliderInput("ADM_MIN", "Admit rate, min",
                         0, 1, 0.2, step = .01),
             sliderInput("ADM_MAX", "Admit rate, max",
                         0, 1, 0.5, step = .01),
             sliderInput("FIRST_MIN", "First Gen, min",
                         0, 1, 0.1, step = .01),
             sliderInput("FIRST_MAX", "First Gen, max",
                         0, 1, 0.5, step = .01),
             checkboxGroupInput("SchoolType", "School Type", choiceNames=c("Public","Private"), choiceValues=c("1","2"), selected="1"),
             checkboxGroupInput(inputId = "RegionFinder",
                                label = "Select Region(s):",
                                choices = c("New England" = 1, "Mid Atlantic" = 2, "Great Lakes" = 3, "Plains" =4, "South" = 5, "Southwest" = 6, "Mountain West" = 7, "Pacific" =8),
                                selected = 1)
           ),
             tags$small(paste0(
               "Note: This is a quick demo project developed by Ryan Womack, not an official or regularly updated data source on colleges."
             ))
           )
    ),
    column(9,
           plotlyOutput(outputId="plot1"),
           wellPanel(
             span("Number of colleges selected:",
                  textOutput("n_colleges"),
                  tableOutput("my_colleges")
                  
             )
           )
    )
  )
)

# Define Server

server <- function(input, output, session) {
  # Filter the colleges, returning a data frame
  colleges <- reactive({
    input$SCHTYPE
    input$ADM_MIN
    input$ADM_MAX
    input$FIRST_MIN
    input$FIRST_MAX
    input$RegionFinder
    input$xvar
    input$yvar
    input$sorter
    # Apply filters
    collegedata %>%
      filter(ADM_RATE >= input$ADM_MIN) %>%
      filter(ADM_RATE <= input$ADM_MAX) %>%
      filter(FIRST_GEN >= input$FIRST_MIN) %>%
      filter(FIRST_GEN <= input$FIRST_MAX) %>%
      filter(SCHTYPE %in% input$SchoolType) %>%
      filter(REGION %in% input$RegionFinder) %>%
      arrange(get(input$sorter))  %>%
      select(INSTNM, ADM_RATE, SATMT25, SATMT75, SATVR25, SATVR75, SCHTYPE, UGDS_ASIAN, 
             UGDS_BLACK, UGDS_HISP, UGDS_WHITE, FIRST_GEN, PCTPELL, C150_4_ASIAN,
             C150_4_BLACK, C150_4_HISP, C150_4_WHITE, FIRSTGEN_COMP_ORIG_YR6_RT, 
             NOT1STGEN_COMP_ORIG_YR6_RT, FAMINC, FIRSTGEN_DEBT_MDN, NOTFIRSTGEN_DEBT_MDN,
             MD_EARN_WNE_P10)
  })
  
  output$plot1 <- renderPlotly({
    d <- colleges()
    fig <- plot_ly(
      d, x = ~get(input$xvar), y = ~get(input$yvar),
      text = ~INSTNM,
      color = ~SCHTYPE,
      type= 'scatter'
    ) %>%
      layout(xaxis = list(title = names(axis_vars[which(axis_vars == input$xvar)])),
             yaxis = list(title = names(axis_vars[which(axis_vars == input$yvar)]))
             )
    
    fig
    
  })
  
  output$n_colleges <- renderText({ nrow(colleges()) })
  output$my_colleges <- renderTable(colleges())
}

# Run the application
shinyApp(ui = ui, server = server)
