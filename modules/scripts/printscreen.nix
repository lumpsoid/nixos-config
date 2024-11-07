{
  pkgs,
  writeShellApplication,
  useWayland ? false,
}: let
  waylandDeps = with pkgs; [imagemagick wl-clipboard slurp grim];
  x11Deps = with pkgs; [imagemagick xclip];
  commonScript =
    /*
    sh
    */
    ''
      timestamp=$(date +%Y%m%d%H%M%S)
      temp_path="/tmp/$timestamp.png"
      out_path="$HOME/Pictures/Screenshots/$timestamp.avif"
    '';
  x11Script =
    /*
    sh
    */
    ''
      # capture screenshot
      import "$temp_path" &&

      cat "$temp_path" | xclip -selection clipboard -target image/png -i | notify-send 'screenshot done' &&

      magick -quality 57 "$temp_path" "$out_path" &&

      rm "$temp_path" &&

      exit;

    '';
  waylandScript =
    /*
    sh
    */
    ''
      geometry=$(slurp)
      if [ "$geometry" = "" ]; then
        exit;
      fi

      grim -g "$geometry" "$temp_path" &&

      wl-copy < "$temp_path" &&

      magick -quality 57 "$temp_path" "$out_path" &&

      rm "$temp_path" &&

      exit;

    '';
  fullScript =
    commonScript
    + (
      if useWayland
      then waylandScript
      else x11Script
    );
in
  writeShellApplication {
    name = "printscreen";
    runtimeInputs =
      if useWayland
      then waylandDeps
      else x11Deps;
    text = fullScript;
  }
