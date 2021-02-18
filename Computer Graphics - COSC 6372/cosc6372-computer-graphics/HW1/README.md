# Assignment 1

Michael McQuade  
2046739

## Running with Visual Studio Code

Since I used Visual Studio Code to develop this assignment, I've generated and modified a [tasks.json](.vscode/tasks.json) file and a [launch.json](.vscode/launch.json) file. These files enable running the project by opening [main.cpp](src/main.cpp) and pressing <kbd>ctrl</kbd> + <kbd>F5</kbd> or going to `Run` and choosing `Run without debugging`.

When you run this way, object files with the extension `.o` will be generated in an `out` directory. This folder and these files are not under source control.

## Running from the command line

Alternatively to VS Code, you may run the application by compiling it and running the executable.

This project was tested on Mac OS Big Sur 11.2 (20D64) and compiled successfully with the following:

- g++ using Apple clang version 12.0.0 (clang-1200.0.32.29)
- GNU Make 3.81.
- C++17

To run the project, compile it first by navigating to the project directory and running:

```bash
make
```

This will generate a number of files inside of the `out` directory, as in the VS Code method above.

Execute the following to run the application:

```bash
./out/hw
```

Nothing will be written to standard out. Instead, two files will be generated: `NoDepthBuf.bmp` and `WithDepthBuf.bmp`.
