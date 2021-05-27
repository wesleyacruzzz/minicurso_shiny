title <- "ENEM"

ui <- fluidPage(
    
dashboardPage(
dashboardHeader(title = title,titleWidth = "300px"),
# Side Bar ####
dashboardSidebar(width = "300px",
  sidebarMenu(
    
    menuItem("Modelagem dos dados",
      tabName = "tabs",
    selectInput("mod","Escolha o modelo",
      choices=c("XGboost","Random Forest"),selected = "XGboost")),
    
    menuItem("Predição",
             tabName = "tabs",textAreaInput("quest","Adicione todas as              suas questões")),
    actionButton("but1", "Refresh")
)),
        # Body ####
dashboardBody(
  tags$head(
    tags$style(HTML(
                    '.myClass { 
          font-size: 20px;
          line-height: 50px;
          text-align: left;
          font-family: "Helvetica Neue",Helvetica,Arial,sans-serif;
          padding: 0 15px;
          overflow: hidden;
          color: white;
          }
          ')),
                
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")),
    tags$script(HTML('
                       $(document).ready(function() {
                       $("header").find("nav").append(\'<span class="myClass"> Predição das notas do ENEM </span>\');
                       })
                       
                       ')),
            
fluidRow(width=12,
  tabBox(height = "540px", width = 12,
    tabsetPanel(id = "tabs",
      tabPanel(" ", value = "A",
        splitLayout(
          dataTableOutput("metricas"),
          column(width = 12,
            splitLayout(
              infoBoxOutput("res", width = 12),
              infoBoxOutput("res1", width = 12),
            cellWidths = c("50%","50%")),
          plotOutput("plot1")),
        cellWidths = c("30%","70%"),
        cellArgs = list(style = "padding: 6px"),
        style = "border: 1px solid silver;"))
                                     
                         )))
            
        )
    ))