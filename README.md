# Plagiarism-Detector-3000

## Background

Plagiarism has become an increasing problem in today's society with easy access to information. Plagiarism checkers have historically analysed literals to find similarities. The problem with code plagiarism is that you can easily avoid this by changing variable names or adding redundant characters that will not change the code's function. Plagiarism checkers developed for code has tried solving this by instead comparing the compiled code, which should be the same if only the variable names were changed. The problem with this is that you can reorder lines or add dummy code to create a very different compiled output, but that still performs the same task.

My plagiarism checker built for MATLAB has tried another solution. It works by comparing the outputs from programs, which will not be affected by reordering or renaming. There are however some techniques that can still be used to surpass this program, see [Further development](#Further-development)


## Instructions

Download the file [plagiarism-detector-3000.m](https://github.com/Robert-Mellberg/Plagiarism-Detector-3000/blob/main/plagiarism_detector_3000.m) and open the file in MATLAB. Change the variable **filePath** to the folder where your files are stored, all files in any subfolder will be executed. You can also change the **limit** variable to regulate how many similar files per file you want to display. You can then run the program and for every file it will print out similarity scores for the **limit** most similar files. The similarity score will be between 0-100 and a higher value implies a higher similarity

## How the detector works

When running a script MATLAB will generate a workspace where all your variables are stored. All variables used in the main script will be stored in this workspace, however variables used in functions will only be stored in a local workspace. The plagiarism-detector-3000 will run a MATLAB file and then store its workspace in a cell array. After having run all the files it will compare their workspaces to find similarities, it does this by comparing any subset of two workspaces with each other. For each variable in the workspace that is a numeric, string or chararray in singular, vector or matrix format will be compared. If such a variable is found in the workspace being compared it will result in a hit, the similarity score is then calculated by **Similiarity score = Hits / Total**. The **limit** files with the highest similarity scores will then be presented.

## Performance

Since there will be a lot of programs executed and each one compared with one another, it is probably interesting to reason about the execution time. If there are N programs (and N workspaces) and K variables in each workspace, then there will be N files executions, N^2 workspace comparisons, K^2 variable comparisons for each workspace comparison and N^2\*K^2 variable comparisons total. This will result in a execution time of T = A\*N+B\*N^2\*K^2, where A and B are two constants.

A time measurement with 365 programs showed that the file executions took 300 seconds while the comparisons took 30 seconds, which implies that the linear term will dominate for reasonable amount of programs. It will take 3650 programs before the nonlinear term will dominate. This of course is dependent on the complexity of the files and the size of their workspaces.

## Further development

There are still many improvements that can be made to the program. One weakness of the program is that it values all hits the same, it would be reasonable to assume that a variable with value 0 found in two programs should have less impact on the similarity score than a variable of an identical 100x100 matrix found in two programs. By letting the matrix have a bigger impact on the similarity score it would more easily bring out those suspicious cases. Another weakness is that the user can clear the workspace before exiting the program, which will lead to the detector not having anything to compare. A simple solution to this would be to let the detector remove any clear, clearvars etc before executing the programs. It can very rarely lead to problems with the execution if that program is reusing variable names between clears, but that effect can probably be neglected.

There are however some problems that will be harder to fix with this solution. One problem is that usually you can change some variable in some small way and produce a different (but still correct) result, for example halve the step size. Halving the step size will usually lead to a twice as big vector with more accurate values, which will become significantly harder to notice. Another problem is that the coder can put all code in a function which will make the workspace unavailable to the detector, however that act is suspicious by itself and you can solve it by flagging that the workspace is empty and that the code needs manual inspection for plagiarism. There is still the problem that users can copy functions without being detected, this problem is harder to solve and would probably include having to alter the code at the end of every function to document the function's workspace.

## License

The program is distributed under a [Creative Commons license](https://github.com/Robert-Mellberg/Plagiarism-Detector-3000/blob/main/LICENSE), meaning that anyone can modify and distribute the program

## Contact information
Robert Mellberg

robmel@kth.se
