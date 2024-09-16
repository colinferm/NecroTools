<?php
define('DB_HOST', getenv('DATABASE_HOST'));
define('DB_TYPE','mysql');
define('DB_NAME', getenv('DATABASE_USER'));
define('DB_USER', getenv('DATABASE_USER'));
define('DB_PASS', getenv('DATABASE_PASSWORD'));

define('IS_REDIS_ACTIVE', 1);
define('REDIS_HOST', getenv('REDIS_HOST'));

// See UserController:peperGen to generate a unique pepper
define('PEPPER', '$2y$10$0RPcLXUOzQu1EZO8PQXikuULwwnkFGi7ycn3G.IBl580Vv7ibw4Wu');
?>