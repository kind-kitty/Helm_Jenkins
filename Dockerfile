FROM jenkins/jenkins:lts
USER root
RUN chown 1000 /var/jenkins
USER jenkins