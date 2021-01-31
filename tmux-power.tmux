#!/usr/bin/env bash
#===============================================================================
#   Author: Wenxuan
#    Email: wenxuangm@gmail.com
#  Created: 2018-04-05 17:37
#===============================================================================

# $1: option
# $2: default value
tmux_get() {
    local value="$(tmux show -gqv "$1")"
    [ -n "$value" ] && echo "$value" || echo "$2"
}

# $1: option
# $2: value
tmux_set() {
    tmux set-option -gq "$1" "$2"
}

# Options
right_arrow_icon=$(tmux_get '@tmux_power_right_arrow_icon' '')
left_arrow_icon=$(tmux_get '@tmux_power_left_arrow_icon' '')
upload_speed_icon=$(tmux_get '@tmux_power_upload_speed_icon' '')
download_speed_icon=$(tmux_get '@tmux_power_download_speed_icon' '')
session_icon="$(tmux_get '@tmux_power_session_icon' '')"
user_icon="$(tmux_get '@tmux_power_user_icon' '')"
time_icon="$(tmux_get '@tmux_power_time_icon' '')"
date_icon="$(tmux_get '@tmux_power_date_icon' '')"
show_upload_speed="$(tmux_get @tmux_power_show_upload_speed false)"
show_download_speed="$(tmux_get @tmux_power_show_download_speed false)"
show_web_reachable="$(tmux_get @tmux_power_show_web_reachable false)"
prefix_highlight_pos=$(tmux_get @tmux_power_prefix_highlight_pos)
time_format=$(tmux_get @tmux_power_time_format '%T')
date_format=$(tmux_get @tmux_power_date_format '%F')
my_mood="$(tmux_get @tmux_power_my_mood true)"
my_status_mood="$(tmux_get @tmux_power_my_status_mood true)"

# short for Theme-Colour
TC=$(tmux_get '@tmux_power_theme' 'gold')
case $TC in
    'gold' )
        TC='#ffb86c'
        ;;
    'redwine' )
        TC='#b34a47'
        ;;
    'moon' )
        TC='#00abab'
        ;;
    'forest' )
        TC='#228b22'
        ;;
    'violet' )
        TC='#9370db'
        ;;
    'snow' )
        TC='#fffafa'
        ;;
    'coral' )
        TC='#ff7f50'
        ;;
    'sky' )
        TC='#87ceeb'
        ;;
    'default' ) # Useful when your term changes colour dynamically (e.g. pywal)
        TC='colour3'
        ;;
esac

G01=#080808 #232
G02=#121212 #233
G03=#1c1c1c #234
G04=#262626 #235
G05=#303030 #236
G06=#3a3a3a #237
G07=#444444 #238
G08=#4e4e4e #239
G09=#585858 #240
G10=#626262 #241
G11=#6c6c6c #242
G12=#767676 #243

FG="$G10"
BG="$G04"

#========================================
# My Own dracula colors

# black dark/light
D0="#1d1f26"                         
D8="#44475a"                          

# red dark/light
D1="#ff9580"                          
D9="#FF6E67"                          

# green dark/light
D2="#aaff00"                          
D10="#5AF78E"                         

# yellow dark/light
D3="#ffff80"                          
D11="#F4F99D"                         

# blue dark/light
D4="#9580ff"                          
D12="#CAA9FA"                         

# magenta dark/light
D5="#ff80bf"                          
D13="#FF92D0"                         

# cyan dark/light
D6="#80ffea"                          
D14="#9AEDFE"                         

# white dark/light
D7="#BFBFBF"                          
D15="#E6E6E6"                         

#========================================

# Status options
tmux_set status-interval 1
tmux_set status on

# Basic status bar colors
#tmux_set status-fg "$FG"
tmux_set status-fg "$D2"
tmux_set status-bg "$BG"
#tmux_set status-bg "#44475a"
tmux_set status-attr none

# tmux-prefix-highlight
tmux_set @prefix_highlight_fg "$BG"
tmux_set @prefix_highlight_bg "$FG"
tmux_set @prefix_highlight_show_copy_mode 'on'
tmux_set @prefix_highlight_copy_mode_attr "fg=$TC,bg=$BG,bold"
#tmux_set @prefix_highlight_output_prefix "#[fg=$TC]#[bg=$BG]$left_arrow_icon#[bg=$TC]#[fg=$BG]"
tmux_set @prefix_highlight_output_prefix "#[fg=#80ffea]#[bg=#500734] "
tmux_set @prefix_highlight_output_suffix " #[fg=#500734]#[bg=$BG]$right_arrow_icon"

#     
# Left side of status bar
tmux_set status-left-bg "$G04"
tmux_set status-left-fg "G12"
tmux_set status-left-length 150
user=$(whoami)
LS="#[fg=$G04,bg=$D12,bold] $user_icon $user@#h #[fg=$D12,bg=$D1,nobold]$right_arrow_icon#[fg=$G04,bg=$D1] $session_icon #S "
if "$show_upload_speed"; then
    LS="$LS#[fg=$G06,bg=$G05]$right_arrow_icon#[fg=$TC,bg=$G05] $upload_speed_icon #{upload_speed} #[fg=$G05,bg=$BG]$right_arrow_icon"
else
    LS="$LS#[fg=$D1,bg=#500734]$right_arrow_icon"
fi
if [[ $prefix_highlight_pos == 'L' || $prefix_highlight_pos == 'LR' ]]; then
    LS="$LS#{prefix_highlight}"
fi
tmux_set status-left "$LS"

# Right side of status bar
tmux_set status-right-bg "$G04"
tmux_set status-right-fg "G12"
tmux_set status-right-length 150

if "$my_mood"; then
    tmux_set @np1 "#[fg=#80ffea,bg=#500734] $time_icon"
    tmux_set @np2 " #[fg=#ff92d0,bg=#500734]$left_arrow_icon#[fg=$G04,bg=#ff92d0] $date_icon "
    tmux_set @gp1 "#[fg=$G04,bg=#500734]"
    tmux_set @gp2 " #[fg=#aaff00,bg=#500734,nobold]#[fg=#80ffea,bg=#500734] $time_icon "
    tmux_set @gp3 " #[fg=#ff90d0,bg=#500734]$left_arrow_icon#[fg=$G04,bg=#ff90d0] $date_icon "
    RS="#[fg=#500734,bg=$G04,nobold]$left_arrow_icon#{?#{==:#(gitmux "#{pane_current_path}"),""},#{@np1} %T#{@np2}%F ,#{@gp1}#(gitmux "#{pane_current_path}")#{@gp2}%T#{@gp3}%F }"
else
    RS="#[fg=#500734,bg=$G04,nobold]$left_arrow_icon#[fg=#80ffea,bg=#500734] $time_icon %T #[fg=#ff92d0,bg=#500734]$left_arrow_icon#[fg=$G04,bg=#ff92d0] $date_icon %F "
fi


if "$show_download_speed"; then
    RS="#[fg=$G05,bg=$BG]$left_arrow_icon#[fg=$TC,bg=$G05] $download_speed_icon #{download_speed} #[fg=$G06,bg=$G05]$left_arrow_icon$RS"
fi
if "$show_web_reachable"; then
    RS=" #{web_reachable_status} $RS"
fi
if [[ $prefix_highlight_pos == 'R' || $prefix_highlight_pos == 'LR' ]]; then
    RS="#{prefix_highlight}$RS"
fi
tmux_set status-right "$RS"

# Window status
#tmux_set window-status-format " #I:#W#F "

if "$my_status_mood"; then
    tmux_set window-status-format " #[fg=$BG,bg=#ffff80]$right_arrow_icon #[fg=#500734,bg=#ffff80,bold]#I #[fg=#ffff80,bg=#ef95e1] #[fg=#500734,bold]#W#{?window_last_flag,  ,}#{?window_zoomed_flag, ,}#{?pane_marked, ,}#{?pane_marked_set, ,}#[fg=#ef95e1,bg=$BG]$right_arrow_icon"
else
    tmux_set window-status-format " #[fg=$BG,bg=#80ffea]$right_arrow_icon #[fg=#500734,bg=#80ffea,bold]#I #[fg=#80ffea,bg=$G04]"
fi

tmux_set window-status-current-format "#[fg=$BG,bg=#aaff00]$right_arrow_icon#[fg=$G04,bold] #I #[fg=#aaff00,bg=#500734] #[fg=#80ffea,bold]#W#{?current_window_flag,,  }#{?window_zoomed_flag, ,}#{?pane_marked, ,}#{?pane_marked_set, ,}#[fg=#500734,bg=$BG,nobold]$right_arrow_icon"


# Window separator
tmux_set window-status-separator ""

# Window status alignment
tmux_set status-justify centre

# Current window status
tmux_set window-status-current-statys "fg=$TC,bg=$BG"

# Pane border
#tmux_set pane-border-style "fg=$G07,bg=default"

# Active pane border
#tmux_set pane-active-border-style "fg=$TC,bg=$BG"

# Pane number indicator
tmux_set display-panes-colour "$G07"
tmux_set display-panes-active-colour "$TC"

# Clock mode
tmux_set clock-mode-colour "$TC"
tmux_set clock-mode-style 24

# Message
tmux_set message-style "fg=$TC,bg=$BG"

# Command message
tmux_set message-command-style "fg=$TC,bg=$BG"

# Copy mode highlight
tmux_set mode-style "bg=$TC,fg=$FG"
