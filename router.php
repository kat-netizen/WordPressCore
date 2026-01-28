<?php
/**
 * Router script for PHP built-in server with WordPress
 */

$root = $_SERVER['DOCUMENT_ROOT'];
$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);

// Serve static files directly
$file = $root . $path;
if (is_file($file)) {
    $extension = pathinfo($file, PATHINFO_EXTENSION);
    $mime_types = [
        'css'  => 'text/css',
        'js'   => 'application/javascript',
        'png'  => 'image/png',
        'jpg'  => 'image/jpeg',
        'jpeg' => 'image/jpeg',
        'gif'  => 'image/gif',
        'svg'  => 'image/svg+xml',
        'ico'  => 'image/x-icon',
        'woff' => 'font/woff',
        'woff2'=> 'font/woff2',
        'ttf'  => 'font/ttf',
        'eot'  => 'application/vnd.ms-fontobject',
    ];
    
    if (isset($mime_types[$extension])) {
        header('Content-Type: ' . $mime_types[$extension]);
        readfile($file);
        return true;
    }
    
    // Let PHP handle .php files
    if ($extension === 'php') {
        return false;
    }
    
    return false;
}

// Check if this is a directory with an index.php (e.g., wp-admin/)
if (is_dir($file)) {
    $index_file = rtrim($file, '/') . '/index.php';
    if (is_file($index_file)) {
        $_SERVER['SCRIPT_NAME'] = rtrim($path, '/') . '/index.php';
        require $index_file;
        return true;
    }
}

// Route everything else to index.php (WordPress front-end)
$_SERVER['SCRIPT_NAME'] = '/index.php';
require $root . '/index.php';
