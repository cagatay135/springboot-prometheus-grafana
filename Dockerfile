# Stage 1: Build the application
FROM gradle:7-jdk17 AS builder

# Copy the project files to the container
COPY --chown=gradle:gradle . /home/gradle/src

# Set working directory
WORKDIR /home/gradle/src

# Build the application
RUN gradle build --no-daemon

# Stage 2: Create the runtime image
FROM gradle:7-jdk17

RUN mkdir /app

# Copy the built artifact from the builder stage
COPY --from=builder /home/gradle/src/build/libs/*.jar /app/MonitoringJava-0.0.1-SNAPSHOT.jar

# Set JMX envs
ENV JAVA_TOOL_OPTIONS_TEMP "-Dcom.sun.management.jmxremote \
                     -Dcom.sun.management.jmxremote.authenticate=false \
                     -Dcom.sun.management.jmxremote.ssl=false \
                     -Dcom.sun.management.jmxremote.local.only=false \
                     -Dcom.sun.management.jmxremote.port=9010 \
                     -Dcom.sun.management.jmxremote.rmi.port=9010 \
                     -Djava.rmi.server.hostname=127.0.0.1"

# Run the application
ENTRYPOINT ["java", "-jar", "-Xmx1G", "-Xms512M", "-XX:+UnlockDiagnosticVMOptions", "-XX:+DebugNonSafepoints", "/app/MonitoringJava-0.0.1-SNAPSHOT.jar"]
