# Supported tags
-	latest

> [GitHub](https://github.com/kamehamehotdogs/PalWorld)

# What is PalWorld?
Palworld is an upcoming action-adventure, survival, and monster-taming game created and published by Japanese developer Pocket Pair. The game is set in an open world populated with animal-like creatures called "Pals", which players can battle and capture to use for base building, traversal, and combat. <br/>

> [PalWorld](https://store.steampowered.com/app/1623730/Palworld/)

<img src="https://cdn.akamai.steamstatic.com/steam/apps/1623730/capsule_616x353.jpg?t=1705662211" alt="logo" width="300"/></img>

# How to use this image

## Hosting a simple game server
Running on the *host* interface:<br/>
```console
$ docker run -d --net=host -v /home/steam/PalServer/ --name=palserver-dedicated kamehamehotdogs/palserver
```

Running using a bind mount for data persistence on container recreation:
```console
$ mkdir -p $(pwd)/palserver-data
$ chmod 777 $(pwd)/palserver-data # Makes sure the directory is writeable by the unprivileged container user
$ docker run -d --net=host -v $(pwd)/palserver-data:/home/steam/PalWorld/ --name=palserver-dedicated kamehamehotdogs/palserver:latest
```

**The container will automatically update the game on startup, so if there is a game update just restart the container.**

## Docker Compose (preferred method)
```dockerfile
version: "3"
services:
  palserver:
    volumes:
      - <path-to-local>/data:/home/steam/data
    container_name: palserver-dedicated
    restart: unless-stopped
    command: bash -c "/home/steam/entry.sh"
    ports:
      - "8211:8211/udp" #These are the default ports. Change at your own risk
    image: kamehamehotdogs/palserver:latest
```
If you would like to use non-standard port mapping:

```
version: "3"
services:
  palserver:
    volumes:
      - <path-to-local>/data:/home/steam/data
    container_name: palserver-dedicated
    restart: unless-stopped
    command: bash -c "/home/steam/entry.sh"
    ports:
      - "8311:8211/udp" #This will redirect external connections through port 8311 (non-standard port) to 8211 (standard port)
    image: kamehamehotdogs/palserver:latest
```


## Config
The config files can be edited using this command:

```console
$ docker exec -it palserver-dedicated nano /home/steam/PalWorld/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
```
If the file cannot be found, run the following command to copy the default server configurations to the PalWorldSettings.ini file and then edit the PalWorldSettings.ini. **Changes to the default file will not apply to the server and its always best to stop the container before making changes to this file.**
```
sudo docker exec -it palserver-dedicated cp /home/steam/PalWorld/DefaultPalWorldSettings.ini /home/steam/PalWorld/Pal/Saved/Config/LinuxServer/ && nano /home/steam/PalWorld/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
```
# Final Notes 
If you intend to allow others access to your server remotely, I strongly recommend that you set a server and admin password in your PalWorldSettings.ini file as well as change the default port. You'll also need to configure port forwarding on your router. Consult your routers documentation for instructions on how to accomplish this.

If you want to learn more about configuring a PalServer, check this [documentation](https://palserver:latest.gamepedia.com/Server_Configuration).

## Mods

TBD
