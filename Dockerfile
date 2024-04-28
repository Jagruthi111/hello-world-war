FROM maven:3.3-jdk-8 as mavenbuilder
ARG DIR=/home/devops
WORKDIR $DIR
COPY . .
RUN /usr/bin/mvn clean install
RUN ls target/
RUN which mvn
FROM tomcat:9.0
ARG DIR=/home/devops/target
COPY --from=mavenbuilder ${DIR}/hello-world-war-1.0.0.war /usr/local/tomcat/webapps/
