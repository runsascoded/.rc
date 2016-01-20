#!/usr/bin/env python

import sys
from os import path
# import pandas as pd
from skimage.data import imread
from skimage.io import imsave
import numpy as np

# def transform_pcf(output_dir="",
#                   patch_size=None,
#                   rotations=4,
#                   reflect=True,
#                   limit=None):
#     training = pd.read_csv("training.csv",
#                            header=None,
#                            names=['name', 'fga'],
#                            dtype={'name': object, 'fga': float})
#     if limit:
#         training = training.head(limit)
#     from skimage.io import imsave
#
#     if not patch_size:
#         patch_size = 0
#         print("Finding maximum patch size...")
#         for i, row in training.iterrows():
#             name = row['name']
#             print("Checking %s" % name)
#             for kind in ["DX", "TS"]:
#                 img = imread("images/%s/%s-%s.png" % (kind, name, kind))
#                 rows, cols, _ = img.shape
#                 patch_size = min(patch_size, rows, cols)
#         print("Patch size: %d" % patch_size)
#
#     for i, row in training.iterrows():
#         row_patches = []
#         row_output = []
#         row_weights = []
#         name = row['name']
#         fga = row['fga']
#         sys.stdout.flush()
#         for kind in ["DX", "TS"]:
#             img_name = "images/%s/%s-%s.png" % (kind, name, kind)
#             transform_path(img_name, patch_size)
#
#         for idx, patch in enumerate(row_patches):
#             imsave(path.join(output_dir, "patch_%s_%d.png" % (name, idx)), patch)
#
#         y_row = np.asarray(row_output)
#         z_row = np.asarray(row_weights)
#
#         with open(path.join(output_dir, "output_file_%s" % name), 'w') as f:
#             np.save(f, y_row)
#         with open(path.join(output_dir, "weights_file_%s" % name), 'w') as f:
#             np.save(f, z_row)

def transform_path(img_name, patch_size, output_dir=None, reflect=True, rotate=True, center=True):
    print("Transforming %s to %s" % (img_name, output_dir))

    base_name, ext = path.splitext(path.basename(img_name))
    def output_path(i):
        return path.join(
                output_dir if output_dir else '.',
                '-'.join(
                        [ base_name, str(i) ]
                ) + ext
        )

    test_path = output_path(0)

    if path.exists(test_path):
        print("\tAlready exists!")
        return

    img = imread(img_name)
    img_patches = [
        patch
        for patches in transform_img(img, img_name, patch_size=patch_size, center=center)
        for patch in patches
    ]
    num_patches = len(img_patches)

    print("\tFound %d patches" % num_patches)

    reflections = [ True, False ] if reflect else [ False ]
    i = 0
    for img_patch in img_patches:
        for rot_i in range(4) if rotate else range(1):
            rotated = np.rot90(img_patch, k=rot_i)
            for reflection in reflections:
                reflected = np.fliplr(rotated) if reflection else rotated
                imsave(
                        output_path(i),
                        reflected
                )
                i += 1

def transform_img(img, name, patch_size, center):
    from skimage.exposure import is_low_contrast

    rows, cols, _ = img.shape

    if rows < patch_size or cols < patch_size:
        print("Image too small: %s-%s.png" % (name))
        return []

    row_blocks = int(rows / patch_size)
    col_blocks = int(cols / patch_size)

    v_margin = (rows - (row_blocks * patch_size)) / 2 if center else 0
    l_margin = (cols - (col_blocks * patch_size)) / 2 if center else 0

    patches = []
    for i in range(row_blocks):
        row_patches = []
        for j in range(col_blocks):
            patch = img[
                    v_margin + patch_size * i:v_margin + patch_size * (i + 1),
                    l_margin + patch_size * j:l_margin + patch_size * (j + 1),
                    :]

            if not is_low_contrast(patch):
                row_patches.append(patch)

        patches.append(row_patches)

    return patches

if __name__ == '__main__':
    from argparse import ArgumentParser
    parser = ArgumentParser()
    parser.add_argument('--size', '-s', action='store', dest='size', type=int)
    parser.add_argument('--outdir', '-o', action='store', dest='outdir', default='.')
    parser.add_argument('paths', nargs='*')
    args = parser.parse_args(sys.argv[1:])
    for arg in args.paths:
        transform_path(arg, args.size, args.outdir)
