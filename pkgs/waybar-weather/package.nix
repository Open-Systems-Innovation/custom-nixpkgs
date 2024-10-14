{ pkgs }:

pkgs.stdenv.mkDerivation {
  pname = "waybar-weather";
  version = "1.0.0";
  
  # Source can be a file or directory where your program resides
  src = ./weather.py;

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
