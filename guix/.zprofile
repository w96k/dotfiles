export GUIX_PROFILE="$HOME/.guix-profile"
source "$HOME/.guix-profile/etc/profile"

# Wayland vars
export XDG_SESSION_TYPE=wayland
export SDL_VIDEODRIVER=wayland
export _JAVA_AWT_WM_NONREPARENTING=1
export MOZ_ENABLE_WAYLAND=1

if test -z "${XDG_RUNTIME_DIR}";
then
    export XDG_RUNTIME_DIR=/tmp/${UID}-runtime-dir
    if ! test -d "${XDG_RUNTIME_DIR}"; then
	mkdir "${XDG_RUNTIME_DIR}"
	chmod 0700 "${XDG_RUNTIME_DIR}"
    fi
fi

streaming() {
    INRES="1280x720" # input resolution
    OUTRES="1280x720" # output resolution
    FPS="10" # target FPS
    GOP="20" # i-frame interval, should be double of FPS,
    GOPMIN="10" # min i-frame interval, should be equal to fps,
    THREADS="2" # max 6
    CBR="1000k" # constant bitrate (should be between 1000k - 3000k)
    QUALITY="ultrafast"  # one of the many FFMPEG preset
    AUDIO_RATE="44100"
    STREAM_KEY="$1" # use the terminal command Streaming streamkeyhere to stream your video to twitch or justin
    SERVER="live-sjc" # twitch server in California, see http://bashtech.net/twitch/ingest.php to change

    ffmpeg -f x11grab -s "$INRES" -r "$FPS" -i :0.0 -f flv -ac 2 -ar $AUDIO_RATE \
	   -vcodec libx264 -g $GOP -keyint_min $GOPMIN -b:v $CBR -minrate $CBR -maxrate $CBR -pix_fmt yuv420p\
	   -s $OUTRES -preset $QUALITY -tune film -acodec libmp3lame -threads $THREADS -strict normal \
	   -bufsize $CBR "rtmp://$SERVER.twitch.tv/app/$STREAM_KEY"
}

if [ "$(tty)" = "/dev/tty1" ]; then
    tor &
    exec sway
fi

if [ -f .zshrc ]
then
    . .zshrc
fi
