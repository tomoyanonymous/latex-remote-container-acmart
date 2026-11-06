# latex-remote-container-acmart

[![Docker Image Version (tag latest semver)][docker-image-version-badge]][docker-image-version-badge-link]
[![Docker Image Size][docker-image-size-badge]][docker-image-size-badge-link]
[![Docker Pulls][docker-pulls-badge]][docker-pulls-badge-link]


[docker-image-version-badge]: https://img.shields.io/docker/v/tomoyanonymous/latex-remote-container-acmart
[docker-image-version-badge-link]: https://hub.docker.com/repository/docker/tomoyanonymous/latex-remote-container-acmart
[docker-image-size-badge]: https://img.shields.io/docker/image-size/tomoyanonymous/latex-remote-container-acmart
[docker-image-size-badge-link]: https://hub.docker.com/repository/docker/tomoyanonymous/latex-remote-container-acmart
[docker-pulls-badge]: https://img.shields.io/docker/pulls/tomoyanonymous/latex-remote-container-acmart
[docker-pulls-badge-link]: https://hub.docker.com/repository/docker/tomoyanonymous/latex-remote-container-acmart

based on 

- https://github.com/nukopy/ubuntu-texlive-ja
- https://github.com/aruneko/texlive

Uses TeX Live 2026 (with collection-latexextra and collection-publishers, so current acmart builds out of the box). pandoc is also installed.

Additionally, it is compatible with acmart package (with libertine font and more) and installs IPA fonts.

