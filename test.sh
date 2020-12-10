
mkdir -p lib
cp -av /usr/lib/x86_64-linux-gnu/libGL* lib
cp -av /usr/lib/x86_64-linux-gnu/libEGL* lib
cp -av /usr/lib/x86_64-linux-gnu/libnvidia* lib
cp -av /usr/lib/x86_64-linux-gnu/libnvoptix* lib
cp -r -av /usr/lib/x86_64-linux-gnu/vdpau lib

echo "running vnc server"
docker stop test
docker rm test

password=$RANDOM.$RANDOM.$RANDOM
echo "password: $password"

id=$(docker run -dP --gpus=all \
	-e INPUT_DIR=/input \
	-e X11VNC_PASSWORD=$password \
	-e LD_LIBRARY_PATH=/usr/lib/host \
	-v /tmp/.X11-unix:/tmp/.X11-unix:ro \
	-v `pwd`/lib:/usr/lib/host:ro \
	-v `pwd`/testdata:/input:ro \
	--name test \
	brainlife/itksnap)
hostport=$(docker port $id | cut -d " " -f 3)
echo "container $id using $hostport"

WEBSOCK_PORT=0.0.0.0:11000
hostname=$(hostname)

echo "------------------------------------------------------------------------"
echo "http://$hostname:11000/vnc_lite.html?password=$password"
echo "------------------------------------------------------------------------"

/usr/local/noVNC/utils/launch.sh --listen $WEBSOCK_PORT --vnc $hostport

