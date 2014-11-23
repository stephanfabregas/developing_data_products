<style>
.section .reveal .state-background {
  background: #333333;
}

.section .reveal h1,
.section .reveal h2,
.section .reveal p {
  color: white;
}

ul, p {
  color: #333333;
}
</style>

Planetary Stellar Distance Estimation
========================================================
author: Stephan E. Fabregas
date: 2014-11-23

The Planetary Stellar Distance Estimation Tool
========================================================
- With a dataset of confirmed exoplanets, we can calculate an estimation
of a planet's stellar distance based on its orbital period (or what we
more commonly refer to as a year).

- You can explore this relationship using the Planetary Stellar Distance
Estimation tool at: http://sfabregas.shinyapps.io/developing_data_products

The Kepler Mission
========================================================



The Kepler Mission has given humanity its first look at planets
outside our own solar system.

- Thousands of potential planets have been identified
- More than 844 planets from over 374 star systems have been confirmed
- This has all been accomplished within just the last 5-10 years
- There is still much to learn about the diversity of planets

Discovering Exoplanets
========================================================

- When a planet passes between us and its star, the observed brightness
of that star decreases very slightly
- If we observe this small change and it happens at regular intervals,
then we may guess that we have found a planet
- Based on the length of that interval, we can also guess how far away
that planet is from its star

Using the Tool
========================================================

- Use this [shinyapps tool](http://sfabregas.shinyapps.io/developing_data_products)
to explore what we know about hundreds of discovered exoplanets
- For example - the estimated distance to its star (in AU) for a planet whose year is 600 days long:




```r
predict(dist.fit, newdata=data.frame(year=600))[[1]]
```

```
[1] 1.333
```

- Also compare how these discovered exoplanets compare to familiar planets
within our solar system - Mercury, Venus, Earth, and Mars
