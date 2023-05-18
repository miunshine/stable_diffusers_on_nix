let
  pkgs = import ( builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/963006aab35e3e8ebbf6052b6bf4ea712fdd3c28.tar.gz";
  }) {};
  


  myOverridenPython = pkgs.python3.override {

    packageOverrides = (self: super: {
      diffusers = self.buildPythonPackage rec {
        pname = "diffusers";
        version = "0.16.1";
        src = self.fetchPypi {
          inherit pname version;
          sha256 = "sha256-TNdAA4LIbYXghCVVDeGxqB1O0DYj+9S82Dd4ZNnEbv4=";
        };
        postPatch = ''
          substituteInPlace ./src/diffusers/utils/testing_utils.py --replace \
            'raise ImportError(BACKENDS_MAPPING["opencv"][1].format("export_to_video"))' 'import cv2'
        '';
        doCheck = false;
        propagatedBuildInputs = with self; [
          setuptools
          pillow
          numpy
          regex
          requests
          importlib-metadata
          huggingface-hub
          opencv4
        ];
      };
    });
  };

  myPython = myOverridenPython.withPackages (p: with p; [
    diffusers
    torch-bin
    (transformers.override { torch = p.torch-bin; })
    (accelerate.override { torch = p.torch-bin; })
  ]);
 
in pkgs.mkShell {
  buildInputs = [
    myPython
  ];
}
