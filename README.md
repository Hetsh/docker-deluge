**This Project is still work in progress.**

# Deluge
Super small code hosting platform.

## Running the server
```bash
docker run --detach --name deluge --publish 3022:3022 --publish 3000:3000 hetsh/deluge
```

## Stopping the container
```bash
docker stop deluge
```

## Creating persistent storage
```bash
STORAGE="/path/to/storage"
mkdir -p "$STORAGE"
chown -R 1367:1367 "$STORAGE"
```
`1367` is the numerical id of the user running the server (see Dockerfile).
The user must have RW access to the storage directory.
Start the server with the additional mount flags:
```bash
docker run --mount type=bind,source=/path/to/storage,target=/deluge ...
```

## Time
Synchronizing the timezones will display the correct time in the logs.
The timezone can be shared with this mount flag:
```bash
docker run --mount type=bind,source=/etc/localtime,target=/etc/localtime,readonly ...
```

## Automate startup and shutdown via systemd
The systemd unit can be found in my GitHub [repository](https://github.com/Hetsh/docker-deluge).
```bash
systemctl enable deluge --now
```
By default, the systemd service assumes `/apps/deluge/app.ini` for config, `/apps/deluge/data` for storage and `/etc/localtime` for timezone.
Since this is a personal systemd unit file, you might need to adjust some parameters to suit your setup.

## Fork Me!
This is an open project hosted on [GitHub](https://github.com/Hetsh/docker-deluge). Please feel free to ask questions, file an issue or contribute to it.
