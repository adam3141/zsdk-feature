# Zephyr SDK Feature (zsdk)
Feature to get the SDK, toolchain and host tools from the Zephyr sdk-ng repository

## Example Usage

```json
"features": {
    "xxxxxx/zsdk:0": {
        "version": "latest"
    }
}
```

## Options
| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| sdk-version | Please select the version of the SDK to get | string | v0.16.8 |
| host-tools | Select to install host tools inside the container | boolean | false |
| toolchains | Please enter a comma separated list of toolchains | string | arm-zephyr-eabi, x86_64-zephyr-elf |
