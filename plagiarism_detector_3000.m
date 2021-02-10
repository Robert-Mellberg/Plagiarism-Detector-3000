%Author: Robert Mellberg

%This program runs list of matlab files specified by the user and compare
%their outputs to find plagiarizations. For each file it will report
%similarity scores (hitrates) between 0-100 that specifies the similarities.
%A higher score means that the files are more similar. The only variables
%that should be modified are filePath and limit


%Filepath is the absolute path to where the folder with the files are
%located. The files can be located in any subfolder to Filepath
filePath = "C:\filepath";
%Limit gives the limit to how many similar files per examined file should be
%printed. The files with the highest similarities will be printed
limit = 2;

filePaths = getFilePaths(filePath);
filePaths = filePaths(~contains(filePaths, mfilename));
workSpaces = {};
results = {};

%This vector keeps a list of strings (absolute paths) of the files that
%reported an exception when being run
programsWithError = string.empty;

tic;
h = waitbar(0,'Running the programs');
for i = 1:length(filePaths)
    currWorkSpace = getWorkSpace(filePaths(i));
    if isnumeric(currWorkSpace)
       programsWithError(end+1) = filePaths(i);
       continue; 
    end
    workSpaces{end+1, 1} = currWorkSpace;
    workSpaces{end, 2} = filePaths(i);
    waitbar(i/length(filePaths))
end
close(h)
t1 = toc;
tic;
h = waitbar(0,'Comparing outputs');
for i = 1:size(workSpaces, 1)
    currWorkSpace = workSpaces{i, 1};
    comparisons = {};
    for j = 1:size(workSpaces, 1)
       if i == j
          continue;
       end
       compWorkSpace = workSpaces{j, 1};
       hitrate = getHitrate(currWorkSpace, compWorkSpace);
       comparisons{end+1, 1} = hitrate*100;
       comparisons{end, 2} = workSpaces{j, 2};
    end
    comparisons = sortrows(comparisons, -1);
    results{end+1,1} = workSpaces{i, 2};
    results{end,2} = comparisons;

    waitbar(i/size(workSpaces, 1))
end
close(h)
t2 = toc;
clc;
for i = 1:size(results, 1)
    fprintf("File: %s\n\n", results{i,1});
    comparisons = results{i, 2};
    for j = 1:min(size(comparisons, 1), limit)
       fprintf("Hitrate: %f similar file: %s\n", comparisons{j, 1}, comparisons{j, 2}) 
    end
    fprintf("\n")
end


function hitrate = getHitrate(currWorkSpace, compWorkSpace)
       total = 0;
       hit = 0;
       
       for x = 1:length(currWorkSpace)
          varCurrWorkSpace = currWorkSpace{x};
          if(isComparable(varCurrWorkSpace))
              total = total + 1;
              for y = 1:length(compWorkSpace)
                 if(isComparable(compWorkSpace{y}) && strcmp(class(varCurrWorkSpace),class(compWorkSpace{y})) && all(size(varCurrWorkSpace) == size(compWorkSpace{y})) && all(varCurrWorkSpace == compWorkSpace{y}, [1, 2]))
                    hit = hit+1;
                    break;
                 end
              end
          end
       end
       hitrate = hit/max(1, total);
end

function workSpace = getWorkSpace(filePath)
    try
        run(filePath);
        vars = who;
        vars(ismember(vars,'filePath')) = [];
        workSpace = {};
        for i = 1:length(vars)
            content = eval(vars{i});
            workSpace{end+1} = content;
        end
    catch e
        workSpace = -1;
    end
end


function filePaths = getFilePaths(folder)
    files = dir(folder);
    files = {files.name};
    filePaths = [];
    
    for i = 3:length(files)
        file = files{i};
        if length(file) >= 2 && file(end-1:end) == ".m"
           filePaths = [filePaths folder + "\" + convertCharsToStrings(file)];
        else
           newFilePaths = getFilePaths(folder + '\' + file);
           filePaths = [filePaths newFilePaths];
        end
    end
end

function res = isComparable(var)
    res = isnumeric(var) || isstring(var) || ischar(var);
end
