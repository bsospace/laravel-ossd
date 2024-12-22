#  ใช้ PHP 8.2 และ Apache 2.4 จาก Docker Hub
FROM php:8.2-apache

# ลง extenstion PHP
RUN docker-php-ext-install pdo pdo_mysql

# เปิดใช้ mod_rewrite ของ Apache
RUN a2enmod rewrite

# คัดลอกไฟล์ Laravel ไปที่ /var/www/html
COPY . /var/www/html/

# ตั้งค่าเจ้าของไฟล์และโฟลเดอร์
RUN chown -R www-data:www-data /var/www/html

# ตั้งค่าสิทธิ์ของไฟล์และโฟลเดอร์
RUN chmod -R 755 /var/www/html

# คัดลอกไฟล์ Apache config
COPY ./000-default.conf /etc/apache2/sites-available/000-default.conf

# port apache ใช้ 80
EXPOSE 80
