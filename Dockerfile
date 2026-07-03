# Package the built spring-petclinic jar into a runnable image.
# The pipeline builds the jar first (./mvnw package), then builds this image
# and runs it as an isolated staging container for the ZAP (DAST) scan.
FROM eclipse-temurin:17-jre

WORKDIR /app

# The Build stage produces one executable fat jar in target/ (the plain jar is
# renamed to *.jar.original, so this glob matches only the runnable one).
COPY target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
