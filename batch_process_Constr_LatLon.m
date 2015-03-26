local_path = [pwd '\Magnetar_Unified'];
addpath(local_path);

% source input through the config.txt file
Params = eqn_paramLoader('config.txt');

%%

outpath = 'C:\Users\User\Desktop\TFA plots constrained coords\ASM\SWARM AC\';

Pc_class = 'Pc34';
Missions = {'SWARM'; 'SWARM'; []; []};
Satellites = {'A'; 'C'; []; []};
Filetype = {'MAG_LR'; 'MAG_LR'; 'MAG_LR'; []};
Field_choice = {'F'; 'F'; 'F'; []};
Component = [4;4;4;4];
Latitude = [-35, -5];

date_vec = (datenum(2014, 3, 21) : 1 : datenum(2014, 3, 21))';

%for i = 1:length(date_vec)
    
    %ti = date_vec(i); 
    
%     create "outpath\daystring\" folder
%     dayString = datestr(ti, 'yyyy_mm_dd');
%     if ~exist([outpath, dayString, '\'], 'dir')
%         mkdir(outpath, dayString);
%     end
    
%     Full_date = {num2str(year(ti),'%04d'), num2str(year(ti),'%04d');
%                  num2str(month(ti),'%02d'), num2str(month(ti),'%02d');
%                  num2str(day(ti),'%02d'), num2str(day(ti),'%02d');
%                  '00:00:00', '23:59:59'};

    Full_date = {'2014', '2014';
                 '03', '04';
                 '18', '05';
                 '00:00:00', '23:59:59'};

    Magnetar = eqn_MagnetarUnifiedProcess(Missions, Satellites, ...
            Filetype, Field_choice, Component, Full_date, Pc_class, Latitude, Params);
    
    nColumns = sum(~cellfun(@isempty,Satellites));
    
    no_of_tracks = size(Magnetar.Bind{1,1}, 1);
    for j=2:nColumns
        if size(Magnetar.Bind{j,1}, 1) > no_of_tracks
            Magnetar.Bind{j}(end, :) = [];
            Magnetar.Rind{j}(end, :) = [];
            Magnetar.dind{j}(end, :) = [];
        elseif size(Magnetar.Bind{j,1}, 1) < no_of_tracks
            Magnetar.Bind{1}(end, :) = [];
            Magnetar.Rind{1}(end, :) = [];
            Magnetar.dind{1}(end, :) = [];
            no_of_tracks = no_of_tracks - 1;
        else
            % equal => no problem
        end
    end
    indsOfTracksToDelete = zeros(no_of_tracks, 1);
    
    for j=1:no_of_tracks
        inds = Magnetar.Rind{1}(j,:);
        xGEO = Magnetar.R{1}(inds(1):inds(2), 2:4);
        tGEO = Magnetar.R{1}(inds(1):inds(2), end);
        rGEO = eqn_coordinateTransform(tGEO, xGEO, 'xGEO', 'rGEO');
        medianLon = median(rGEO(:,2));
        
        if isempty(medianLon) && isnan(medianLon)
            indsOfTracksToDelete(j) =  1;
        else
            if medianLon < 275 || medianLon > 305
                indsOfTracksToDelete(j) =  1;
            else
                
            end
        end
    end
    
    if length(find(indsOfTracksToDelete)) < no_of_tracks
        for j=1:nColumns
            Magnetar.Bind{j}(find(indsOfTracksToDelete), :) = [];
            Magnetar.Rind{j}(find(indsOfTracksToDelete), :) = [];
            Magnetar.dind{j}(find(indsOfTracksToDelete), :) = [];
        end
        
       h = signal_Plotter_44(Magnetar);

        c = get(h.trackbytrack_button, 'callback');
        q = c{1}; % function handle for TrackByTrack button
        q([],[],h); % change plotter to Track By Track mode

        c = get(h.save_alltracks_button, 'callback');
        q = c{1}; % function handle for SaveAllTracks button
        q([], [], h, [outpath]);

        close(h.fig);
        
    else
        disp('No tracks within the requested parameters detected!');
    end
    
%end
