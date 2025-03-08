# Use an official Golang runtime as a builder stage
FROM golang:1.20 AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the Go module files and download dependencies
COPY go.mod go.sum ./
RUN go mod tidy

# Copy the source code
COPY . .

# Build the Go application
RUN go build -o go-app

# Use a minimal base image for the final container
FROM alpine:latest

# Set working directory
WORKDIR /root/

# Copy the built application from the builder stage
COPY --from=builder /app/go-app .

# Expose port 8000 instead of 8080
EXPOSE 8000

# Command to run the application
CMD ["./go-app"]
