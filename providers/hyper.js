const Promise         = require('bluebird');
const child_process   = Promise.promisifyAll(require('child_process'));

class Hyper {
    constructor() {
    }

    async bake(config)
    {
        child_process.execSync(`linuxkit build ${config}`, {
            stdio: ['inherit', 'inherit', 'inherit']
        });
    }

    async start(name, ip)
    {
        console.log(`Starting ${name}`);
        const subprocess = child_process.spawn('linuxkit', ['run', `-ip`, `${ip}`, `${name}`], {
            detached: true,
            stdio: 'ignore'
        });
        
        subprocess.unref();
    }

    async halt()
    {

    }

    // Prereq
    // docker build -t ssh .
    // FROM alpine:edge
    // RUN apk add --no-cache openssh-client
    async ssh(ip)
    {
        child_process.execSync(`docker run --rm -ti -v ~/.ssh:/root/.ssh  ssh ssh ${ip}`, {
            stdio: ['inherit', 'inherit', 'inherit']
        });        
    }

}

module.exports = Hyper;
