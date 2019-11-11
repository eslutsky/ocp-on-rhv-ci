# docker file is based on this image:
wget https://raw.githubusercontent.com/cytopia/docker-ansible/master/Dockerfile-tools

# run the docker build
docker build . --network=host --build-arg version=latest

#tagging the new built image
docker image tag c6abf3f3d585 eslutsky/ansible:latest-tools

