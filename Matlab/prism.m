%% Denna funktion f�r in en prisma och ger en graf �ver hur ljusstr�len bryts.
%Argumenten �r:
%n1-Brytningsindex f�r mediumet utanf�r prismat
%n2-Brytningsindex f�r prismat
%Prismat i en 2x4 matris d�r f�rsta raden �r x pos och andra raden �r y pos
function [] = prism(n1, n2, prisma)
%% Inst�llningar
% Str�lens l�ngd
X =-6:0.001:6;
% Ljusstr�len, denna �r alltid samma
K = 0;
M = 0;
%Critical angle
crit_angle = asind(n1/n2);

% Allokering av minne f�r den brutna ljusstr�len
Y_out = zeros(1,length(X));

%% Linjerna f�r de olika prisma v�ggarna
% F�rsta v�ggen
K_1 = (prisma(2,1)-prisma(2,2))/(prisma(1,1)-prisma(1,2));
M_1 =prisma(2,1)-K_1*prisma(1,1);


% Andra v�ggen
K_2 = (prisma(2,2)-prisma(2,3))/(prisma(1,2)-prisma(1,3));
M_2 =prisma(2,2)-K_2*prisma(1,2);

% Tredje v�ggen
K_3 = (prisma(2,3)-prisma(2,4))/(prisma(1,3)-prisma(1,4));
M_3 =prisma(2,3)-K_3*prisma(1,3);

%% Normaler och vektorer
% Ljus vecktorn
ljus = [1,0];

% F�rsta v�ggens normalen
norm1 = [K_1,1];

% F�rsta v�ggens normalen
norm2 = [K_2, 1];

% F�rsta v�ggens normalen
norm3 = [K_3, 1];

%% Brytningsloopen
% Denna s�ker efter vilket v�gg som str�len prickar och sedan plockar
% dennes normal och hittar den nya vinkeln.
index = 1;
Wall1 = true;
Wall2 = true;
Wall3 = true;
first = true;
second = true;

% loopar �ver alla x v�rden
for a = X
    
    % Ber�knar Y v�rden mot v�ggarna
     % Ljustr�lens y v�rde
     Y = K*a +M;
    if a>=min(prisma(1,:)) && a<=max(prisma(1,:))
        if ~((abs(Y-prisma(2,1))<0.01 && abs(a-prisma(1,1))<0.01)||(abs(Y-prisma(2,2))<0.01 && abs(a-prisma(1,2))<0.01)||(abs(Y-prisma(2,3))<0.01 && abs(a-prisma(1,3))<0.01))
            Y1 = (K_1*a+M_1); % F�rsta v�ggen
            Y2 = (K_2*a+M_2);% Andra v�ggen
            Y3 = (K_3*a+M_3); % Tredje v�ggen

            % Kollar om den krockar med n�gon v�g
            if Wall1 && abs(Y - Y1) < 0.02
                % adderar talet
                Y_out(index) = Y;              
                % Kollar om str�len �r i mediumet eller inte
                if first
                    angle_in = acosd(dot(ljus, norm1)/(norm(ljus)*norm(norm1)));
                    [K, M, angle_out] = line_ekv_first(angle_in, Y, a, n1, n2);
                    first = false;
                elseif second
                    angle = 60-angle_out;
                    second = false;
                    if(abs(angle) <= crit_angle)
                        [K, M, angle_out] = line_ekv_second(angle,angle_in,angle_out, Y, a, n2, n1);
                    else
                        Y_out(index) =Y ;
                        X(index:length(X)) = a;
                        break;
                    end
                end

                ljus =[1, K];

                Wall1 = false;
            elseif Wall2 && abs(Y - Y2) < 0.02
                % adderar talet till vektorn
                Y_out(index) = Y;

                % Kollar om str�len �r i mediumet eller inte
                if first
                    angle_in = acosd(dot(ljus, norm2)/(norm(ljus)*norm(norm2)));
                    [K, M, angle_out] = line_ekv_first(angle_in, Y, a, n1, n2);
                    first = false;
                elseif second
                    angle = 60-angle_out;
                    second = false;
                    if(abs(angle) <= crit_angle)
                        [K, M, angle_out] = line_ekv_second(angle,angle_in,angle_out, Y, a, n2, n1);
                        
                    else
                        Y_out(index) =Y ;
                        X(index:length(X)) = a;
                        break;
                    end
                end
                ljus =[1, K];
                Wall2 = false;
            elseif Wall3 && abs(Y - Y3) < 0.02
                % adderar talet
                Y_out(index) = Y;

                % Kollar om str�len �r i mediumet eller inte
                if first
                    angle_in = acosd(dot(ljus, norm3)/(norm(ljus)*norm(norm3)));
                    [K, M, angle_out] = line_ekv_first(angle_in, Y, a, n1, n2);
                    first = false;
                elseif second
                    angle = 60-angle_out;
                    second = false;
                    if(abs(angle) <= crit_angle)
                        [K, M, angle_out] = line_ekv_second(angle,angle_in,angle_out, Y, a, n2, n1);
                    else
                        Y_out(index) =Y ;
                        X(index:length(X)) = a;
                        break;
                    end
                end
                ljus =[1, K];
                Wall3 = false;
            else
                % addera talet
                Y_out(index) = Y;
            end
        else
            Y_out(index) =0 ;
            X(index:length(X)) = a;
            break;
            
        end
    else
        Y_out(index) = Y;
        
    end
    index = index + 1;
end


%% Plotning
plot(X,Y_out);
grid on
hold on
plot(prisma(1,:),prisma(2,:));
axis([-1 1 -1 1]);
hold off


end

