FROM node:12-alpine

WORKDIR /app

# Install build dependencies (for compiling Python)
RUN apk add --no-cache make gcc musl-dev zlib-dev openssl-dev libffi-dev g++

# Download and install Python 2.7.18 (or your preferred version)
RUN wget https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tgz \
    && tar -xzf Python-2.7.18.tgz \
    && cd Python-2.7.18 \
    && ./configure --prefix=/usr/local --enable-shared \
    && make \
    && make install \
    && cd .. \
    && rm -rf Python-2.7.18*  # Clean up

# Install pip for Python 2
RUN /usr/local/bin/python2.7 -m ensurepip --upgrade

COPY package.json .
COPY package-lock.json .

RUN npm ci

COPY . .

# Build the application.  You might need to adjust this based on the actual build process.
RUN npm run build
