Zadanie 2


Repo:
- pliki z zadania 1:
wthr.py, Dockerfile(zmodyfikowany), requirements.txt
konfiguracja actions - docker publish.yml
.trivyignore, 2 wyjątki

Build push:
workflow docker/build-push-action@v4
qemu i buildx są utsawiane przez docker/setup-qemu-action@v2  i docker/setup-buildx-action@v2  

Dockerhub:

publiczne repo zadanie-drugie-cache
ustawienie na github secretów - username i token


push do main uruchamia workflow