# Author: Stephan E. Fabregas
# Title: Exploring Extra-solar Planets
# Date: 2014-11-23
# Contact: stephan.fabregas@gmail.com

# Data downloaded from: http://archive.stsci.edu/kepler/confirmed_planets/search.php
# Options selected:
#   Output format - File: comma-separated values
#   Remove Null Columns selected
#   Maximum Records 10001
# All other values are default, then download the data
# NOTE: the second row in the data downloaded was removed
#   before processing in R. Also, the file extension was
#   changed from .txt to .csv
# Data information:
# http://archive.stsci.edu/search_fields.php?mission=kepler_cp
# ASSUMPTIONS: Magnitudes provided are apparent, not absolute

# Reference for light spectrum:
# https://www.astro.umd.edu/~ssm/ASTR620/mags.html
# http://en.wikipedia.org/wiki/Visible_spectrum
# g-band = blue
# r-band = yellow
# i-band = red
# z-band = infrared
# Sun band magnitudes:
# http://www.ucolick.org/~cnaw/sun.html
# g = -26.37
# r = -27.08
# i = -27.42
# z = -27.59
#library(shiny)

# Load the data
d <- read.csv("kepler_cp_search_use.csv")

# Use only variables of interest and complete cases
drop <- c(3, 4, 5, 6, 9, 11, 12, 13, 14, 15, 16, 18, 20, 21, 32, 33, 34, 35, 36, 37)
d <- d[, -drop]
d <- d[complete.cases(d),]

# Rename and refactor variables to clean things a bit
names(d) <- c("name", "system", "temp", "size", "year", "discovery", "distToStar", "age", "mass", "starSize", "effTemp", "gravity", "mag", "gMag", "rMag", "iMag", "zMag")
d$system <- as.factor(d$system)
# Convert units to something more useful
# Show firstTransit as the date of first discovery
startdate <- as.Date("2009-01-01")
d$discovery <- startdate + d$discovery
# Show stellar gravity in m/s2
d$gravity <- 10^d$gravity / 100
# Convert mag data to RBGA data
minmag <- min(d[,14:17])
maxmag <- max(d[,14:17])
d$gMag <- (d$gMag-minmag)/(maxmag-minmag) * 16
d$rMag <- (d$rMag-minmag)/(maxmag-minmag) * 16
d$iMag <- (d$iMag-minmag)/(maxmag-minmag) * 16
d$zMag <- (d$zMag-minmag)/(maxmag-minmag) * 16
rangeMag <- (max(d[,13]) - min(d[,13]))
d$mag <- (d$mag - min(d[,13]))/(rangeMag) * 16
d$rr <- round(d$iMag * d$mag)
d$gg <- round(d$rMag * d$mag)
d$bb <- round(d$gMag * d$mag)
d$aa <- round(d$zMag * d$mag)
d$color <- paste("#", as.character(as.hexmode(d$rr)),
               as.character(as.hexmode(d$gg)), as.character(as.hexmode(d$bb)),
               sep="")

# Count planets per system
countPlanets <- function(x) {
    return(length(d$system[d$system==x]))
}
d$numPlanets <- sapply(d$system, countPlanets)

# Predicting distance to planet based on length of year
dist.fit <- glm(distToStar~year*I(log(year)), data=d)
dist.conf <- confint(dist.fit)

pred <- function(x, b, m1, m2, m3) {
    return(b + m1*x + m2*log(x) + m3*(x*log(x)))
}

# Set up prediction lines for plotting
pred.fit <- predict(dist.fit, newdata=data.frame(year=c(1:750)))
pred.low <- pred(1:750, dist.conf[1,1], dist.conf[2,1], dist.conf[3,1], dist.conf[4,1])
pred.high <- pred(750:1, dist.conf[1,2], dist.conf[2,2], dist.conf[3,2], dist.conf[4,2])

# Addtiional planetary data from http://wikipedia.org
planets <- data.frame(year=c(686.97, 365.24199, 224.7011, 87.969), dist=c(1.523679, 1.0, 0.723327, 0.387098),
                      size=c(0.533, 1.0, 0.9499, 0.3829), color=c("orange", "#3388ff", "yellow", "purple"))

shinyServer(
    function(input, output) {
        # User input prediction
        inp <- reactive({predict(dist.fit, newdata=data.frame(year=input$yr))})
        output$year <- renderPrint({input$yr})
        output$dist <- renderPrint({inp()[[1]]})
        # The big plot
        output$out <- renderPlot({
            # Set scaling factor for solar inner-planets according to user checkbox
            big <- 0
            if (length(input$showOurs) == 2)
                big <- 10
            else
                if (length(input$showOurs) == 1)
                    if (input$showOurs == "1")
                        big <- 1
            # Begin the plotting process
            par(bg="#000000", col.axis="white", col.lab="white", col.main="white", fg="white")
            plot(pred.fit, type="n", xlim=c(0, 700), ylim=c(0, 1.6),
            main="Exoplanets", xlab="Length of Year (in Earth days)", ylab="Distance to Star (AU)")
            # Confidence interval shading
            polygon(c(1:750, 750:1), c(pred.low, pred.high), col="#1f1f1f", border=NA)
            # Note that exoplanets are colored according to their apparent mag data at major wavelength bands
            points(d$year, d$distToStar, cex=d$size, pch=19, col=d$color)
            points(d$year, d$distToStar, cex=d$size, col="#aaaaaa44")
            # Prediction and c.i. lines and points
            lines(pred.fit, col="white")
            lines(1:750, pred.low, lty=2)
            lines(750:1, pred.high, lty=2)
            points(d$year, d$distToStar, pch=".")
            # Planets from our inner solor system scaled according to user checkbox options
            points(planets$year, planets$dist, col=as.character(planets$color), cex=planets$size*big, pch=19)
            points(planets$year, planets$dist, cex=planets$size*big, col="#1f1f1f")
            # Target showing user input/prediction
            abline(h=inp())
            abline(v=input$yr)
        })
    })