function [position,isterminal,direction] = event_PS(t,F, mu)
  position = F(1) - (1 - mu);

  isterminal = 1;  % Parar l'integrador
  direction = 0;   % -1 -> el zero nomes es pot acostar dir. negativa // 0 -> qual. direcc. // +1 nomes direccio positiva
end