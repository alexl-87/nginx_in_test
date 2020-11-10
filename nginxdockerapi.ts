const express = require('express');
const app = express();
const { exec } = require("child_process");

// reload nginx service
app.get('/api/nginx/reload', (req,res)=>{

    let command: string = "/usr/local/nginx/sbin/nginx -s reload";
    console.log("Run command: "+command);
    runCommand(command);
    res.send("Executed command: "+command);
});

// replace substring in file
app.get('/api/nginx/replace/:directory/:file/:substring/:replacement', (req,res)=>{

    let command: string = `sed -i 's/${req.params.substring}/${req.params.replacement}/' /usr/local/nginx/${req.params.directory}/${req.params.file}`;
    console.log("Run command: "+command);
    runCommand(command);
    res.send("Executed command: "+command);
});

// copy file 
app.get('/api/nginx/cp/:sourcedir/:sourcefile/:destdir/:destfile', (req,res)=>{

    let command: string = `cp /usr/local/nginx/${req.params.sourcedir}/${req.params.sourcefile} /usr/local/nginx/${req.params.destdir}/${req.params.destfile}`;
    console.log("Run command: "+command);
    runCommand(command);
    res.send("Executed command: "+command);
});

// set response code
app.get('/api/nginx/response/:code', (req,res)=>{

    let command: string = `sed -i 's/REPLACE_RESPONSE_CODE/${req.params.code}/' /usr/local/nginx/conf/nginx.conf`;
    console.log("Run command: "+command);
    runCommand(command);
    res.send("Executed command: "+command);
});

// run bash command
function runCommand(cmd: string, callback?: (error: any, output: string) => void) {
    if (callback == undefined){
        return new Promise((resolve, reject) => {
            exec(cmd, (error: any, stdout: any, stderr: any) => {
                if (error != undefined) {
                    reject(error);
                }
                if (stderr) {
                    console.error(`${stderr}`);
                }
                resolve(stdout);
            });
        });
    }
}

app.listen(3000, ()=>console.log('listening on port 3000...'));