# Use the official Node.js Alpine image
FROM node:18-alpine

# Install OpenSSL and libc6-compat, which are required by Prisma on Alpine Linux
RUN apk add --no-cache openssl libc6-compat

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json (or yarn.lock/pnpm-lock.yaml)
COPY package*.json ./

# Install all dependencies
RUN npm install

# Copy the Prisma schema directory
COPY prisma ./prisma/

# Generate the Prisma Client
RUN npx prisma generate

# Copy the rest of your application code
COPY . .

# ---------------------------------------------------------
# ADD THESE TWO LINES: Catch the variable from Render
ARG NEXT_PUBLIC_CLOUDINARY_CLOUD_NAME
ARG NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY

ENV NEXT_PUBLIC_CLOUDINARY_CLOUD_NAME=$NEXT_PUBLIC_CLOUDINARY_CLOUD_NAME
ENV NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=$NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY
# ---------------------------------------------------------

# Build the Next.js application
RUN npm run build

# Expose the port the app runs on
EXPOSE 3000

# Set environment variables
ENV NODE_ENV=production
ENV PORT=3000

# Start the Next.js application
CMD ["npm", "start"]