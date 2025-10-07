# Daniela Jacome

# 1. Construcción de la aplicación con Maven
FROM maven:latest AS build

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar el archivo pom.xml y las dependencias del proyecto
COPY pom.xml .

# Descargar las dependencias de Maven
RUN mvn dependency:go-offline

# Copiar todo el código fuente
COPY src ./src

# Compilar el proyecto y empaquetar el JAR
RUN mvn clean package -DskipTests

# 2Crear la imagen final para ejecutar la aplicación
FROM openjdk:17-jdk-slim

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar el JAR generado desde 1
COPY --from=build /app/target/spring-petclinic-3.5.0-SNAPSHOT.jar /app/petclinic.jar

# Exponer el puerto 8080
EXPOSE 8080

# Ejecutar el JAR con Java
CMD ["java", "-jar", "/app/petclinic.jar"]
