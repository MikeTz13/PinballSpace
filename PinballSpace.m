clc; clear all; close all;

% Obtener la lista de cámaras disponibles
camList = webcamlist;

% Seleccionar la cámara que deseas usar (por ejemplo, la primera de la lista)
selectedCam = camList{1};

% Crear el objeto de la cámara seleccionada
cam = webcam(selectedCam);

% Cargar imágenes del juego de pinball
fondo = imread('Fondo1.png');
bola = imresize(imread('Bola1.png'),0.1);
paleta_izquierda_normal = imresize(imread('PaletaIzquierda.png'),0.70);
paleta_izquierda_cerrada = imresize(imread('PaletaIzquierdaArriba.png'),0.70);
paleta_derecha_normal = imresize(imread('PaletaDerecha.png'),0.70);
paleta_derecha_cerrada = imresize(imread('PaletaDerechaArriba.png'),0.70);


% Definir el tamaño de la ventana de juego+
altura_ventana = size(fondo, 1);
anchura_ventana = size(fondo, 2);

% Crear una nueva figura
fig = figure;
subplot 211
imshow(fondo);
title("Pinball SPACE",'Color','red','FontAngle','italic','FontSize',16)


% Posición inicial de la bola y las paletas
posicion_inicial_bola = [371,50 ];
posicion_inicial_paleta_izquierda = [100, 850];
posicion_inicial_paleta_derecha = [500, 850];


% Velocidad inicial de la bola
velocidad_bola = [30 , 16  ]; % [dx, dy]

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

% Inicializar contadores
contador1 = 0; % Para objetos azules
contador2 = 0; % Para objetos rojos

% Bucle principal del juego
while ishandle(fig)
    % Obtener la imagen de la cámara
    img0 = snapshot(cam);
     
    
    % Detectar objetos de color azul
    img_blue = imsubtract(img0(:,:,3), rgb2gray(img0));
    bw_blue = im2bw(img_blue, 0.13);
    bw_blue = medfilt2(bw_blue);
    bw_blue = imopen(bw_blue, strel('disk',1));
    bw_blue = bwareaopen(bw_blue, 3000); % Elimina área menor a 3000px
    bw_blue = imfill(bw_blue, 'holes');
    [L_blue, N_blue] = bwlabel(bw_blue);
    
    % Detectar objetos de color verde
    img_red = imsubtract(img0(:,:,1), rgb2gray(img0));
    bw_red = im2bw(img_red, 0.13);
    bw_red = medfilt2(bw_red);
    bw_red = imopen(bw_red, strel('disk',1));
    bw_red = bwareaopen(bw_red, 3000); % Elimina área menor a 3000px
    bw_red = imfill(bw_red, 'holes');
    [L_red, N_red] = bwlabel(bw_red);
    
    %-----------------regionprops------------------
    prop_blue = regionprops(L_blue);
    prop_red = regionprops(L_red);
    %----------------------------------------------
    
    subplot 212
    imshow(img0)
    
    
    % Dibujar objetos detectados en color azul
    for n = 1:N_blue
        c = round(prop_blue(n).Centroid); % obtener centroide
        rectangle('Position',prop_blue(n).BoundingBox,'EdgeColor','b','LineWidth',2); % dibujar rectangulo
        text(c(1), c(2), strcat('X:', num2str(c(1)), ' \newline', ' Y:', num2str(c(2))), 'Color', 'blue'); % Agregar coordenada
        line([640/2 640/2], [0 480],'Color','red','LineWidth',2); % Dibuja línea vertical
        line([0 640], [480/2 480/2],'Color','red','LineWidth',2); % Dibuja línea horizontal
        contador1 = contador1 + 1; % Incrementar contador de objetos azules
    end
    
    % Dibujar objetos detectados en color rojo
    for n = 1:N_red
        c = round(prop_red(n).Centroid); % obtener centroide
        rectangle('Position',prop_red(n).BoundingBox,'EdgeColor','r','LineWidth',2); % dibujar rectangulo
        text(c(1), c(2), strcat('X:', num2str(c(1)), ' \newline', ' Y:', num2str(c(2))), 'Color', 'red'); % Agregar coordenada
        line([640/2 640/2], [0 480],'Color','red','LineWidth',2); % Dibuja línea vertical
        line([0 640], [480/2 480/2],'Color','red','LineWidth',2); % Dibuja línea horizontal
        contador2 = contador2 + 1; % Incrementar contador de objetos rojos
    end
    

    % Cambiar imagen de la paleta izquierda si se detecta un objeto azul
    if N_blue > 0
        disp('Se detectó un objeto azul');
        set(h_paleta_izquierda, 'CData', paleta_izquierda_cerrada);
    else
        set(h_paleta_izquierda, 'CData', paleta_izquierda_normal);
    end
    
    % Cambiar imagen de la paleta derecha si se detecta un objeto rojo
    if N_red > 0
        disp('Se detectó un objeto rojo');
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
        
        % Si la bola toca la paleta cerrada, invertir la dirección en y
        if N_blue > 0 || N_red > 0
            velocidad_bola(2) = -abs(velocidad_bola(2)); % Movimiento recto hacia arriba
        else
            % Invertir la dirección en x
            velocidad_bola(1) = -velocidad_bola(1);
        
            % Cambiar la dirección en y de forma aleatoria
            velocidad_bola(2) = randi([-4, 4]); % Elige una velocidad aleatoria entre -4 y 4
        end
    end
    
    % Colisión con los bordes de la ventana
    if nueva_posicion_bola_x(1) <= 0 || nueva_posicion_bola_x(end) >= anchura_ventana
        velocidad_bola(1) = -velocidad_bola(1); % Invertir la dirección en x
    end
    
    % Colisión con el borde superior del fondo
    if nueva_posicion_bola_y(1) <= 0
        velocidad_bola(2) = -velocidad_bola(2); % Invertir la dirección en y
    end
    
    % Colisión con el borde inferior del fondo
    if nueva_posicion_bola_y(end) >= (altura_ventana - size(bola, 1))
        disp('¡Perdiste!');
        close(fig);
        return;
    end
    
    % Pausa para actualizar el juego
    pause(0.01);
end

%
% clear cam;