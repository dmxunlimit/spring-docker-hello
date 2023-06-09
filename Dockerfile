# Maven build container 
FROM maven:3.8.5-openjdk-11 AS maven_build

COPY pom.xml /tmp/

COPY src /tmp/src/

WORKDIR /tmp/

RUN mvn package

#pull base image
FROM eclipse-temurin:11

#add user with id
# Create a new user with UID 10014

# RUN addgroup -g 10014 choreo && \
#     adduser  --disabled-password  --no-create-home --uid 10014 --ingroup choreo choreouser

RUN useradd admin -u 10014 -ms /bin/bash

# VOLUME /tmp

WORKDIR /data/

#expose port 8080
EXPOSE 8080

#copy hello world to docker image from builder image

COPY --from=maven_build /tmp/target/helloworld-1.0.jar /data/helloworld-1.0.jar

#set permissions
RUN chown -R admin:admin /data
RUN chmod -R 755 /data

# RUN chown -R admin:admin /data
RUN chmod -R 755 /root/

USER 10014

#default command

CMD java -jar /data/helloworld-1.0.jar

