# author: antipatico (https://blog.bootkit.dev)
{ options
, pkgs
, config
, lib
, ...
}:
with lib;
with lib.antipatico; let
  cfg = config.services.t14-micmuteled;
  script = pkgs.writeShellScriptBin "t14-micmuteled-update" ''
    #!/usr/bin/env bash

    LED_BRIGHTNESS="$1"
    DEVICE_ID="$2"
    AUDIO_USER_ID="$3"
    
    MIC_STATUS=$(PIPEWIRE_RUNTIME_DIR="/run/user/$AUDIO_USER_ID" ${pkgs.alsa-utils}/bin/amixer cget numid=$DEVICE_ID | ${pkgs.ripgrep}/bin/rg -o 'values=(on|off)+' -r '$1')

    [ "$MIC_STATUS" == 'on' ] && (echo 0 > "$LED_BRIGHTNESS")
    [ "$MIC_STATUS" == 'off' ] && (echo 1 > "$LED_BRIGHTNESS")
  '';
in
{
  options.services.t14-micmuteled = with types; {
    enable = mkEnableOption "tweak to make micmute led work on t14 laptop";
    ledBrightness = mkOpt str "/sys/class/leds/platform::micmute/brightness" "Path to the target led to control";
    microphoneNumId = mkOpt int 2 "numid for the microphone to monitor (find out using: amixer controls)";
    userId = mkOpt int 1000 "User id to select the right pipewire socket";
  };

  config = mkIf cfg.enable {
    services.acpid = {
    enable = true;
    # The following is useful if you are trying to develop your own solution
    #logEvents = true;
    handlers.t14-micmute = {
      event = "button/f20.*";
      action = ''${script}/bin/t14-micmuteled-update "${cfg.ledBrightness}" ${toString cfg.microphoneNumId} ${toString cfg.userId}'';
    };
    };
  };
}
