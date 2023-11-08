install.packages("plotly")
install.packages("shiny")
library(shiny)
library(plotly)
PISAsubset<-PISA_2018_student%>%
  select(PV1MATH, PV1READ, WEALTH, PV1SCIE, CNT)%>%
  filter(CNT=="United Kingdom")%>%
  select(-CNT)
PISAsubset$PV1MATH<-as.numeric(PISAsubset$PV1MATH)
PISAsubset$PV1READ<-as.numeric(PISAsubset$PV1READ)
PISAsubset$WEALTH<-as.numeric(PISAsubset$WEALTH)
PISAsubset$PV1SCIE<-as.numeric(PISAsubset$PV1SCIE)
ui <- fluidPage(
  titlePanel("Interactive Scatter Plot"),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "x_variable", label = "X-axis Variable", choices = colnames(PISAsubset)),
      selectInput(inputId = "y_variable", label = "Y-axis Variable", choices = colnames(PISAsubset))
    ),
    mainPanel(
      plotlyOutput(outputId = "scatter_plot")
    )
  )
)

# Define the server logic
server <- function(input, output) {
  output$scatter_plot <- renderPlotly({
    x_var <- input$x_variable
    y_var <- input$y_variable
    
    # Create a scatter plot using Plotly
    plot_ly(PISAsubset, x = ~PISAsubset[[x_var]], y = ~PISAsubset[[y_var]], mode = "markers") %>%
      layout(title = paste("Scatter Plot of", x_var, "vs.", y_var),
             xaxis = list(title = x_var),
             yaxis = list(title = y_var))
  })
}

# Run the Shiny app
shinyApp(ui = ui, server = server)