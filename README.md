# Satis Server Setup

This guide walks you through setting up a [Satis](https://getcomposer.org/doc/articles/handling-private-packages-with-satis.md) Composer repository server for private or custom PHP packages.

---

### 🛠 Create satis.json
In the root of your project, create a satis.json file with the following content:
```json
{
  "name": "my/repository",
  "homepage": "http://packages.example.org",
  "repositories": [
      { "type": "vcs", "url": "https://github.com/mycompany/privaterepo" },
      { "type": "vcs", "url": "http://svn.example.org/private/repo" },
      { "type": "vcs", "url": "https://github.com/mycompany/privaterepo2" }
  ],
  "require": {
      "company/package": "*",
      "company/package2": "*",
      "company/package3": "2.0.0"
  },
  "require-all": false,
  "require-dependencies": true,
  "require-dev-dependencies": true,
  "config": {
    "secure-http": true
  },
  "output-dir": "public",
  "archive": {
    "directory": "dist",
    "format": "tar",
    "prefix-url": "https://your-domain.com/composer/dist",
    "skip-dev": false
  }
}
```
Documentaion:
[handling-private-packages](https://getcomposer.org/doc/articles/handling-private-packages.md)

---
# Details:

"repositories": VCS sources (e.g., GitHub, GitLab, Bitbucket).

"require": Packages to include (version tag must exist like v1.0.0).

"output-dir": Directory where the generated Composer repository will be written. This should be publicly served (e.g., by Nginx).

"archive" (optional): Creates downloadable tarballs. Speeds up installs and adds security.

---
### 🏷 Tag Your Private Package(s)
Ensure your custom/private packages are tagged with semantic versions:
```bash
  cd path/to/your/package
  git tag v1.0.0
  git push origin v1.0.0
```
---
### 🏗 Build the Satis Repository
Run the following to generate the static Composer repo:
```bash
  php bin/satis build satis.json public/
```
 Re-run the build command anytime you update satis.json or push new tags

---
### 🔐 Handling Private Repositories
If your VCS repository is private, you’ll need to provide authentication.

GitHub OAuth:
```bash
  composer config --global github-oauth.github.com your_token
```
HTTP Basic Authentication:
```bash
  composer config http-basic.github.com your_username your_password
```
---
#  Satis

A simple static Composer repository generator.

## About

Satis is a tool that allows PHP developers to create a private package repository for their projects' dependencies. It provides
increased control over package distribution, improved security, and faster package installations, by creating a static Composer
registry that can be hosted anywhere (even via Docker, locally).

## Run from source

Satis requires a recent PHP version, it does not run with unsupported PHP versions. Check the `composer.json` file for details.

- Install Satis: `composer create-project --keep-vcs --no-dev composer/satis:dev-main`
- Build a repository: `php bin/satis build <configuration-file> <output-directory>`

Read the more detailed instructions in the [documentation][].

## Run as Docker container

> Note: use `composer/satis` for Docker Hub, `ghcr.io/composer/satis` for GitHub container registry.

Pull the image:

```sh
docker pull composer/satis
```

Run the image (with Composer cache from host):

```sh
docker run --rm --init -it \
  --user $(id -u):$(id -g) \
  --volume $(pwd):/build \
  --volume "${COMPOSER_HOME:-$HOME/.composer}:/composer" \
  composer/satis build <configuration-file> <output-directory>
```

If you want to run the image without implicitly running Satis, you have to
override the entrypoint specified in the `Dockerfile`:

```sh
--entrypoint /bin/sh
```

## Purge

If you choose to archive packages as part of your build, over time you can be
left with useless files. With the `purge` command, you can delete these files.

```sh
php bin/satis purge <configuration-file> <output-dir>
```

> Note: don't do this unless you are certain your projects no longer reference any of these archives in their `composer.lock` files.

## Updating

Updating Satis is as simple as running `git pull && composer install` in the
Satis directory.

If you are running Satis as a Docker container, simply pull the latest image.

## Contributing

Please note that this project is released with a [Contributor Code of Conduct][].
By participating in this project you agree to abide by its terms.

Fork the project, create a feature branch, and send us a pull request.

If you introduce a new feature, or fix a bug, please try to include a testcase.

While not required, it is appreciated if your contribution meets our coding standards.

You can check these yourself by running the tools we use:

```bash
# install tooling & dependencies
for d in tools/*; do composer --working-dir=$d install; done

# run php-cs-fixer
tools/php-cs-fixer/vendor/bin/php-cs-fixer fix

# run phpstan
tools/phpstan/vendor/bin/phpstan

# alternatively, use the shortcuts
composer phpstan
composer php-cs-fixer[-fix]
```

## Authors

See the list of [contributors][] who participate(d) in this project.

## Community Tools

- [satisfy][] - Symfony based composer repository manager with a simple web UI.

## Examples

- [eventum/composer] - A simple static set of packages hosted in GitHub Pages
- [satis.spatie.be] - A brief guide to setting up and securing a Satis repository

## License

Satis is licensed under the MIT License - see the [LICENSE][] file for details

[documentation]: https://getcomposer.org/doc/articles/handling-private-packages-with-satis.md
[contributor code of conduct]: https://www.contributor-covenant.org/version/2/0/code_of_conduct/
[contributors]: https://github.com/composer/satis/contributors
[satisfy]: https://github.com/ludofleury/satisfy
[license]: https://github.com/composer/satis/blob/main/LICENSE
[eventum/composer]: https://github.com/eventum/composer
[satis.spatie.be]: https://alexvanderbist.com/2021/setting-up-and-securing-a-private-composer-repository/
