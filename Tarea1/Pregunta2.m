function A= Pregunta2()
%Matriz largo(filas)xtiempo(columnas)
L=1;
t=5; %tiempo
h=0.1; %Discretización largo cuerda
k=0.05; %Discretización tiempo.
%c=2;
%r=((c)*k)/(h); Elegimos los valores para que r=1
A=zeros(t/k,3*L/h);
n=57; %Numero de lista en Ucursos
%Condiciones iniciales
for j= 1:(3*L/h)
    Cin=3*n*sin(pi*(0.1*j));%Se multiplica por 0.1 para que no quede sin(0)
    A(1,j)=Cin;
    A(2,j)= Cin;
end 


 %A(1,j)se refiere al tiempo 0 en la posición j (no se puede
 %especificar como 0 en una matriz)
 
 %Condiciones de borde.
 %Dado a que la cuerda se encuentra sujeta en ambos extremos, es razonable
 %suponer las siguientes condiciones de borde 
 
 %L= 1 (Distancia cero)
 for i=1:t/k
     A(i,1)= 0; %L= 0
     A(i,3*L/h)=0; %L= 3L/h
 end
%Método explicito
      for i= 2:((t/k))-1
        for j= 2:(3*L/h)-1     
         A(i+1,j)=A(i,j+1)+A(i,j-1)-A(i-1,j);
        end
      end
 %vector para graficar
 x=1:(3*L/h);
 %Verificar que las dimensiones sean las correctas para graficar
 size(A);
 length(x);
 length(A(i,:));
 m= max(A);
 o= max(m);
%Descomentar para crear video
% v= VideoWriter('cuerda1.avi');
% open(v);
 %Graficar movimiento en el tiempo
   for i = 1:t/k
    plot(x,A(i,:)); % graficar cuerda
    xlabel('Largo Cuerda')
    ylabel('Amplitud')
    title('Movimiento Cuerda en el tiempo')
    axis([0,3*L/h,-o,o]); % mantener escala del grafico
    pause(0.1); % esperar k tiempo
%     frame=getframe(gcf);%Descomentar para crear video
%     writeVideo(v,frame);% Descomentar para crear video
%     
   end
    %Graficar compilación de resultados (Se debe descomentar este gráfico y
    %comentar el anterior)
% figure;
% surf(A);
% title('Conjunto de soluciones');
% zlabel('Amplitud');
% xlabel('Largo Cuerda');
 end