#!/bin/bash

# Disable Xdebug for faster Composer operations
echo "Disabling Xdebug for faster Composer operations..."

# Check if Xdebug is loaded
if php -m | grep -q xdebug; then
    echo "Xdebug is currently enabled. Disabling..."
    
    # Try to disable via environment variable
    export XDEBUG_MODE=off
    
    # Check if we can disable via php.ini
    PHP_INI=$(php --ini | grep "Loaded Configuration File" | awk '{print $NF}')
    if [ "$PHP_INI" != "(none)" ] && [ -f "$PHP_INI" ]; then
        echo "Found php.ini at: $PHP_INI"
        # Create backup and disable xdebug
        cp "$PHP_INI" "$PHP_INI.backup"
        sed -i '' '/xdebug/d' "$PHP_INI"
        echo "Xdebug disabled in php.ini"
    fi
    
    echo "Xdebug should now be disabled. Run 'php -m | grep xdebug' to verify."
else
    echo "Xdebug is not currently enabled."
fi

echo "You can now run Composer commands without Xdebug slowdown." 