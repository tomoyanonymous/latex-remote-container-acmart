# based on https://github.com/aruneko/texlive
# and https://github.com/nukopy/ubuntu-texlive-ja

FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
# Set uid and gid to the current user
ARG USER
ARG UID
ARG GID

# install general packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      build-essential \
      cpanminus \
      git \
      curl \
      wget \
      ssh\
      locales \
      libfontconfig1 \
      ca-certificates \
      fonts-ipafont \
      && \
    # clean to reduce image size
    apt-get clean -y && \
    apt-get autoremove -y && \
    apt-get autoclean -y && \
    rm -rf /var/lib/apt/lists/*

ARG ARCHIVE_URL="https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz"
ENV TEXLIVE_VERSION="2024"

WORKDIR /tmp/install-tl-unx
COPY ./texlive.profile ./

# Install TeX Live
WORKDIR /tmp/install-tl-unx
COPY ./texlive.profile ./
RUN wget -nv ${ARCHIVE_URL}
RUN tar -xzf ./install-tl-unx.tar.gz --strip-components=1
RUN ./install-tl --profile=./texlive.profile --no-interaction
RUN rm -rf /tmp/install-tl-unx

# Copy `docker-entrypoint.sh` for adding TeX Live binaries to PATH
COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

# Use docker-entrypoint.sh to acquire path
RUN . /docker-entrypoint.sh && tlmgr update --self --all
RUN . /docker-entrypoint.sh && tlmgr install \
      collection-basic \
      collection-latexrecommended \
      collection-xetex \
      collection-bibtexextra \
      collection-binextra \
      collection-fontsrecommended \
      collection-langenglish \
      collection-langjapanese \
      collection-pictures \
      collection-mathscience \
      latexmk \
      acmart \
      inconsolata\
      newtx \
      biblatex \
      biber
RUN mkdir -p \
      /usr/local/texlive/texmf-local/fonts/opentype/google/notosanscjk/ 
RUN mkdir -p \
      /usr/local/texlive/texmf-local/fonts/opentype/google/notoserifcjk/
RUN ln -s /usr/share/fonts/opentype/noto/NotoSansCJK-*.ttc \
      /usr/local/texlive/texmf-local/fonts/opentype/google/notosanscjk/ 
RUN ln -s /usr/share/fonts/opentype/noto/NotoSerifCJK-*.ttc \
      /usr/local/texlive/texmf-local/fonts/opentype/google/notoserifcjk/ 
RUN mkdir /usr/local/texlive/texmf-local/fonts/truetype
RUN mkdir /usr/local/texlive/texmf-local/fonts/truetype/ipafont
RUN ln -s /usr/share/fonts/truetype/ipafont \
      /usr/local/texlive/texmf-local/fonts/truetype/ipafont

RUN . /docker-entrypoint.sh && mktexlsr 

RUN cd ../ && rm -rf install-tl.tar.gz install-tl
RUN apt autoremove -y
RUN rm -rf /var/lib/apt/lists/*

RUN mkdir /workdir

VOLUME /workdir

WORKDIR /workdir

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["bash"]