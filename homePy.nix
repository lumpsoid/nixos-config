with import <nixpkgs> {};
  (
    python3.withPackages (ps:
      with ps; [
        jupyter-core
        jupyter_console
        qtconsole
        notebook
        nbconvert
        ipykernel
        ipywidgets
        jupyter-client

        requests
        beautifulsoup4
        lxml
        pandas
      ])
  )
  .env
