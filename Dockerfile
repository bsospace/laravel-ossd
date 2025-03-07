# ใช้ PHP 8.2 พร้อม Apache เป็น base image
FROM php:8.2-apache

# เปิดใช้งาน mod_rewrite ของ Apache เพื่อให้ Laravel สามารถใช้ Pretty URLs ได้
RUN a2enmod rewrite

# คัดลอกโค้ด Laravel ไปยังโฟลเดอร์ /var/www/html ภายใน container
COPY . /var/www/html

# ติดตั้ง Composer โดยใช้คำสั่ง PHP แทน multi-stage build
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'.PHP_EOL; } else { echo 'Installer corrupt'.PHP_EOL; unlink('composer-setup.php'); exit(1); }" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/local/bin/composer  # ย้าย Composer ไปที่ /usr/local/bin เพื่อให้เรียกใช้งานง่ายขึ้น

# เปลี่ยนเจ้าของไฟล์เป็น www-data เพื่อให้ Laravel ใช้งานได้
RUN chown -R www-data:www-data /var/www/html

# ตั้งค่าตำแหน่งทำงานเป็น /var/www/html
WORKDIR /var/www/html

# ติดตั้ง dependencies ของ Laravel โดยไม่รวมแพ็กเกจที่ใช้สำหรับ development
RUN composer install --no-dev --optimize-autoloader

# เปิดพอร์ต 80 เพื่อให้ container สามารถรับคำขอ HTTP ได้
EXPOSE 80

# รัน Apache เมื่อตัว container เริ่มทำงาน
CMD ["apache2-foreground"]
