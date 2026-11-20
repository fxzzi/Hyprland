self:
{
  lib,
  pkgs,
  ...
}:
let
  package = (import ./mk-packages.nix { inherit lib self; } pkgs).hyprland;
in
{
  config = {
    wayland.windowManager.hyprland.package = lib.mkDefault package;
  };
}
