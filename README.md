This repo is a cmake/make C++20 template project.

Requirements:
=============
Basically you only need a decent C++20 compiler

Arch Linux:
```bash
sudo pacman -S clang gcc git make cmake
```

NixOS:
```bash
nix-shell
```

Installation:
=============

```bash
git clone --recursive https://github.com/FloydZ/example_cxx
```

Installed Packages:
-------------------
- [gbench](https://corpaul.github.io/flamegraphdiff/) cia cmake
- [gtest](https://github.com/google/googletest) via cmake
- [b63](https://github.com/FloydZ/b63) via submodule


Installed/Needed Tools:
------------------------
- [make](https://www.gnu.org/software/make/)
- [cmake](https://cmake.org/)

Create Build directories:
-------------------------

```bash
mkdir cmake-build-debug cmake-build-release
cd cmake-build-debug
cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=1 ..
cd ..
cd cmake-build-release
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_EXPORT_COMPILE_COMMANDS=1 ..
```

Remove a unused submodule:
--------------------------

An example of how to remove a unneeded git submodule:
```bash
rm -rf .git/modules/<path-to-submodule>
git config --remove-section submodule.<path-to-submodule>.
```
