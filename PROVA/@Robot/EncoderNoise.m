function this = EncoderNoise(this)

% Measurement noise %
this.RightEnc = this.RightEnc + randn(1,length(this.RightEnc)) * this.enc_sigma + this.enc_mu;
this.LeftEnc  = this.LeftEnc + randn(1,length(this.LeftEnc)) * this.enc_sigma + this.enc_mu;

% Quantization effect
this.quatizeffect_RightEnc = round(this.RightEnc/this.enc_quantization) * this.enc_quantization;
this.quatizeffect_LeftEnc  = round(this.LeftEnc/this.enc_quantization) * this.enc_quantization;
end