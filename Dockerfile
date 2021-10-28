FROM registry.access.redhat.com/ubi8/nodejs-14:latest

USER root
ADD . /tmp/src

RUN curl -o meteor.tgz $(npm view meteor dist.tarball)

RUN mkdir -p /home/1001 \
	&& export HOME=`pwd` \
	&& export SUDO_USER=1001 \
	&& npm install -g meteor.tgz --unsafe-perm

RUN /usr/bin/fix-permissions /tmp/src
USER 1001

# Install the dependencies
RUN /usr/libexec/s2i/assemble

# Set the default command for the resulting image
CMD /usr/libexec/s2i/run
