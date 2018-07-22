![Minimum Version](https://img.shields.io/badge/Requires-R2016b%20%28v8.4%29-orange.svg)

# UIGET

`uiget` opens a dialog box that allows the user to select folder(s) and/or file(s) in a single UI. This is designed as a generic alternative to MATLAB's more specific UI selection tools: [`uigetdir`](https://www.mathworks.com/help/matlab/ref/uigetdir.html) and [`uigetfile`](https://www.mathworks.com/help/matlab/ref/uigetfile.html)

This tool utilizes MATLAB's [`string`](https://www.mathworks.com/help/matlab/ref/string.html) objects, introduced in R2016b.

This utility was inspired by: [Making a dialog where the user can choose either a file or a folder](https://stackoverflow.com/questions/51440968/making-a-dialog-where-the-user-can-choose-either-a-file-or-a-folder), a Q&A posted by SO user [Dev-iL](https://stackoverflow.com/users/3372061/dev-il) on 2018-07-20

## Syntax

`file = uiget`

`[file, path] = uiget`

`___ = uiget(basepath)`


## Examples


## Name, Value Pairs
| Parameter | Description | Type | Default Value |
| :--:      | :--:        | :--: | :--:          |
| `'MultiSelect'` | Specify whether a user can select multiple files or folders | `logical` | false |