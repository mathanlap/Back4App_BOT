# Step 1: Choose the base image
FROM node:lts

# Step 2: Install Google Chrome
RUN apt-get update && \
    apt-get install -y wget gnupg && \
    wget --quiet --output-document=- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor > /etc/apt/trusted.gpg.d/google-archive.gpg && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list && \
    apt-get update && \
    apt-get install -y google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*

# Step 3: Install FFmpeg for video recording
RUN apt-get update && \
    apt-get install -y ffmpeg && \
    rm -rf /var/lib/apt/lists/*

# Step 4: Set the working directory inside the container
WORKDIR /app

# Step 5: Copy package.json and package-lock.json into the container
COPY package*.json ./

# Step 6: Install npm dependencies
RUN npm install

# Step 7: Copy the rest of the application code into the container
COPY . .

# Step 8: Set environment variables
ENV NAUKRI_EMAILID=$NAUKRI_EMAILID
ENV NAUKRI_PASSWORD=$NAUKRI_PASSWORD
ENV BOT_EMAILID=$BOT_EMAILID
ENV BOT_MAIL_PASSWORD=$BOT_MAIL_PASSWORD
ENV RECEIVEING_EMAILID=$RECEIVEING_EMAILID

# Step 9: Command to run the application
CMD ["node", "index.js"]
