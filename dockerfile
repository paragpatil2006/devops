#Pull Jenkins Base Image
FROM jenkins/jenkins:lts

#Build the container
USER root
RUN apt-get update -y
RUN apt-get install wget -y

RUN wget --no-verbose -O /tmp/apache-maven-3.8.6-bin.tar.gz https://dlcdn.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz

RUN tar xzf /tmp/apache-maven-3.8.6-bin.tar.gz -C /opt/
RUN ln -s /opt/apache-maven-3.8.6 /opt/maven
RUN ln -s /opt/maven/bin/mvn /usr/local/bin
RUN rm -f /tmp/apache-maven-3.8.6-bin.tar.gz
ENV MAVEN_HOME /opt/maven

RUN chown -R jenkins:jenkins /opt/maven

RUN apt-get install apt-transport-https gnupg lsb-release
RUN wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | apt-key add -
RUN echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | tee -a /etc/apt/sources.list.d/trivy.list
RUN apt-get update
RUN apt-get install -y trivy
RUN curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin
RUN curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin

RUN apt-get clean

USER jenkins
