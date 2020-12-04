echo "running vnc server"
docker stop test
docker rm test

password=$RANDOM.$RANDOM.$RANDOM
echo "password: $password"

id=$(docker run -dP --runtime=nvidia \
	-e LD_LIBRARY_PATH=/usr/lib/nvidia \
	-v /usr/lib/nvidia-384:/usr/lib/nvidia:ro \
	-v /usr/local/licensed-bin:/usr/local/licensed-bin:ro \
	-v /tmp/.X11-unix:/tmp/.X11-unix:ro \
	--name test \
	-e X11VNC_PASSWORD=$password \
	-v `pwd`/test:/input:ro \
	brainlife/ui-trackvis)
hostport=$(docker port $id | cut -d " " -f 3)
echo "container $id using $hostport"

#-v "/usr/local/licensed-bin/config/":"/root/.config":ro \
#-v "/usr/local/licensed-bin/config/Massachusetts General Hospital":"/root/.config/Massachusetts General Hospital":ro \

WEBSOCK_PORT=0.0.0.0:11000
hostname=$(hostname)

echo "------------------------------------------------------------------------"
echo "http://$hostname:11000/vnc_lite.html?password=$password"
echo "------------------------------------------------------------------------"

/usr/local/noVNC/utils/launch.sh --listen $WEBSOCK_PORT --vnc $hostport

