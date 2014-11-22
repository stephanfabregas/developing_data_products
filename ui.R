shinyUI(pageWithSidebar(
        headerPanel("Plantetary Stellar Distance Estimation"),

        sidebarPanel(
            checkboxGroupInput("showOurs", "Show Solar Planets",
                               c("Show"="1", "Enlarge"="2")),
            sliderInput("yr", "Select the Planet's Year Length (in days)",
                        value=365, min=1, max=700, step=1)
        ),

        mainPanel(
            list(tags$head(tags$style("body {background-color: #888888}"))),
            h4("You selected the planet's year length (days):"),
            verbatimTextOutput("year"),
            h4("Estimated distance to star given year length (AU):"),
            verbatimTextOutput("dist"),
            plotOutput(outputId='out', width="700px", height="500px")
        )
))