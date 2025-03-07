clc;clear variables;close all

filename = "22x8-PERF.PE0";
fid = fopen(filename, 'r');% fid is a variable that is assigned to a text 
                           %file opened in read mode (same case for write,
                           %only 'r' is replaced with 'w')

tline = fgetl(fid);% fgetl is MATLAB function to pick a line from file id 
                   %(fid). Calling it again will fetch the next line

line_skip_counter = 0;
prop_data_found = false;

% initializing arrays to store data w.r.t rpm
station_in_mat = nan(1,1);
chord_in_mat = nan(1,1);
Pitch_quoted_mat = nan(1,1);
Pitch_le_te_mat = nan(1,1);
Pitch_prather_mat = nan(1,1);
sweep_in_mat = nan(1,1);
thickness_ratio_mat = nan(1,1);
twist_deg_mat = nan(1,1);
max_thick_in_mat = nan(1,1);
cross_section_in2_mat = nan(1,1);
zhigh_in_mat = nan(1,1);
cg_y_mat = nan(1,1);
cg_z_mat = nan(1,1);


row_counter = 0;

while ischar(tline) 
    if tline(26:1) == "STATION"
        prop_data_found = true
        tline = fgetl(fid)
        continue
    end
    if prop_data_found
        line_skip_counter = line_skip_counter + 1
    end
    
    if line_skip_counter >= 3
        split_data = split(tline)     % splits the line w.r.t spaces
        if length(split_data) < 3
            row_counter = 0;
            line_skip_counter = 0;
            prop_data_found = false;
            tline = fgetl(fid);
            continue
        end
        row_counter = row_counter + 1;

        station_in = str2double(split_data(2));
        chord_in = str2double(split_data(3));
        Pitch_quoted = str2double(split_data(4));
        Pitch_le_te = str2double(split_data(5));
        Pitch_prather = str2double(split_data(6));
        sweep_in = str2double(split_data(7));
        thickness_ratio = str2double(split_data(8));
        twist_deg = str2double(split_data(9));
        max_thick_in = str2double(split_data(10));
        cross_section_in2 = str2double(split_data(11));
        zhigh_in = str2double(split_data(12));
        cg_y = str2double(split_data(13));
        cg_z = str2double(split_data(14));

             
        station_in_mat(row_counter, 1) = station_in;
        chord_in_mat(row_counter, 1) = chord_in;
        Pitch_quoted_mat(row_counter, 1) = Pitch_quoted;
        Pitch_le_te_mat(row_counter, 1) = Pitch_le_te;
        Pitch_prather_mat(row_counter, 1) = Pitch_prather;
        sweep_in_mat(row_counter, 1) = sweep_in;
        thickness_ratio_mat(row_counter, 1) = thickness_ratio;
        twist_deg_mat(row_counter, 1) = twist_deg;
        max_thick_in_mat(row_counter, 1) = max_thick_in;
        cross_section_in2_mat(row_counter, 1) = cross_section_in2;
        zhigh_in_mat(row_counter, 1) = zhigh_in;
        cg_y_mat(row_counter, 1) = cg_y;
        cg_z_mat(row_counter, 1) = cg_z;
    end
    tline = fgetl(fid);
end
fclose(fid);            % closes the file
