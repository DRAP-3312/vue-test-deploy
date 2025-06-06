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
# 'npm run build' is the standard command for Vue/Vite applications
# Ensure this command is correct for your project
RUN npm run build

# Stage 2: Serve the application with Nginx
FROM nginx:alpine AS production-stage

# Copy your custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy the built application files from the build stage to the Nginx path
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Expose port 80 where Nginx will listen for requests
EXPOSE 80

# Command to start Nginx when the container runs
CMD ["nginx", "-g", "daemon off;"]