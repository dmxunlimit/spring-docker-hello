# Maven build container 
FROM maven:3.8.5-openjdk-11 AS maven_build
RUN echo "Pulled Image maven:3.8.5-openjdk-11"

RUN echo "COPY pom.xml /tmp/"
COPY pom.xml /tmp/

RUN echo "COPY src /tmp/src/"
COPY src /tmp/src/

WORKDIR /tmp/

RUN echo "RUN mvn package"
RUN mvn package

#pull base image
FROM eclipse-temurin:11

#add user with id
# Create a new user with UID 10014
RUN echo "RUN addgroup -g 10014 admin "
RUN addgroup -g 10014 admin && \
    adduser --uid 10014 --ingroup admin admin

RUN echo "USER 10014"
USER 10014

RUN echo "WORKDIR /data/"
WORKDIR /data/

#expose port 8080
EXPOSE 8080

#copy hello world to docker image from builder image
RUN echo "COPY --from=maven_build"
COPY --from=maven_build /tmp/target/helloworld-1.0.jar /data/helloworld-1.0.jar

#set permissions
RUN echo "RUN chown -R admin:admin /data"
RUN chown -R admin:admin /data
RUN chmod -R 755 /data

#default command
RUN echo "CMD java -jar /data/helloworld-1.0.jar"
CMD java -jar /data/helloworld-1.0.jar

