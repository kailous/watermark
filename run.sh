#!/bin/bash

# 指定水印图片的路径
watermark="../xiaome.png"

# 如果不存在则创建输出目录
if [ ! -d "../out" ]; then
  mkdir "../out"
fi
cd img || echo "图片目录不存在"
# 统计当前目录下所有的 JPG 和 PNG 文件数量
num_files=$(find . -maxdepth 1 \( -iname "*.jpg" -o -iname "*.png" \) | wc -l)
if [ $num_files -eq 0 ]; then
  echo "当前目录下不存在支持的图像文件"
  echo "仅支持 JPG & PNG 格式"
  exit 1
fi

# 初始化计数器
counter=0

# 遍历所有JPG和PNG文件，为它们添加水印
for file in *.{jpg,png}; do
  # 给图片加水印
  composite -dissolve 50% -tile ${watermark} "${file}" "../out/watermark_${file}"
  # 计数器自增
  counter=$((counter+1))
  # 计算进度百分比
  progress=$((counter*100/num_files))
  # 打印进度条
  printf "\r[%-50s] %d%%" "$(printf '#%.0s' $(seq 1 $((progress/2))))" "${progress}"
done
# 完成后提示
echo "  ${counter}张图片水印全部添加完成！"