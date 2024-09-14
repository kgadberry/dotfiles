{ config, lib, pkgs, inputs, ... }:

let
    nixGLDefault = inputs.nixgl.packages."${pkgs.system}".nixGLDefault;
in {
    config.nixGL.prefix = "${nixGLDefault}/bin/nixGL";
}
