# Command Line Reference

## Overview

This document aims at providing a summary of all commands provided by the cookie environment along
with the context they are expected to be run in.

## Managment

The following are global commands of the cookie environment:

- cookie bootstrap: create or update the build environment
- cookie shell (*): enter the build environment shell bound to the current target (if any)
- cookie profiles: list the existing profiles along with there supproted hardware
- cookie mkimage: create an image from the current target (must have been merged first)

(*) These command can only by run from the HOST environment

## Targets 

The following commands are related to target managment:

- cookie list: list all targets that currently exists
- cookie select (*): select a new target a the current target
- cookie create (*): create a new target for a given profile
- cookie destroy (*): delete a target
- cookie merge: install packages as defiend by the target profile
- cookie add: add a package to the current target
- cookie remove: remove a package from the current target
- cookie packages: list all packages installed in the current target

(*) These command can only by run from the HOST environment as they impact the BUILD environment

## Packages

The following commands are related to package manipulations:

- cookie buid: perform a single build step on a package
- cookie search: search for a list of package matching a selector
- cookie depends: show the dependencies of a package

## Makefile

The following commands are to be use in the package Makefiles to perform certain operations:

- cookie fetch: retrieve a remote archive
- cookie extract: unpack an archive
- cookie git: perform git operation (clone, checkout)
- cookie import: import a file from the profile
- cookie patch: apply a patch located in the profile



