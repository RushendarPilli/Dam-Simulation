
function AdvancedDamComputationalMethods
clc; close all;

%%

rho = 1000;      % kg/m^3
g   = 9.81;      % m/s^2

%% Figure
fig = figure('Name','Advanced Dam Computational Methods Simulator - Final Clean Layout', ...
    'NumberTitle','off', ...
    'Position',[30 40 1350 720], ...
    'Color','w');

set(gcf,'Color','w');

%% ========================================
% LEFT SIDE PANELS
panelColor = [0.96 0.96 0.96];

inputPanel = uipanel('Parent',fig,'Title','Inputs', ...
    'FontSize',10,'FontWeight','bold', ...
    'BackgroundColor',panelColor,'ForegroundColor','k', ...
    'Position',[0.015 0.48 0.25 0.47]);

resultPanel = uipanel('Parent',fig,'Title','Scrollable Results', ...
    'FontSize',10,'FontWeight','bold', ...
    'BackgroundColor',panelColor,'ForegroundColor','k', ...
    'Position',[0.015 0.05 0.25 0.40]);

%% Compact input controls
xLab = 0.05;
xSld = 0.05;
xVal = 0.72;

labelW = 0.62;
sliderW = 0.62;
valueW = 0.20;

hLabel = 0.055;
hSlider = 0.07;

y = 0.88;
dy = 0.125;

uicontrol('Parent',inputPanel,'Style','text','Units','normalized', ...
    'Position',[xLab y labelW hLabel], ...
    'String','1) Water Height H (m)', ...
    'HorizontalAlignment','left','ForegroundColor','k','BackgroundColor',panelColor);
heightSlider = uicontrol('Parent',inputPanel,'Style','slider','Units','normalized', ...
    'Min',5,'Max',150,'Value',60, ...
    'Position',[xSld y-0.075 sliderW hSlider],'Callback',@updateSimulation);
heightText = uicontrol('Parent',inputPanel,'Style','text','Units','normalized', ...
    'Position',[xVal y-0.075 valueW hSlider], ...
    'String','60','ForegroundColor','k','BackgroundColor','w');

y = y - dy;
uicontrol('Parent',inputPanel,'Style','text','Units','normalized', ...
    'Position',[xLab y labelW hLabel], ...
    'String','2) Dam Width W (m)', ...
    'HorizontalAlignment','left','ForegroundColor','k','BackgroundColor',panelColor);
widthSlider = uicontrol('Parent',inputPanel,'Style','slider','Units','normalized', ...
    'Min',10,'Max',300,'Value',100, ...
    'Position',[xSld y-0.075 sliderW hSlider],'Callback',@updateSimulation);
widthText = uicontrol('Parent',inputPanel,'Style','text','Units','normalized', ...
    'Position',[xVal y-0.075 valueW hSlider], ...
    'String','100','ForegroundColor','k','BackgroundColor','w');

y = y - dy;
uicontrol('Parent',inputPanel,'Style','text','Units','normalized', ...
    'Position',[xLab y labelW hLabel], ...
    'String','3) Flow Rate Q (m^3/s)', ...
    'HorizontalAlignment','left','ForegroundColor','k','BackgroundColor',panelColor);
flowSlider = uicontrol('Parent',inputPanel,'Style','slider','Units','normalized', ...
    'Min',10,'Max',2500,'Value',600, ...
    'Position',[xSld y-0.075 sliderW hSlider],'Callback',@updateSimulation);
flowText = uicontrol('Parent',inputPanel,'Style','text','Units','normalized', ...
    'Position',[xVal y-0.075 valueW hSlider], ...
    'String','600','ForegroundColor','k','BackgroundColor','w');

y = y - dy;
uicontrol('Parent',inputPanel,'Style','text','Units','normalized', ...
    'Position',[xLab y labelW hLabel], ...
    'String','4) Efficiency eta', ...
    'HorizontalAlignment','left','ForegroundColor','k','BackgroundColor',panelColor);
etaSlider = uicontrol('Parent',inputPanel,'Style','slider','Units','normalized', ...
    'Min',0.4,'Max',0.95,'Value',0.85, ...
    'Position',[xSld y-0.075 sliderW hSlider],'Callback',@updateSimulation);
etaText = uicontrol('Parent',inputPanel,'Style','text','Units','normalized', ...
    'Position',[xVal y-0.075 valueW hSlider], ...
    'String','0.85','ForegroundColor','k','BackgroundColor','w');

y = y - dy;
uicontrol('Parent',inputPanel,'Style','text','Units','normalized', ...
    'Position',[xLab y labelW hLabel], ...
    'String','5) Dam Type', ...
    'HorizontalAlignment','left','ForegroundColor','k','BackgroundColor',panelColor);
damMenu = uicontrol('Parent',inputPanel,'Style','popupmenu','Units','normalized', ...
    'String',{'Gravity Dam','Arch Dam','Buttress Dam','Earth-fill Dam'}, ...
    'Position',[xSld y-0.075 0.82 hSlider], ...
    'Callback',@updateSimulation);

y = y - dy;
uicontrol('Parent',inputPanel,'Style','text','Units','normalized', ...
    'Position',[xLab y labelW hLabel], ...
    'String','6) Numerical Points', ...
    'HorizontalAlignment','left','ForegroundColor','k','BackgroundColor',panelColor);
resolutionSlider = uicontrol('Parent',inputPanel,'Style','slider','Units','normalized', ...
    'Min',10,'Max',500,'Value',100, ...
    'Position',[xSld y-0.075 sliderW hSlider],'Callback',@updateSimulation);
resolutionText = uicontrol('Parent',inputPanel,'Style','text','Units','normalized', ...
    'Position',[xVal y-0.075 valueW hSlider], ...
    'String','100','ForegroundColor','k','BackgroundColor','w');

y = y - dy;
uicontrol('Parent',inputPanel,'Style','text','Units','normalized', ...
    'Position',[xLab y labelW hLabel], ...
    'String','7) Monte Carlo Samples', ...
    'HorizontalAlignment','left','ForegroundColor','k','BackgroundColor',panelColor);
mcSlider = uicontrol('Parent',inputPanel,'Style','slider','Units','normalized', ...
    'Min',100,'Max',5000,'Value',1000, ...
    'Position',[xSld y-0.075 sliderW hSlider],'Callback',@updateSimulation);
mcText = uicontrol('Parent',inputPanel,'Style','text','Units','normalized', ...
    'Position',[xVal y-0.075 valueW hSlider], ...
    'String','1000','ForegroundColor','k','BackgroundColor','w');

%% Scrollable result box
resultBox = uicontrol('Parent',resultPanel,'Style','listbox','Units','normalized', ...
    'Position',[0.05 0.05 0.90 0.88], ...
    'FontSize',8.5, ...
    'ForegroundColor','k', ...
    'BackgroundColor','w', ...
    'String',{'Results appear here.'}, ...
    'Value',1);

%% ===============================
% PLOT LAYOUT
axVisual      = axes('Parent',fig,'Position',[0.31 0.43 0.38 0.50]);

axForce       = axes('Parent',fig,'Position',[0.74 0.72 0.23 0.19]);
axPower       = axes('Parent',fig,'Position',[0.74 0.44 0.23 0.19]);

axDerivative  = axes('Parent',fig,'Position',[0.31 0.08 0.20 0.24]);
axMonteCarlo  = axes('Parent',fig,'Position',[0.54 0.08 0.19 0.24]);
axFDPressure  = axes('Parent',fig,'Position',[0.77 0.08 0.20 0.24]);

updateSimulation();

%% ==========
% UPDATE FUNCTION

function updateSimulation(~,~)

    H   = get(heightSlider,'Value');
    W   = get(widthSlider,'Value');
    Q   = get(flowSlider,'Value');
    eta = get(etaSlider,'Value');
    damType = get(damMenu,'Value');

    nPoints = round(get(resolutionSlider,'Value'));
    Nmc     = round(get(mcSlider,'Value'));

    set(heightText,'String',sprintf('%.1f',H));
    set(widthText,'String',sprintf('%.1f',W));
    set(flowText,'String',sprintf('%.1f',Q));
    set(etaText,'String',sprintf('%.2f',eta));
    set(resolutionText,'String',sprintf('%d',nPoints));
    set(mcText,'String',sprintf('%d',Nmc));

    %% Dam strength assumptions
    if damType == 1
        damName = 'Gravity Dam';
        Fmax = 9.0e10;
    elseif damType == 2
        damName = 'Arch Dam';
        Fmax = 1.3e11;
    elseif damType == 3
        damName = 'Buttress Dam';
        Fmax = 6.5e10;
    else
        damName = 'Earth-fill Dam';
        Fmax = 4.5e10;
    end

    %% Analytical calculations
    P_bottom = rho*g*H;
    F_analytical = 0.5*rho*g*H^2*W;
    Power = eta*rho*g*Q*H;
    SF = Fmax/F_analytical;

    %% Numerical integration
    h_vals = linspace(0,H,nPoints);
    pressure_vals = rho*g*h_vals;
    force_density = pressure_vals*W;
    F_trapz = trapz(h_vals,force_density);
    integrationError = abs(F_analytical - F_trapz)/F_analytical*100;

    %% Derivative
    dF_dH_analytical = rho*g*H*W;
    H_range = linspace(1,150,250);
    F_range = 0.5*rho*g.*H_range.^2*W;
    dF_dH_numerical = gradient(F_range,H_range);

    %% Finite difference
    dh = H/(nPoints-1);
    P_fd = zeros(1,nPoints);
    h_fd = linspace(0,H,nPoints);

    for i = 2:nPoints
        P_fd(i) = P_fd(i-1) + rho*g*dh;
    end

    P_exact = rho*g*h_fd;
    fdPressureError = max(abs(P_exact - P_fd))/max(P_exact)*100;

    %% Optimization
    H_candidates = linspace(5,150,500);
    bestH = NaN;
    bestPower = 0;

    for i = 1:length(H_candidates)
        H_test = H_candidates(i);
        F_test = 0.5*rho*g*H_test^2*W;
        SF_test = Fmax/F_test;
        Power_test = eta*rho*g*Q*H_test;

        if SF_test >= 1.5 && Power_test > bestPower
            bestPower = Power_test;
            bestH = H_test;
        end
    end

    %% Monte Carlo
    rng(1);
    H_rand = H + randn(1,Nmc)*0.05*H;
    Q_rand = Q + randn(1,Nmc)*0.08*Q;
    eta_rand = eta + randn(1,Nmc)*0.04;

    H_rand(H_rand < 1) = 1;
    Q_rand(Q_rand < 1) = 1;
    eta_rand(eta_rand < 0.1) = 0.1;
    eta_rand(eta_rand > 1.0) = 1.0;

    F_rand = 0.5*rho*g.*H_rand.^2*W;
    SF_rand = Fmax./F_rand;
    Power_rand = eta_rand.*rho.*g.*Q_rand.*H_rand;

    probabilityUnsafe = sum(SF_rand < 1)/Nmc*100;
    meanPowerMC = mean(Power_rand);
    stdPowerMC = std(Power_rand);

    %% Dimensionless validation
    Pi_force = F_analytical/(rho*g*H^2*W);

    %% Safety color
    if SF >= 2
        damColor = [0.1 0.65 0.2];
        status = 'SAFE';
    elseif SF >= 1
        damColor = [1.0 0.75 0.1];
        status = 'WARNING';
    else
        damColor = [0.9 0.1 0.1];
        status = 'UNSAFE';
    end

    %% Main visual
    axes(axVisual);
    cla(axVisual);
    styleWhiteAxis(axVisual);
    hold(axVisual,'on');

    maxH = 150;
    xlim(axVisual,[-10 125]);
    ylim(axVisual,[0 maxH+25]);
    axis(axVisual,'equal');
    grid(axVisual,'on');
    box(axVisual,'on');

    xlabel(axVisual,'Horizontal Distance','Color','k','FontWeight','bold','FontSize',9);
    ylabel(axVisual,'Height / Depth','Color','k','FontWeight','bold','FontSize',9);
    title(axVisual,['Dam Simulation: ', damName],'Color','k','FontWeight','bold','FontSize',10);

    patch(axVisual,[0 120 120 0],[0 0 -8 -8],[0.55 0.42 0.25], ...
        'EdgeColor','none');

    patch(axVisual,[0 45 45 0],[0 0 H H],[0.25 0.55 1.0], ...
        'FaceAlpha',0.55,'EdgeColor','none');

    text(axVisual,5,H+5,sprintf('Water = %.1f m',H), ...
        'FontSize',8,'FontWeight','bold','Color','b');

    if damType == 1
        damX = [45 72 58 45];
        damY = [0 0 maxH maxH];
    elseif damType == 2
        damX = [45 63 72 62 45];
        damY = [0 0 maxH*0.25 maxH maxH];
    elseif damType == 3
        damX = [45 60 60 45];
        damY = [0 0 maxH maxH];
    else
        damX = [38 88 62 45];
        damY = [0 0 maxH maxH];
    end

    patch(axVisual,damX,damY,damColor, ...
        'FaceAlpha',0.9,'EdgeColor','k','LineWidth',2);

    if damType == 3
        for yy = 20:25:125
            plot(axVisual,[60 82],[yy yy-18],'k','LineWidth',2);
        end
    end

    arrowDepths = linspace(5,H,9);
    for k = 1:length(arrowDepths)
        yArrow = arrowDepths(k);
        depthFromSurface = H - yArrow;
        arrowLength = 2 + 20*(depthFromSurface/H)^2;
        quiver(axVisual,45,yArrow,arrowLength,0,0, ...
            'Color','r','LineWidth',1.5,'MaxHeadSize',2);
    end

    text(axVisual,5,9,'Pressure increases with depth', ...
        'FontSize',8,'FontWeight','bold','Color','r');

    pipeY = 18;
    plot(axVisual,[45 95],[pipeY pipeY],'k','LineWidth',7);
    plot(axVisual,[45 95],[pipeY pipeY],'c','LineWidth',3);

    rectangle(axVisual,'Position',[92 pipeY-6 12 12], ...
        'Curvature',[1 1], ...
        'FaceColor',[0.75 0.75 0.75], ...
        'EdgeColor','k','LineWidth',1.5);

    text(axVisual,88,pipeY-13,'Turbine', ...
        'FontSize',8,'FontWeight','bold','Color','k');

    quiver(axVisual,58,pipeY,24,0,0, ...
        'Color','b','LineWidth',2.5,'MaxHeadSize',2);

    text(axVisual,68,pipeY+12,sprintf('Power = %.1f MW',Power/1e6), ...
        'FontSize',8,'FontWeight','bold','Color','b');

    text(axVisual,52,168,sprintf('SF = %.2f | %s',SF,status), ...
        'FontSize',9,'FontWeight','bold','Color',damColor);

    if ~isnan(bestH)
        text(axVisual,52,160,sprintf('Opt H = %.1f m, Max P = %.1f MW', ...
            bestH,bestPower/1e6), ...
            'FontSize',8,'FontWeight','bold','Color',[0.15 0 0.75]);
    else
        text(axVisual,52,160,'No safe height found for SF >= 1.5', ...
            'FontSize',8,'FontWeight','bold','Color','r');
    end

    hold(axVisual,'off');

    %% Force plot
    axes(axForce);
    cla(axForce);
    styleWhiteAxis(axForce);

    plot(axForce,H_range,F_range/1e9,'b','LineWidth',2.0);
    hold(axForce,'on');
    plot(axForce,H,F_analytical/1e9,'ro','MarkerSize',6,'LineWidth',2.0);
    yline(axForce,Fmax/1e9,'--','Fmax','Color',[0.35 0.35 0.35], ...
        'LabelHorizontalAlignment','right','LabelVerticalAlignment','bottom');
    hold(axForce,'off');

    xlabel(axForce,'Height H (m)','Color','k','FontWeight','bold','FontSize',8);
    ylabel(axForce,'Force (GN)','Color','k','FontWeight','bold','FontSize',8);
    title(axForce,'Force vs Height','Color','k','FontWeight','bold','FontSize',9);
    set(gca, 'XColor','k', 'YColor','k')
    grid(axForce,'on');
    box(axForce,'on');

    %% Power plot
    axes(axPower);
    cla(axPower);
    styleWhiteAxis(axPower);

    Q_range = linspace(10,2500,250);
    P_range = eta*rho*g.*Q_range*H;

    plot(axPower,Q_range,P_range/1e6,'b','LineWidth',2.0);
    hold(axPower,'on');
    plot(axPower,Q,Power/1e6,'ro','MarkerSize',6,'LineWidth',2.0);
    hold(axPower,'off');

    xlabel(axPower,'Flow Rate Q (m^3/s)','Color','k','FontWeight','bold','FontSize',8);
    ylabel(axPower,'Power (MW)','Color','k','FontWeight','bold','FontSize',8);
    title(axPower,'Power vs Flow Rate','Color','k','FontWeight','bold','FontSize',9);
    set(gca, 'XColor','k', 'YColor','k')
    grid(axPower,'on');
    box(axPower,'on');

    %% Derivative plot
    axes(axDerivative);
    cla(axDerivative);
    styleWhiteAxis(axDerivative);

    plot(axDerivative,H_range,dF_dH_numerical/1e9,'b','LineWidth',2.0);
    hold(axDerivative,'on');
    plot(axDerivative,H,dF_dH_analytical/1e9,'ro','MarkerSize',6,'LineWidth',2.0);
    hold(axDerivative,'off');

    xlabel(axDerivative,'Height H (m)','Color','k','FontWeight','bold','FontSize',8);
    ylabel(axDerivative,'dF/dH (GN/m)','Color','k','FontWeight','bold','FontSize',8);
    title(axDerivative,'Derivative Sensitivity','Color','k','FontWeight','bold','FontSize',9);
    set(gca, 'XColor','k', 'YColor','k')
    grid(axDerivative,'on');
    box(axDerivative,'on');

    %% Monte Carlo
    axes(axMonteCarlo);
    cla(axMonteCarlo);
    styleWhiteAxis(axMonteCarlo);

    histogram(axMonteCarlo,Power_rand/1e6,25, ...
        'FaceColor',[0.25 0.5 0.85], ...
        'EdgeColor','k');
    xlabel(axMonteCarlo,'Power (MW)','Color','k','FontWeight','bold','FontSize',8);
    ylabel(axMonteCarlo,'Frequency','Color','k','FontWeight','bold','FontSize',8);
    title(axMonteCarlo,'Monte Carlo Power','Color','k','FontWeight','bold','FontSize',9);
    set(gca, 'XColor','k', 'YColor','k')
    grid(axMonteCarlo,'on');
    box(axMonteCarlo,'on');

    %% Finite difference
    axes(axFDPressure);
    cla(axFDPressure);
    styleWhiteAxis(axFDPressure);

    plot(axFDPressure,h_fd,P_exact/1000,'b','LineWidth',2.0);
    hold(axFDPressure,'on');
    plot(axFDPressure,h_fd,P_fd/1000,'--','Color',[0.9 0.35 0.05],'LineWidth',2.0);
    hold(axFDPressure,'off');

    xlabel(axFDPressure,'Depth h (m)','Color','k','FontWeight','bold','FontSize',8);
    ylabel(axFDPressure,'Pressure (kPa)','Color','k','FontWeight','bold','FontSize',8);
    title(axFDPressure,'Finite Difference Pressure','Color','k','FontWeight','bold','FontSize',9);
    legend(axFDPressure,{'Exact','Finite Difference'}, ...
        'Location','northwest','TextColor','k','Color','w');
    set(gca, 'XColor','k', 'YColor','k')
    grid(axFDPressure,'on');
    box(axFDPressure,'on');

    %% Scrollable results
    if isnan(bestH)
        optText = 'No safe optimum found';
    else
        optText = sprintf('Best H = %.1f m, Max P = %.1f MW',bestH,bestPower/1e6);
    end

    resultLines = {
        'Advanced Dam Analysis'
        '---------------'
        sprintf('Dam: %s',damName)
        sprintf('H = %.2f m',H)
        sprintf('W = %.2f m',W)
        sprintf('Q = %.2f m^3/s',Q)
        sprintf('eta = %.2f',eta)
        ''
        'Analytical Model'
        '----------------'
        sprintf('Bottom Pressure = %.2f kPa',P_bottom/1000)
        sprintf('Force = %.2f GN',F_analytical/1e9)
        sprintf('Power = %.2f MW',Power/1e6)
        sprintf('Safety Factor = %.2f',SF)
        sprintf('Status = %s',status)
        ''
        'Computational Methods'
        '-----------------'
        sprintf('Trapz Force = %.2f GN',F_trapz/1e9)
        sprintf('Trapz Error = %.5f %%',integrationError)
        sprintf('dF/dH = %.2f GN/m',dF_dH_analytical/1e9)
        sprintf('FD Error = %.5f %%',fdPressureError)
        sprintf('Pi Check = %.3f',Pi_force)
        ''
        'Optimization'
        '---------'
        optText
        ''
        'Monte Carlo'
        '--------'
        sprintf('Mean Power = %.2f MW',meanPowerMC/1e6)
        sprintf('Std Dev = %.2f MW',stdPowerMC/1e6)
        sprintf('Unsafe Risk = %.2f %%',probabilityUnsafe)
        ''
        'Why These Methods Are Used'
        '---------------------'
        'Trapz: approximates total water force.'
        'Derivative: shows sensitivity to height.'
        'Finite difference: solves pressure variation.'
        'Optimization: finds safest high-power design.'
        'Monte Carlo: tests uncertainty in operation.'
        'Pi check: validates force scaling.'
        };

    set(resultBox,'String',resultLines,'Value',1);
end

%% ====================================
% HELPER FUNCTION for plot style

    function styleWhiteAxis(ax)

    set(ax, ...
        'Color','w', ...          % white background
        'XColor','k', ...             % X-axis + ticks BLACK
        'YColor','k', ...      % Y-axis + ticks BLACK
        'GridColor',[0.3 0.3 0.3], ...% darker grid
        'GridAlpha',0.25, ...
        'LineWidth',1.2, ...
        'FontSize',9, ...
        'FontWeight','bold');  % makes numbers darker
    ax.XAxis.Color = [0 0 0];
    ax.YAxis.Color = [0 0 0];
end

end
