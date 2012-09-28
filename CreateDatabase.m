clear all
clc
close all
character_names = {'zero','one','two','three','four'};
characters = ['0','1','2','3','4']; % the characters that will be added to the database
numberOfExamples = 20; % the number of times each character is introduced into the database
for i = 2 : size(characters,2)
    c = cell(numberOfExamples,1);
    for j = 1 : numberOfExamples
        string = sprintf('Draw the %d-th %s',j,characters(i));
        disp(string);
        c{j} = DrawCharacter; % add the character to its proper cell
    end
    filename = character_names{i};
    save(filename,'c');
end


