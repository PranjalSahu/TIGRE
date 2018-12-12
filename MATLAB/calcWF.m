function wt=calcWF(kVp_l,cmBreast,LE_filter,cm_LE_filt,HE_filter,cm_HE_filt)
%% Description:
 % calculate weighting factor for given LE kV, breast thickness, LE/HE
 % filter type and filter thickness
%% Method
 % (energy-integrating detector) a-selenium layer thickness = 0.03 cm.
 % Lau, Maidment: estimating breast thickness for dual-energy subtraction
 % in contrast-enhanced digital mammography(2016).
 % wt is calculated as the slope of signal point pairs (log(LE),log(HE))
 % for breast density from 0%-100% (10% interval)
%% Usage: 
 % kVp_l: LE in kV
 % cmBreast: breast thickness in cm
 % LE_filter: (text) first 6 lower-case letter of LE filter material
 % cm_LE_filt: LE filter thickness in cm
 % HE_filter: (text) first 6 lower-case letter of HE filter material
 % cm_HE_filt: HE filter thickness in cm
%% Input: 
%% output:
%% History
 % 2016.06.15 H Huang created
%% Main

L=0.03; % cm a-Selenium detector layer thickness

[energy_L spec_L energy_H spec_H]=genSpecDEWF(kVp_l,LE_filter,cm_LE_filt,HE_filter,cm_HE_filt);

for j=1:11
        comp_g=(j-1)*0.1;
        AttSpec_L = breastAtten(energy_L,spec_L,cmBreast,comp_g);
        LE = absenergy(L,energy_L,AttSpec_L);
        
        AttSpec_H = breastAtten(energy_H,spec_H,cmBreast,comp_g);
        HE = absenergy(L,energy_H,AttSpec_H);
       
        logS(j,:)=[comp_g,log(LE),log(HE)];
end
    
coeff=polyfit(logS(:,2),logS(:,3),1);

wt=coeff(1);
end