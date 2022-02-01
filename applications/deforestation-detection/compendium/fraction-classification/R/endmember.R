# -*- coding: utf-8 -*-
#
# Copyright (C) 2021 Storm Gallery.
#
# storm-gallery is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.


#' @title Transform a endmember list in a Data Frame
#'
#' @rdname endmember
#'
#' @description
#' description
#'
#' @param ... ...
#'
#' @param ... ...
#'
#' @return todo
#' @export
as.endmember.data.frame <- function(endmember_definition) {
  em_names <- names(endmember_definition)

  ems <- lapply(1:length(em_names), function(index) {
    unlist(x         = endmember_definition[em_names[index]],
           use.names = FALSE)
  })

  data.frame(t(data.frame(ems)), row.names = em_names)
}
