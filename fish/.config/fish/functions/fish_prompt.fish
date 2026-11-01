function fish_prompt
    # 1. Capture the exit status immediately
    set -l last_status $status
    
    # 2. Capture the current time
    set -l time_now (date "+%H:%M:%S")

    # --- Line 1 ---
    
    # Time block (Bright Blue background, Black text)
    set_color -b brblue
    set_color black
    echo -n " $time_now "
    
    # The pointy arrow (Powerline separator)
    # Background must be normal (transparent), text color must match the block we just left
    set_color normal
    set_color brblue
    echo -n ""
    
    # Reset everything completely, then add a space separator
    set_color normal
    echo -n ' '

    # Directory
    set_color cyan
    echo -n (prompt_pwd)
    set_color normal
    echo -n ' '
    
    # User@Host
    set_color green
    echo -n $USER
    set_color normal
    echo -n '@'
    
    set_color blue
    echo -n (prompt_hostname)
    set_color normal
    
    # Move to the next line
    echo ""

    # --- Line 2 ---
    
    # Error code (shows only if the last command failed)
    if test $last_status -ne 0
        set_color red
        echo -n "[exit $last_status] "
        set_color normal
    end

    # The arrow symbol
    set_color magenta
    echo -n '❯ '
    set_color normal
end
