library(shiny)


shinyUI(
    pageWithSidebar(
    
    headerPanel("Milhas por Galão"),
    
    sidebarPanel(
        selectInput("var", "Variável:",
                    list("Cilindradas" = "cyl", 
                         "Transmissão" = "am", 
                         "Marchas" = "gear")),
        
        checkboxInput("outliers", "Mostrar outliers", FALSE)
    ),
    
    mainPanel(
        h3(textOutput("formula")),
        
        plotOutput("mpgPlot")
    )
))