
# Creating the package

The first step is to create a new cookie package. This is basically a Makefile that describe how
to get the sources and build. See [packages](documentation/PACKAGES.md) for more information on
this part.

# Installing the package manually

Once the package is defined, the next step is to verify manually that it can be compiled and
installed properly. This is done using the host command. See the [host](documentation/HOST.md) for
infomration on how to use this command. If everything goes well, the package will end up installed
in the environment, but changes will be lost when leaving the shell.

# Modifying the DockerFile

Eventhou the local modification are not saved, the .deb itself is stored within the shared
folder. Cookie automatically place .deb packages created this way in the bootstrap directory, so
that they can be used easily in the Dockerfile. To include the new custom package in the build
environment the following line need to be added to the Dockerfile:

	RUN dpkg -y /root/debian/<package_name>.deb

# Updating the bootstrap environment

Once the Docker file is updated, the last step is to regenerate the bootstrap environment using
the **update** command.
