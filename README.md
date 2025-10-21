# Issue with S7

I have recently stumbled upon a problem with S7, which is related to https://github.com/RConsortium/S7/issues/240 which discusses allowing multiple packages to export the same generic.
The issue that I demonstrate here is essentially the same problem, but I believe the problem is even more severe, as it implies that packages **cannot reexport S7 generics**.

We start by installing the packages

```r
devtools::install("pkg1")
devtools::install("pkg2")
devtools::install("pkg3")
```

The problem is now, that when attaching both packages, they will be conflicting:

``` r
library(pkg3)
common_generic
#> <S7_generic> common_generic(x) with 2 methods:
#> 1: method(common_generic, pkg3::class_pkg3)
#> 2: method(common_generic, pkg1::class_pkg1)
library(pkg2)
#>
#> Attaching package: 'pkg2'
#> The following object is masked from 'package:pkg3':
#>
#>     common_generic
common_generic
#> <S7_generic> common_generic(x) with 2 methods:
#> 1: method(common_generic, pkg2::class_pkg2)
#> 2: method(common_generic, pkg1::class_pkg1)
```

<sup>Created on 2025-10-21 with [reprex v2.1.1](https://reprex.tidyverse.org)</sup>


A workaround for this is to not directly reexport the generic, but a wrapper around this generic, possibly with the same name.


```r
pkg3::common_generic_wrapper
#> function (...)
#> {
#>     pkg1::common_generic(...)
#> }
#> <bytecode: 0x12df7c780>
#> <environment: namespace:pkg3>
pkg1::common_generic
#> <S7_generic> common_generic(x) with 3 methods:
#> 1: method(common_generic, pkg3::class_pkg3)
#> 2: method(common_generic, pkg2::class_pkg2)
#> 3: method(common_generic, pkg1::class_pkg1)
```

As long as all packages using `pkg1::common_generic` register their methods with this generic, packages work seamlessly together.

Of course, this solution is not very aesthetic and adds another unnecessary call.
I think at the very least this should be documented, as it's not completely obvious and resulting bugs will not be caught in unit tests, unless the packages reexporting the same generic depend on each other as well.
