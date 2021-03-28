# Assignment 4 - Shading

Michael McQuade  
2046739

## Compiling from the command line

You may run the application by compiling it and running the executable.

This project was tested on Mac OS Big Sur 11.2 (20D64) and compiled successfully with the following:

- g++ using Apple clang version 12.0.0 (clang-1200.0.32.29)
- GNU Make 3.81.
- C++20

In order to run the project, you must compile it first by navigating to the project directory and running:

```bash
make
```

This will generate a number of files inside of the `out` directory, as in the VS Code method above.

## Running the compiled program

After compiling successfully, execute the following to run the application:

```bash
./out/hw
```

Nothing will be written to standard out. It's important that you run the command from the `HW4` directory, as that is where the input file is located.

## Running with Visual Studio Code

Alternatively to using Make, you can run it with VS Code. Since I used Visual Studio Code to develop this assignment, I've generated and modified a [tasks.json](.vscode/tasks.json) file and a [launch.json](.vscode/launch.json) file. These files enable running the project by opening [main.cpp](src/main.cpp) and pressing <kbd>ctrl</kbd> + <kbd>F5</kbd> or going to `Run` and choosing `Run without debugging`.

When you run this way, object files with the extension `.o` will be generated in an `out` directory. This folder and these files are not under source control, so you must create the out directory first.

**IMPORTANT**: For this to work, you must have opened the `HW4` workspace in VS Code. You can do this from the command line by running `code .` from within the `HW4` directory or you can choose `File` > `Open Workspace` and choose the [workspace.code-workspace](workspace.code-workspace) file.
