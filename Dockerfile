FROM maven:3.6.3-jdk-11 as mavenbuilder
ARG TEST=/home/multibuild
WORKDIR $TEST
COPY . .

RUN mvn clean package

FROM tomcat:9.0
ARG TEST=/home/multibuild
COPY --from=mavenbuilder ${TEST}/target/hello-world-war-1.0.1.war /usr/local/tomcat/webapps
EXPOSE 8085
CMD ["catalina.sh", "run"]
