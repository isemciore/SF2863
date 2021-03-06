function [ haveConverged ] = SysEngContinious7b( )
lambda_1 = 10;
lambda_2  = 20;
mu = 8;
n1 = [0 1 2 3];
n2 = [3 2 1 0];

speedColumn = [18 10 14 0]';
referenceValue = [10.8801287208367, 10.9107276819205, 10.937456078707, 10.9610046265697];
haveConverged = 1;
maxDistance = 0;
for i = 1:4
    averageSpeed = 0;
    
    
    oldAverage = 0;
    currentTime = 0;
    currentState = [1 0 0 0];
    distance = 0;
    tic
    while (currentTime < 1000) 
        if(currentState(1) == 1)
            eng1TTF = exprnd(1/lambda_1);
            eng2TTF = exprnd(1/lambda_2);
            if(eng1TTF < eng2TTF)
                newState=[0 0 1 0];
            else
                newState=[0 1 0 0];
            end
            deltaT = min(eng1TTF,eng2TTF);
        elseif(currentState(2) == 1)
            eng1TTF = exprnd(1/lambda_1);
            eng2TTR = exprnd(1/(3*mu));
            if(eng1TTF < eng2TTR)
                newState = [0 0 0 1];
            else
                newState = [1 0 0 0];
            end
            deltaT = min(eng1TTF,eng2TTR);
        elseif(currentState(3) == 1)
            eng1TTR = exprnd(1/(3*mu));
            eng2TTF = exprnd(1/lambda_2);
            if(eng1TTR < eng2TTF)
                newState = [1 0 0 0];
            else
                newState = [0 0 0 1];
            end
            deltaT = min(eng1TTR, eng2TTF);
        else
            eng1TTR = exprnd(1/(n1(i)*mu));
            eng2TTR = exprnd(1/(n2(i)*mu));
            if(eng1TTR < eng2TTR)
                newState = [0 1 0 0];
            else
                newState = [0 0 1 0];
            end
            deltaT = min(eng1TTR,eng2TTR);
        end
       
        currentTime = currentTime+deltaT;
        distance = distance + currentState*speedColumn.*deltaT;
        oldAverage = averageSpeed;
        averageSpeed = distance/currentTime;
        currentState = newState;
    end
    toc
    if(maxDistance < distance)
        maxDistance = distance;
    end
    
    if((abs(averageSpeed-referenceValue(i)) < referenceValue(i)*0.01) && (haveConverged == 1))
    else
        haveConverged =0;
        break;
    end
    a1 = sprintf('avg speed %s', num2str(averageSpeed));
    disp(a1)
    a2 = sprintf('pro diff %s',num2str(100*abs(averageSpeed-referenceValue(i))/referenceValue(i)));
    disp(a2)
    
    
    if(false)
    fprintf('Converged to average speed %s \n', num2str(averageSpeed));
    fprintf('referencevalue  %s \n', num2str(referenceValue(i)));
    
    fprintf('difference %s \n', num2str(100*abs(averageSpeed-referenceValue(i))/(referenceValue(i))));
    end
    
    if(false)
    a1 = sprintf('Strategy: n1=%s, n2=%s',num2str(n1(i)),num2str(n2(i)));
    disp(a1);
    a2 = sprintf('Average speed: %s',num2str(averageSpeed));
    disp(a2);
    a3 = sprintf('Time for convergence 10percent %s time unit',num2str(currentTime));
    disp(a3);
    a4 = sprintf('Distance travelled %s is',num2str(distance));
    disp(a4);
    end
end

end