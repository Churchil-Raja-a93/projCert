# Use an official PHP runtime as the base image
FROM php:8.2-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    zip \
    unzip \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Install Composer
# COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory to Apache's web root
WORKDIR /var/www/html

# Remove default files from the base image
RUN rm -rf /var/www/html/*

# Copy your PHP application files to the web root
COPY . /var/www/html/

# Install PHP dependencies if composer.json exists
RUN if [ -f composer.json ]; then \
    composer install --no-dev --no-interaction --optimize-autoloader; \
    fi

# Set permissions and enable Apache modules
RUN chown -R www-data:www-data /var/www/html \
    && a2enmod rewrite

# Expose port 80
EXPOSE 80

# Start Apache server
CMD ["apache2-foreground"]
