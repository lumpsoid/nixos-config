with import <nixpkgs> {
    config = {
        allowUnfree = true;
        cudaSupport = true;
    };
};
(let
  pandasflavor = python3.pkgs.buildPythonPackage rec {
    pname = "pandas_flavor";
    version = "0.5.0";
    src = fetchPypi {
      inherit pname version;
      sha256 = "oeu5BRK0ssuE5bhrjUb6JwLsqeRdF9MLH09p29ak4xA=";
    };
    doCheck = false;
    propagatedBuildInputs = [
      # Specify dependencies
      pkgs.python3Packages.pandas
      pkgs.python3Packages.xarray
      pkgs.python3Packages.lazy-loader
      #pkgs.python3Packages.tuna
    ];
  };
  outdated = python3.pkgs.buildPythonPackage rec {
    pname = "outdated";
    version = "0.2.2";
    src = fetchPypi {
      inherit pname version;
      sha256 = "S3/eyI42cREg0JbUhfxNUDXk5f+9kHzzps4q9DBYuXA=";
    };
    doCheck = false;
    propagatedBuildInputs = [
      # Specify dependencies
      pkgs.python3Packages.setuptools-scm
      pkgs.python3Packages.littleutils
      pkgs.python3Packages.requests
    ];
    
  };
  pingouin = python3.pkgs.buildPythonPackage rec {
    pname = "pingouin";
    version = "0.5.3";
    src = fetchPypi {
      inherit pname version;
      sha256 = "dTDrdmXUeLfX2oyuPN/KjMuCmynrodG/iF/L/zsjxks=";
    };
    doCheck = false;
    propagatedBuildInputs = [
      # Specify dependencies
      pkgs.python3Packages.numpy
      pkgs.python3Packages.scipy
      pkgs.python3Packages.pandas
      pandasflavor
      pkgs.python3Packages.statsmodels
      pkgs.python3Packages.matplotlib
      pkgs.python3Packages.seaborn
      pkgs.python3Packages.scikit-learn
      pkgs.python3Packages.tabulate
      outdated
    ];
  };
  
in python3.withPackages (ps: with ps; [
    jupyter-core
    jupyter_console
    qtconsole
    notebook
    nbconvert
    ipykernel
    ipywidgets

    matplotlib
    scipy
    pandas
    numpy
    pingouin
    pytorch-bin
    torchmetrics
  ])
).env
