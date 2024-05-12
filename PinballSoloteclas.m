% Cargar imágenes
fondo = imread('Fondo1.png');
bola = imresize(imread('Bola1.png'),0.08);
paleta_izquierda_normal = imresize(imread('PaletaIzquierda.png'),0.60);
paleta_izquierda_cerrada = imresize(imread('PaletaIzquierdaArriba.png'),0.60);
paleta_derecha_normal = imresize(imread('PaletaDerecha.png'),0.60);
paleta_derecha_cerrada = imresize(imread('PaletaDerechaArriba.png'),0.60);

% Definir el tamaño de la ventana de juego
altura_ventana = size(fondo, 1);
anchura_ventana = size(fondo, 2);

% Crear una nueva figura
fig = figure;
imshow(fondo);

% Posición inicial de la bola y las paletas
posicion_inicial_bola = [371,50 ];
posicion_inicial_paleta_izquierda = [100, 850];
posicion_inicial_paleta_derecha = [500, 850];
% Velocidad inicial de la bola
velocidad_bola = [8, 4]; % [dx, dy]

% Mostrar la bola y las paletas en la ventana
hold on;
h_bola = imshow(bola);
h_paleta_izquierda = imshow(paleta_izquierda_normal);
h_paleta_derecha = imshow(paleta_derecha_normal);

% Establecer la posición inicial de la bola y las paletas
set(h_bola, 'XData', [posicion_inicial_bola(1), posicion_inicial_bola(1) + size(bola, 2) - 1]);
set(h_bola, 'YData', [posicion_inicial_bola(2), posicion_inicial_bola(2) + size(bola, 1) - 1]);

set(h_paleta_izquierda, 'XData', [posicion_inicial_paleta_izquierda(1), posicion_inicial_paleta_izquierda(1) + size(paleta_izquierda_normal, 2) - 1]);
set(h_paleta_izquierda, 'YData', [posicion_inicial_paleta_izquierda(2), posicion_inicial_paleta_izquierda(2) + size(paleta_izquierda_normal, 1) - 1]);

set(h_paleta_derecha, 'XData', [posicion_inicial_paleta_derecha(1), posicion_inicial_paleta_derecha(1) + size(paleta_derecha_normal, 2) - 1]);
set(h_paleta_derecha, 'YData', [posicion_inicial_paleta_derecha(2), posicion_inicial_paleta_derecha(2) + size(paleta_derecha_normal, 1) - 1]);

% Bucle principal del juego
while ishandle(fig)
    % Detectar teclas presionadas
    keys = get(fig, 'CurrentKey');
    % Cambiar imagen de la paleta izquierda
    if any(strcmp(keys, 'w')) 
        set(h_paleta_izquierda, 'CData', paleta_izquierda_cerrada);
    else
        set(h_paleta_izquierda, 'CData', paleta_izquierda_normal);
    end
    
    % Cambiar imagen de la paleta derecha
    if any(strcmp(keys, 's')) 
        set(h_paleta_derecha, 'CData', paleta_derecha_cerrada);
    else
        set(h_paleta_derecha, 'CData', paleta_derecha_normal);
    end
    
    % Obtener la posición de la bola
    posicion_bola_x = get(h_bola, 'XData');
    posicion_bola_y = get(h_bola, 'YData');
    
    % Mover la bola
    nueva_posicion_bola_x = posicion_bola_x + velocidad_bola(1);
    nueva_posicion_bola_y = posicion_bola_y + velocidad_bola(2);
    set(h_bola, 'XData', nueva_posicion_bola_x);
    set(h_bola, 'YData', nueva_posicion_bola_y);
    
    % Detección de colisión con las paletas
    if (nueva_posicion_bola_x(1) <= posicion_inicial_paleta_izquierda(1) + size(paleta_izquierda_normal, 2) - 1 && ...
            nueva_posicion_bola_x(end) >= posicion_inicial_paleta_izquierda(1) && ...
            nueva_posicion_bola_y(1) <= posicion_inicial_paleta_izquierda(2) + size(paleta_izquierda_normal, 1) - 1 && ...
            nueva_posicion_bola_y(end) >= posicion_inicial_paleta_izquierda(2)) || ...
        (nueva_posicion_bola_x(1) <= posicion_inicial_paleta_derecha(1) + size(paleta_derecha_normal, 2) - 1 && ...
            nueva_posicion_bola_x(end) >= posicion_inicial_paleta_derecha(1) && ...
            nueva_posicion_bola_y(1) <= posicion_inicial_paleta_derecha(2) + size(paleta_derecha_normal, 1) - 1 && ...
            nueva_posicion_bola_y(end) >= posicion_inicial_paleta_derecha(2))
        
        % Invertir la dirección en x
        velocidad_bola(1) = -velocidad_bola(1);
        
        % Cambiar la dirección en y de forma aleatoria
        velocidad_bola(2) = randi([-4, 4]); % Elige una velocidad aleatoria entre -4 y 4
    end
    
    % Colisión con los bordes de la ventana
    if nueva_posicion_bola_x(1) <= 0 || nueva_posicion_bola_x(end) >= anchura_ventana
        velocidad_bola(1) = -velocidad_bola(1); % Invertir la dirección en x
    end
    if nueva_posicion_bola_y(1) <= 0 || nueva_posicion_bola_y(end) >= altura_ventana
        velocidad_bola(2) = -velocidad_bola(2); % Invertir la dirección en y
    end
    
    % Pausa para actualizar el juego
    pause(0.01);
end