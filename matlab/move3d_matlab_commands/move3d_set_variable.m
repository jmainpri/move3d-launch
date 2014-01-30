function move3d_set_variable( file, variable, new_value)

% Example from stackoverflow.com
% to replace a line a file with when starting by the patern aaa=
% sed "s/aaa=.*/aaa=xxx/g"

str = [ [' '] [''''] ['s/'] [variable] ['='] ['.*'] ['/'] [variable] ['='] [new_value] ['/g'] [''''] [' '] [''''] [file] [''''] ];
str = strcat( 'sed -i ', str );
system( str );