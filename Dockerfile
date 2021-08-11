# vi:syntax=dockerfile
FROM debian:buster

# upgrade debian packages
ENV DEBIAN_FRONTEND="noninteractive"
RUN apt update
RUN apt install apt-utils -y
RUN apt upgrade -y

# install python and redis library
RUN apt install python3 python3-redis -y

# install the script
WORKDIR /usr/src/script
COPY ./find-exit.py .
RUN chmod +x ./find-exit.py

# clean up apt
RUN rm -rf /var/lib/apt/lists/*

# non-root user
RUN useradd -u 1001 nonroot
RUN mkdir /home/nonroot
RUN chown -R nonroot /home/nonroot
RUN chown -R nonroot /usr/src/script
USER 1001

# set entrypoint
ENTRYPOINT ["/usr/src/script/find-exit.py"]
