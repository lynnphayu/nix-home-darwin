{
  username,
  self,
  ...
}:
{
  defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyleSwitchesAutomatically = true;
      AppleICUForce24HourTime = true;
    };
    loginwindow = {
      autoLoginUser = "${username}";
    };
    menuExtraClock = {
      Show24Hour = true;
    };
    screencapture = {
      location = "/Users/${username}/Desktop/screenshots";
    };
    dock = {
      autohide = true;
      autohide-delay = 0.1;
      orientation = "bottom";
      show-process-indicators = true;
      show-recents = false;
      tilesize = 40;
      largesize = 50;
      magnification = true;
      minimize-to-application = true;
      persistent-apps = [ ];
    };
    WindowManager = {
      EnableStandardClickToShowDesktop = true;
      EnableTiledWindowMargins = false;
    };
    controlcenter = {
      Display = true;
      BatteryShowPercentage = true;
      Sound = true;

      NowPlaying = false;
      AirDrop = false;
      Bluetooth = false;
      FocusModes = false;
    };
  };
  configurationRevision = self.rev or self.dirtyRev or null;
  stateVersion = 5;
}
