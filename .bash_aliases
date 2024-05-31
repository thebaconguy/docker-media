export DOCKER_STORAGE_ROOT=/home/username/dockerstorage
export DOCKER_COMPOSE_ROOT=${DOCKER_STORAGE_ROOT}/docker-compose

# don't forget to leave the trailing spaces at the end so following commands can build on them

# start building our docker compose command and give it a nice shorterned alias
alias dcrun=' \
  cd $DOCKER_COMPOSE_ROOT && \
  COMPOSE_HTTP_TIMEOUT=1800 docker compose \
    -f $DOCKER_COMPOSE_ROOT/docker-compose.networking.yml \
    -f $DOCKER_COMPOSE_ROOT/docker-compose.media.yml \
    -f $DOCKER_COMPOSE_ROOT/docker-compose.cloud.yml \
    -f $DOCKER_COMPOSE_ROOT/docker-compose.utils.yml \
    -f $DOCKER_COMPOSE_ROOT/docker-compose.game.yml \
    -f $DOCKER_COMPOSE_ROOT/docker-compose.prod.yml '
    # add more override files as desired
    # the last ones have precedence over previous ones, where override order is concerned
    # more info: https://docs.docker.com/compose/extends/#multiple-compose-files

# start the compose project in daemon (background) mode
alias dcup='dcrun up -d '

# bring everything down and remove any failed remains along the way
alias dcdown='dcrun down '

# fetch updated images for all the images specified in the config (:latest by default)
alias dcpull='dcrun pull '

# WARNING: this will delete everything that is not being used at the time of running this command
# recommend using this after running 'dcup' and everything is running smoothly
# this will wipe out old (and more importantly, unused) containers, images, networks and volumes
alias dclean='docker system prune --force --volumes'

# fetch and update all containers
alias dcupdate=' \
  dcpull && \
  dcup && \
  dclean '

# log the latest from a container. example: 'dlf letsencrypt'
alias dlf='docker logs -f '

# terminal into a container. example: 'dsh letsencrypt' (not currently working)
alias dsh="docker exec -it ${1} bash"

# other helpers
alias check_nginx='docker run --rm --network=none -v $DOCKER_STORAGE_ROOT/letsencrypt:/config:ro yandex/gixy /config/nginx/nginx.conf'

alias update_geoip='\
  cd $DOCKER_STORAGE_ROOT/letsencrypt/geoip && \
  wget "http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz" && \
  gunzip -f GeoIP.dat.gz'
