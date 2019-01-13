![Minimum Version](https://img.shields.io/badge/Requires-R2016b%20%28v8.4%29-orange.svg) [![MATLAB FEX](https://img.shields.io/badge/MATLAB%20FEX-uiget-brightgreen.svg)](https://www.mathworks.com/matlabcentral/fileexchange/68307-uiget)

# UIGET

![basewindow](https://github.com/StackOverflowMATLABchat/uiget/blob/master/.doc/basewindow.PNG)

`uiget` opens a dialog box that allows the user to select folder(s) and/or file(s) in a single UI. This is designed as a generic alternative to MATLAB's more specific UI selection tools: [`uigetdir`](https://www.mathworks.com/help/matlab/ref/uigetdir.html) and [`uigetfile`](https://www.mathworks.com/help/matlab/ref/uigetfile.html)

This tool utilizes MATLAB's [`string`](https://www.mathworks.com/help/matlab/ref/string.html) objects, introduced in R2016b.

This utility was inspired by: [Making a dialog where the user can choose either a file or a folder](https://stackoverflow.com/questions/51440968/making-a-dialog-where-the-user-can-choose-either-a-file-or-a-folder), a Q&A posted by SO user [Dev-iL](https://stackoverflow.com/users/3372061/dev-il) on 2018-07-20

## Syntax

`file = uiget()`

`[file, path] = uiget()`

`___ = uiget(basepath)`

`___ = uiget(basepath, Name, Value)`


## Description

`file = uiget()` opens a modal dialog box that lists files and folders in the current folder. It enables a user to select or enter the name of a file. `uiget` returns the file name when the user clicks **Open**. If the user clicks **Cancel** or the window close button (X), uigetfile returns `""`.

**NOTE:** If the user intends to choose a directory, they must specify a second output argument to `uiget`. If a directory is chosen in the single-output case, an empty string is returned and the user is presented with a warning. This is true for both a single selection and when using `'MultiSelect'`.

`[file, path] = uiget()` returns the file name and path to a file or folder when the user clicks **Open**. If the user clicks **Cancel** or the window close button (X), then `uiget` returns `""` for both output arguments.

`___ = uiget(basepath)` specifies the start path in which the dialog box opens. If path is empty or is not a valid path, then the dialog box opens in the current working directory.

`___ = uiget(basepath, Name, Value)` specifies dialog box parameters using one or more `Name, Value` pair arguments. See below for a list of valid `Name, Value` pairs.

## Examples

### Select a single file

```
>> file = uiget()

file = 

    "uiget.m"
```

Selecting a directory with a single output provides the behavior described above:
```
>> file = uiget();
Warning: One or more paths have been selected without requesting the path output.
Please specify a second output to uiget to receive these paths. 
```

### Select a File and Display Full File Specification

```
function runtest()
[file, path] = uiget();
fprintf('User Selected: %s\n', fullfile(path, file))
end

>> runtest
User Selected: C:\uiget\uiget.m
```

### Set a Custom Dialog Title

```
>> [file, path] = uiget(pwd, 'Title', 'Please Select 42 Files')
```

![42files](https://github.com/StackOverflowMATLABchat/uiget/blob/master/.doc/42files.PNG)

### Specify Filters and Filter Descriptions

```
function runtest()
filterspec = {'*.m;*.mlx;*.fig;*.mat;*.slx;*.mdl', 'MATLAB Files (*.m,*.mlx,*.fig,*.mat,*.slx,*.mdl)';
              '*.m;*.mlx','Code files (*.m,*.mlx)'; ...
              '*.fig','Figures (*.fig)'; ...
              '*.mat','MAT-files (*.mat)'; ...
              '*.mdl;*.slx','Models (*.slx, *.mdl)' ...
              };
[file, path] = uiget(pwd, 'ExtensionFilter', filterspec);
fprintf('User Selected: %s\n', fullfile(path, file))
end

>> runtest
User Selected: C:\uiget\uiget.m
```

![ExtensionFilter](https://github.com/StackOverflowMATLABchat/uiget/blob/master/.doc/extensionfilter.PNG)

## Name, Value Pairs

| Parameter | Description | Type | Default Value |
| :--:      | :--:        | :--: | :--:          |
| `'MultiSelect'` | Specify whether a user can select multiple files or folders | `logical` | `false` |
| `'ScalarPathOutput'` | Specify whether a scalar path is output when using `'MultiSelect'` | `logical` | `false` |
| `'Title'` | Specify a custom dialog title | `char` vector, `string` scalar | `'Select File or Folder'` |
| `'ExtensionFilter'` | Specify a custom file extension filter | `{n x 2}` `cell` array of text, where each row is `{extension(s), description}`<sup>1, 2</sup> | All Files |
| `'ForceCharOutput'` | Force return of a cell array of `char` | `logical` | `false` |

1. Extension filter syntax follows that of [uigetfile](https://www.mathworks.com/help/matlab/ref/uigetfile.html), see [the documentation](https://www.mathworks.com/help/matlab/ref/uigetfile.html#mw_d51d3e26-4b0d-4017-a1ed-28162572b6bc) for additional details and examples.

2. The "All Files" file filter is already provided by the dialog window, so explicitly specifying it will create an additional entry.