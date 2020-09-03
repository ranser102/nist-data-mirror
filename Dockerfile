FROM maven:3.5.3-jdk-8-alpine as target
WORKDIR /build
COPY pom.xml .
RUN mvn dependency:go-offline

COPY src/ /build/src/
RUN mvn clean package

FROM openjdk:latest
COPY --from=target /build/target/nist-data-mirror.jar /deployments/nist-data-mirror.jar

ARG sleeptime
ENV SleepBetweenRefresh=$sleeptime
CMD (while [ 1 ] ; do java -jar /deployments/nist-data-mirror.jar /tmp/NVD/ ;date ; echo "Sleep-Between-Refresh=$SleepBetweenRefresh"; sleep $SleepBetweenRefresh; done)