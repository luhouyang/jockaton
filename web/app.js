function compressAndDownloadImage(base64) {
    var url = base64;

    fetch(url)
        .then(res => res.blob())
        .then(blob => {
            var imageFile = blob;
            console.log('originalFile instanceof Blob', imageFile instanceof Blob); // true
            console.log(`originalFile size ${imageFile.size / 1024 / 1024} MB`);

            var options = {
                maxSizeMB: 0.02,//right now max size is 20kb you can change
                maxWidthOrHeight: 1920,
                useWebWorker: true
            }
            if (imageFile.size/1024>20.0) {
                imageCompression(imageFile, options)
                .then(function (compressedFile) {
                    console.log('compressedFile instance of Blob', compressedFile instanceof Blob); // true
                    console.log(`compressedFile size ${compressedFile.size / 1024 / 1024} MB`); // smaller than maxSizeMB
                    console.log(compressedFile);
                    // download file to local machine
                    saveAs(new Blob([compressedFile], { type: "image/jpeg" }), Math.floor(Date.now() / 1000) + '.jpeg');
                    // returns data to dart code
                    compressedFile.arrayBuffer().then((buffer) => window.parent.postMessage(buffer, "*"));
                })
                .catch(function (error) {
                    console.log(error.message);
                });
            } else {
                // returns data to dart code
                imageFile.arrayBuffer().then((buffer) => window.parent.postMessage(buffer, "*"));
            }
            
        })

}