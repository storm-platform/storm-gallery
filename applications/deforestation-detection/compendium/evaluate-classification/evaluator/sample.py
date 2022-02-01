# -*- coding: utf-8 -*-
#
# Copyright (C) 2021 Storm Gallery.
#
# storm-gallery is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

import numpy as np
from sklearn.metrics import confusion_matrix, classification_report


def _producer_user_accuracy(cmatrix):
    """Compute Producer and user accuracy
    Args:
        cmatrix (Union[np.array, list]): array with sklearn confusion matrix
    Returns:
        dict: dictionary with producer, user, and overall_accuracy keys
    See:
        https://www.asprs.org/wp-content/uploads/pers/1986journal/mar/1986_mar_397-399.pdf
    """

    cmatrix = np.array(cmatrix).T

    column_total = cmatrix.sum(axis=0)
    row_total = cmatrix.sum(axis=1)

    data_diagonal = np.diagonal(cmatrix)

    return {
        "user": (data_diagonal / row_total).tolist(),
        "producer": (data_diagonal / column_total).tolist(),
        "overall_accuracy": data_diagonal.sum() / column_total.sum(),
    }


def generate_metrics_for_multilabel_classification(
    y_true: "np.ndarray", y_pred: "np.ndarray", labels: list, label_names: list
) -> dict:
    """Generate Confusion Matrix, Accuracy Score and F1-Score metrics.

    Args:
        y_true (np.ndarray): Ground truth (correct) target values.

        y_pred (np.ndarray): Estimated targets as returned by a classifier.

        labels (list): label in data

        label_names (list): List with labels names
    Returns:
        dict: Dictionary with confusion matrix, accuracy score and F1-Score metrics
    """

    # f1-score, accuracy, recall and precision
    metrics = classification_report(
        y_true=y_true,
        y_pred=y_pred,
        labels=labels,
        target_names=label_names,
        output_dict=True,
    )

    # confusion matrix
    metrics["cmatrix"] = confusion_matrix(y_true=y_true, y_pred=y_pred).tolist()

    metrics["user_producer_accuracy"] = _producer_user_accuracy(metrics["cmatrix"])
    return metrics
