## 👋 Welcome to rhel7 🚀  

rhel7 README  
  
  
## Run container

```shell
dockermgr update rhel7
```

### via command line

```shell
docker pull casjaysdevdocker/rhel7:latest && \
docker run -d \
--restart always \
--name casjaysdevdocker-rhel7 \
--hostname casjaysdev-rhel7 \
-e TZ=${TIMEZONE:-America/New_York} \
-v $HOME/.local/share/srv/docker/rhel7/files/data:/data:z \
-v $HOME/.local/share/srv/docker/rhel7/files/config:/config:z \
-p 80:80 \
casjaysdevdocker/rhel7:latest
```

### via docker-compose

```yaml
version: "2"
services:
  rhel7:
    image: casjaysdevdocker/rhel7
    container_name: rhel7
    environment:
      - TZ=America/New_York
      - HOSTNAME=casjaysdev-rhel7
    volumes:
      - $HOME/.local/share/srv/docker/rhel7/files/data:/data:z
      - $HOME/.local/share/srv/docker/rhel7/files/config:/config:z
    ports:
      - 80:80
    restart: always
```

## Authors  

🤖 casjay: [Github](https://github.com/casjay) [Docker](https://hub.docker.com/r/casjay) 🤖  
⛵ CasjaysDevDocker: [Github](https://github.com/casjaysdevdocker) [Docker](https://hub.docker.com/r/casjaysdevdocker) ⛵  
