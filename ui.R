shinyUI(pageWithSidebar(
        headerPanel("Plantetary Stellar Distance Estimation"),

        sidebarPanel(
            h4("The Kepler Mission"),
            p("The Mikulski Archive for Space Telescopes supports many astronomical
              datasets free and open for public and scientific use. Data for this
              application is from the Kepler Archive which contains data collected
              with the goal of finding habitable earth-like planets. Data presented here
              come from the confirmed planets dataset:
              http://archive.stsci.edu/kepler/confirmed_planets/search.php"),
            p("This application shows the relationship between inner-planetary orbit
              periods and their distance to the orbited star. In more plain English, we
              are attempting to predict a planet's distance to its star by measuring how
              long it takes the planet to make one orbit (which we commonly refer to on
              earth as being a year)."),
            p("We predict the distance to the home star based on year length because
              the Kepler Mission gives us data on the periodic transit of planetary bodies
              passing between us and that star. That is, it is relatively easy to accurately
              know how long a 'year' is, but less easy to know precisely how far that
              planet is from its star (at least in this simplified approach)."),
            h4("Using This Application"),
            p("Use the slider below to select a 'year' length based on earth days. We then
              calculate an estimate of how far that planet is from its star. The distance
              is measured in Astronomical Units - which happens to be the distance between
              the Earth and our sun. So, if you set the 'year' to 365 (days), then the
              distance is approximately 1. The estimate is based on exoplanetary data, so
              it is a bit off, but well within the 95% confidence interval (the dotted lines
              in the plot). The plot updates dynamically to show the point you have selected."),
            p("To see the Earth, and other inner planets from our solar system, check the
              Show box. Our planets close to home are relatively small compared to the
              exoplanets found to date, so if you'd like to enlarge them, select the Enlarge
              box. You can deselect these options at any time."),
            h4("What's in the Plot?"),
            p("The plot shows every exoplanet that has been discovered and confirmed (mostly)
              by the Kepler Mission. These planets are shown as semi-transparent circles with
              a white point at their center designating their year length (in Earth days) and
              distance to their home star (in AU). The size of the circle represents the
              relative size of each planet. Select the Show box to show the inner
              planets within our solar system, 4 color circles will appear representing
              Mercury (purple), Venus (yellow), Earth (blue), and Mars (orange). They are
              shown at scale, so may be very small and difficult to see. Select the Enlarge box
              to show our planets enlarged by a factor of 10."),
            h4("Additional Details"),
            p("Note that this process does not work for planets in our outer solar system (Jupiter,
              Saturn, Uranus, and Neptune). There are several reasoons for this, including: 1) No
              exoplanets been discovered that are even remotely as far from their home star, 2)
              Plotting such data on the same chart would be challenging at best - at the very least,
              we'd need to use log scales, but that may not even be sufficient, and 3) The prediction
              model used here is not very sophisticated and would be clearly incorrect for values
              well outside the range given."),
            p("Additional information about this application, including the underlying code
              and analysis can be found at: [link to github]")
        ),

        mainPanel(
            h4("Options"),
            checkboxGroupInput("showOurs", "Show Solar Planets",
                               c("Show"="1", "Enlarge"="2")),
            sliderInput("yr", "Select the Planet's Year Length (in days)",
                        value=365, min=1, max=700, step=1),
            list(tags$head(tags$style("body {background-color: #888888}"))),
            h4("You selected the planet's year length (days):"),
            verbatimTextOutput("year"),
            h4("Estimated distance to star given year length (AU):"),
            verbatimTextOutput("dist"),
            plotOutput(outputId='out', width="800px", height="600px")
        )
))