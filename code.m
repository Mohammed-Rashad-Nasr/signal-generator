%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% by   : Mohammed Rashad               % 
% Function generator with operations   %
% Date : 16/05/2021                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%clear
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


errorcheck='false';                                              % error check variable
Samplingfreq = input('Enter Sampling frequency of signal f:');   % frequancy variable input
start = input('Enter start of time scale s:');                   % time start variable input
End = input('Enter end of time scale e:');                       % time start variable input
t=start:1/Samplingfreq:End;                                      % initializing total time range


%getting breakpoints
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Breakpoints=input('Enter number of Breakpoints:');               % positions = [start B1 B2 .... B End] %
position=[start zeros(1,Breakpoints)];                           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
signal = zeros(size(t));
for i=1:Breakpoints
    position(i+1)=input('Enter breakpoints position:');
end
position(end+1)=End;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%signal generation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=1:length(position)-1    
    if strcmp(errorcheck,'false')                                       % error check to exit if it was True
        signal_type=input('Enter your signal type:','s');               % asking user for signal type within the nth range
         t2=position(j):1/Samplingfreq:(position(j+1)-1/Samplingfreq);  % t2 contains time range of the current breakpoint only 
         
               % switching on the signal type 
                switch signal_type
                 
                    case 'DC'
                        amplitude=input('Enter the Amplitude:');                                             % inputs
                        signal(t>=position(j) & t<position(j+1))=amplitude;                                  % signal generation
                        
                        
                    case 'Ramp'
                        slope=input('Enter your signal slope:');                                             % inputs
                        intercept=input('Enter your signal intercept:');
                        signal(t>=position(j) & t<position(j+1))=slope*t2+intercept;                         % signal generation
                        
                        
                    case 'exponential'
                        e_amplitude=input('Enter your signal amplitude:');                                   % inputs
                        exponent=input('Enter your signal exponent:');
                        signal(t>=position(j) & t<position(j+1))=e_amplitude*exp(t2*exponent);               % signal generation
                        
                        
                    case 'sinusoidal' 
                        s_amplitude=input('Enter your signal amplitude:');                                   % inputs
                        frequancy=input('Enter your signal frequncy:');
                        phase=input('Enter your signal phase:');
                        signal(t>=position(j) & t<position(j+1))=sin(2*pi*frequancy*t2+phase)*s_amplitude;   % signal generation
                        
                        
                    case 'polynomial'
                        powerp=input('Enter your power:');                                                   % inputs
                        intercept=input('Enter your intercept:');
                        amplitude=[];                                                                        % coefficients vector
                        
                        for h=1:powerp                                                                       % getting coefficients
                           amplitude(end+1)=input('Enter amplitude:');
                        end
                        
                        for i=1:length(t)                                                                    % signal generation
                           if (t(i)>=position(j)&&t(i)<position(j+1))
                                for k=1:powerp
                                     signal(i)=signal(i)+amplitude(k)*(t(i)^k);
                                end
                           end
                           signal(i)=signal(i)+intercept;
                        end
                      
                        
                        
                    otherwise
                        disp('signal cant generated')
                        errorcheck='True';
                end  
        end
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% signal plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(errorcheck,'false')
    f1=figure; 
    plot(t,signal)
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% operations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% getting first operation from user
operation=input('choose operation to perform on signal : amplitude scaling , time shift , compressing , expanding , mirror , none ','s'); 

% doing operations until user types none 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while(1)
    % switching on operation 
    switch operation
        
        case 'amplitude scaling'
            t2=t;                                                             % new time range
            scaling=input('enter scaling factor   ');                         % inputs
            signal2 = scaling.*signal;                                        % generating new signal
        
        
            
        case 'time shift'
            shift=input('enter shift value   ');                              % inputs
            t2=t;                                                             % new time range
            if shift >= 0                                                     % generating new signal for shifting left
                  for i=1:length(t)
                    if (i+(shift*Samplingfreq))<=length(t)
                         signal2(i)=signal(i+(shift*Samplingfreq));
                    else 
                        signal2(i)=0;
                    end 
                  end
            else                                                              % generating new signal for shifting right
                for i=1:length(t)
                    if (i+(shift*Samplingfreq))>0
                         signal2(i)=signal(i+(shift*Samplingfreq));
                    else 
                        signal2(i)=0;
                    end 
                  end
            end
            
            
        case 'compressing'
            comp=input('enter compression factor   ');                        % inputs
            t2= start/comp : 1/Samplingfreq : End/comp ;                      % new time range
            signal2=resample(signal,1,comp);                                  % generating new signal
            
            
        case 'expanding'
            expand=input('enter expnsion factor   ');                         % inputs
            t2= start*expand : 1/Samplingfreq : (End*expand)+1/Samplingfreq ; % new time range
            signal2=resample(signal,expand,1);                                % generating new signal 
            
            
        case 'mirror'
            t2=t;                                                             % new time range
            signal2=signal(end:-1:1);                                         % generating new signal 
             
            
        case 'none'
            break;
            
            
        otherwise 
            errorcheck='True'
            disp('unknown operation')
            break;
    end
    
     if strcmp(errorcheck,'false')                                           % check error
        f2=figure;                                                           % plotting signal
        plot(t2,signal2)
     end
     
     %asking for operation again
    operation=input('choose operation to perform on signal : amplitude scaling , time shift , compressing , expanding , mirror , none ','s');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
