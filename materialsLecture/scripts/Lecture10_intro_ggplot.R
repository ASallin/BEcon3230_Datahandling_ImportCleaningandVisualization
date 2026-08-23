## The grammar of graphics in action

# Example from [A Comprehensive Guide to the Grammar of Graphics for Effective 
# Visualization of Multi-dimensional Data](https://towardsdatascience.com/a-comprehensive-guide-to-the-grammar-of-graphics-for-effective-visualization-of-multi-dimensional-1f92b4ed4149) 
# using the built-in `mtcars` dataset in R.

library(ggplot2)
mtcars # mtcars is a built-in dataset in R


## From two dimensions...
ggplot(mtcars, aes(x = wt, y = mpg)) + 
  geom_point() + 
  theme_bw()


## To three dimensions...
ggplot(mtcars, aes(x = wt, y = mpg, color=factor(gear))) + 
  geom_point() + 
  theme_bw()

## To four dimensions...
ggplot(mtcars, aes(x = wt, y = mpg, color=factor(gear), size = cyl)) + 
  geom_point() + 
  theme_bw()

## To four dimensions (with `facets`)...
ggplot(mtcars, aes(x = wt, y = mpg, color=factor(gear))) + 
  geom_point() +
  facet_wrap(~cyl) +
  theme_bw()

## To five dimensions
ggplot(mtcars, aes(x = wt, y = mpg, color=factor(gear), size = cyl)) + 
  geom_point() +
  facet_wrap(~am) +
  theme_bw()

## To six dimensions
ggplot(mtcars, aes(x = wt, y = mpg, color=factor(gear), size = cyl)) + 
  geom_point() +
  facet_grid(am ~ carb) +
  theme_bw()