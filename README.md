# Android CI
### Continous Integration (CI) for Android apps with an emulator
By using snapshots, the emulator in this image is able to boot in under 15 seconds. This Docker image contains the Android SDK, emulator packages and an AVD with a snapshot.

# Image
```yml
image: yorickvanzweeden/android-ci:latest
```

Specifications
* Build-tools: 28.0.2
* Platform: 24
* System-image: android-24;google_apis;x86_64

# Sample GitLab usage
*.gitlab-ci.yml*

```yml
image: yorickvanzweeden/android-ci:latest

before_script:
    - export GRADLE_USER_HOME=`pwd`/.gradle
    - chmod +x ./gradlew

cache:
  key: "$CI_COMMIT_REF_NAME"
  paths:
     - .gradle/

stages:
  - build
  - test_instrumented

build:
  stage: build
  script:
     - ./gradlew assembleDebug
  artifacts:
    expire_in: 1 week
    paths:
      - app/build/outputs/apk/

instrumentedTests:
  stage: test_instrumented
  only:
    - scheduled
  script:
    # Running emulator
    - /sdk/emulator/emulator -avd ${AVD_NAME} -no-window -no-audio -snapshot ${SNAPSHOT_NAME} &

    # Wait for emulator
    - ./android-wait-for-emulator

    # Run instrumented Android tests
    - /sdk/platform-tools/adb shell input keyevent 82
    - ./gradlew cAT
```


# How it works
In order to have an emulator running in a Docker container, the Docker container must run with a `privileged` flag. This flag is required for KVM (Linux kernel virtualization). Docker build does not contain a `privileged` flag and therefore docker-compose is used with a bash script. The bash script is allowed to run in privileged mode and start the emulator. In order to save a snapshot, an expect script is fired that sets up a telnet connection. In Gitlab/other CI tools, the emulator may start from the snapshot instead of a cold boot. This reduces the startup time of the emulator to about 15 seconds.

If you want to create your own image, you should adjust the `.env` file to your needs and run the `build-image.sh` script. The name of the AVD and snapshot used are stored in the variables `AVD_NAME` and `SNAPSHOT_NAME`.
