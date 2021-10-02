# based on https://github.com/aruneko/texlive
# and https://github.com/nukopy/ubuntu-texlive-ja

FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH $PATH:/usr/local/texlive/2021/bin/x86_64-linux

# install general packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      build-essential \
      cpanminus \
      git \
      curl \
      wget \
      ssh\
      locales && \
    # clean to reduce image size
    apt-get clean -y && \
    apt-get autoremove -y && \
    apt-get autoclean -y && \
    rm -rf /var/lib/apt/lists/*

RUN cd /tmp && wget -nv -O install-tl.tar.gz \
      http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz --no-check-certificate\
&& mkdir install-tl \
&& tar -xzf install-tl.tar.gz -C install-tl --strip-components=1 \
&& cd install-tl \
&& printf "%s\n" \
      "selected_scheme scheme-basic" \
      "option_doc 0" \
      "option_src 0" \
      > ./texlive.profile \
&& ./install-tl --profile=./texlive.profile 
RUN tlmgr install \
      collection-latexrecommended \
      collection-latexextra \
      collection-fontsrecommended \
      collection-langjapanese \
      latexmk \
      acmart \
      inconsolata\
      newtx \
      biblatex \
      biber
RUN mkdir -p \
      /usr/local/texlive/texmf-local/fonts/opentype/google/notosanscjk/ 
RUN  mkdir -p \
      /usr/local/texlive/texmf-local/fonts/opentype/google/notoserifcjk/
RUN ln -s /usr/share/fonts/opentype/noto/NotoSansCJK-*.ttc \
      /usr/local/texlive/texmf-local/fonts/opentype/google/notosanscjk/ 
RUN ln -s /usr/share/fonts/opentype/noto/NotoSerifCJK-*.ttc \
      /usr/local/texlive/texmf-local/fonts/opentype/google/notoserifcjk/ 
RUN mktexlsr 

RUN cd ../ && rm -rf install-tl.tar.gz install-tl
RUN apt autoremove -y
RUN rm -rf /var/lib/apt/lists/*

RUN mkdir /workdir

VOLUME /workdir

WORKDIR /workdir

CMD ["/bin/bash"]