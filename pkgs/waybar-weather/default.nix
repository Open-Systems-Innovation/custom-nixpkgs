{ pkgs, lib, ...}:

pkgs.stdenv.mkDerivation {
  pname = "waybar-weather";
  version = "1.0.0";
  
  # Fetch source from GitHub
  src = pkgs.fetchFromGitHub {
    owner = "Open-Systems-Innovation";
    repo = "waybar-weather";
    rev = "main";  # Or specify a commit hash or tag
    sha256 = "U/4qi0pxO6pbnpi7dFHVRd4ZTXCeGQmE/hbQI0BZPW8=";
  };

  # Runtime dependencies
  buildInputs = [
    pkgs.python3
    pkgs.python3Packages.requests
  ];

  # Install phase for Python script
  installPhase = ''
    mkdir -p $out/bin
    cp weather.py $out/bin/waybar-weather
    chmod +x $out/bin/waybar-weather
  '';

  meta = with pkgs.lib; {
    description = "A weather application that fetches weather data from wttr.in and formats it.";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
