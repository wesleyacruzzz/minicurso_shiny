title <- "Desenhando com triângulos"

ui <- fluidPage(
    
    dashboardPage(
        dashboardHeader(title = title),
        # Side Bar ####
        dashboardSidebar(disable = T),
        
        # Body ####
        dashboardBody(
            tabPanel("Índice de capacidade",
                     fluidRow(width=12,
                              splitLayout(
                                plotOutput("plot1",
                                  click = "plot_click"),
                                plotOutput("plot2"),
                                cellWidths = c("70%","30%")),
                              box(numericInput("linha","Linha de corte",10))
                     )
            )
        )
    ))
