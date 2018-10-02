echo "Building image"
docker-compose build

echo "Running container"
docker-compose up

echo "Committing image"
docker commit -c 'ENTRYPOINT [""]' emulator yorickvanzweeden/android-ci:latest

echo "Pushing image to dockerhub"
docker push yorickvanzweeden/android-ci:latest