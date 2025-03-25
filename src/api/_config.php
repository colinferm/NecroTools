<?php
define('DB_HOST', getenv('DATABASE_HOST'));
define('DB_TYPE','mysql');
define('DB_NAME', getenv('DATABASE_USER'));
define('DB_USER', getenv('DATABASE_USER'));
define('DB_PASS', getenv('DATABASE_PASSWORD'));
define('DB_PREFIX', 'necro_');

define('REDIS_HOST', getenv('REDIS_HOST'));

$cache = new Redis();
$isCache = $cache->pconnect(REDIS_HOST);
define('IS_REDIS_ACTIVE', $isCache);

// See UserController:peperGen to generate a unique pepper
define('PEPPER', '$2y$10$0RPcLXUOzQu1EZO8PQXikuULwwnkFGi7ycn3G.IBl580Vv7ibw4Wu');

?>