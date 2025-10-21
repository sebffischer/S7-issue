#' @export
class_pkg3 <- S7::new_class("class_pkg3")

#' @importFrom pkg1 common_generic
S7::method(common_generic, class_pkg3) <- function(x) {
  print("Calling from pkg3")
}

#' @export
#' @export
common_generic <- function(...) {
  pkg1::common_generic(...)
}

.onLoad <- function(libname, pkgname) {
  S7::methods_register()
}
