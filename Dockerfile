FROM ubuntu:latest

RUN apt-get update \
        && apt-get install -y --no-install-recommends \
        apt-file apt-utils && apt-file update
RUN apt-get install -y --no-install-recommends --auto-remove --fix-missing \
        software-properties-common \
        ed \
        less \
        locales \
        vim-tiny \
        wget \
        curl \
        ca-certificates \
        gnupg2 \
        xterm

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -

RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
        && locale-gen en_US.utf8 \
        && /usr/sbin/update-locale LANG=en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

RUN useradd -m bioscith

RUN apt-get install --no-install-recommends --auto-remove --fix-missing -y nodejs
RUN apt-get clean

ENV TZ 'Asia/Bangkok'
ENV DEBIAN_FRONTEND "noninteractive"
RUN echo $TZ > /etc/timezone \
        && apt-get update \
        && apt-get install -y tzdata \
        && rm /etc/localtime \
        && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
        && dpkg-reconfigure -f noninteractive tzdata \
        && apt-get install -y --no-install-recommends \
        r-cran-littler \
        r-base \
        r-base-dev \
        r-recommended \
        r-cran-stringr \
        && echo 'options(repos = c(CRAN = "https://cran.rstudio.com/"), download.file.method = "wget")' >> /etc/R/Rprofile.site \
        && ln -s /usr/lib/R/site-library/littler/examples/install.r /usr/local/bin/install.r \
        && ln -s /usr/lib/R/site-library/littler/examples/install2.r /usr/local/bin/install2.r \
        && ln -s /usr/lib/R/site-library/littler/examples/installGithub.r /usr/local/bin/installGithub.r \
        && ln -s /usr/lib/R/site-library/littler/examples/testInstalled.r /usr/local/bin/testInstalled.r \
        && install.r docopt \
        && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

RUN  R -e "install.packages('nadiv')" && \
        echo Installation of nadiv R package completed
RUN  R -e "install.packages('data.table')" && \
        echo Installation of data.table R package completed
RUN echo "Install ggplot2"        
RUN  R -e "install.packages('ggplot2')" && \
        echo Installation of ggplot2 R package completed
RUN  R -e "install.packages('jsonlite')" && \
        echo Installation of jsonlite R package completed
RUN  R -e "install.packages('lattice')" && \
        echo Installation of lattice R package completed
RUN  R -e "install.packages('lme4')" && \
        echo Installation of lme4 R package completed
RUN  R -e "install.packages('Matrix')" && \
        echo Installation of Matrix R package completed
RUN  R -e "install.packages('MCMCglmm')" && \
        echo Installation of MCMCglmm R package completed
RUN  R -e "install.packages('nlme')" && \
        echo Installation of nlme R package completed

RUN mkdir -p /home/bioscith/VSNi/service/work

WORKDIR /home/bioscith

RUN mkdir -p /home/bioscith/bin
RUN echo "DOWN LOAD ASreml R"
RUN wget https://artemis.vsni.co.uk/downloads/c6f54f3e718aad9d428c8466399d93115e603115 -O bin/asreml4r-latest.tar.gz --no-check-certificate
RUN echo "INstall ASreml R"
RUN R -e "install.packages('./bin/asreml4r-latest.tar.gz', repos = NULL, type = 'source' )" && \
        echo Installation of ASReml R 4 completed

RUN mkdir -p ~/VSNi/enterprise_licenses
RUN echo 'CUSTOMER BSbiAAFb isv=vsni server=ls34.rlmcloud.com port=5053 password=Mu8EjkFvLS8sC46Sy' > ~/VSNi/enterprise_licenses/Mu8EjkFvLS8sC46Sy.lic

WORKDIR /home/bioscith/app
COPY . .

RUN npm install
CMD ["npm", "start"]