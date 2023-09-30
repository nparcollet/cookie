
# Unable to destroy a target because of its volume

## Symptom

You are trying to remove an existing target with cookie destroy but end up with the following error message:

	... Error response from daemon: remove ea37395a12e4e0a8d84356fdab98f5bb546dc33f599208b5c661b8ea0ee10422: volume is in use - [526c96532067ddf12988d0bb3882240fabd55d7c469fda957d430fc9f1bd702d]
	[*] cookie destroy failed: shell: command "docker volume rm ea37395a12e4e0a8d84356fdab98f5bb546dc33f599208b5c661b8ea0ee10422" in "/pasth/to/cookies" failed with status 1

## Reason

It is possible that you previously started a shell within this target and did not exit it properly. As a result, it is
still running in the background. To verify this, you can use the **docker ps** command:

	# docker ps
	CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS                                                  NAMES
	526c96532067        cookie              "/bin/bash"         15 hours ago        Up 15 hours         111/tcp, 662/tcp, 2049/tcp, 38465-38467/tcp, 111/udp   reverent_benz

## Resolution

With the container id available, it is easy to stop it with the following command:

	# docker stop 526c96532067

After that, destroying the target should behave as expected.


# Conflict when installing a package

## Symptom

You are trying to merge a target and get an error regarding some conflict:

	[*] conflicts detected: ['sbin/sln', 'sbin/ldconfig', 'lib/libstdc++exp.a', 'lib/libutil.so.1', 'lib/libpthread.so.0', 'lib/libnsl.so.1', ...

## Reason

Possibly, the installation of this package was previously attempted but failed in a non clean way, in such
a way that file were actually installed in the rootfs but not marked as such.

## Resolution

Remove manually the file reported as in conflict. However, make sure first the package was not
installed. Another solution, eventhou not ideal, is to recreate the target and start with a clean
slate.

# Target / Host conflict

# Symptom

The system fail to build a "host" element, that is, something that is to be run on the host and
not on the target.

## Reason

Sometime a package need to build tools on the host and other components on the target. When this
occur there may be situation where the cookie definition confuse this system and the host tools build
may fail. For instance PKG_CONFIG_SYSROOT_DIR is set for the target, but when building host tool it
should be set for the host instead. The reason depend on the host package being build.

## Resolution

This is highly dependent on the package. For PKG_CONFIG_SYSROOT_DIR for instance, the solution
will be to set PKG_CONFIG_SYSROOT_DIR="" when host tools are being built.

# Host Dependencies

## Symptom

You try to build a package, and it fail building using a tool that is supposed to be available.

## Reason

The system does not provide host dependencies declaration at a package level. This is because
cookie have full control over the build environment, and thus it is expected to contains everything
needed. However maybe some new packages or new package version need something that is not available

## Resolution

Update the bootstrap environment. This is usually simply about adding a package to the
"apt install" list.