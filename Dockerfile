FROM registry.access.redhat.com/ubi8/nodejs-14:latest

USER 0
ADD . /tmp/src

RUN mkdir -p /home/1001 \
	&& export HOME=`pwd` \
	&& export SUDO_USER=1001 \
	&& npm install -g meteor --unsafe-perm

RUN chown -R 1001:0 /tmp/src \
	&& mv /home/1001/.meteor ${APP_ROOT}

ENV PATH="${APP_ROOT}/.meteor:${PATH}" METEOR_WAREHOUSE_DIR=${APP_ROOT}/.meteor

USER 1001

# Install the dependencies
RUN /usr/libexec/s2i/assemble

# Set the default command for the resulting image
CMD /usr/libexec/s2i/run
