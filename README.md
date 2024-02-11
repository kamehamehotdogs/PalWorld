# Supported tags and respective `Dockerfile` links
-	[`latest` (*bullseye/Dockerfile*)](https://github.com/CM2Walki/Squad/blob/master/bullseye/Dockerfile)

# What is PalWorld?
Palworld is an upcoming action-adventure, survival, and monster-taming game created and published by Japanese developer Pocket Pair. The game is set in an open world populated with animal-like creatures called "Pals", which players can battle and capture to use for base building, traversal, and combat. <br/>

> [PalWorld](https://store.steampowered.com/app/1623730/Palworld/)

<img src="https://cdn.akamai.steamstatic.com/steam/apps/1623730/capsule_616x353.jpg?t=1705662211" alt="logo" width="300"/></img>

# How to use this image

## Hosting a simple game server
Running on the *host* interface (recommended):<br/>
```console
$ docker run -d --net=host -v /home/steam/PalServer/ --name=palserver-dedicated om2180/PalWorld
```

Running using a bind mount for data persistence on container recreation:
```console
$ mkdir -p $(pwd)/palserver-data
$ chmod 777 $(pwd)/palserver-data # Makes sure the directory is writeable by the unprivileged container user
$ docker run -d --net=host -v $(pwd)/palserver-data:/home/steam/palserver-dedicated/ --name=palserver-dedicated om2180/palserver
```

Running multiple instances (iterate PORT, QUERYPORT and RCONPORT):<br/>
```console
$ docker run -d --net=host -v /home/steam/palserver-dedicated/ -e PORT=8211 -e QUERYPORT=27166 -e RCONPORT=21115 --name=palserver-dedicated2 om2180/palserver
```

**The container will automatically update the game on startup, so if there is a game update just restart the container.**

### docker-compose.yml example
```dockerfile
version: '3.9'

services:
  palserver:
    image: om2180/palserver
    container_name: palserver
    restart: unless-stopped
    network_mode: "host"
    volumes:
      - ~/palserver/:/home/steam/palserver-dedicated/
    environment:
      - PORT=8211
      - QUERYPORT=27165
      - RCONPORT=21114
      - MAXPLAYERS=32
```

# Configuration
## Environment Variables
Feel free to overwrite these environment variables, using -e (--env):
```dockerfile
PORT=8211
QUERYPORT=27165
RCONPORT=21114
MAXPLAYERS=32
```

## Config
The config files can be edited using this command:

```console
$ docker exec -it palserver-dedicated nano /home/steam/palserver-dedicated/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini

```

If you want to learn more about configuring a PalServer, check this [documentation](https://palserver.gamepedia.com/Server_Configuration).

## Mods

TBD

# Contributors
