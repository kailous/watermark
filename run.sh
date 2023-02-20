#!/bin/bash
# 设定水印图片的路径
watermark="../xiaome.png"
# 遍历当前目录下所有的jpg文件
cd img
for file in *.jpg; do
  # 给图片加水印
  composite -dissolve 50% -tile ${watermark} "${file}" "../out/watermark_${file}"
  echo ${file} 添加成功
done