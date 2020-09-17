rcitoid
=========

[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![cran checks](https://cranchecks.info/badges/worst/rcitoid)](https://cranchecks.info/pkgs/rcitoid)
[![Build Status](https://travis-ci.com/ropensci/rcitoid.svg?branch=master)](https://travis-ci.com/ropensci/rcitoid)
[![Build status](https://ci.appveyor.com/api/projects/status/yk8vpcdr1rmi7byy?svg=true)](https://ci.appveyor.com/project/sckott/rcitoid)
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
#> [1] "[{\"key\":\"6GCZU4NS\",\"version\":0,\"itemType\":\"journalArticle\",\"tags\":[],\"publicationTitle\":\"Journal of Documentation\",\"journalAbbreviation\":\"Journal of Documentation\",\"volume\":\"71\",\"issue\":\"2\",\"language\":\"en\",\"ISSN\":[\"0022-0418\"],\"date\":\"2015-03-09\",\"pages\":\"253–277\",\"DOI\":\"10.1108/JD-12-2013-0166\",\"url\":\"https://www.emerald.com/insight/content/doi/10.1108/JD-12-2013-0166/full/html\",\"title\":\"Setting our bibliographic references free: towards open citation data\",\"libraryCatalog\":\"DOI.org (Crossref)\",\"accessDate\":\"2020-09-17\",\"shortTitle\":\"Setting our bibliographic references free\",\"author\":[[\"Silvio\",\"Peroni\"],[\"Alexander\",\"Dutton\"],[\"Tanya\",\"Gray\"],[\"David\",\"Shotton\"]],\"source\":[\"Zotero\",\"Zotero\"]}]"
#> attr(,"type")
#> [1] "json"
```

## get citation data

DOI


```r
cit_oid("10.1108/jd-12-2013-0166")
#> [[1]]
#> [[1]]$key
#> [1] "YFQK7UCZ"
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
#> [1] "R4A72DW5"
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
#> [1] "VSJ5LSKX"
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
#> # A tibble: 13 x 34
#>    key   version itemType tags  title websiteTitle url   abstractNote date 
#>    <chr>   <int> <chr>    <lis> <chr> <chr>        <chr> <chr>        <chr>
#>  1 TDF5…       0 webpage  <lis… Enha… Mucosal imm… http… "BCG, the o… 2019…
#>  2 R2LH…       0 journal… <df[… Shar… <NA>         http… "Sex determ… 06 0…
#>  3 YEQJ…       0 journal… <df[… Resp… <NA>         http… "With the i… 2018 
#>  4 H4CX…       0 journal… <df[… Mixe… <NA>         http… "Medicinal … 2019…
#>  5 NSWJ…       0 journal… <lis… ESMO… <NA>         http… "Supplement… 2016…
#>  6 V3N3…       0 journal… <lis… Effi… <NA>         http… "Background… 2019…
#>  7 NHLX…       0 journal… <lis… Iden… <NA>         http… "Background… 2019…
#>  8 <NA>       NA book     <NUL… Agro… <NA>         http… "Providing … <NA> 
#>  9 MBYX…       0 journal… <lis… Anti… <NA>         http…  <NA>        2011…
#> 10 LTT6…       0 journal… <lis… The … <NA>         http…  <NA>        2006…
#> 11 RJB8…       0 book     <lis… The … <NA>         <NA>   <NA>        2006 
#> 12 U4EQ…       0 confere… <df[… Desi… <NA>         http… "Testabilit… 2009…
#> 13 RDTJ…       0 confere… <lis… Traf… <NA>         http…  <NA>        2017…
#> # … with 25 more variables: extra <chr>, language <chr>, accessDate <chr>,
#> #   author <list>, PMID <chr>, PMCID <chr>, DOI <chr>, source <list>,
#> #   pages <chr>, ISSN <list>, journalAbbreviation <chr>,
#> #   publicationTitle <chr>, volume <chr>, issue <chr>, libraryCatalog <chr>,
#> #   shortTitle <chr>, oclc <chr>, ISBN <list>, place <chr>, numPages <chr>,
#> #   contributor <list>, publisher <chr>, editor <list>, proceedingsTitle <chr>,
#> #   conferenceName <chr>
```

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/rcitoid/issues)
* License: MIT
* Get citation information for `rcitoid` in R doing `citation(package = 'rcitoid')`
* Please note that this package is released with a [Contributor Code of Conduct](https://ropensci.org/code-of-conduct/). By contributing to this project, you agree to abide by its terms.

[![ropensci_footer](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)
