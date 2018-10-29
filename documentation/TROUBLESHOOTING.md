
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


