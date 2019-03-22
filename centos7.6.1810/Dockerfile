FROM centos:7.6.1810

ARG SWARM_VERSION=3.15
ARG SWARM_SHA=54eb41ef015208225f241b4ac447bc9cb8db9de6991c514cb7843e07f7850378340aef9de397e3552b0393acb03035569fa758dc0a227535e80cb4c0867be301
ARG SWARM_USER=swarm
ARG SWARM_UID=1001
ARG SWARM_GROUP=swarm
ARG SWARM_GID=1001

ENV SWARM_USER=${SWARM_USER}
ENV SWARM_GROUP=${SWARM_GROUP}
ENV SWARM_JAVA_PARAMETERS="-Xms128m -Xmx512m"
ENV SWARM_MASTER_URL \
    SWARM_JENKINS_USER \
    SWARM_JENKINS_PASSWORD \
    SWARM_EXECUTORS \
    SWARM_LABELS \
    SWARM_NAME \
    SWARM_CLIENT_PARAMETERS
# internal environment variables
ENV SWARM_HOME=/home/swarm \
    SWARM_WORKDIR=/opt/jenkins

RUN /usr/sbin/groupadd --gid $SWARM_GID $SWARM_GROUP && \
    /usr/sbin/useradd --uid $SWARM_UID --gid $SWARM_GID --shell /bin/bash $SWARM_USER && \
    # install development tools
    yum install -y \
        git \
        java-1.8.0-openjdk && \
    yum clean all && \
    rm -rf /var/cache/yum/* && \
    # install tini zombie reaper and signal forwarder
    export TINI_VERSION=0.18.0 && \
    export TINI_SHA=2bc84640755fb02bca67ad24eff8657d4a8c3a1c3923532319271d292590f7aebab49ab855eb6d25eb6222032e7a10e43257342aad9b790eb62fdd2f524fe908 && \
    curl -fsSL https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static -o /bin/tini && \
    chmod +x /bin/tini && \
    sha512sum /bin/tini && \
    echo "$TINI_SHA /bin/tini" | sha512sum -c - && \
    # install jenkins swarm slave
    mkdir -p ${SWARM_HOME} && \
    curl -fsSL -o ${SWARM_HOME}/swarm-client-${SWARM_VERSION}.jar https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/${SWARM_VERSION}/swarm-client-${SWARM_VERSION}.jar && \
    sha512sum ${SWARM_HOME}/swarm-client-${SWARM_VERSION}.jar && \
    echo "$SWARM_SHA ${SWARM_HOME}/swarm-client-${SWARM_VERSION}.jar" | sha512sum -c - && \
    mv ${SWARM_HOME}/swarm-client-${SWARM_VERSION}.jar ${SWARM_HOME}/swarm-client.jar && \
    mkdir -p ${SWARM_WORKDIR} && \
    chown -R ${SWARM_USER}:${SWARM_GROUP} ${SWARM_HOME} ${SWARM_WORKDIR}

USER ${SWARM_USER}
WORKDIR ${SWARM_WORKDIR}
VOLUME ${SWARM_WORKDIR}
COPY docker-entrypoint.sh ${SWARM_HOME}/docker-entrypoint.sh

ENTRYPOINT ["/bin/tini", "--", "/home/swarm/docker-entrypoint.sh"]
CMD ["swarm"]
