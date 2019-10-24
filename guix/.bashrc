# Bash initialization for interactive non-login shells and
# for remote shells (info "(bash) Bash Startup Files").

# Export 'SHELL' to child processes.  Programs such as 'screen'
# honor it and otherwise use /bin/sh.
export SHELL

if [[ $- != *i* ]]
then
    # We are being invoked from a non-interactive shell.  If this
    # is an SSH session (as in "ssh host command"), source
    # /etc/profile so we get PATH and other essential variables.
    [[ -n "$SSH_CLIENT" ]] && source /etc/profile

    # Don't do anything else.
    return
fi

# Source the system-wide file.
source /etc/bashrc

# Adjust the prompt depending on whether we're in 'guix environment'.
if [ -n "$GUIX_ENVIRONMENT" ]
then
    PS1='\u@\h \w [env]\$ '
else
    PS1='\u@\h \w\$ '
fi
alias ls='ls -p --color=auto'
alias ll='ls -l'
alias grep='grep --color=auto'

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
