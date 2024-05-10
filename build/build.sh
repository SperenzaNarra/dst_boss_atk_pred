#!/bin/bash

set -ex

REPO="$PWD"

apk add gimp python3 py3-pillow

pushd xcf

for DIR in *; do
  echo "$DIR"
  gimp -n -i -b - <<EOF
  (let* ( (file's (cadr (file-glob "${DIR}/*.xcf" 1))) (filename "") (image 0) (layer 0) )
    (while (pair? file's)
      (set! image (car (gimp-file-load RUN-NONINTERACTIVE (car file's) (car file's))))
      (gimp-image-scale image 128 128)
      (set! layer (car (gimp-image-merge-visible-layers image CLIP-TO-IMAGE)))
      (set! filename (string-append (substring (car file's) 0 (- (string-length (car file's)) 4)) ".png"))
      (gimp-file-save RUN-NONINTERACTIVE image layer filename filename)
      (gimp-image-delete image)
      (set! file's (cdr file's))
      )
    (gimp-quit 0)
    )
EOF
done

for FILE in */*.png; do
  "${REPO}/build/mod_tools/png" "$FILE" unused_arg
done

for FILE in */*.tex */*.xml; do
  mv "$FILE" ../dist/images/"$FILE"
done
