#' @export
class_pkg1 <- S7::new_class("class_pkg1")

#' @export
common_generic <- S7::new_generic("common_generic", "x", function(x) {
  S7::S7_dispatch()
})

S7::method(common_generic, class_pkg1) <- function(x) {
  print("Calling from pkg1")
}
