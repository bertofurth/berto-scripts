# berto-scripts
Miscellaneous useful bash scripts.

# pdf-ocr-script.sh
Use the "tesseract" tool to perform OCR on pdfs in a given directory and 
create corresponding plain text files containing recognized text.

TODO - Doesn't handle spaces in filenames properly.

Assumes that the following tools are installed 


poppler-tools (to convert pdfs to image files)
tesseract-ocr
tesseract-ocr-traineddata-english  (see below)
tesseract-ocr-traineddata-orientation_and_script_detection

I would suggest making sure that the "best" trained data from

https://github.com/tesseract-ocr/tessdata_best/raw/main/eng.traineddata

is installed. This will be slower than the default data but much more accurate

    cd /usr/share/tessdata
    mv eng.traineddata eng.traineddata.orig
    wget https://github.com/tesseract-ocr/tessdata_best/raw/main/eng.traineddata





