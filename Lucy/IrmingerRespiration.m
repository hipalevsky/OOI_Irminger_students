
%plot(wfpmerge.time,wfpmerge.oxygen_driftcorr)
%% Filtering (smoothing) the data at each depth
NumProfilesToSmooth = 10; %set this as a variable so that you can adjust this value

%Updated this to smooth over time, which required adding the dimension "2"
%since you want to smooth over the 2nd dimension (time) rather than the 1st
%dimension (depth)
oxygen_driftcorr_smoothed = movmean(wfpmerge.oxygen_driftcorr, NumProfilesToSmooth, 2); %unsure at what interval I want to smooth oxygen data

%Example plot
figure(1); clf
    depth_id = 51; %Example plot at the 11th depth in depth_grid (which is 400 m), in depth_grid, 400m is 51st column
plot(wfpmerge.time, wfpmerge.oxygen_driftcorr(depth_id,:),'k.'); hold on;
plot(wfpmerge.time, oxygen_driftcorr_smoothed(depth_id,:),'m-'); hold on;
datetick('x',2)

%%
%Plots at every 10 depths
for i=1:10:491
    figure(i); 
    depth_id=i;
    plot(wfpmerge.time, wfpmerge.oxygen_driftcorr(depth_id,:),'k.'); hold on;
    plot(wfpmerge.time, oxygen_driftcorr_smoothed(depth_id,:),'m-'); hold on;
    datetick('x',2)
    title('i')
end
%%
%Standard deviation of each profile. I don't think I want std of each
% depth? There are 491 depths (5 m each) and 784 profiles total
% for i=1:784
%     %depth_id=i;
%     std_driftcorr_smoothed(i)=nanstd(oxygen_driftcorr_smoothed(i));
% end

%%
%just kidding I think I want std at each depth
for i=1:491
    %depth_id=i
    std_driftcorr_smoothed = nanstd(oxygen_driftcorr_smoothed, 0,2);
end

%%
%returns true for all elements more than three standard deviations from the
%mean. Along the second dimension which should calculate it along rows and
%not columns
%for i=1:491
    TF=isoutlier(oxygen_driftcorr_smoothed,'movmedian', 5, 2);
    B=filloutliers(oxygen_driftcorr_smoothed,'previous', 2);
%end
%%
for i=1:10:491
    figure(i); 
    depth_id=i;
    plot(wfpmerge.time, B(depth_id,:),'k.'); hold on;
    plot(wfpmerge.time, B(depth_id,:),'m-'); hold on;
    datetick('x',2)
    title('i')
end
%%
%Identifying 3 strat seasons and pulling out dates for each season
location = find(wfpmerge.time <= datenum(datetime(2015,10,15)) & wfpmerge.time >= datenum(datetime(2015,3,15)));
oxygen_strat_season_1 = B(:,location);
    strat_season_1 = wfpmerge.time(location);
    
location = find(wfpmerge.time <= datenum(datetime(2016,10,15)) & wfpmerge.time >= datenum(datetime(2016,3,15)));
oxygen_strat_season_2 = B(:,location);
    strat_season_2 = wfpmerge.time(location);
    
location = find(wfpmerge.time <= datenum(datetime(2017,10,15)) & wfpmerge.time >= datenum(datetime(2017,3,15)));
oxygen_strat_season_3 = B(:,location);
strat_season_3 = wfpmerge.time(location);
    
%% 
%Finding max and min O2 at each depth
  for j = 1: length(wfpmerge.depth_grid)
      max_O2_season1(j) = max(oxygen_strat_season_1(j,:));
      min_O2_season1(j) = min(oxygen_strat_season_1(j,:));
  end
  
%%
  for j = 1: length(wfpmerge.depth_grid)
      max_O2_season2(j) = max(oxygen_strat_season_2(j,:));
      min_O2_season2(j) = min(oxygen_strat_season_2(j,:));
  end
  
%%
  for j = 1: length(wfpmerge.depth_grid)
      max_O2_season3(j) = max(oxygen_strat_season_3(j,:));
      min_O2_season3(j) = min(oxygen_strat_season_3(j,:));
  end
      
%%      
% wfpmerge.time_smoothed = movmean(wfpmerge.time, 50);
% plot(wfpmerge.time_smoothed, oxygen_driftcorr_smoothed, 'm-'); %having
% trouble with getting time to show up as real dates and not numbers--
% fixed that using code below

% id_maxDO= max(oxygen_driftcorr_smoothed)'; %want to find max and min DO at everydepth over stratified season --what is in each column of DO -- this function took the max and min of each column
% id_minDO= min(oxygen_driftcorr_smoothed)';
%%
% figure(1); clf;
% [X,Y] = meshgrid(wfpmerge.time, wfpmerge.depth_grid);
% contourf(X,Y,oxygen_driftcorr_smoothed,cvec,'linecolor','none'); hold on;
% axis([min(wfpmerge.time) max(wfpmerge.time) mindepth maxdepth]); caxis([cmin cmax]);
% colormap(C); set(gca,'YDir','reverse'); ylabel('Depth (m)', 'Fontsize', 10); hcb = colorbar; set(hcb,'location','eastoutside')
% datetick('x',2,'keeplimits');
% title('Oxygen concentration (mol/L)', 'Fontsize', 12)
%%
% figure(2); clf;
% [X,Y] = meshgrid(Trans_wfpmerge.time, wfpmerge.depth_grid);
% contourf(X,Y,id_maxDO-id_minDO,cvec,'linecolor','none'); hold on;
% axis([min(wfpmerge.time) max(wfpmerge.time) mindepth maxdepth]); caxis([cmin cmax]);
% colormap(C); set(gca,'YDir','reverse'); ylabel('Depth (m)', 'Fontsize', 10); hcb = colorbar; set(hcb,'location','eastoutside')
% datetick('x',2,'keeplimits');
% title('Oxygen concentration (mol/L)', 'Fontsize', 12)
% Trans_wfpmerge.time = wfpmerge.time';
figure(2);
plot (wfpmerge.time, id_maxDO-id_minDO, 'm.'); hold on; 
datetick('x',2,'keeplimits');
%plot (wfpmerge.time, id_maxDO-id_minDO);
%fitline = polyfit(wfpmerge.time, id_maxDO-id_minDO, 1);
axis([wfpmerge.time wfpmerge.time]);

%next step is to identify the strat season and then use the find function to pick out only the strat season dates (but not sure how to do this in a way that matlab recognizes)  

%strat_season1 = find(wfpmerge.time <= november 2016 & stationdata.Year >= june 2016) %figure out how to put in time that matlab recognizes
%then within this season, identify max and min O2 at each depth
        
    