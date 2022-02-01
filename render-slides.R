library(fs)
library(pagedown)
library(tidyverse)
library(knitr)

rmd_files <- dir_ls(path = "slides",
                    recurse = TRUE,
                    regexp = ".Rmd")

walk(rmd_files, knit)

html_files <- dir_ls(path = "slides",
                     recurse = TRUE,
                     regexp = ".html")

walk(html_files, chrome_print)


beepr::beep()
