# Favicon development area

`favicon.svg` is the source file from which the rasterized variant is generated:

```shell
magick -background none favicon.svg -resize 32x32 favicon.png
```
