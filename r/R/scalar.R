# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

#' @include arrow-package.R

#' @title Arrow scalars
#' @usage NULL
#' @format NULL
#' @docType class
#'
#' @description A `Scalar` holds a single value of an Arrow type.
#'
#' @name Scalar
#' @rdname Scalar
#' @export
Scalar <- R6Class("Scalar",
  inherit = ArrowObject,
  # TODO: document the methods
  public = list(
    ToString = function() Scalar__ToString(self),
    cast = function(target_type, safe = TRUE, ...) {
      opts <- list(
        to_type = as_type(target_type),
        allow_int_overflow = !safe,
        allow_time_truncate = !safe,
        allow_float_truncate = !safe
      )
      call_function("cast", self, options = modifyList(opts, list(...)))
    },
    as_vector = function() Scalar__as_vector(self)
  ),
  active = list(
    is_valid = function() Scalar__is_valid(self),
    null_count = function() sum(!self$is_valid),
    type = function() Scalar__type(self)
  )
)
Scalar$create <- function(x, type = NULL) {
  if (is.null(x)) {
    x <- vctrs::unspecified(1)
  } else if (length(x) != 1 && !is.data.frame(x)) {
    # Wrap in a list type
    x <- list(x)
  }
  Array__GetScalar(Array$create(x, type = type), 0)
}

#' @rdname array
#' @usage NULL
#' @format NULL
#' @export
StructScalar <- R6Class("StructScalar",
  inherit = Scalar,
  public = list(
    field = function(i) StructScalar__field(self, i),
    GetFieldByName = function(name) StructScalar__GetFieldByName(self, name)
  )
)

#' @export
length.Scalar <- function(x) 1L

#' @export
is.na.Scalar <- function(x) !x$is_valid

#' @export
as.vector.Scalar <- function(x, mode) x$as_vector()

#' @export
as.double.Scalar <- as.double.Array

#' @export
as.integer.Scalar <- as.integer.Array

#' @export
as.character.Scalar <- as.character.Array
