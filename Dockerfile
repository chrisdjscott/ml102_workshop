FROM ubuntu:22.04

# install system dependencies
# TODO: move ldap-utils, libnss-ldapd, libpam-ldapd, nscd, nslcd to base image??
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        curl \
        git \
        ldap-utils \
        libnss-ldapd \
        libpam-ldapd \
        less \
        nano \
        nodejs \
        nscd \
        nslcd \
        python-is-python3 \
        python3 \
        python3-pip \
        rsync \
        unzip \
        vim \
        wget \
        zip \
    && rm -rf /var/lib/apt/lists/*

# download the required image files into the container image
RUN wget -nv https://storage.googleapis.com/download.tensorflow.org/example_images/flower_photos.tgz \
        -O /var/lib/flower_photos.tgz \
    && tar -xzf /var/lib/flower_photos.tgz -C /var/lib \
    && rm -f /var/lib/flower_photos.tgz \
    && chown -R root:root /var/lib/flower_photos \
    && chmod -R o+rX /var/lib/flower_photos \
    && wget -nv https://storage.googleapis.com/mledu-datasets/cats_and_dogs_filtered.zip \
        -O /var/lib/cats_and_dogs_filtered.zip \
    && unzip -q -d /var/lib /var/lib/cats_and_dogs_filtered.zip \
    && rm -f /var/lib/cats_and_dogs_filtered.zip \
    && chown -R root:root /var/lib/cats_and_dogs_filtered \
    && chmod -R o+rX /var/lib/cats_and_dogs_filtered

# install requirements.txt packages
COPY requirements.txt /opt/ml102_workshop/requirements.txt
RUN pip3 --no-cache-dir install -r /opt/ml102_workshop/requirements.txt \
    && pip3 --no-cache-dir install jupyterlab

# copy the repo source (e.g. notebooks) to the container image
COPY ./ /opt/ml102_workshop/
