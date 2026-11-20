{ lib, self }:
let
  inherit (lib)
    composeManyExtensions
    extends
    fix
    systems
    ;

  overlay = composeManyExtensions (
    with self.overlays;
    [
      hyprland-packages
      hyprland-extras
    ]
  );
in
# Build Hyprland's packages on top of an existing nixpkgs instance.
#
# Re-importing nixpkgs with our overlays forces a whole second evaluation of
# nixpkgs, which is slow, and ignores the caller's nixpkgs config. Instead, apply
# the overlays to a small set layered over `pkgs`. `callPackage` is rebound to
# that set so dependencies resolve to our versions, and the hypr* libraries don't
# replace the nixpkgs ones for the rest of the package set.
#
# This doesn't splice, so cross builds fall back to appending the overlays.
pkgs:
let
  inherit (pkgs) appendOverlays newScope stdenv;
in
if systems.equals stdenv.buildPlatform stdenv.hostPlatform then
  fix (extends overlay (final: pkgs // { callPackage = newScope final; }))
else
  appendOverlays [ overlay ]
