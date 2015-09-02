%% lowpass.m
%  jdw - 28APR2011
%
% Changelog:
%   28APR2011 - originally written
%
% This is a helper function to quickly lowpass filter a signal
%
% Parameters:
%   signals - signals to be filtered.  If signals is an MxN array, the
%     vectors of length M, indexed by the N dimension will be treated as
%     independent signals and filtered as such.
%   lpFreq - the lowpass cutoff frequency
%   fSamp - the sampling rate of signals
%   filterOrder (optional) - the filter order of the butterworth filter to
%     be used.  The default value is 4th order.
%
% Return Values:a
%   filteredSignals - the filtered signals
%

function filteredSignals = bandpass(signals, lpFreq, fSamp, filterOrder)
    if (~exist('filterOrder', 'var'))
        filteredSignals = ecogFilter(signals, false, 0, false, 0, true, lpFreq, fSamp);
    else
        filteredSignals = ecogFilter(signals, false, 0, false, 0, true, lpFreq, fSamp, filterOrder);
    end
end