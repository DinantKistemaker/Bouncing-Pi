% simulation of the bouncing with pi puzzle:
% https://www.youtube.com/watch?v=HEfHFsfGXjs&t=6s
% its solution and its graphical representation
% Solution by Dinant Kistemaker and Knoek van Soest
% DA Kistemaker 16-jan-2019.


m1  = 1;
v1b = 0;
x1  = 1;

m2  =  1;
v2b = -1;
x2  =  2;

alpha = atan(1/sqrt(m2)); % this defines the fixed ratio of the before and after speeds of the masses depending on the mass ratio
% when m2>>>m1, alpha ~ 1/sqrt(m2)

bounce=0;
X1=x1;X2=x2;T=0;
fi=0;
for i=1:(floor(sqrt(m2)*pi)+100); % this indicates already the answer, the 100 is just for checking 
    bounce = bounce+1
    if mod(i,2)
        tcol_mass=(x2-x1)/(v1b-v2b);
        dt  = tcol_mass;
        v1a = (m1-m2)/(m1+m2)*v1b + 2*m2/(m1+m2)*v2b; % v1 after elastic collision
        v2a = (m2-m1)/(m1+m2)*v2b + 2*m1/(m1+m2)*v1b; % v2 after elastic collision
    else
        tcol_wall = (0-x1)/v1b;
        dt  =  tcol_wall;
        v1a = -v1a; % v1 after elastic collision
        v2a =  v2b; % v2 after elastic collision
    end
    x1 = x1 +v1b*dt;
    x2 = x2 +v2b*dt;
    X1(i+1)=x1;
    X2(i+1)=x2;
    T(i+1) = T(i)+dt;
    
    v1b = v1a; v2b = v2a;
    test=1;
    DT(i)=dt;
    if v1b>=0&&v2b>=v1b %this is the sufficient condition!
        % remainder is done for purposes of animation afterwards
        dt = 2;
        x1 = x1 +v1b*dt;
        x2 = x2 +v2b*dt;
        X1(i+2)=x1;
        X2(i+2)=x2;
        T(i+2) = T(i+1)+dt;
        break % we are
    end
    
end


%% Grafical representation of our solution
% current v1 and v2 are shown on a coordinate system with axes:
% [-1/2sqrt(2)sqrt(m2)v2 -1/2sqrt(2)sqrt(m1)v1]
% Energy is concerved thus, these points are on a circle with a radius
% defined by the initial amount of energy of m2
% every bounce causes the state to jump to another position on the energy
% circe, defined by angle fi. Every collision is graphically represented by
% a mirroring around an axis with a directional coefficient alpha (see
% above) when the two masses collide and mirroring with the horizontal axis
% when the left mass collides with the wall.
% The general idea is here that you need N*alpha to be greater than
% pi-alpha, with n the amount of bounces. N = floor((pi-alpha)/alpha). 
% Note that for large mass ratio
% alpha = 1/sqrt(m2) and thus N = floor(pi*sqrt(m)).

fi(i)=0;
for i=1:bounce; %this can be done faster, just to show the idea:
    if mod(i,2)
        fi(i+1) = ((i+1))*alpha;
    else
        fi(i+1) = -i*alpha;
    end
end
fi(end+1)=fi(end);
%%
t=linspace(T(1),T(end),bounce*50);
x1=interp1(T,X1,t); x2=interp1(T,X2,t); % for animation purposes


%%
figure(1),clf
title(['m_1 = 1kg and m_2 = ',num2str(m2),'kg'],'FontSize',16),hold on
ball1=plot(x1(1),-2,'ro','MarkerFaceColor','r','MarkerSize',14);
ball2=plot(x2(1),-2,'ko','MarkerFaceColor','k','MarkerSize',14)

r=1;
x=-1:.01:1;
y=sqrt(r^2-x.^2);
plot([x x],[y -y],'LineWidth',4)
hold on

x=-1.5:.1:1.5;
plot(x,x*0,'k','LineWidth',4)
text(-.3,1.6,'1/2*sqrt(2)*v_1','FontSize',14)
plot([0 0],[-1.5 1.5],'k','LineWidth',2)
text(1.4,-.2,'1/2*sqrt(2)*sqrt(m_2)*v_2','FontSize',14)

x=1.5*cos(alpha+pi):.1:(1.5*cos(alpha));
y=tan(alpha)*x;
plot(x,y,'r','LineWidth',4)
text(1.55*cos(alpha),1.55*sin(alpha)+.05,'alpha = tan(1/sqrt(m_2))')
text(1.55*cos(alpha),1.55*sin(alpha)-.05,'alpha ~ 1/(sqrt(m_2)')


x=linspace(-1,cos(pi+alpha),100);
y=-sqrt(r^2-x.^2);
P=patch([0 x 0],[y(1) y y(1)],[.5 .5 .5]);
P.FaceAlpha=.3;
P.LineStyle='none';
FI=fi(1);
circ=plot(cos(FI),sin(FI),'ko','MarkerFaceCOlor','b','MarkerSize',12)
axis off
plot([0 0],[-2.2 -1.8],'k','LineWidth',4)
axis equal 
axis ([-2 3 -2.5 2.5])

pause,disp('hit any key to start')

text (1.5,-1,'Bounce nr: ','FontSize',16)
TT=text(2.3,-1,'0','FontSize',16);
B=0:length(T);
B(end-1)=B(end-2);
for i = 1:length(t)
    
    set(ball1,'XData',x1(i))
    set(ball2,'XData',x2(i))
    j=find(T<=t(i));
    j=j(end);
    set(TT,'String',num2str(B(j)))
    FI=fi(j);
    set(circ,'XData',cos(FI),'YData',sin(FI));
    axis ([-2 3 -2.5 2.5])
    drawnow
end




