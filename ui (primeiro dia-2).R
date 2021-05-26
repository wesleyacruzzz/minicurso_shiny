library(shiny)
library(tidyverse)
library(shinydashboard)

dashboardPage(
    dashboardHeader(title = "Dashboard Básico"),
    dashboardSidebar(disable = T),
    
    dashboardBody(
        fluidRow(
            column(width = 6,
                   plotOutput("plot1", height = 400)),
            
            column(width = 6,
                   box(
                       sliderInput("slider", "Número de observações:", 1, 10000, 1000),
                       sliderInput("slider1", "Média", -10000, 10000, 0),
                       sliderInput("slider2", "Desvio padrão", 0.1, 10, 1)
                   ),
                   box(
                       title = "Deseja comparar com outra distribuição Normal?",
                       numericInput("num1", "Média",value = 10),
                       numericInput("num2", "Desvio padrão",value = 1),
                       selectInput("comparar","Comparar", 
                                   choices = c("Nada","Sim"),selected = "Nada")
                   ))
        )
    )
)