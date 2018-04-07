function this = EncoderSim(this, it)

% Motors angular velocities
OmegaR = (2*this.u(1,it) + this.interaxle*this.u(2,it))/(2*this.wheelradius);
OmegaL = (2*this.u(1,it) - this.interaxle*this.u(2,it))/(2*this.wheelradius);

% Angular increments for 'Delta t'
Right_Enc = OmegaR * this.Dt;
Left_Enc =  OmegaL * this.Dt;

% Encoder values - raw value (no noise)
if it < 2
    this.RightEnc(it) = Right_Enc;
    this.LeftEnc(it)  = Left_Enc;
else
    this.RightEnc(it) = this.RightEnc(it-1) + Right_Enc;
    this.LeftEnc(it)  = this.LeftEnc(it-1) + Left_Enc;
end
% clear memory
clear Right_Enc Left_Enc

% add noise to odometry 
RightEnc = this.RightEnc(it) + ...
    randn(1,length(this.RightEnc(it))) * this.enc_sigma + this.enc_mu;
LeftEnc  = this.LeftEnc(it) + ...
    randn(1,length(this.LeftEnc(it))) * this.enc_sigma + this.enc_mu;

% Quantization effect - with noise
this.noisyRightEnc(it) = round(RightEnc/this.enc_quantization) * this.enc_quantization;
this.noisyLeftEnc(it)  = round(LeftEnc/this.enc_quantization) * this.enc_quantization;
% clear memory
clear Right_Enc Left_Enc
end