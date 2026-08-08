%==========================================
% Date 01/03/2025
% Plot 3D en subplots
% rivo sitraka
%==========================================
clc; clear; close all;

%% Repository data directory
base_dir = '../data/raw/power_profiling/transmission';

if ~isfolder(base_dir)
    error('ERROR: Directory "%s" does not exist.', base_dir);
end

%% Measurement files
files = {
    fullfile(base_dir, 'standard', ...
        'ppk-pm0_DR5_TX0_L10.wind.csv'), ...
    fullfile(base_dir, 'ucb', ...
        'ppk-pm0_DR5_TX0_L10.wind.csv')
};

labels = {'Standard', 'UCB'};


%% Création de la figure pour le tracé global
fig = figure('Units', 'inches', 'Position', [200, 100, 10, 6]);
set(fig, 'Color', 'white');                          
set(fig, 'PaperUnits', 'inches', 'PaperPosition', [200, 100, 10, 6]);

%% Boucle sur chaque fichier avec subplot
for i = 1:length(files)
    % Création du subplot (un par fichier)
    ax = subplot(length(files), 1, i);
    hold(ax, 'on');
    grid(ax, 'on');
    box(ax, 'on');
    set(gca, 'FontSize', 14)
    
    % Construction du chemin complet du fichier
    chemin_fichier = fullfile(files{i});
    
    % Vérifier si le fichier existe
    if ~isfile(chemin_fichier)
        fprintf('Fichier introuvable : %s, il sera ignoré.\n', chemin_fichier);
        title(ax, sprintf('Fichier introuvable : %s', files{i}), 'FontSize', 14);
        continue;
    end
    
    % Lecture du fichier CSV en ignorant la première ligne (en-tête)
    data = csvread(chemin_fichier, 1, 0);
    
    % Extraction des colonnes de données
    Timestamp_ms = data(:,1);
    Current_uA  = data(:,2);
    
    % Conversion des unités
    Current_mA = Current_uA / 1000;
    Timestamp_s = Timestamp_ms;
    
    % Recherche de l'indice où le courant atteint >= 3 mA
    idx = find(Current_mA >= 3, 1);
    if isempty(idx)
        idx = 1;
    end
    
    % Reculer de 50000 points si possible
    start_idx = max(1, idx- 1000);
    
    % Découper les données sur une fenêtre de 10000 points (à adapter)
    end_idx = min(length(Current_mA), start_idx + 9000 - 1);
    Timestamp_trunc = Timestamp_s(start_idx:end_idx);
    Current_trunc   = Current_mA(start_idx:end_idx);
    
    % Réinitialiser l'axe du temps pour que t = 0 corresponde au début du découpage
    Timestamp_trunc = Timestamp_trunc - Timestamp_trunc(1);
    
    % Tracer la courbe et personnaliser l'axe avec DisplayName
    plot(ax, Timestamp_trunc, Current_trunc, 'LineWidth', 3, 'DisplayName', labels{i});
    xlabel(ax, 'Time (ms)', 'FontSize', 14);
    ylabel(ax, 'Current (mA)', 'FontSize', 14);
    
    % Affichage automatique de la légende basée sur DisplayName
    legend(ax, 'show');
end

%% Dossier de sauvegarde et sauvegarde du graphique
output_folder = fullfile('Images');
if ~isfolder(output_folder)
    mkdir(output_folder);
end
plot_path_fig = fullfile(output_folder, 'tx_L20_compare.fig');
plot_path_eps = fullfile(output_folder, 'tx_L20_compare.eps');

saveas(fig, plot_path_fig);
print(fig, '-depsc', plot_path_eps);

fprintf('Graphique enregistré sous : %s\n', plot_path_fig);
fprintf('Graphique enregistré sous : %s\n', plot_path_eps);
