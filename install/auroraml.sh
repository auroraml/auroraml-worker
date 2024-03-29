#!/bin/bash



aurora_etc_dir="/etc/auroraml"
test -d "$aurora_etc_dir" || ( mkdir "$aurora_etc_dir" && chmod 755 "$aurora_etc_dir" )

htdocs="/var/www/html"

rm -rf "${htdocs}" 2> /dev/null
mkdir -p "${htdocs}"
cp -rT ../www "${htdocs}"
chown www-data:www-data "${htdocs}" -R
chmod 755 "${htdocs}" -R

# Direcciones baneadas
echo '; Lista de direcciones filtradas
; banned[]="isabel@elpuent.com"
banned[]="#^mailer-daemon@.*$#is"
banned[]="#^nospam@.*$#is"
banned[]="#^.*@fcm\.pri\.sld\.cu$#is"
banned[]="#^.*@dmsch\.sld\.cu$#is"
banned[]="reina.meli@nauta.cu"
; Estafadores
banned[]="alexdjcom@nauta.cu"
banned[]="adrianojrbr@nauta.cu"
banned[]="winnie25@nauta.cu"
banned[]="igaki@nauta.cu"
banned[]="jobplay@nauta.cu"
banned[]="anyelinai@nauta.cu"
banned[]="anyitamayo@nauta.cu"
banned[]="yordan.almenares@nauta.cu"
banned[]="barrerasyaima@nauta.cu"
banned[]="puchi79@nauta.cu"
banned[]="loidmila@nauta.cu"
banned[]="aracelishidalgo@nauta.cu"
banned[]="reynier1505@nauta.cu"
banned[]="noel1010@nauta.cu"

; Comemierdas que reclamaron dinero

; Un tipo que no quiere recibir correos
banned[]="yadir87@nauta.cu"
' > "${aurora_etc_dir}/banned.ini"


# Configuracion de AuroraSuite


echo "<?php

// MYSQL
define('MYSQL_HOST', '$(read_def "Mysql Host" "192.168.0.11")');
define('MYSQL_PORT', $(read_def "Mysql Port" "3306"));
define('MYSQL_USER', '$(read_def "Mysql User" "")');
define('MYSQL_PASS', '$(read_def "Mysql Pass" "")');
define('MYSQL_DB', '$(read_def "Mysql Database" "")');


// SMTP
define('MAIL_IS_SMTP', 1);
define('SMTP_HOST', '$(read_def "SMTP Host" "192.168.0.10")');
define('SMTP_PORT', $(read_def "SMTP Port" "25"));
define('SMTP_AUTH', 0);
define('SMTP_SSL', 0);

define('SMTP_DEBUG', 0);

define('MAIL_ORIGIN', '$(read_def "MAIL ORIGIN" "auroraml.net")');

// Timeouts
define('WEBPAGE_TIMEOUT', 5);
define('WEBPAGE_DEPS_TIMEOUT', 3);
define('MAX_SIMULTANEOUS_REQUEST', 30);

// Misc
define('_DEBUG_', 0);
define('DIAS_PRUEBA', 7);

// Version Minima de AuroraSuite para nuevos usuarios
define('AU_NEW_USER_MIN_VERSION_CODE ',  13);
define('AU_NEW_USER_MIN_VERSION_NAME ',  '6.0.1');

// Hack para cuando hay una cola enorme de entrada
// porque el sistema estuvo caido
define('DROP_ALL', 0);

" > "${aurora_etc_dir}/config.php"

# Importar la configuracion en AuroraSuite
mkdir -p "${htdocs}/config"
echo "<?php
require_once '${aurora_etc_dir}/config.php';

define('AURORA_CONFIG_DIR', '${aurora_etc_dir}');
define('BANNED_FILE', '${aurora_etc_dir}/banned.ini');

" > "${htdocs}/config/config.php"
