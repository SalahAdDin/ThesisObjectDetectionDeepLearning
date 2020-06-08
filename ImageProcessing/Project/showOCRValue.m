

function showOCRValue(BW, ocrResults)
    J1 = 255 * repmat(uint8(BW), 1, 1, 3);
    Iocr = insertObjectAnnotation(J1, 'rectangle', ocrResults.WordBoundingBoxes, ocrResults.WordConfidences);
    figure;
    title('OCR Detected value');
    imshow(Iocr);
end