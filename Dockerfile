# Stage 1: Build the Vue.js application
FROM node:20-alpine AS build-stage

# Set the working directory inside the container
WORKDIR /app

# Copy package definition files to ensure dependency cache
COPY package*.json ./

# Install project dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the Vue.js application for production
# Esto crea la carpeta 'dist' dentro del contenedor en /app/dist
RUN npm npm run build

# Stage 2: Serve the application with Nginx (dentro del contenedor)
FROM nginx:alpine AS production-stage

# Copia tu configuración de Nginx (que ya tenías para servir el index.html)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copia los archivos construidos de la etapa de construcción a la ruta de Nginx
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Expone el puerto 80 donde Nginx escuchará DENTRO del contenedor
EXPOSE 80

# Comando para iniciar Nginx cuando el contenedor se ejecute
CMD ["nginx", "-g", "daemon off;"]