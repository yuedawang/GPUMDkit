# GPUMDkit

**GPUMDkit** is a shell interface for the GPUMD (Graphics Processing Units Molecular Dynamics) program. It provides a set of tools to streamline the use of common scripts in GPUMD and neuroevolution potential (NEP), simplifying workflows and enhancing efficiency.

## Features
- **Simplified Script Invocation**: Easily run scripts for GPUMD and NEP.
- **Workflow Automation**: Automate common tasks to save time and reduce manual intervention.
- **User-Friendly Interface**: Intuitive shell commands designed to enhance user experience.

## Installation
To install GPUMDkit, follow these steps:

1. Clone the repository or download the `gpumdkit.sh` file.
2. Set the `GPUMDtools_path` environment variable to the path of your GPUMD tools, for example:
    ```sh
    export GPUMDtools_path=/your_dir/GPUMD/tools
    ```
3. Add executable permissions to the `gpumdkit.sh` file:
    ```sh
    chmod +x gpumdkit.sh
    ```
4. Move the `gpumdkit.sh` file to a directory in your PATH, for example:
    ```sh
    mv gpumdkit.sh /usr/local/bin/
    ```

## Usage
Refer to the [Usage Instructions](./USAGE.md) for detailed examples and command options.

