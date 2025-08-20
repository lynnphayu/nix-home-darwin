{ username, pkgs, ... }:
{
  nix-daemon.enable = true;
  postgresql = {
    dataDir = "/Users/${username}/services_data/postgres_data";
    enable = true;
    package = pkgs.postgresql_17;
    authentication = ''
      host    all             all             127.0.0.1/32            trust
      local   all             all                                     trust
    '';
    enableTCPIP = true;
  };
  redis = {
    enable = true;
    package = pkgs.redis;
    dataDir = "/Users/${username}/services_data/redis_data";
    extraConfig = ''
      logfile /Users/${username}/services_log/redis.log
    '';
  };
}
