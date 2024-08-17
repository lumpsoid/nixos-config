{
  lib,
  pkgs,
  config,
  ...
}:
{
  options = {
    scripts.devshellnix.enable =
      lib.mkEnableOption "enable bulding 'devshellnix' script";
  };

  config = lib.mkIf config.scripts.devshellnix.enable {
    home.packages = [
      ( pkgs.writeShellScriptBin "devshellnix" ''
          #!/usr/bin/env bash

          # Define variables
          store_dir="/nix/store"
          gcroots_dir="/nix/var/nix/gcroots"

          action="$1"
          flake_dir="$2"
          flake_path="$flake_dir/flake.nix"

          # need to pass variable as string
          # without $
          is_empty() {
            local var_name="$1"
            local value="${!var_name}"
            if [ -z "$value" ]; then
              echo "The value of $var_name is empty"
            fi
          }

          is_dir() {
            # Check if the path is a directory
            local path=$1
            if [ ! -d "$path" ]; then
              echo "$path is not a directory."
              exit 1
            fi
          }

          check_path_exists() {
            local path=$1
            if [ ! -e "$path" ]; then
              echo "$path does not exist."
              exit 1
            fi
          }

          get_devshell_name() {
            local flake_path=$1
            local devShellLine
            local devShellName
            # if grep doesn't find anything, it will through error (exit 1)
            # to prevent it, using `true`
            devShellLine=$(grep name "$flake_path" || true)

            is_empty "devShellLine"
            # get only name in ""
            devShellName=$(echo "$devShellLine" | cut -d '"' -f2)

            is_empty "devShellName"
            echo "$devShellName"
            return 0
          }

          get_flake_source_path() {
            local flake_source_path
            flake_source_path=$(nix flake metadata | grep Path |  cut -d '/' -f 4)

            is_empty "flake_source_path"
            echo "$flake_source_path"
            return 0
          }

          # if there would be a error
          # in the script
          # it will exit automaticaly 
          set -e

          # Check if the path is provided
          is_empty "flake_dir"
              
          case "$action" in
            "clear")
              # Commands to execute if $variable matches pattern1
              # Check if the path exists
              check_path_exists "$flake_dir"
              # Check if the path is a directory
              is_dir "$flake_dir"
              # Check if the path exists
              check_path_exists "$flake_path"

              devShellName=$(get_devshell_name "$flake_path")
              devShellRootDir="$gcroots_dir/$devShellName"
              if [ ! -e "$devShellRootDir" ]; then
                echo "$devShellRootDir doesn't exists. Exiting..."
                exit 1
              fi
              sudo rm -rf "$devShellRootDir"
              echo "$devShellRootDir was deleted"
              exit 0
              ;;
            "pin")
              # Commands to execute if $variable matches pattern2
              # Check if the path exists
              check_path_exists "$flake_dir"
              # Check if the path is a directory
              is_dir "$flake_dir"
              # Check if the path exists
              check_path_exists "$flake_path"


              # if grep doesn't find anything, it will through error (exit 1)
              # to prevent it, using `true`
              devShellName=$(get_devshell_name "$flake_path")
              devShellRootDir="$gcroots_dir/$devShellName"

              # Check if the path does not exists
              if [ ! -e "$devShellRootDir" ]; then
                sudo mkdir "$devShellRootDir"
              fi

              file_paths=$(ls "$store_dir" | grep "$devShellName" || true)
              # filePaths are empty
              is_empty "file_paths"

              flake_source_path=$(get_flake_source_path)

              # append flake_source_path to the file_paths
              file_paths=$(echo "$file_paths"; echo "$flake_source_path")

              # Iterate over each derivative store path matching the devShell name
              for filePath in $file_paths; do
                # Define the symlink name and target
                storePath="$store_dir/$filePath"
                gcrootsDevShellPath="$devShellRootDir/$filePath"
                
                # Create the symlink if it does not already exist
                if [ ! -e "$gcrootsDevShellPath" ]; then
                  sudo ln -s "$storePath" "$gcrootsDevShellPath"
                  printf '✓Symlink was created\n%s\n↳%s\n\n' "$gcrootsDevShellPath" "$storePath"
                else
                  printf '✖Symlink already exists\n%s\n\n' "$gcrootsDevShellPath"
                fi
              done


              echo "$devShellName is pinned in nix store!"
              notify-send -e "$devShellName is pinned in nix store!"
              exit 0
              ;;
            *)
              # Commands to execute if $action does not match any patterns
              echo "Only 'pin' and 'clear' actions are supported"
              exit 1
              ;;
            esac
        '')
    ];
  };
}
