<?php
/**
 * Plugin Name: Codespaces URL Fix
 * Description: Fixes redirect issues when running WordPress in GitHub Codespaces
 */

// Disable canonical redirects that break Codespaces
remove_filter('template_redirect', 'redirect_canonical');

// Force HTTPS on all output
add_action('init', function() {
    ob_start(function($buffer) {
        // Replace any http:// links to the Codespaces domain with https://
        $buffer = str_replace('http://legendary-space-dollop-6976jxpvpv9rhr6gq-8080.app.github.dev', 'https://legendary-space-dollop-6976jxpvpv9rhr6gq-8080.app.github.dev', $buffer);
        // Also fix localhost references
        $buffer = str_replace('http://localhost', 'https://legendary-space-dollop-6976jxpvpv9rhr6gq-8080.app.github.dev', $buffer);
        return $buffer;
    });
});

// Force HTTPS for all URL functions
add_filter('home_url', function($url) {
    return str_replace('http://', 'https://', $url);
}, 999);

add_filter('site_url', function($url) {
    return str_replace('http://', 'https://', $url);
}, 999);

add_filter('admin_url', function($url) {
    return str_replace('http://', 'https://', $url);
}, 999);

add_filter('wp_redirect', function($location) {
    return str_replace('http://', 'https://', $location);
}, 999);

// Tell WordPress we're on HTTPS
add_filter('set_url_scheme', function($url, $scheme, $orig_scheme) {
    return str_replace('http://', 'https://', $url);
}, 999, 3);
