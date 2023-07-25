library(ggvis)
library(dplyr)
library(shiny)
library(plotly)
library(ggrepel)


function(input, output, session) {

  # Filter the colleges, returning a data frame
  colleges <- reactive({
    input$SCHTYPE
    input$ADM_MIN
    input$ADM_MAX
    input$RegionFinder
    input$xvar
    input$yvar
    # Apply filters
    collegedata %>%
      filter(ADM_RATE >= input$ADM_MIN) %>%
      filter(ADM_RATE <= input$ADM_MAX) %>%
      filter(SCHTYPE %in% input$SchoolType) %>%
      filter(REGION %in% input$RegionFinder) %>%
      arrange(ADM_RATE)  %>%
      select(INSTNM, ADM_RATE, SATMT25, SATMT75, SATVR25, SATVR75, SCHTYPE)
  })

 select_x <- reactive({
      input$xvar
 })
    
select_y <- reactive({
      input$yvar
 })
  
    output$plot1 <- renderPlotly({
      d <- colleges()
      fig <- plot_ly(
        d, x = ~get(input$xvar), y = ~get(input$yvar),
        text = ~INSTNM,
        color = ~SCHTYPE
      )
      
      fig
      
 })
    
  output$n_colleges <- renderText({ nrow(colleges()) })
  output$my_colleges <- renderTable(colleges())
}
