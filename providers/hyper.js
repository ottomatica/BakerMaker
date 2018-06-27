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

    async start(name)
    {
        console.log(`Starting ${name}`);
        const subprocess = child_process.spawn('linuxkit', ['run', `${name}`], {
            detached: true,
            stdio: 'ignore'
        });
          
        subprocess.unref();
    }

    async halt()
    {

    }

}

module.exports = Hyper;
