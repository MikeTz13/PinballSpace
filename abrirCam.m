clc, clear
%MATLAB DE WEB
%webcamlist: obtiene información del adaptador de video disponible 
Adaptador=imaqhwinfo('winvideo')
% MATLAB retorna la cantidad de dispositivos disponibles
% En micaso solo hay uno y es 'Integrated Camera'
Camara=imaqhwinfo('winvideo',1);
%Establezca el formato
Video=videoinput("winvideo",1,"RGB24_640x480");
%Presente en una ventana
preview(Video);
%Con snaptshot obtiene una imagen
for i=0:1000
    imagen=getsnapshot(Video);
    Ima_R=double(imagen(:,:,1));
    Ima_G=double(imagen(:,:,2));
    Ima_B=double(imagen(:,:,3));

    ImagenBlue = Ima_B-Ima_R-Ima_G;
    ImagenRed = Ima_R-Ima_B-Ima_G;
    ImagenGreen = Ima_G-Ima_B-Ima_R
    %Ima_R=edge(Ima_R,'canny');
    
    ImagenBinariaR = ImagenRed > 50;
    ImagenBinariaB = ImagenBlue > 50;
    ImagenBinariaG = ImagenGreen > 50;
    imshow(ImagenGreen);
end

%El procesamiento se realiza como se mostró anteriormente.