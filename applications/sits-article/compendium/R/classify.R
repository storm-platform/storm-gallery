#' @title Classify a Data Cube tile
#'
#' @rdname filter
#'
#' @description This function produces the complete cycle of a classification
#' of a cube. It generates the probability to the labels of a map.
#'
#' @param cube        a \code{sits_cube} object with the cube metadata.
#' @param model       a \code{sits_model} object with the machine learning
#'                    model.
#' @param ...         additional parameters.
#' @param smooth_type a \code{character} with the type of smoothing.
#' @param roi         Region of interest. It can be an \code{sf_object}, a
#'                    \code{shapefile} , or a bounding box vector with
#'                    named XY values ("xmin", "xmax", "ymin", "ymax") or
#'                    named lat/long values
#'                    ("lon_min", "lat_min", "lon_max", "lat_max").
#'
#' @return a \code{list} with the probabilities, smoothed and labelled cubes.
#'
#' @export
classify_tile <-
  function(cube, model, ..., smooth_type = "bayes", roi = NULL) {
    # Classify the data cube
    cube_probs <- sits::sits_classify(data     = cube,
                                      ml_model = model,
                                      roi      = roi,
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
