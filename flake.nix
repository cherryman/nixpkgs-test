{
  description = "testing nixpkgs on ci on all systems";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:cherryman/nixpkgs?rev=8f2d45e4191cd6fb8daf748bd5b04c5361393f7a";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          system,
          ...
        }:
        {
          packages.default = pkgs.writeShellApplication {
            name = "test";
            runtimeInputs = [
              pkgs.frida-tools
              (pkgs.python3.withPackages (ps: with ps; [ frida-python ]))
            ];
            text = ''
              python3 -c "import frida; frida._frida"
              frida --help
            '';
          };
        };
      flake = { };
    };
}
