{pkgs}:
pkgs.writeShellApplication {
  name = "volume-control";
  runtimeInputs = with pkgs; [
    pulseaudio
    dunst
    ripgrep
    coreutils
  ];
  text =
    # bash
    ''
      get_current_volume() {
        pactl get-sink-volume @DEFAULT_SINK@ | rg -oP '\d+%' | head -1 | tr -d '%'
      }

      send_notification() {
        notification_tag="volume"
        volume=$(get_current_volume)
        mute_status=$(pactl get-sink-mute @DEFAULT_SINK@ | rg -oP '(yes|no)')
        if [ "$mute_status" = "yes" ]; then
          dunstify -h string:x-dunst-stack-tag:$notification_tag -u low "Volume Muted"
        else
          dunstify -h string:x-dunst-stack-tag:$notification_tag -u low "Volume: $volume%"
        fi
      }

      case "$1" in
        up)
          current_volume=$(get_current_volume)
          if [ "$current_volume" -lt 100 ]; then
            pactl set-sink-volume @DEFAULT_SINK@ +5%
            # send_notification
          else
            echo "Volume is already at 100% or higher."
          fi
          ;;
        down)
          pactl set-sink-volume @DEFAULT_SINK@ -5%
          # send_notification
          ;;
        toggle)
          pactl set-sink-mute @DEFAULT_SINK@ toggle
          # send_notification
          ;;
        *)
          echo "Usage: $0 {up|down|toggle}"
          exit 1
          ;;
      esac
    '';
}
