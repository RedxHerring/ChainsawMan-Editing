# We will use this file to get the subs from the 480p source from https://nyaa.si/view/1620545
cd \[Erai-raws\]\ Chainsaw\ Man\ -\ 01\ ~\ 12\ \[1080p\]\[Multiple\ Subtitle\]/
file_path="../Subs/Erai-Subs/"
mkdir -p $file_path
suffix=".ass"
for vid in *.mkv; do
    for strm in {0..15}; do
        lang_text=$(ffprobe -v error -hide_banner -of default=noprint_wrappers=0 -print_format flat  -select_streams s:$strm -show_entries stream=index:stream_tags=language "$vid" | grep language)
        lang=$(echo $lang_text | cut -d '"' -f 2)
        echo "Processing video $vid, stream $strm, language $lang"
        mkdir -p "$file_path$lang/"
        # For the name we save, we want to match the format used by the Upscale project, which is
        # EpXXepisodetitle.ass. The title is actually not contained, so we settle for EpXX.ass
        searchstring="Man - "
        rest=${vid#*$searchstring}
        epnum=$(cut -c 1-2<<< $rest)
        out_name="Ep$epnum"
        if test -f "$file_path$lang/$out_name$suffix"; then
            echo "$file_path$out_name$suffix already exists"
        else
            ffmpeg -i "$vid" -map s:$strm "$file_path$lang/$out_name$suffix" ;
            echo "ffmpeg -i $vid -map s:$strm $file_path$lang/$out_name$suffix"
        fi
    done
done
