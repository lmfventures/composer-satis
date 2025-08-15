### Template Composer Package

Use this section as a quick-start to build and publish your own Composer package from scratch.

> Important: Name your package `lmf/your-package-name`.

#### Prerequisites

- PHP 8.1+ (or your target PHP version)
- Composer installed (`composer --version`)
- GitHub/GitLab repo with `git` set up

#### 1) Create the repository and initialize Composer

```bash
mkdir your-package-name && cd your-package-name
git init
composer init \
  --name="lmf/your-package-name" \
  --description="Short description of your package" \
  --type="library" \
  --license="MIT" \
  --author="Your Name <you@example.com>" \
  --require="php:^8.1" \
  --autoload="psr-4:{\"Lmf\\\\YourPackage\\\": \"src/\"}"
```

This creates a minimal `composer.json` and PSR-4 autoload mapping for `Lmf\YourPackage\` → `src/`.

#### 2) Scaffold directories

```bash
  mkdir -p src tests
```

Optionally add: `docs/`, `examples/`, `config/`, `.github/workflows/`.

#### 3) Create your first class

```php
<?php
// file: src/Greeting.php

namespace Lmf\YourPackage;

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

use Lmf\YourPackage\Greeting;

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
    git tag v1.0.0
    git remote add origin git@github.com:your-org-or-username/your-package-name.git
    git push -u origin main --tags
```

#### 8) Publish to Github

- Ensure GitHub hooks are active so Satis auto-updates on new tags

Users can now install your package:

```bash
  composer require lmf/your-package-name:^1.0
```

#### 9) Optional: Laravel package specifics

If your package targets Laravel:

- Add a service provider under `src/` (e.g., `MyPackageServiceProvider`) and register bindings
- In `composer.json`, add `extra.laravel.providers` for auto-discovery:

```json
{
    "extra": {
        "laravel": {
            "providers": ["Lmf\\\\YourPackage\\\\YourPackageServiceProvider"]
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
    "name": "lmf/your-package-name",
    "description": "Short description",
    "type": "library",
    "license": "MIT",
    "authors": [{ "name": "Your Name", "email": "you@example.com" }],
    "require": {
        "php": "^8.1"
    },
    "autoload": {
        "psr-4": {
            "Lmf\\\\YourPackage\\\\": "src/"
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

---

### Automated Satis Build Trigger on Release

This workflow automatically notifies your Satis repository whenever a new release is published or a version tag is pushed.
Once triggered, Satis will automatically rebuild, ensuring your Composer repository is always up to date.

#### Setup Instructions

1. Run the following commands in your project root to create the workflow file:
    ```bash
    mkdir -p .github/workflows && touch .github/workflows/notify-satis.yml
    ```
2. Paste the following workflow code into .github/workflows/notify-satis.yml:

    ```yaml
    name: Notify Satis

    on:
    release:
        types: [published]
    push:
        tags:
        - 'v*'

    jobs:
    dispatch:
        runs-on: ubuntu-latest
        steps:
        - name: Send repository_dispatch to Satis
            uses: peter-evans/repository-dispatch@v3
            with:
            token: ${{ secrets.SATIS_DISPATCH_TOKEN }}
            repository: lmfventures/composer-satis
            event-type: satis.update
            client-payload: >
                {
                "repository_url":"${{ github.server_url }}/${{ github.repository }}.git",
                "tag":"${{ github.event.release.tag_name || github.ref_name }}",
                "ref":"${{ github.ref }}",
                "release_url":"${{ github.event.release.html_url || '' }}",
                "release_name":"${{ github.event.release.name || '' }}",
                "commit_sha":"${{ github.sha }}"
                }
    ```

3. Create the GitHub Secret
    - Go to your repository in GitHub.

    - Navigate to Settings → Secrets and variables → Actions → New repository secret.

    - Name it exactly:
        ```text
        SATIS_DISPATCH_TOKEN
        ```
    - Paste the Personal Access Token (PAT) into the value field.

    - Click Add secret.
