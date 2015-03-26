local_path = [pwd '\Magnetar_Unified'];
addpath(local_path);

% source input through the config.txt file
Params = eqn_paramLoader('config.txt');

satName = {'A', 'B', 'C'};

for satIndex = 1:3
    
    outpath = ['G:\PROCESSED\SWARM\VFM\Pc3\Swarm-', satName{satIndex}, '\'];

    Pc_class = 'Pc3';
    Missions = {'SWARM'; []; []; []};
    Satellites = {satName{satIndex}; []; []; []};
    Filetype = {'MAG_LR'; []; []; []};
    Field_choice = {'B_VFM'; []; []; []};
    Component = [7;7;7;7];
    Latitude = [-90, 90];

    date_vec = (datenum(2014, 5, 15) : 1 : datenum(2014, 11, 15))';

    for i = 1:length(date_vec)

        ti = date_vec(i); 

        Full_date = {num2str(year(ti),'%04d'), num2str(year(ti),'%04d');
                     num2str(month(ti),'%02d'), num2str(month(ti),'%02d');
                     num2str(day(ti),'%02d'), num2str(day(ti),'%02d');
                     '00:00:00', '23:59:59'};

        Magnetar = eqn_MagnetarUnifiedProcess(Missions, Satellites, ...
                Filetype, Field_choice, Component, Full_date, Pc_class, Latitude, Params);

        if exist('Magnetar', 'var');
            w = whos('Magnetar');
            s = w.bytes;

        % An "empty" Magnetar may have size > 1 kB, but it can be
        % recognized by the fact that the 'R' variable inside will have only
        % two columns and not 5 as is normally the case!
        if (s > 1000) && (size(Magnetar.R{1}, 2) == 5)
                t = Magnetar.R{1}(:,end);
                xGEO = Magnetar.R{1}(:, 2:4);
                MLT = eqn_coordinateTransform(t, xGEO, 'xGEO', 'MLT');
                Magnetar.MLT{1} = [MLT, t];
                save([outpath, 'SWARM-', satName{satIndex}, '_B-Total_Pc3_', datestr(ti, 'yyyy-mm-dd'),...
                    '.mat'], 'Magnetar');
            end

            clear 'Magnetar';
        end

    end
end

%%

outpath = 'G:\PROCESSED\SWARM\VFM\Swarm-AC Tracks 90MagLat\';

Pc_class = 'Pc34';
Missions = {'SWARM'; 'SWARM'; []; []};
Satellites = {'A'; 'C'; []; []};
Filetype = {'MAG_LR'; 'MAG_LR'; []; []};
Field_choice = {'B_VFM'; 'B_VFM'; []; []};
Component = [7;7;7;7];
Latitude = [-90, 90];

date_vec = (datenum(2014, 5, 15) : 1 : datenum(2014, 6, 14))';

for i = 1:length(date_vec)
    
    ti = date_vec(i); 
    
    % create "outpath\daystring\" folder
    dayString = datestr(ti, 'yyyy_mm_dd');
    if ~exist([outpath, dayString, '\'], 'dir')
        mkdir(outpath, dayString);
    end
    
    Full_date = {num2str(year(ti),'%04d'), num2str(year(ti),'%04d');
                 num2str(month(ti),'%02d'), num2str(month(ti),'%02d');
                 num2str(day(ti),'%02d'), num2str(day(ti),'%02d');
                 '00:00:00', '23:59:59'};
    
    Magnetar = eqn_MagnetarUnifiedProcess(Missions, Satellites, ...
            Filetype, Field_choice, Component, Full_date, Pc_class, Latitude, Params);
        
    h = signal_Plotter_44(Magnetar);
    
    c = get(h.trackbytrack_button, 'callback');
    q = c{1}; % function handle for TrackByTrack button
    q([],[],h); % change plotter to Track By Track mode
    
    c = get(h.save_alltracks_button, 'callback');
    q = c{1}; % function handle for SaveAllTracks button
    q([], [], h, [outpath, dayString, '\']);
    
    close(h.fig);
end

%%

outpath = 'G:\PROCESSED\SWARM\VFM\Swarm-B Tracks 90MagLat\';

Pc_class = 'Pc34';
Missions = {'SWARM'; []; []; []};
Satellites = {'B'; []; []; []};
Filetype = {'MAG_LR'; []; []; []};
Field_choice = {'B_VFM'; []; []; []};
Component = [7;7;7;7];
Latitude = [-90, 90];

date_vec = (datenum(2014, 9, 3) : 1 : datenum(2014, 11, 15))';

for i = 1:length(date_vec)
    
    ti = date_vec(i); 
    
    % create "outpath\daystring\" folder
    dayString = datestr(ti, 'yyyy_mm_dd');
    if ~exist([outpath, dayString, '\'], 'dir')
        mkdir(outpath, dayString);
    end
    
    Full_date = {num2str(year(ti),'%04d'), num2str(year(ti),'%04d');
                 num2str(month(ti),'%02d'), num2str(month(ti),'%02d');
                 num2str(day(ti),'%02d'), num2str(day(ti),'%02d');
                 '00:00:00', '23:59:59'};
    
    Magnetar = eqn_MagnetarUnifiedProcess(Missions, Satellites, ...
            Filetype, Field_choice, Component, Full_date, Pc_class, Latitude, Params);
        
    h = signal_Plotter_44(Magnetar);
    
    c = get(h.trackbytrack_button, 'callback');
    q = c{1}; % function handle for TrackByTrack button
    q([],[],h); % change plotter to Track By Track mode
    
    c = get(h.save_alltracks_button, 'callback');
    q = c{1}; % function handle for SaveAllTracks button
    q([], [], h, [outpath, dayString, '\']);
    
    close(h.fig);
end