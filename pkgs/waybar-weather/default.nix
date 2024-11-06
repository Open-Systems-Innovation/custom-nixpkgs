{ pkgs, lib, ...}:

pkgs.stdenv.mkDerivation {
  pname = "waybar-weather";
  version = "1.0.0";
  
  # Fetch source from GitHub
  src = pkgs.fetchFromGitHub {
    owner = "Open-Systems-Innovation";
    repo = "waybar-weather";
    rev = "main";  # Or specify a commit hash or tag
    sha256 = "sha256-t6ReobQgL66jhX7Q/5bjxgjeu0CwuJGQyA339f+44/k=";
  };

  # Runtime dependencies
  buildInputs = [
    #pkgs.python3
    #pkgs.python3Packages.requests
    (pkgs.python3.withPackages (python-pkgs: with python-pkgs; [
      # select Python packages here
      requests
    ]))
  ];

  # Install phase for Python script
  installPhase = ''
    mkdir -p $out/bin
    cp weather.py $out/bin/waybar-weather
    chmod +x $out/bin/waybar-weather
  '';

  # Make sure the script runs with the Python environment
  postInstall = ''
    wrapProgram $out/bin/waybar-weather \
      --prefix PATH : ${pkgs.python3}/bin
  '';

  meta = with pkgs.lib; {
    description = "A weather application that fetches weather data from wttr.in and formats it.";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
