#!/bin/bash

# 指定路径
# 主目录路径
HOME_DIR="${HOME}/Documents/watermark"
# 水印图片路径
xiaome="${HOME_DIR}/watermark/xiaome.png"
# 备份目录路径
now=$(date +"%Y-%m-%d_%H-%M-%S")
number=$(date +"%Y%m%d%H%M%S")
backup_files="${HOME_DIR}/backup/${now}"

# 选择水印图片
watermark=${xiaome}

# 如果不存在则创建目录
# 输出目录
if [ ! -d "${HOME_DIR}/out" ]; then
  mkdir "${HOME_DIR}/out"
fi
# 备份目录
if [ ! -d "${HOME_DIR}/backup" ]; then
  mkdir "${HOME_DIR}/backup"
fi
# 图片目录
if [ ! -d "${HOME_DIR}/img" ]; then
  mkdir "${HOME_DIR}/img"
fi

# 进入图片目录
cd ${HOME_DIR}/img || echo "图片目录不存在"

# 统计当前目录下所有的 JPG 和 PNG 文件数量
num_files=$(find . -maxdepth 1 \( -iname "*.jpg" -o -iname "*.png" \) | wc -l)
if [ $num_files -eq 0 ]; then
  echo "img 目录下没有任何 JPG & PNG 格式的图片文件！"
  exit 1
fi

# 初始化计数器
counter=0

# 遍历所有JPG和PNG文件，为它们添加水印
for file in *.{jpg,png}; do
  # 给图片加水印
  /opt/homebrew/bin/composite -dissolve 50% -tile ${watermark} "${file}" "${HOME_DIR}/out/watermark_${number}_${file}"
  # 计数器自增
  counter=$((counter+1))
  # 计算进度百分比
  progress=$((counter*100/num_files))
  # 打印进度条
  printf "\r[%-50s] %d%%" "$(printf '#%.0s' $(seq 1 $((progress/2))))" "${progress}"
done

# 完成后提示
echo "  ${counter}张图片水印全部添加完成！"

# 移动所有图片到备份目录
mkdir "${HOME_DIR}/backup/${now}"
mv *.jpg *.png ${backup_files}
open "${HOME_DIR}/out"