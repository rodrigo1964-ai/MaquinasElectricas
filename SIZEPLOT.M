% get current figure handle 
hx = gcf;
papersize = get(hx,'PaperSize')
paperposition=get(hx,'PaperPosition')
figposition=get(hx,'Position')
mtitle = 'Resize height of figure';
kplot = menu(mtitle,'No','To 2.5 in', 'To 5 in', 'To 7.5 in','To 8 in', 'None of the above'); 

if kplot ==1;
disp('Paperposition unchanged')
elseif kplot ==2; newheight = [1.25,1.25,6,2.5]; 
figposition = [470,600,600,250];
elseif kplot ==3; newheight = [1.25,1.25,6,5]; 
figposition = [470,250,600,500];
elseif kplot ==4; newheight = [1.25,1.25,6,7.5]; 
figposition = [470,50,600,750];
elseif kplot ==5; newheight = [1.25,1.25,6,8]; 
figposition = [470,50,600,800];
elseif kplot ==6; 
Dposition = input('Enter changes in inches, eg.[Dleftmargin,Drightmargin,Dwidth, Dheight] > ')
newheight = paperposition + Dposition; 
figposition = figposition + 100*Dposition; 
end
if kplot ~= 1 
set(gcf,'Position',figposition)
set(gcf,'PaperPosition',newheight)
end

