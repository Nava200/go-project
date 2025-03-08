# Stage 1: Build the Go application using the golang base image
FROM golang:1.20 AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the Go module files and download dependencies
COPY go.mod go.sum ./
RUN go mod tidy

# Copy the source code to the container
COPY . .

# Build the Go application
RUN go build -o go-app .

# Stage 2: Create a minimal runtime container
FROM alpine:latest

# Install necessary dependencies for the Go binary to run (e.g., libc)
RUN apk add --no-cache libc6-compat

# Set the working directory
WORKDIR /root/

# Copy the built application from the builder stage
COPY --from=builder /app/go-app .

# Expose the port the app will run on
EXPOSE 8000

# Run the Go application
CMD ["./go-app"]
