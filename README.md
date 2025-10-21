# Issue with S7

I have recently stumbled upon a problem with S7, which is related to https://github.com/RConsortium/S7/issues/240 which discusses allowing multiple packages to export the same generic.
The issue that I demonstrate here is essentially the same problem, but I believe the problem is even more severe, as it implies that packages **cannot reexport S7 generics**.
Because of this problem, packages like https://github.com/r-lib/generics would become impossible with S7.

To reproduce:

1.
Install the packages:

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

A workaround for this is to not directly reexport the generic, but a wrapper around this generic, possibly with the same name.

```r
pkg3::common_generic2
```
As long as all packages using `pkg1::common_generic` register their methods with this generic, packages work seamlessly together.

Of course, this solution is not very aesthetic and adds another unnecessary call, so maybe there is a better solution?
