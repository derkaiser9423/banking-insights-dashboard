# Load required libraries
library(shiny)
library(ggplot2)
library(dplyr)

# Load the dataset
data <- read.csv("bank-full.csv", sep = ";", header = TRUE)


# Define the User Interface (UI)
ui <- fluidPage(
  titlePanel("Bank Marketing Dashboard"),
  
  sidebarLayout(
    sidebarPanel(
      h3("Filters"),
      selectInput("job", "Select Job Type:", 
                  choices = c("All", unique(data$job)), 
                  selected = "All"),
      selectInput("marital", "Select Marital Status:", 
                  choices = c("All", unique(data$marital)), 
                  selected = "All"),
      selectInput("education", "Select Education Level:", 
                  choices = c("All", unique(data$education)), 
                  selected = "All")
    ),
    
    mainPanel(
      tabsetPanel(
        # Overview Tab
        tabPanel("Overview",
                 h4("Subscription Rate"),
                 plotOutput("subscriptionRate"),
                 h4("Demographic Insights"),
                 plotOutput("ageDistribution")),
        
        # Financial Insights Tab
        tabPanel("Financial Insights",
                 h4("Balance vs Subscription"),
                 plotOutput("balancePlot")),
        
        # Campaign Performance Tab
        tabPanel("Campaign Performance",
                 h4("Contact Duration vs Subscription"),
                 plotOutput("contactDuration"),
                 h4("Monthly Trends"),
                 plotOutput("monthlyTrend"))
      )
    )
  )
)

# Define the Server Logic
server <- function(input, output) {
  # Filter the data based on user input
  filteredData <- reactive({
    data_filtered <- data
    if (input$job != "All") {
      data_filtered <- data_filtered[data_filtered$job == input$job, ]
    }
    if (input$marital != "All") {
      data_filtered <- data_filtered[data_filtered$marital == input$marital, ]
    }
    if (input$education != "All") {
      data_filtered <- data_filtered[data_filtered$education == input$education, ]
    }
    return(data_filtered)
  })
  
  # Subscription Rate Plot
  output$subscriptionRate <- renderPlot({
    ggplot(filteredData(), aes(x = y, fill = y)) +
      geom_bar() +
      labs(title = "Subscription Rates", x = "Subscribed (Yes/No)", y = "Count") +
      theme_minimal()
  })
  
  # Age Distribution Plot
  output$ageDistribution <- renderPlot({
    ggplot(filteredData(), aes(x = age)) +
      geom_histogram(binwidth = 5, fill = "blue", color = "white") +
      labs(title = "Age Distribution", x = "Age", y = "Count") +
      theme_minimal()
  })
  
  # Balance vs Subscription
  output$balancePlot <- renderPlot({
    ggplot(filteredData(), aes(x = y, y = balance, fill = y)) +
      geom_boxplot() +
      labs(title = "Balance by Subscription Status", x = "Subscribed (Yes/No)", y = "Balance") +
      theme_minimal()
  })
  
  # Contact Duration vs Subscription
  output$contactDuration <- renderPlot({
    ggplot(filteredData(), aes(x = duration, y = as.numeric(as.factor(y)))) +
      geom_smooth(method = "lm", color = "blue") +
      labs(title = "Contact Duration vs Subscription", x = "Contact Duration (seconds)", y = "Subscription Likelihood") +
      theme_minimal()
  })
  
  # Monthly Subscription Trends
  output$monthlyTrend <- renderPlot({
    ggplot(filteredData(), aes(x = month, fill = y)) +
      geom_bar(position = "dodge") +
      labs(title = "Monthly Subscription Trends", x = "Month", y = "Count") +
      theme_minimal()
  })
}

# Run the application
shinyApp(ui = ui, server = server)
