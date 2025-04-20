with import <nixpkgs> {};
let
  my-python = pkgs.python3;
  python-with-my-packages = my-python.withPackages (p: with p; [
    # just an example
	scipy
  ]);
in
{ pkgs ? import <nixpkgs> {} }:

stdenv.mkDerivation {
  name = "examplecpp";
  src = ./.;

  buildInputs = [ 
	git 
	libtool 
	autoconf 
	automake 
	autogen 
	gnumake 
	cmake 
	clang 
	gcc
	hyperfine
  ];
}
