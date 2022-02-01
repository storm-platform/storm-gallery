# -*- coding: utf-8 -*-
#
# Copyright (C) 2021 Storm Gallery.
#
# storm-gallery is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

import posixpath

from pathlib import Path
from typing import Union, List

from pystac.item import Item

from osgeo import gdal


def item2stack_vrt(items: List[Item], assets: List[str], output_dir: Union[Path, str]):
    """Convert a STAC Item into a GDAL Virtual Format (VRT) stack."""
    output_dir = Path(output_dir)
    output_dir.mkdir(exist_ok=True, parents=True)

    for item in items:
        # split one item in multiple vrts
        for asset_name, asset_obj in item.assets.items():
            if asset_name in assets:

                # processing the href
                asset_href = f"/vsicurl/{asset_obj.href}"

                asset_file_id = posixpath.splitext(
                    posixpath.basename(asset_href).split("?", 1)[0]
                )[0]

                # creating the vrt
                vrt_file = output_dir / (asset_file_id + ".vrt")

                vrt_gdal = gdal.BuildVRT(str(vrt_file), asset_href)
                vrt_gdal = None


def item2brick_vrt(
    items: List[Item], assets: List[str], output_dir: Union[Path, str]
) -> List[Path]:
    """Convert a STAC Item into a GDAL Virtual Format (VRT) brick."""
    output_dir = Path(output_dir)
    output_dir.mkdir(exist_ok=True, parents=True)

    generated_vrts = []

    for item in items:
        item_id = item.id
        item_assets = item.assets

        # creating the vrt
        vrt_file = output_dir / (item_id + ".vrt")

        # using the selected assets
        vrt_assets = [
            f"/vsicurl/{asset.href}"
            for asset_name, asset in item_assets.items()
            if asset_name in assets
        ]

        # building!
        vrt_options = gdal.BuildVRTOptions(separate=True)
        vrt_gdal = gdal.BuildVRT(str(vrt_file), vrt_assets, options=vrt_options)
        vrt_gdal = None

        generated_vrts.append(vrt_file)
    return generated_vrts
