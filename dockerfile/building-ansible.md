# docker file is based on this image:
wget https://raw.githubusercontent.com/cytopia/docker-ansible/master/Dockerfile-tools

# run the docker build
docker build . --network=host --build-arg version=latest