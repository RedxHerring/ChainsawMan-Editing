input=$1
epnum=$(echo $input | grep -E -o [0-9]{2})
epnum1=${epnum:0:2}
Origmkv="[Erai-raws] Chainsaw Man - 01 ~ 12 [1080p][Multiple Subtitle]/$(ls "[Erai-raws] Chainsaw Man - 01 ~ 12 [1080p][Multiple Subtitle]/" | grep "Man - $epnum1")"
input_name=$(basename "${input%.*}")
output="Output/$input_name-av1.mkv"
echo "Encoding $input into $output with metadata from $Origmkv"
input_sub="Editing/$input_name.kdenlive.srt"
ffmpeg -y -init_hw_device qsv=hw -filter_hw_device hw \
-i $input -i $input_sub -i "$Origmkv" -map 0:v:0 -map 0:a:0 -map 1:s \
-map_metadata:s:v 2:s:v -map_metadata:s:a:0 2:s:a:0 -map_metadata:s:s:0 2:s:s:0 \
-c:v av1_qsv -preset 1 -extbrc 0 -look_ahead_depth 36 -c:a libopus -c:s copy -c:t copy \
-disposition:s:s:0 forced $output
