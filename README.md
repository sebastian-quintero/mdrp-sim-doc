# mdrp-sim-doc

Here you can find the document that goes along with the code of the [Meal Delivery Routing Problem Simulator](https://github.com/sebastian-quintero/mdrp-sim).
This document was made with [Bookdown](https://bookdown.org/). Check out this [comprehensive documentation for Bookdown](https://bookdown.org/yihui/bookdown/).
Questions? Email me at: sebastianquinterorojas@gmail.com or connect with me via [Linkedin](https://www.linkedin.com/in/sebastian-quintero-rojas/).

## Document

The full PDF document can be found [here](https://github.com/sebastian-quintero/mdrp-sim-doc/tree/master/_book).
The dir is: `./_book/`.

## Set Up & Use

1. Download [R](https://cran.r-project.org/mirrors.html) and [RStudio](https://rstudio.com/products/rstudio/download/#download).
2. In the RStudio IDE, in the terminal, install the R package **bookdown**:

```R
# stable version on CRAN
install.packages("bookdown")
# or development version on GitHub
# devtools::install_github('rstudio/bookdown')
```

3. In the RStudio IDE terminal, use the following command to render the document (alternatively go to the _Build_ tab and use the _Build Book_ button):

```R
bookdown::render_book('index.Rmd')
```

4. The document is rendered in the `./_book/` dir.

## Bookdown For A Thesis

Here are some tips & tricks for using _Bookdown_ to write an Engineering Master's thesis.
