# WingTask Fork of Taskwarrior

This fork was created to allow extending Taskwarrior to support WingTask in a
more integrated way.

[Taskwarrior github repository](https://github.com/GothenburgBitFactory/taskwarrior)

## How this fork was created

1. The fork button was clicked on GitHub to create a copy of the Taskwarrior repository under timcase.
2. The develop branch is the main branch for taskwarrior and it was synced with the develop branch of the original repository, so that it is up to date with the latest changes from the original Taskwarrior project.
3. At the time of the fork the current version of Taskwarrior was v3.4.2, by viewing the [tag page](https://github.com/GothenburgBitFactory/taskwarrior/tags) we can see that the latest version is v3.4.2, so we know that the fork is up to date with the latest version of Taskwarrior. We also see that the latest commit for tag v3.4.2 was 48fb891, so we can check that the develop branch of the fork has this commit, which confirms that it is up to date with the latest version of Taskwarrior.
4. A fork of the develop branch was created using the commit 48fb891 as the base, and this new branch was named wingtask-v3.4.2. ```bash git checkout -b wingtask-v3.4.2 48fb891```
5. Patches were applied to the branch for the extended behavior of WingTask.

## Future updating

1. Checkout the develop branch and pull the latest changes from the original Taskwarrior repository (`upstream`) to ensure it is up to date with the latest version of Taskwarrior. ```git checkout develop && git pull upstream develop```
2. Checkout the wingtask-v3.4.2 branch and rebase the develop branch into it to bring in the latest changes from the original Taskwarrior repository. ```git checkout wingtask-v3.4.2 && git rebase develop```
3. Conflicts should not happen because Taskwarrior is open to extension and closed to modification, conflicts would be a bad sign that the original Taskwarrior code was modified instead of extended, but if any conflicts do arise they should be resolved by carefully reviewing the changes and ensuring that the extended behavior for WingTask is preserved while incorporating the latest changes from the original Taskwarrior repository.
4. Check what new version tag of Taskwarrior we want to update to, and make note of the commit hash for that tag.
5. ```bash git checkout -b wingtask-vX.Y.Z <commit-hash>``` to create a new branch for the new version of Taskwarrior, using the commit hash for the new version as the base.
6. Apply any new extensions if needed.

## WingTask Integration

This needs to be done in the Dockerfile for production, and in Dockerfile.dev for development, the following code snippet can be used to install the forked version of Taskwarrior from source, this ensures that we have the latest version of Taskwarrior with our extensions for WingTask.

```bash
RUN cd /tmp && \
    git clone --depth 1 --branch wingtask-v3.4.2 https://github.com/timcase/taskwarrior.git && \
    cd taskwarrior && \
    cmake -S . -B build -DCMAKE_BUILD_TYPE=Release && \
    cmake --build build && \
    cmake --install build && \
    cd / && \
    rm -rf /tmp/taskwarrior

```

## Changelog

2025-12-16 Added a new read-only parse command that allows parsing a task without modifying it, this allows
           WingTask users to use taskwarrior syntax for creating tasks.
           Commits: 2c8231db2, c714e6dd1
