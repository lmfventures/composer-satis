# Satis Server Setup.

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

# Details:

"repositories": VCS sources (e.g., GitHub, GitLab, Bitbucket).

"require": Packages to include (version tag must exist like v1.0.0).

"output-dir": Directory where the generated Composer repository will be written. This should be publicly served (e.g., by Nginx).

"archive" (optional): Creates downloadable tarballs. Speeds up installs and adds security.

Documentaion:
[handling-private-packages](https://getcomposer.org/doc/articles/handling-private-packages.md)

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

If your VCS repository is private, add the SSH private key (linked to your Composer package repository) to GitHub Actions secrets and the public key as a deploy key on the repository.
This enables Composer Satis to authenticate via SSH, creating a secure connection between the repositories without exposing credentials.

Add ssh key secret → composer-satis repository

Settings → Secrets and variables → Actions

Name it: SSH_PRIVATE_KEY

Value of your private SSH key:

```text
-----BEGIN OPENSSH PRIVATE KEY-----
[………]
-----END OPENSSH PRIVATE KEY-----
```

Add Deploy Key → Private package repository

Settings → Deploy keys

Title: Satis Access Key(this is an example name)

Key: Your public SSH key

---

[Official Satis Documentaion Link](https://github.com/composer/satis)
