
if [ ! -d lib ]; then
    echo "creating ./lib"
    mkdir -p lib
    cp -av /usr/lib/x86_64-linux-gnu/libGL* lib
    cp -av /usr/lib/x86_64-linux-gnu/libEGL* lib
    cp -av /usr/lib/x86_64-linux-gnu/libnvidia* lib
    cp -av /usr/lib/x86_64-linux-gnu/libnvoptix* lib
    cp -r -av /usr/lib/x86_64-linux-gnu/vdpau lib
fi

echo "running vnc server"
docker rm -f test

set -e
set -x

password=$RANDOM.$RANDOM.$RANDOM
echo "password: $password"

container_name=brainlife/itksnap:5.0.9
docker pull $container_name

id=$(docker run -dP --gpus=all \
	-e INPUT_DIR=/input \
	-e X11VNC_PASSWORD=$password \
	-e LD_LIBRARY_PATH=/usr/lib/host \
	-v /tmp/.X11-unix:/tmp/.X11-unix:ro \
	-v `pwd`/lib:/usr/lib/host:ro \
	-v `pwd`/testdata:/input:ro \
	--name test $container_name)

sleep 5
hostport=$(docker port $id | cut -d " " -f 3)
echo "container $id using $hostport"

WEBSOCK_PORT=0.0.0.0:11000
hostname=$(hostname)

echo "------------------------------------------------------------------------"
echo "http://$hostname:11000/vnc_lite.html?password=$password"
echo "------------------------------------------------------------------------"

set -x

/usr/local/noVNC/utils/launch.sh --listen $WEBSOCK_PORT --vnc $hostport

