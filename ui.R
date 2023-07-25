library(ggvis)

# For dropdown menu
actionLink <- function(inputId, ...) {
  tags$a(href='javascript:void',
         id=inputId,
         class='action-button',
         ...)
}

fluidPage(
  titlePanel("college explorer"),
  fluidRow(
    column(3,
      wellPanel(
        h4("Filter"),
        sliderInput("ADM_MIN", "Admit rate, min",
          0, 1, 0.5, step = .01),
        sliderInput("ADM_MAX", "Admit rate, max",
          0, 1, 0.6, step = .01),
        checkboxGroupInput("SchoolType", "School Type", choiceNames=c("Public","Private"), choiceValues=c("1","2"), selected="1"),
        radioButtons("showNames", "Show Names", choices=c("Y","N"), selected="N"),
        checkboxGroupInput(inputId = "RegionFinder",
                           label = "Select Region(s):",
                           choices = c("New England" = 1, "Mid Atlantic" = 2, "Great Lakes" = 3, "Plains" =4, "South" = 5, "Southwest" = 6, "Mountain West" = 7, "Pacific" =8),
                           selected = 1)
      ),
      wellPanel(
        selectInput(inputId = "xvar",
                    label = "X-axis variable",
                    choices = c("ADM_RATE", "SATMT25", "SATMT75", "SATVR25", "SATVR75"),
                    selected = "ADM_RATE"),
        selectInput(inputId = "yvar",
                    label = "Y-axis variable",
                    choices = c("ADM_RATE", "SATMT25", "SATMT75", "SATVR25", "SATVR75"),
                    selected = "ADM_RATE"),
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
