<?php
define('DB_HOST', getenv('DATABASE_HOST'));
define('DB_TYPE','mysql');
define('DB_NAME','necromunda');
define('DB_USER','necromunda');
define('DB_PASS','necromunda');

define('IS_REDIS_ACTIVE', 1);
define('REDIS_HOST', getenv('REDIS_HOST'));
?>