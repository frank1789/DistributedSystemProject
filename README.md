[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

# Distributed Multirobot Exploration and Mapping

project for final exam

## Installing

Depending on the machine you are using:
- Windows
- Mac
- Linux

First delete files with extensions \*.mex*architecturename*, for example, for Mac the file will have extension: ***.mexmaci64**
You now have to compile the **sens\_model\_.c** file for the specific architecture in the matlab terminal.

```matlab
>> mex -v sens_model_noise sens_model_noise.c
```

Now you can run the script.
If you encounter problems in compiling using the mex command, update Matlab to the latest available release or refer to the [official site](https://mathworks.com/).

## Run
To launch the script, open the *Start.m* file

## Authors
- Argentieri Francesco
- Mazzaglia Giacomo
