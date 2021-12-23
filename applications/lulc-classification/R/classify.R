#' @title Classify a Data Cube tile
#'
#' @rdname filter
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
classify_tile <-
  function(cube, model, ..., smooth_type = "bayes") {
    # Classify the data cube
    cube_probs <- sits::sits_classify(data     = cube,
                                      ml_model = model,
                                      ...)
    
    # Post-processing
    cube_probs_smoothed <- sits::sits_smooth(cube = cube_probs,
                                             type = smooth_type,
                                             ...)
    
    # Labeling
    lulc_labels <-
      sits::sits_label_classification(cube = cube_probs_smoothed,
                                      ...)
    
    list(probs = cube_probs,
         probs_smooth = cube_probs_smoothed,
         labels = lulc_labels)
  }
