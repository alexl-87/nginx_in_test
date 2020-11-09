const express = require('express');
const app = express();
const { exec } = require("child_process");

// run new docker
app.get('/api/docker/run/:port', (req,res)=>{

    let command: string = `docker run -t -d -p ${req.params.port}:443 --name NGINX-${req.params.port} --hostname NGINX-${req.params.port} nginx_forward_proxy`;
    console.log("Run command: "+command);
    runCommand(command);
    res.send("SUCCESS");

});

// start nginx
app.get('/api/docker/listen/:port', (req,res)=>{

    let command: string = `docker exec -itd NGINX-${req.params.port} /usr/local/nginx/sbin/nginx`;
    console.log("Run command: "+command);
    runCommand(command);
    res.send("SUCCESS");

});

// copy file from git reposytory to directory in root /usr/local/nginx/
app.get('/api/docker/cp/:port/:file/:directory', (req,res)=>{

    let command: string = `docker cp /home/nginx/nginx/${req.params.file} NGINX-${req.params.port}:/usr/local/nginx/${req.params.directory}`;
    console.log("Run command: "+command);
    runCommand(command);
    res.send("SUCCESS");

});

// remove docker
app.get('/api/docker/rm/:port', (req,res)=>{
    
    let command: string = `docker rm -f NGINX-${req.params.port}`;
    console.log("Run command: "+command);
    runCommand(command);
    res.send("SUCCESS");
    
});

// set response code
app.get('/api/docker/response/:port/:response', (req,res)=>{

    let command: string = `docker exec -itd NGINX-${req.params.port} /usr/local/nginx/sbin/nginx_${req.params.response}.sh`;
    console.log("Run command: "+command);
    runCommand(command);
    res.send("SUCCESS");

});

//replase substring in file in git repository
app.get('/api/docker/replase/:file/:substring/:replacement', (req,res)=>{

    let command: string = `sed -i 's/${req.params.substring}/${req.params.replacement}/' /home/nginx/nginx/${req.params.file}`;
    console.log("Run command: "+command);
    runCommand(command);
    res.send("SUCCESS");
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

app.listen(8880, ()=>console.log('listening on port 8880...'));