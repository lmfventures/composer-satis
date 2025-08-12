# Satis Server: Configuration & Update Guide

This guide walks you through setting up a [Satis](https://getcomposer.org/doc/articles/handling-private-packages-with-satis.md) Composer repository server for private or custom PHP packages.

---

## 📄 Satis JSON Configuration

Inside the composer-satis/satis.json file, follow these rules:

### Repositories

- "type": "vcs" for each entry.
    - Use the correct Git SSH URL:
        ```perl
        "url": "git@github.com:lmfventures/<repository>.git"
        ```
    - Add the Composer package "name" in the format "lmf/package".

### Require Section

- Add each package you want Satis to serve.
    - Use " \* " for the version unless you require a specific one.

Example:

```json
{
    "repositories": [
        {
            "type": "vcs",
            "url": "git@github.com:lmfventures/<repository package>.git",
            "name": "lmf/<repository name>"
        },
        {
            "type": "vcs",
            "url": "git@github.com:lmfventures/<repository package2>.git",
            "name": "lmf/<repository name2>"
        }
    ],
    "require": {
        "lmf/package": "*",
        "lmf/package2": "2.0.0"
    }
}
```

Documentaion:
[handling-private-packages](https://getcomposer.org/doc/articles/handling-private-packages.md)

---

### 🏷 Tag Your Private Package(s)

Your private packages must have Git tags for Satis to fetch them.
If a package has no tags, create one:

```bash
    cd path/to/your/package
    git tag v1.0.0
    git push origin v1.0.0
```

### Semantic Versioning Guide:

1.0.1 → Patch release (small fixes, no new features, backwards compatible)

1.1.0 → Minor release (new features, backwards compatible)

2.0.0 → Major release (breaking changes)

💡 Always prefix tags with v (e.g., v1.0.1).

---

[Official Satis Documentaion Link](https://github.com/composer/satis)
