rcitoid
=========

[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![cran checks](https://cranchecks.info/badges/worst/rcitoid)](https://cranchecks.info/pkgs/rcitoid)
[![R-check](https://github.com/ropensci/rcitoid/workflows/R-check/badge.svg)](https://github.com/ropensci/rcitoid/actions?query=workflow%3AR-check)
[![codecov](https://codecov.io/gh/ropensci/rcitoid/branch/master/graph/badge.svg)](https://codecov.io/gh/ropensci/rcitoid)
[![rstudio mirror downloads](https://cranlogs.r-pkg.org/badges/rcitoid)](https://github.com/r-hub/cranlogs.app)
[![cran version](https://www.r-pkg.org/badges/version/rcitoid)](https://cran.r-project.org/package=rcitoid)




Client for the Citoid service https://www.mediawiki.org/wiki/Citoid

docs: https://en.wikipedia.org/api/rest_v1/#!/Citation/getCitation

There are two functions, both of which do the same things, except:

- `cit_oid()`: parses text
- `cit_oid_()`: does not parse text, you can parse later yourself

Even with `cit_oid()` though, you get a list of lists, and you may
want to parse it to a data.frame. See an example below.

## Install

Stable version


```r
install.packages("rcitoid")
```

Development version


```r
remotes::install_github("ropensci/rcitoid")
```

Load the package



```r
library("rcitoid")
```

## get citation data

use underscore method to get text


```r
cit_oid_("10.1108/jd-12-2013-0166")
#> [[1]]
#> [1] "[{\"key\":\"6FVPATDA\",\"version\":0,\"itemType\":\"journalArticle\",\"tags\":[],\"publicationTitle\":\"Journal of Documentation\",\"journalAbbreviation\":\"Journal of Documentation\",\"volume\":\"71\",\"issue\":\"2\",\"language\":\"en\",\"ISSN\":[\"0022-0418\"],\"date\":\"2015-03-09\",\"pages\":\"253–277\",\"DOI\":\"10.1108/JD-12-2013-0166\",\"url\":\"https://www.emerald.com/insight/content/doi/10.1108/JD-12-2013-0166/full/html\",\"title\":\"Setting our bibliographic references free: towards open citation data\",\"libraryCatalog\":\"DOI.org (Crossref)\",\"accessDate\":\"2020-11-26\",\"shortTitle\":\"Setting our bibliographic references free\",\"author\":[[\"Silvio\",\"Peroni\"],[\"Alexander\",\"Dutton\"],[\"Tanya\",\"Gray\"],[\"David\",\"Shotton\"]],\"source\":[\"Zotero\"]}]"
#> attr(,"type")
#> [1] "json"
```

## get citation data

DOI


```r
cit_oid("10.1108/jd-12-2013-0166")
#> [[1]]
#> [[1]]$key
#> [1] "HCXFCV8F"
#> 
#> [[1]]$version
#> [1] 0
#> 
#> [[1]]$itemType
#> [1] "journalArticle"
#> 
...
```

PMID


```r
cit_oid(30446726)
#> [[1]]
#> [[1]]$key
#> [1] "JDITNMEK"
#> 
#> [[1]]$version
#> [1] 0
#> 
#> [[1]]$itemType
#> [1] "journalArticle"
#> 
...
```

PMCID


```r
cit_oid("PMC4679344")
#> [[1]]
#> [[1]]$key
#> [1] "SY68KLQD"
#> 
#> [[1]]$version
#> [1] 0
#> 
#> [[1]]$itemType
#> [1] "journalArticle"
#> 
...
```

ISBN


```r
cit_oid(1439895619)
#> [[1]]
#> [[1]]$itemType
#> [1] "book"
#> 
#> [[1]]$title
#> [1] "Agroecology : the ecology of sustainable food systems"
#> 
#> [[1]]$oclc
#> [1] "908080219"
#> 
...
```

## parse to data.frame

because the resulting data is nested and can have missing data slots,
it's probably easier to get raw text and manipulate from there.


```r
library(dplyr)

pmid <- c(30446726, 30722046, 30687373, 30688010)
pmcid <- c("PMC4679344", "PMC6347797", "PMC6347793")
isbn <- 1439895619
dois <- c("10.1109/jsac.2011.110806", "10.1007/s00422-006-0078-4",
  "10.5040/9781474219624-0044", "10.1109/icemi.2009.5274826",
  "10.1109/wispnet.2017.8299996")
res <- cit_oid_(id = c(pmid, pmcid, isbn, dois))
tbl_df(bind_rows(lapply(res, jsonlite::fromJSON)))
#> # A tibble: 13 x 33
#>    key   version itemType tags  title pages ISSN  journalAbbrevia…
#>    <chr>   <int> <chr>    <lis> <chr> <chr> <lis> <chr>           
#>  1 P4CD…       0 journal… <df[… Enha… 555–… <chr… Mucosal Immunol 
#>  2 QR7H…       0 journal… <df[… Shar… 1113… <chr… Mol Biol Evol   
#>  3 SLTV…       0 journal… <df[… Resp… 1981  <chr… Front Plant Sci 
#>  4 CWF3…       0 journal… <df[… Mixe… 604–… <chr… Integr Zool     
#>  5 YG5T…       0 journal… <lis… ESMO… 2–30  <chr… Int J Gynecol C…
#>  6 6W95…       0 journal… <lis… Effi… <NA>  <chr… J Orthop Surg R…
#>  7 R3ZP…       0 journal… <lis… Iden… <NA>  <chr… J Hematol Oncol 
#>  8 <NA>       NA book     <NUL… Agro… <NA>  <NUL… <NA>            
#>  9 G24A…       0 journal… <lis… Anti… 1392… <chr… IEEE J. Select.…
#> 10 SXSZ…       0 journal… <lis… The … 193–… <chr… Biol Cybern     
#> 11 LG4G…       0 book     <lis… The … <NA>  <NUL… <NA>            
#> 12 778X…       0 confere… <df[… Desi… 1–47… <NUL… <NA>            
#> 13 P5X4…       0 confere… <lis… Traf… 1412… <NUL… <NA>            
#> # … with 25 more variables: publicationTitle <chr>, volume <chr>, issue <chr>,
#> #   date <chr>, abstractNote <chr>, DOI <chr>, extra <chr>,
#> #   libraryCatalog <chr>, url <chr>, accessDate <chr>, author <list>,
#> #   PMID <chr>, PMCID <chr>, source <list>, shortTitle <chr>, oclc <chr>,
#> #   ISBN <list>, place <chr>, numPages <chr>, contributor <list>,
#> #   language <chr>, publisher <chr>, editor <list>, proceedingsTitle <chr>,
#> #   conferenceName <chr>
```

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/rcitoid/issues)
* License: MIT
* Get citation information for `rcitoid` in R doing `citation(package = 'rcitoid')`
* Please note that this package is released with a [Contributor Code of Conduct](https://ropensci.org/code-of-conduct/). By contributing to this project, you agree to abide by its terms.

[![ropensci_footer](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)
