function u= Pregunta1(h)
%Se eligió el metal Niquel, cuyo calor especifico es k= 444 [Joule/Kg*Kelvin]

k=444;
%k=4181;% calor especifico del agua =4181.3;
%k=129; %Calor especifico del oro
Q=200000; %[J]
g=-Q/k;
%Definiremos una matriz rectangular de (y) filas x (x) columnas de ceros. 

%La estrategia consistirá en iterar sobre este rectángulo ignorando los puntos "inexistentes"
%que quedan fuera de la L usando el comando Continue para saltar dicha iteración.

%Matriz u. h corresponde al paso entre una posicion y otra (partición), se
x=fix(89/h);
y=fix(55/h);
b=fix(34/h);
z=fix(21/h);
u= zeros((y),(x));

%Definimos las condiciones de borde
c1=0; %(1,y) AB
c2=0; %(x,0)AF
c3=0; %(34,34) hasta (34, 55) CD
c4=0; %(34,34) hasta (89,34) DE

%Las condiciones de borde para el ailante térmico son tipo Neumann 
%(d/dn)(u(i,j))=0 para lo cual se usará una ecuación especial más adelante.

%Asignar las condiciones de borde a la matriz

for i=1:(y); %AB
    u(i,1)=c1;
end
for j=1:(x); %AF
    u(y,j)=c2;
end
for i=1:(z); %CD
    u(i,b)=c3;
end
for j=(b):(x); %DE
    u(z,j)=c4;
end

%Calculo de w
parte1=cos(pi/((y)-1));
parte2= cos(pi/((x)-1));
parte3= (parte1 + parte2)^2;
parte4= sqrt(4- parte3);
parte5=2+parte4;

w= 4/parte5;

e=1000;
emax= Q/k/100000;
iter=0;
while e>emax&& iter<=300
        e = 0; %resetear error
       for i=2:y-1;
          for j= 2:x-1;
              %Parte inexistente
              if i<(z)&& j>(b)
                    continue
                    %Condiciones tipo Dirichlet
              else
                    r= (u(i+1,j)+u(i-1,j)+u(i,j+1)+u(i,j-1)-4*u(i,j)-(h*h*g))/4;%Condiciones tipo Neumman
                    u(i,j)= u(i,j) + w*r;
                    %Condiciones tipo Neumann
                    if j<=(b) && i>= (z)
                        u(1,j)=u(1,j)+w*((u(1,j-1)+u(1,j+1)+(2*u((1+1),j))-4*u(1,j)-(h*h*g))/4);%ladobc
                        u(i,x)= u(i,x)+w*((u(i+1,x)+u(i-1,x)+(2*u(i,(x)-1))-4*u(i,x)-(h*h*g))/4);%ladoEF
                        e = max(e,abs(r));%Actualizar error
                    end
              end
                    
          end 
       end
       iter= iter+1;
end
%Quitar los sectores inexistentes de la placa
for i= 1:z-1 
    for j= b-1:x
        u(i,j)=NaN;
    end
end


%Vectores para plotear
 q = 0:1:(x)-1;
 w = 0:1:(y)-1;
 length(q);
 length(w);
 size(u);
    [vq, vw] = gradient(u);
    figure;
    subplot(2, 2, 1); % grafico 2D color
    
    surf(q, w, u, 'EdgeColor', 'None'); view(2); colorbar;
    title('Color Bar placa 2D');
    xlabel('Largo placa [Adim]')
    ylabel('Ancho placa [Adim]')
    subplot(2, 2, 2); % grafico 3D color
    
    surf(q, w, u, 'EdgeColor', 'None');
    title('3 Dimensiones')
    xlabel('Largo placa [Adim]')
    ylabel('Ancho placa [Adim]')
    zlabel('Temperatura placa [Adim]')
    subplot(2, 2, 3); % curvas de nivel con gradiente
    contour(q, w, u, 20);%20 curvas de nivel, para variar la cantidad de curvas, modificar el 4 parametro
    title('curvas de nivel')
    xlabel('Largo placa [Adim]')
    ylabel('Ancho placa [Adim]')
    hold on; quiver(q(1:5/h:x), w(1:5/h:y), vq(1:5/h:y,1:5/h:x), vw(1:5/h:y,1:5/h:x)); hold off;   
  
end
