function [position,isterminal,direction] = event_PS(t,F)
  position = F(1); % Valor que volem zero. En aquest cas, posicio y = 0 (tall amb l'eix de les abscisses.


  isterminal = 1;  % Parar l'integrador
  direction = 0;   % -1 -> el zero nomes es pot acostar dir. negativa // 0 -> qual. direcc. // +1 nomes direccio positiva
end