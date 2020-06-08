function [suit] = getCardSuit(suitimage, suits, CI, DI, HI, SI)

    c_c = normxcorr2(CI, suitimage);
    [ypeakc,xpeakc] = find(c_c==max(c_c(:)));
%     yoffSet = ypeakc-size(CI,1);
%     xoffSet = xpeakc-size(CI,2);
% 
%     imshow(suitimage)
%     drawrectangle(gca,'Position',[xoffSet,yoffSet,size(CI,2),size(CI,1)], ...
%         'FaceAlpha',0);

    c_d = normxcorr2(DI, suitimage);
    [ypeakd,xpeakd] = find(c_d==max(c_d(:)));
    % yoffSet = ypeak-size(DI,1);
    % xoffSet = xpeak-size(DI,2);
    % drawrectangle(gca,'Position',[xoffSet,yoffSet,size(DI,2),size(DI,1)], ...
    %     'FaceAlpha',0);

    c_h = normxcorr2(HI, suitimage);
    [ypeakh,xpeakh] = find(c_h==max(c_h(:)));

    c_s = normxcorr2(SI, suitimage);
    [ypeaks,xpeaks] = find(c_s==max(c_s(:)));

    xpeaks = [xpeakc, xpeakd, xpeakh, xpeaks];
    ypeaks = [ypeakc, ypeakd, ypeakh, ypeaks];

    [xval, xidx] = max(xpeaks, [], 2);
    [yval, yidx] = max(ypeaks, [], 2);

    if xidx == yidx
       suit = suits(yidx) 
    end

end