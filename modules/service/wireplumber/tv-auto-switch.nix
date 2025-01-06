{
  lib,
  config,
  ...
}: let
  cfg = config.module.wireplumber.tv-auto-switch;
in {
  options = {
    module.wireplumber.tv-auto-switch.enable =
      lib.mkEnableOption "enable custom wireplumber tv auto switch";
  };

  config = lib.mkIf cfg.enable {
    services.pipewire.wireplumber = {
      extraConfig."99-auto-switch-sink" = {
        "wireplumber.components" = [
          {
            name = "test/auto-switch-sink.lua";
            type = "script/lua";
            provides = "custom.auto-switch-sink";
          }
        ];

        "wireplumber.profiles" = {
          main = {
            "custom.auto-switch-sink" = "required";
          };
        };
      };
      extraScripts = {
        "test/auto-switch-sink.lua" =
          /*
          lua
          */
          ''
            -- auto-switch-sink.lua

            local HDMI_OUTPUT_NAME = "alsa_output.pci-0000_01_00.1.HiFi__HDMI1__sink"
            local INTERNAL_SINK_NAME = "alsa_output.pci-0000_07_00.6.HiFi__Speaker__sink"

            function switch_to_sink(sink_name)
                local session = Session:current()
                local core = session:core()
                local nodes = core:find_objects("node", {["media.class"] = "Audio/Sink"})

                for _, node in ipairs(nodes) do
                    if node.properties["node.name"] == sink_name then
                        core:call("set-default-node", node, "Playback")
                        return true
                    end
                end

                return false
            end

            function switch_audio_output()
                if not switch_to_sink(HDMI_OUTPUT_NAME) then
                    switch_to_sink(INTERNAL_SINK_NAME)
                end
            end

            function on_node_added(node)
                if node.properties["media.class"] == "Audio/Sink" then
                    switch_audio_output()
                end
            end

            function on_node_removed(node)
                if node.properties["node.name"] == HDMI_OUTPUT_NAME then
                    switch_to_sink(INTERNAL_SINK_NAME)
                end
            end

            Session:current():connect("node-added", on_node_added)
            Session:current():connect("node-removed", on_node_removed)

            -- Initial switch on script load
            switch_audio_output()

          '';
      };
    };
  };
}
