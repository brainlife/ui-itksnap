set -e
set -x
name=brainlife/ui-itksnap
tag=5.0.9
docker build -t $name .
docker tag $name $name:$tag 
docker push $name:$tag
