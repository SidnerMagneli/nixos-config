{ pkgs }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; }; in
shared-packages ++ [
  nix-search-cli
  dockutil
  vscode
  uv
  mkalias
  rectangle
  (azure-cli.withExtensions [ azure-cli.extensions.aks-preview ])
  (wrapHelm kubernetes-helm {
        plugins = with pkgs.kubernetes-helmPlugins; [
          helm-secrets
          helm-diff
          helm-s3
          helm-git
        ];
  })
  
]
