function KillExcelPID

% ÿʹ��һ��xlsread xlswrite������matlab�����ں�̨��һ��excel�Ľ���
% ���ʹ��xlsread xlswrite����Ҫ�Ѻ�̨��excel����kill����������ܻᵼ��matlab����xlsread xlswrite����
[~, computer] = system('hostname');
[~, user] = system('whoami');
[~, alltask] = system(['tasklist /S ', computer, ' /U ', user]);
excelPID = regexp(alltask, 'EXCEL.EXE\s*(\d+)\s', 'tokens');
for i = 1 : length(excelPID)
      killPID = cell2mat(excelPID{i});      system(['taskkill /f /pid ', killPID]);
end