### Template Composer Package

Use this section as a quick-start to build and publish your own Composer package from scratch.

#### Prerequisites

- PHP 8.1+ (or your target PHP version)
- Composer installed (`composer --version`)
- GitHub/GitLab repo with `git` set up

#### 1) Create the repository and initialize Composer

```bash
mkdir my-vendor-my-package && cd my-vendor-my-package
git init
composer init \
  --name="my-vendor/my-package" \
  --description="Short description of your package" \
  --type="library" \
  --license="MIT" \
  --author="Your Name <you@example.com>" \
  --require="php:^8.1" \
  --autoload="psr-4:{\\"MyVendor\\\\MyPackage\\\": \\"src/\\"}"
```

This creates a minimal `composer.json` and PSR-4 autoload mapping for `MyVendor\MyPackage\` → `src/`.

#### 2) Scaffold directories

```bash
  mkdir -p src tests
```

Optionally add: `docs/`, `examples/`, `config/`, `.github/workflows/`.

#### 3) Create your first class

```php
<?php
// file: src/Greeting.php

namespace MyVendor\MyPackage;

class Greeting
{
    public function sayHello(string $name): string
    {
        return "Hello, {$name}!";
    }
}
```

#### 4) Install dev tools and tests

```bash
  composer require --dev phpunit/phpunit:^11 friendsofphp/php-cs-fixer:^3
```

Add scripts to `composer.json` to streamline workflows:

```json
{
    "scripts": {
        "test": "phpunit --colors=always",
        "lint": "php -l src/*.php || true",
        "format": "php-cs-fixer fix --using-cache=no --verbose"
    }
}
```

Add a basic PHPUnit config (phpunit.xml.dist):

```xml
<?xml version="1.0" encoding="UTF-8"?>
<phpunit colors="true" bootstrap="vendor/autoload.php">
    <testsuites>
        <testsuite name="Unit">
            <directory>tests</directory>
        </testsuite>
    </testsuites>
</phpunit>
```

Create a first test:

```php
<?php
// file: tests/GreetingTest.php

use MyVendor\MyPackage\Greeting;

it('greets by name', function () {
    $greeting = new Greeting();
    expect($greeting->sayHello('World'))->toBe('Hello, World!');
});
```

If you prefer classic PHPUnit instead of Pest, use a `\PHPUnit\Framework\TestCase` class.

Run tests:

```bash
  composer test
```

#### 5) Composer autoload verification

After adding classes, dump autoload to update the class map:

```bash
  composer dump-autoload
```

#### 6) Documentation and metadata

- **README.md**: package purpose, install, usage, API examples, versioning policy
- **LICENSE**: MIT (or your choice)
- **CHANGELOG.md**: follow Keep a Changelog; use SemVer
- **.gitattributes**: exclude dev files from distribution (e.g., `/tests export-ignore`)

Example `.gitattributes`:

```
/tests export-ignore
/.github export-ignore
/.idea export-ignore
/phpunit.xml.dist export-ignore
/.php-cs-fixer.dist.php export-ignore
```

#### 7) Versioning and tagging

Use Semantic Versioning.

```bash
    git add .
    git commit -m "feat: initial release"
    git tag v0.1.0
    git remote add origin git@github.com:my-vendor/my-package.git
    git push -u origin main --tags
```

#### 8) Publish to Packagist

- Create an account at `https://packagist.org`
- Submit your repository URL
- Ensure GitHub/GitLab hooks are active so Packagist auto-updates on new tags

Users can now install your package:

```bash
  composer require my-vendor/my-package:^0.1
```

#### 9) Optional: Laravel package specifics

If your package targets Laravel:

- Add a service provider under `src/` (e.g., `MyPackageServiceProvider`) and register bindings
- In `composer.json`, add `extra.laravel.providers` for auto-discovery:

```json
{
    "extra": {
        "laravel": {
            "providers": ["MyVendor\\MyPackage\\MyPackageServiceProvider"]
        }
    }
}
```

#### 10) Maintenance checklist

- **CI**: run tests on push/PR (GitHub Actions/GitLab CI)
- **Static analysis**: Psalm or PHPStan
- **Code style**: PHP-CS-Fixer config committed
- **Security**: watch dependabot/`composer audit`
- **Support policy**: document PHP/Laravel versions supported

---

#### Minimal composer.json template

Copy and adapt:

```json
{
    "name": "my-vendor/my-package",
    "description": "Short description",
    "type": "library",
    "license": "MIT",
    "authors": [{ "name": "Your Name", "email": "you@example.com" }],
    "require": {
        "php": "^8.1"
    },
    "autoload": {
        "psr-4": {
            "MyVendor\\MyPackage\\": "src/"
        }
    },
    "require-dev": {
        "phpunit/phpunit": "^11"
    },
    "scripts": {
        "test": "phpunit --colors=always",
        "format": "php-cs-fixer fix --using-cache=no --verbose"
    },
    "minimum-stability": "stable",
    "prefer-stable": true
}
```

You now have a working template to build, test, version, and publish a Composer package.

[See LMF package OCR for reference](https://github.com/lmfventures/package-ocr)
