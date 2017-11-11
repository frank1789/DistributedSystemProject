function this = EncoderSim(this)

% Motors angular velocities
OmegaR = (2*this.u(1,:) + this.interaxle*this.u(2,:))/(2*this.whellradius);
OmegaL = (2*this.u(1,:) - this.interaxle*this.u(2,:))/(2*this.whellradius);

% Angular increments for 'Delta t'
Right_Enc = [0, OmegaR(1:end-1).*diff(this.t')];
Left_Enc =  [0, OmegaL(1:end-1).*diff(this.t')];

% Encoder values
this.RightEnc = cumsum(Right_Enc);
this.LeftEnc  = cumsum(Left_Enc);
this.EncoderNoise();
end