function [txt,Pf] = roc_i(resultImg,maskImg,dnum)
%roc_i Calculate the roc of the predicted results
%dataset
%   Input: resultImg = prediction result of the algorithm dimension = (1*n)
%          maskImg = gt dimension = (1*n)
%          dnum = number of anomaly pixels

if (nargin < 3)
    dnum = length(maskImg == 1);
end
resultImg = hyperNormalize(resultImg);
n = size(resultImg,2);
location = maskImg == 1;
tvalue = resultImg(location);
tvalue = sort(tvalue);
%threhold = linspace(tvalue(1),tvalue(100),dnum);
threhold = tvalue;
det = zeros(1,dnum);
fal = zeros(1,dnum);
for i = 1:dnum
    tempImg = resultImg;
    for j = 1:n
        if tempImg(j) < threhold(i);
            tempImg(j) = 0;
        else
            tempImg(j) = 1;
        end
    end
    target = tempImg(location);
    num1 = 0;
    for j = 1:size(tvalue,2)
        if target(j) == 1
            num1 = num1+1;
        end
    end
    num2 = size(tempImg(tempImg == 1),2);
    det(i) = num1/size(tvalue,2);
    fal(i) = (num2-num1)/n;
end
fal = sort(fal);
fal1 = sort(fal,'descend');
det = sort(det);
txt = [fal',det'];
thr=1:dnum;
thr=thr/dnum;
Pf = [thr', fal1'];
plot(fal,det);

end

