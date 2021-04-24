#!/usr/bin/env bash

#帮助文档
function help {
	echo "Help Document":
	echo "-q                   对jpeg格式图片进行图片质量因子为Q的压缩"
	echo "-r                   对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩成R分辨率"
	echo "-w font-size text    对图片批量添加自定义文本水印"
	echo "-p text              统一添加文件名前缀，不影响原始文件扩展名"
	echo "-s text              统一添加文件名后缀，不影响原始文件扩展名"
	echo "-t                   将png/svg图片统一转换为jpg格式图片"
	echo "-h                   帮助文档"
}

# function1:对jpeg格式图片进行图片质量压缩
function quality_compress  {
	for img in *.jpeg ; do
	    [[ -e "$img" ]] || break
	    convert "$img" -quality "$1" "$img"
		echo "$img has been compressed of quality $1"
	done
}

#function2:对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩成R分辨率
function resolution_compress {
	for img in *.jpeg *.png *.svg; do
		[[ -e "$img" ]] || break
	    convert "$img" -resize "$1" "$img"
	    echo "$img has benn resized"
	done
}

#function3:对图片批量添加自定义文本水印
function add-watermark {
	for img in *; do
		[[ -e "$img" ]] || break
	    convert "$img" -pointsize "$1" -fill black -gravity southeast -draw "text 10,10 '$2'" "$img"
		echo "$img has benn watermarked with $2"
	done
}

#function4：批量重命名（统一添加文件名前缀或后缀，不影响原始文件扩展名）
function add-prefix {
	for img in *; do
		[[ -e "$img" ]] || break
	    mv "$img" "$1""$img"
		echo "$img has been added prefix"
	done	    
}
function add-suffix {
	for img in *; do
		[[ -e "$img" ]] || break	
	    mv "$img" "$img""$1"
		echo "$img has been added suffix"
	done
}

#function5:将png/svg图片统一转换为jpg格式图片
function transform_jpg {
	for img in *.png *.svg; do
		[[ -e "$img" ]] || break
		filename=${img%.*}".jpg"
	    convert "$img" "${filename}"
		echo "transform $img to jpg"
	done
}

#main
while [ "$1" != "" ];do
case "$1" in
    "-q")
	    quality_compress "$2"
		exit 0
		;;
	"-r")
		resolution_compress "$2"
		exit 0
		;;
	"-w")
		add-watermark "$2" "$3"
		exit 0
		;;
	"-p")
		add-prefix "$2"
		exit 0
		;;
	"-s")
		add-suffix "$2"
		exit 0
		;;
	"-t")
		transform_jpg
		exit 0
		;;
	"-h")
		help
		exit 0
		;;
esac
done