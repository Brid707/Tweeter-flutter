FROM openjdk:22-rc-oracle

LABEL maintainer="bridmen18@outlook.com"

VOLUME /tmp

EXPOSE 8080

ARG JAR_FILE=target/demo-0.0.1-SNAPSHOT.jar
ADD ${JAR_FILE} antlr-api.jar

#RUN
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/antlr-api.jar"]
