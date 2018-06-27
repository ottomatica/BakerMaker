const Hyper = require('./providers/hyper');

main();

async function main()
{
    let hyperProvider = new Hyper();

    await hyperProvider.bake("config/sshd.yml");
    hyperProvider.start("sshd", "192.168.65.100");

    hyperProvider.ssh("192.168.65.100");
    
}
