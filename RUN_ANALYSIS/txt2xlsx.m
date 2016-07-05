function txt2xlsx( txtPath )
%Asks user for .txt file, creates .xlsx version in mainOutFolder dir
%   Take in directory location of .txt file as argument

global mainOutFolder

arr = importdata(txtPath);

fprintf('\nConverting .txt to .xlsx...')

excelName = 'pOffsetData.xlsx';

cd(mainOutFolder)
if ~exist('pOffsetData','dir')
    mkdir('pOffsetData')
end
cd('pOffsetData')

% this will only write laser and position data. Only for 2D.

xlswrite(excelName,arr.textdata,1,'A1');
xlswrite(excelName,arr.data,1,'D1');
%xlswrite(excelName,arr.textdata(:,1),1,'A1');
%xlswrite(excelName,arr.data,1,'B1');

end