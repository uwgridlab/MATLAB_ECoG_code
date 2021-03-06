
%     [ maskedIfsCorrs, maskedIfsPlvs, maskedRsCorrs, maskedRsPlvs, maskedHGCorrs, maskedHGPlvs, maskedbetaCorrs, maskedbetaPlvs,...
%     maskedalphaCorrs, maskedalphaPlvs, maskedthetaCorrs, maskedthetaPlvs, maskeddeltaCorrs, maskeddeltaPlvs ]...
%     = fastPhaseShuffle_revised( trimmed_sig, fs, Montage.BadChannels, ifsCorrs, ifsPlv, rsCorrs, rsPlv, ...
%     HGcorrs, HGplv, betaCorrs, betaPlv, alphaCorrs, alphaPlv, thetaCorrs, thetaPlv, deltaCorrs, deltaPlv );
%     
     
[ maskedIfsPlvs, maskedRsPlvs, maskedHGPlvs,  maskedbetaPlvs,...
    maskedalphaPlvs, maskedthetaPlvs, maskeddeltaPlvs ]...
    = fastPhaseShuffle_revised( trimmed_sig, fs, [], ifsPlv, rsPlv, ...
    HGplv, betaPlv, alphaPlv, thetaPlv, deltaPlv );

% [ maskedIfsPlvs, maskedRsPlvs, maskedHGPlvs,  maskedbetaPlvs,...
%     maskedalphaPlvs, maskedthetaPlvs, maskeddeltaPlvs ]...
%     = fastPhaseShuffle_revised( trimmed_sig, fs, Montage.BadChannels, ifsPlv, rsPlv, ...
%     HGplv, betaPlv, alphaPlv, thetaPlv, deltaPlv );


save(strcat(subjid, '_phaseShuffled'));

    
%     save(strcat(subjid, '_postBCI_phaseShuffled'));
    
    