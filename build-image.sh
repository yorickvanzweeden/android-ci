sudo docker-compose build
sudo docker-compose -f docker-compose.yml up
docker commit -c 'ENTRYPOINT [""]' emulator myemulator:latest