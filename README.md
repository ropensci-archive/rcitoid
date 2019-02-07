rcitoid
=========

[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![Build Status](https://travis-ci.com/ropenscilabs/rcitoid.svg?branch=master)](https://travis-ci.com/ropenscilabs/rcitoid)
[![Build status](https://ci.appveyor.com/api/projects/status/yk8vpcdr1rmi7byy?svg=true)](https://ci.appveyor.com/project/sckott/rcitoid)
[![codecov](https://codecov.io/gh/ropensci/rcitoid/branch/master/graph/badge.svg)](https://codecov.io/gh/ropensci/rcitoid)
[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/rcitoid)](https://github.com/metacran/cranlogs.app)
[![cran version](https://www.r-pkg.org/badges/version/rcitoid)](https://cran.r-project.org/package=rcitoid)




Client for the Citoid service <https://www.mediawiki.org/wiki/Citoid>

docs: <https://en.wikipedia.org/api/rest_v1/#!/Citation/getCitation>

There are two functions, both of which do the same things, except:

- `cit_oid()`: parses text
- `cit_oid_()`: does not parse text, you can parse later yourself

Even with `cit_oid()` though, you get a list of lists, and you may
want to parse it to a data.frame. See an example below.

## Install

Development version


```r
devtools::install_github("ropenscilabs/rcitoid")
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
#> [1] "[{\"key\":\"D7K4PWH4\",\"version\":0,\"itemType\":\"webpage\",\"url\":\"https://www.emeraldinsight.com/action/captchaChallenge?redirectUrl=https%3A%2F%2Fwww.emeraldinsight.com%2Fdoi%2Fabs%2F10.1108%2FJD-12-2013-0166&\",\"title\":\"EmeraldInsight\",\"accessDate\":\"2019-02-07\",\"websiteTitle\":\"www.emeraldinsight.com\",\"DOI\":\"10.1108/jd-12-2013-0166\",\"source\":[\"Zotero\"]}]"
#> attr(,"type")
#> [1] "json"
```

## get citation data

DOI


```r
cit_oid("10.1108/jd-12-2013-0166")
#> [[1]]
#> [[1]]$key
#> [1] "XMNAGHYW"
#> 
#> [[1]]$version
#> [1] 0
#> 
#> [[1]]$itemType
#> [1] "webpage"
#> 
...
```

PMID


```r
cit_oid(30446726)
#> [[1]]
#> [[1]]$key
#> [1] "D8NZY5CY"
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
#> [1] "6SZW3VCH"
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
#> [1] "744303838"
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
#>    key   version itemType tags  title ISSN  journalAbbrevia…
#>    <chr>   <int> <chr>    <lis> <chr> <lis> <chr>           
#>  1 3XQ4…       0 journal… <lis… Enha… <chr… Mucosal Immunol 
#>  2 TD5Z…       0 journal… <lis… Shar… <chr… Mol. Biol. Evol.
#>  3 PU48…       0 webpage  <lis… Resp… <NUL… <NA>            
#>  4 J9S3…       0 journal… <dat… A mi… <chr… Integr Zool     
#>  5 RH77…       0 journal… <lis… ESMO… <NUL… <NA>            
#>  6 ZPV3…       0 journal… <lis… Effi… <NUL… <NA>            
#>  7 T2TI…       0 journal… <lis… Iden… <chr… J Hematol Oncol 
#>  8 <NA>       NA book     <NUL… Agro… <NUL… <NA>            
#>  9 KRG7…       0 journal… <dat… Anti… <chr… <NA>            
#> 10 42KK…       0 journal… <dat… The … <chr… Biol Cybern     
#> 11 VGSF…       0 webpage  <lis… Bahm… <NUL… <NA>            
#> 12 J484…       0 confere… <dat… Desi… <NUL… <NA>            
#> 13 B2V6…       0 confere… <dat… Traf… <NUL… <NA>            
#> # … with 26 more variables: publicationTitle <chr>, date <chr>,
#> #   abstractNote <chr>, DOI <chr>, extra <chr>, libraryCatalog <chr>,
#> #   url <chr>, accessDate <chr>, author <list>, PMID <chr>, source <list>,
#> #   language <chr>, shortTitle <chr>, websiteTitle <chr>, PMCID <chr>,
#> #   volume <chr>, issue <chr>, pages <chr>, oclc <chr>, ISBN <list>,
#> #   edition <chr>, place <chr>, numPages <chr>, contributor <list>,
#> #   proceedingsTitle <chr>, conferenceName <chr>
```

## Meta

* Please [report any issues or bugs](https://github.com/ropenscilabs/rcitoid/issues)
* License: MIT
* Get citation information for `rcitoid` in R doing `citation(package = 'rcitoid')`
* Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.


[![ropensci_footer](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)
