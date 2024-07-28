# author: antipatico (https://blog.bootkit.dev)
{ options
, config
, lib
, ...
}:
with lib;
with lib.antipatico; let
  cfg = config.services.t14-hibernate;
in
{
  options.services.t14-hibernate = with types; {
    enable = mkEnableOption "tweak to make hibernation work on t14 laptop";
  };

  config = mkIf cfg.enable {
    systemd.services.t14-hibernate-pre = {
      description = "T14 Hibernate Tweak (pre)";
      before = ["hibernate.target" ];
      wantedBy = [ "hibernate.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = [ "/run/current-system/sw/sbin/rmmod ath11k_pci" ];
      };
    };

    systemd.services.t14-hibernate-post = {
      description = "T14 Hibernate Tweak (post)";
      after = ["hibernate.target" ];
      wantedBy = [ "hibernate.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = [ "/run/current-system/sw/sbin/modprobe ath11k_pci" ];
      };
    };
  };
}
