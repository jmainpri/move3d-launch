function move3d_set_variable( move3d_dir, file, variable, new_value)

cd( move3d_dir );
% Example from stackoverflow.com
% to replace a line a file with when starting by the patern aaa=
% sed "s/aaa=.*/aaa=xxx/g"
str = [ [' '] [''''] ['s/'] [variable] ['='] ['.*'] ['/'] [variable] ['='] [new_value] ['/g'] [''''] [' '] [''''] [file] [''''] ];
str = strcat( 'sed -i ', str );
system( str );